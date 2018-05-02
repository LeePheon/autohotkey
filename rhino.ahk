;---------- rhino
#if WinActive("ahk_exe Rhino.exe")

  ^.::Key "!lo"

  f2:: ;prev tab
    MouseGetPos mouseX, mouseY
    Click "1800 40 WheelUp"
    MouseMove mouseX, mouseY
    return

  f3:: ;next tab
    MouseGetPos mouseX, mouseY
    Click "1800 40 WheelDown"
    MouseMove mouseX, mouseY
    return

  ^+z::^y ;undo

#if