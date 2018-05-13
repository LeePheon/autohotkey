;---------- rhino
#if WinActive("ahk_exe Rhino.exe")
  ; send command to console
  ; *todo add console activity check
  Cmd(commands*) {
    loop commands.Length() {
      cmds .= commands[A_Index] . "{Enter}"
    }
    Key cmds
  }

  ^.::Cmd "Options" ;preferences

  f1::Cmd "MaxViewport" ;toggle maximize active viewport
  !f1::Cmd "'_Help"

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

  f4::Cmd "Gumball t" ;toggle manipulator

  ^+z::^y ;undo
  !z::Key "'_Zoom a s"

#if