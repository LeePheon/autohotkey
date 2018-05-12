#if WinActive("ANSYS SpaceClaim")
  #.::Key "^+." ;prefs

  f1:: ;first tab
    MouseGetPos mouseX, mouseY
    Click "100 40"
    MouseMove mouseX, mouseY
    return

  f2:: ;prev tab
    MouseGetPos mouseX, mouseY
    Click "1100 40 WheelUp"
    MouseMove mouseX, mouseY
    return

  f3:: ;next tab
    MouseGetPos mouseX, mouseY
    Click "1100 40 WheelDown"
    MouseMove mouseX, mouseY
    return

  f4:: ;middle tab
    MouseGetPos mouseX, mouseY
    Click "660 40"
    MouseMove mouseX, mouseY
    return
      
  $!f1::Send "{f1}" ;alt-f1 - help
   ^+z::Key "^y" ;redo
    ~RAlt up:: ;pie menu
      if A_PriorKey = "RAlt" {
        Key "o"
      }
      return

  #z::Key "^!+z" ;isolate

  $^1:: ;alt-1 - toggle transparent/opaque
      if scTransparent := !scTransparent {
        Key "+^1"
        Say "Transparent"
      } else {
        Key "^1"
        Say "Opaque"
      }
      return

  $^2:: ;alt-2 - toggle perspective/ortho
      if scPerspective := !scPerspective {
        Key "+^2"
        Say "Perspective"
      } else {
        Key "^2"
        Say "Ortho"
      }
      return

; !3::Send "^0" ;isometric view

#if