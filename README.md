<h1>T-Code Launcher</h1>
The T-Code launcher takes you to transactions at the touch of a button (CAPSLOCK). It works on every SAP server, even those where scripting is disabled. An unlimited number of T-Codes can be stored, and you can add descriptions to help you remember what a specific T-Code does.
 
<h2>Getting the launcher</h2>

1. Download Autohotkey v2+ and install it.

2. Download the latest version of the launcher.   

3. Extract the launcher into a new folder.

4. Double click T-Code-Launcher.ahk.

You may wish to set the T-Code-Launcher to automatically run when you start your computer, so that you always have it to hand. To do this, create a shortcut to the T-Code-Launcher.ahk file and place it in your windows startup folder.

<h2>Using the T-Code Launcher</h2>
To open the launcher while using SAP GUI:

1.	Press caps lock. This opens the T-Launcher screen.

2.	Press a key. This will open the transaction that corresponds to that key in your current window.

3.	To open a transaction in a new window, hold down caps-lock as you press the key that corresponds to the transaction you want to open.

4.	To switch between pages, use the left and right arrow keys or page up and page down.

5.	To cancel opening a new transaction, press escape.

<h2>Configuration</h2>
To configure the launcher to your liking, open the tcodes.ini file.


Sections of the ini file correspond to pages. So, to add a new page, add a new line, then another new line with [Page (number)] to the ini file.

To link a key to a transaction, add a line (key) = (t-code)

To add a description to a transaction, add a semicolon on the same line as a t-code and then write a description. Note semicolons can't be used as a key to launch a t-code.

<h2>What if I want to use a key that's not capslock?</h2>

Edit lines 4 and 86 of the script.

1.	Line 4 creates the hotkey that assigns capslock to the t-code launcher. Here you can change capslock to any key you like.
   
3.	Line 86 detects whether you are holding down capslock. If you are, it opens the transaction in a new window. Here you can change capslock to any key you like.
Remember when choosing a hotkey that you might still want to be able to use this key in SAP GUI.

	
