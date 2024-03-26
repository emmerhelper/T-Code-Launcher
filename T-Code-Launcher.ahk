#Requires AutoHotkey v2.0 
TraySetIcon("icon.png")
#HotIf WinActive("ahk_exe saplogon.exe")
CapsLock::TCodeLauncher(1)

TCodeLauncher(Page:=1){
    ;; Get all data from ini file
    SetCapsLockState('Off')
    fullFileList := FileRead("TCodes.ini")
    StrReplace(fullFileList,"Page",,,&PageCount)
    iniSection := StrSplit(fullFileList,"`r`n`r`n")
    trimmedPage := SubStr(iniSection[Page],11)
    trimmedPage := trim(trimmedPage,"`r`n")

    GUIHotkeys := "Key`n`r"
    GUICodes := "Transaction`n`r"
    GUIDescriptions := "Description`n`r"

    loop parse, trimmedPage, "`n", "`r" {
        
        if (StrLen(A_LoopField) < 5) {
            continue 
        }

        RegExMatch(A_LoopField,".+=",&GuiHotkey)
        GuiHotkeys .= Trim(GuiHotkey[],"=") "`n`r"

        RegExMatch(A_LoopField,"=.+",&LoopField2)

        if InStr(LoopField2[],"; "){        
            RegExMatch(LoopField2[],".+;",&GuiCode)
            RegExMatch(LoopField2[],";.+",&GuiDescription)
            GUICodes .= Trim(GuiCode[],";= ") "`n`r"
            GUIDescriptions .= Trim(GUIDescription[],"; ") "`n`r"
        } else {
            GUICodes .= Trim(LoopField2[],"= ") "`n`r"
            GUIDescriptions .= "🦋`r`n"
        }
    }

    ;; Create GUI
    visualList := Gui(,"Page " Page)
    visualList.Opt("-SysMenu ToolWindow border")
    visualList.SetFont("S16 cFAFAFA")
    visualList.backcolor := "281C28"
    visualList.Add("Text","center",GuiHotkeys)
    visualList.Add("Text","x+25",GUICodes)
    visualList.Add("Text","x+25",GUIDescriptions)
    visualList.Show

    ;; Process input 
    TCode := ""
    IH := InputHook("L1 T5","{PgUp}{PgDn}{Left}{Right}")
    IH.Start()
    ih.Wait()
    visualList.Destroy

    Try {
        TCode := IniRead("TCodes.ini","Page " Page,IH.Input)
        IF InStr(TCode,";"){
            TCode := StrSplit(TCode,";")
            TCode := TCode[1]
        }
    }

    if (IH.EndKey = "PgUp") OR (IH.EndKey = "Right"){
        if (Page = PageCount){
         TCodeLauncher()
        }
        else TCodeLauncher(Page+1)
        return 
    }

    if (IH.EndKey = "PgDn") OR (IH.EndKey = "Left"){
        if (Page = 1){
            TCodeLauncher(PageCount)
        }
        else TCodeLauncher(Page-1)
        return 
    }

    if !Tcode{
        return 
    }
    
    if GetKeyState("CapsLock","P"){
            openSAPTransaction(TCode,,true)
        }
    else openSAPTransaction(TCode)
}
  
sapActiveSession(){
    ;; Return the active session. Only works if an SAP window is currently the active window (it can't be minimised)
        SAP := ComObjGet("SAPGUI")
        app := SAP.GetScriptingEngine()
        session := app.ActiveSession()
        return session
    }
    
openSAPTransaction(transaction, windowName:=false, newWindow:=false){
    ;; Opens the specified T-CODE and waits for the window to have loaded. Optional third parameter 'new' to create a new session. 
        session := sapActiveSession()  

        ;; If scripting is disabled on the server, enter keypresses manually
        try session.findByID("wnd[0]/tbar[0]/okcd")
        catch { 
            openSAPTransactionManually(transaction,windowName,newWindow)
            return 
        }

        if newWindow {
            session.findById("wnd[0]/tbar[0]/okcd").text := "/o" . transaction
            session.findById("wnd[0]/tbar[0]/btn[0]").press()
        } else session.startTransaction(transaction)

    }

openSAPTransactionManually(transaction, windowName:=false, newWindow:=false){
    ;Opens the specified T-CODE and waits for the window to have loaded. Optional third parameter 'new' to create a new session.
    
    if !WinActive("ahk_exe saplogon.exe"){
        WinActivate ("ahk_exe saplogon.exe")
    }

    if newWindow {
        pressInSequence(["^{/}","/o",transaction,"{Enter}"],50)
    } else pressInSequence(["^{/}","/n",transaction,"{Enter}"],50)
    
}

PressInSequence(keys,delay){
    for k, v in keys {
        Send v
        Sleep delay
    }
}

;; Stop capslock activating in the pop-up GUI
#HotIf WinActive("ahk_exe autohotkey64.exe","Transaction")
CapsLock::SetCapsLockState("Off")
