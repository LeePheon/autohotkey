  #if WinActive("ahk_exe Figma.exe")
    WheelUp:: ;zoom-
      Send "^{WheelUp}"
      return

    WheelDown:: ;zoom+
      Send "^{WheelDown}"
      return

    f1::
      MouseGetPos mouseX, mouseY
      Click "80 10"
      key "{s 7}{Enter}"
      MouseMove mouseX, mouseY
      say "Preview/Outline"
      return

    f5::
      key "+h" 
      say "Flip Horizontal"
      return

    f6::
      key "+v"
      say "Flip Vertical"
      return

    ^1::
      key "+0"
      say "Zoom to 100%"
      return

    !z::
      key "+2"
      say "Zoom to Selection"
      return

    ^3::
      key "+1" 
      say "Zoom to Fit"
      return

    ^#Up::
      MouseGetPos mouseX, mouseY
      Click "250 10"
      key "{a 4}{Enter}"
      MouseMove mouseX, mouseY
      say "Align Top"
      return

    ^#Down::
      MouseGetPos mouseX, mouseY
      Click "250 10"
      key "{a 6}{Enter}"
      MouseMove mouseX, mouseY
      say "Align Bottom"
      return

    ^#Left::
      MouseGetPos mouseX, mouseY
      Click "250 10"
      key "{a 1}{Enter}"
      MouseMove mouseX, mouseY
      say "Align Left"
      return

    ^#Right::
      MouseGetPos mouseX, mouseY
      Click "250 10"
      key "{a 3}{Enter}"
      MouseMove mouseX, mouseY
      say "Align Right"
      return

    ^#c::
      MouseGetPos mouseX, mouseY
      Click "250 10"
      key "{a 2}{Enter}"
      MouseMove mouseX, mouseY
      say "Align Horizontal Centers"
      return

    ^#m::
      MouseGetPos mouseX, mouseY
      Click "250 10"
      key "{a 5}{Enter}"
      MouseMove mouseX, mouseY
      say "Align Vertical Centers"
      return

    !g::
      key "^+g"
      say "Ungroup"
      return

    ![::
      MouseGetPos mouseX, mouseY
      Click "120 10"
      key "{s 2}{Enter}"
      MouseMove mouseX, mouseY
      say "Send to Back"
      return

    !]::
      MouseGetPos mouseX, mouseY
      Click "120 10"
      key "{b 1}{Enter}"
      MouseMove mouseX, mouseY
      say "Bring to Front"
      return

    ^l::
      MouseGetPos mouseX, mouseY
      Click "120 10"
      key "{l 1}{Enter}"
      MouseMove mouseX, mouseY
      say "Lock/Unlock Selection"
      return

    ^h::
      MouseGetPos mouseX, mouseY
      Click "120 10"
      key "{s 3}{Enter}"
      MouseMove mouseX, mouseY
      say "Show/Hide Selection"
      return

    !1::
      MouseGetPos mouseX, mouseY
      Click "120 10"
      key "{b 3}{Enter}u"
      MouseMove mouseX, mouseY
      say "Union Selection"
      return

    !2::
      MouseGetPos mouseX, mouseY
      Click "120 10"
      key "{b 3}{Enter}s"
      MouseMove mouseX, mouseY
      say "Subtract Selection"
      return

    !3::
      MouseGetPos mouseX, mouseY
      Click "120 10"
      key "{b 3}{Enter}i"
      MouseMove mouseX, mouseY
      say "Intersect Selection"
      return

    !4::
      MouseGetPos mouseX, mouseY
      Click "120 10"
      key "{b 3}{Enter}e"
      MouseMove mouseX, mouseY
      say "Exclude Selection"
      return

#if