;!alt ^ctrl +shift #win

SetKeyDelay -1
#include functions.ahk
Say "AutoHotkey Loaded"
; #Include *i -\keypress-osd.ahk

;restore keyboard layout
cfg := "settings.ini"
if FileExist(cfg) {
  lng := IniRead(cfg, "Settings", "Language")
  if lng != "English" {
    Lang(lng)
  }
}

;display active keyboard layout under text caret (doesn't work in some apps)
SetTimer "caretLang", 200
caretLang() {
  static timeout := 10 
  static state := timeout
  static lastWinId := 0
  if A_CaretX {
    curWinId := WinActive("A")
    if curWinId != lastWinId {
      state := timeout
      lastWinId := curWinId
    }
    if state > 0 {
      ToolTip SubStr(GetLang(), 1, 2), A_CaretX + 3, A_CaretY + 20, 2
      state--
    } else if state = 0 {
      ToolTip ,,, 2
      state := -1
    }
  } else {
    if state > -1 {
      ToolTip ,,, 2
      lastWinId := 0
      state := -1
    }
  }
}

;--------
; GLOBAL
;--------

;----- vim (win-hjkl, win-shift-hjkl)
LWin & vk48:: ;h
  if GetKeyState("Shift")
    Send "{Home}"
  else
    Send "{Left}"
  return
LWin & vk4A:: ;j
  if GetKeyState("Shift")
    Send "{PgDn}"
  else
    Send "{Down}"
  return
LWin & vk4B:: ;k
  if GetKeyState("Shift")
    Send "{PgUp}"
  else
    Send "{Up}"
  return
LWin & vk4C:: ;l
  if GetKeyState("Shift")
    Send "{End}"
  else
    Send "{Right}"
  return

;----- snippets
  #include *i snippets.ahk

;----- lshift/rshift - switch keyboard layout (en/ru)
  ~LShift up::
    if A_PriorKey = "LShift" {
      Lang "English"
      caretLangState := caretLangTimeout
      Say "En", , A_CaretX + 3, A_CaretY + 20
    }
    return
  ~RShift up::
    if A_PriorKey = "RShift" {
      Lang "Russian"
      caretLangState := caretLangTimeout
      Say "Ru", , A_CaretX + 3, A_CaretY + 20
    }
    return

;----- macos
  ^w:: ;close document
    if !WinActive("ahk_exe cmd.exe") {
      Send "^{f4}"
    }
    return
  ^q:: ;quit app
    if !WinActive("ahk_exe cmd.exe") {
      Send "!{f4}"
    }
    return
  ^#Space::Send "{U+00A0}" ;nbsp
  ;!Left::Send "^{Left}"
  ;!Right::Send "^{Right}"
  ;+!Left::Send "+^{Left}"
  ;+!Right::Send "+^{Right}"

;win-` - toggle explorer window
  #`::
    if WinExist("ahk_class CabinetWClass") {
      if WinActive("ahk_class CabinetWClass") {
        WinMinimize
        Say "Minimize Explorer"
      } else {
        WinRestore
        WinActivate
        Say "Restore Explorer"
      }
    } else {
      Run "explorer.exe"
      Say "Run Explorer"
    }
    return

;ctrl-tab <-> alt-tab
  $<^Tab::AltTab
  $!Tab::
    Send "{Ctrl down}{Tab down}"
    KeyWait "LAlt"
    Send "{Ctrl up}"
    return

;win-f11 - toggle window click-through
  #f11::
    if WinGetExStyle("A") & 0x20 {
        WinSetExStyle "-0x20", "A"
        WinSetTransparent "OFF", "A"
        WinSetAlwaysOnTop "OFF", "A"
        Say "Fluid Off"
    } else {
        WinSetExStyle "+0x20", "A"
        WinSetTransparent 128, "A"
        WinSetAlwaysOnTop "ON", "A"
        Say "Fluid On"
    }
    return

;win-f12 - toggle window transparency
  #f12::
    steps := 4
    alpha := 256
    trans := WinGetTransparent("A")
    trans := trans ? trans : alpha
    trans := trans - alpha / steps
    WinSetTransparent trans 0 ? trans : "OFF", "A"
    Say trans ? "Transparency " Floor(trans * 100 / alpha) "%" : "Transparency 100%"
    return

;fn-delete - dropbox url patch
  Break::
    if SubStr(Clipboard, 1, 19) = "https://www.dropbox" {
      Clipboard := RegexReplace(Clipboard, "^(.*?)www\.dropbox(.*?)(?:\?.*?)*$", "$1dl.dropboxusercontent$2")
      Say "DropBox link converted"
    } else {
      Say "No DropBox link in clipboard"
    }
    return

;----- Autohotkey
  #Escape:: ;win-esc - reload
    lng := GetLang()
    IniWrite(lng, "settings.ini", "Settings", "Language")
    if lng != "English" {
      Lang "English"
    }
    Sleep 100
    Reload
    return
  ^#Escape:: ;ctrl-win-esc - toggle all hotkeys
    Suspend 
    Say A_IsSuspended ? "AutoHotkey Suspended" : "AutoHotkey Resumed"
    return 
  +#Escape:: ;shift-win-esc - toggle autohotkey window
    DetectHiddenWindows "On"
    ahk := "ahk_class AutoHotkey"
    if WinExist(ahk) {
      if WinActive(ahk) {
        WinHide(ahk)
      } else {
        WinShow(ahk)
        WinActivate(ahk)
      }
    }
    DetectHiddenWindows "Off"
    return

;------ Spotlight alternatives
  !Escape::Send "+!^{Escape}" ;alt-escape - wox
  ^!Escape::Send "+{Escape}" ;ctrl-alt-escape - everything

;--------------
; APPLICATIONS
;--------------
  #if WinActive("ahk_exe chrome.exe")
    f1::Key "^t" ;new tab
    f2::Key "^{PgUp}" ;prev tab
    f3::Key "^{PgDn}" ;next tab
    f4::Key "+^t" ;undo close tab
    f11:: ;toggle vpn
      iconsNotFound := 0
      vpn := ["vpn0", "vpn1"] 
      MouseGetPos mouseX, mouseY
      for k, v in vpn {
        file := "chrome\" v ".png"
        if !FileExist(file) {
          Say "Error: file " file " is missing" 
          return
        } else {
          CoordMode "Pixel", "Window"
          WinGetPos winX, winY,,, "A"
          ImageSearch iconX, iconY, 0, 0, A_ScreenWidth, A_ScreenHeight, file
          if ErrorLevel = 0 {
            Click iconX " " iconY 
            Sleep 1000
            CoordMode "Mouse", "Screen"
            Click winX + iconX " " winY + iconY + 140
            Send "{Escape}"
            MouseMove mouseX, mouseY
            return
          } else {
            iconsNotFound++ 
          }
        }
      }
      if iconsNotFound = vpn.Length() {
        Say "Error(" ErrorLevel "): icon not found"
      }
      return

  #if WinActive("ahk_exe Code.exe") ;VSCode
    ^.::Send "^," ;prefs

  #if WinActive("ahk_class CabinetWClass") or WinActive("ahk_exe Clover.exe") ;explorer.exe (clover)
    f1::Send "^n" ;new tab
    f2:: ;pver tab
      CoordMode "Mouse", "Window"
      MouseGetPos mouseX, mouseY
      Click "50 0 WheelUp"
      MouseMove mouseX, mouseY
      return
    f3:: ;next tab
      CoordMode "Mouse", "Window"
      MouseGetPos mouseX, mouseY
      Click "50 0 WheelDown"
      MouseMove mouseX, mouseY
      return
    ^+BS:: ;ctrl-shift-bs - empty recycle bin
      FileRecycleEmpty
      if !ErrorLevel {
        Say "Recycled"
      }
      return
    ^i::Send "!{Enter}" ;ctrl-i - show file info
      return
    ^\:: ;change active folder to current drive's root
      Key "^l"
      Sleep 200
      Key "{Home}^{Right}^+{End}{BS}{Enter}" 
      return
    !n:: ;alt-n - move selected files to new folder
      Say "Move selected to new folder"
      ClipSaved := ClipboardAll()
      Send "^{vk58}" ;cut selection
      Sleep 200
      Send "^+{vk4E}" ;new folder
      Sleep 200
      Send "{Enter}"
      Sleep 200
      Send "{Enter}" ;enter new folder
      Sleep 800
      Send "^{vk56}" ;paste selection
      Sleep 200
      Send "{BS}" ;go back
      Sleep 200
      Send "{f2}" ;rename folder
      Clipboard := ClipSaved
      ClipSaved := ""
      return

  #if WinActive("ahk_exe firefox.exe")
    ^.:: ;prefs
      Key "!t"
      Sleep 100
      Key "o"
      return
    ^!.::Key "^+a" ;extensions
    f1::Key "^{vk54}" ;new tab
    f2::Key "^{PgUp}" ;prev tab
    f3::Key "^{PgDn}" ;next tab
    f4::Key "+^t" ;undo close tab
    f11:: ;toggle vpn
      iconsNotFound := 0
      vpn := ["vpn0", "vpn1"] 
      MouseGetPos mouseX, mouseY
      for k, v in vpn {
        file := "ff\" v ".png"
        if !FileExist(file) {
          Say "Error: file " file " is missing" 
          return
        } else {
          CoordMode "Pixel", "Window"
          ImageSearch iconX, iconY, 0, 0, A_ScreenWidth, A_ScreenHeight, file
          if ErrorLevel = 0 {
            Click iconX " " iconY 
            Sleep 1000
            Click iconX " " iconY + 140
            Send "{Escape}"
            MouseMove mouseX, mouseY
            return
          } else {
            iconsNotFound++ 
          }
        }
      }
      if iconsNotFound = vpn.Length() {
        Say "Error(" ErrorLevel "): icon not found"
      }
      return

  #if WinActive("ahk_exe hh.exe") ;windows help
    ^Escape::WinClose "A"

  #if WinActive("ahk_exe TOTALCMD64.EXE")
    $^w::Key "^w"

;------ Graphic
  #Include *i illustrator.ahk
  #Include *i figma.ahk
  #Include *i rhino.ahk
  #Include *i spaceclaim.ahk

  #if WinActive("ahk_exe blender.exe")
    ^.::Key "^!u"                 ;prefs
    !`::Key "^!+c"                ;set origin
   *#q::KeyMod "{Numpad7}",   "#" ;view ortho top
   *#w::KeyMod "{Numpad8}",   "#" ;view rotate up
   *#e::KeyMod "{Numpad9}",   "#" ;view ortho bottom
   *#r::KeyMod "{NumpadDiv}", "#" ;view local (isolate)
   *#t::KeyMod "{NumpadMul}", "#" ;grease isolate layer
   *#a::KeyMod "{Numpad4}",   "#" ;view rotate left
   *#s::KeyMod "{Numpad5}",   "#" ;view perspective/ortho
   *#d::KeyMod "{Numpad6}",   "#" ;view rotate right
   *#f::KeyMod "{NumpadSub}", "#" ;view zoom-
   *#g::KeyMod "{NumpadAdd}", "#" ;view zoom+
   *#z::KeyMod "{Numpad1}",   "#" ;view ortho front
   *#x::KeyMod "{Numpad2}",   "#" ;view rotate down
   *#c::KeyMod "{Numpad3}",   "#" ;view right
   *#v::KeyMod "{Numpad0}",   "#" ;view camera
   *#b::KeyMod "{NumpadDot}", "#" ;view selected
   *#Space::KeyMod "{NumpadEnter}", "#"

  #if WinActive("ahk_exe CINEMA 4D.exe")
    MButton::Mouse "M", "LAlt", "MButton" ;pan
    RButton::Mouse "R", "LAlt", "LButton" ;rotate

  #if WinActive("ahk_exe Dreamweaver.exe")
    !Tab::Key "!vv" ;switch between code and design windows
    !z::Key "!vww" ;toggle word wrap

  #if WinActive("ahk_exe FreeCAD.exe")
    RButton::Mouse "R", "MButton", "LButton" ;rotate

  #if WinActive("ahk_exe Fusion360.exe")
    MButton::Mouse "M", "LCtrl", "LShift", "MButton" ;pan
    RButton::Mouse "R", "MButton" ;rotate
    f1::Send "+1"

  #if WinActive("ahk_exe GravitDesigner.exe")
    MButton::Mouse "M", "Space", "LButton" ;pan
    WheelUp::Send "^{WheelUp}" ;zoom-
    WheelDown::Send "^{WheelDown}" ;zoom+

  #if WinActive("ahk_exe keyshot.exe") or WinActive("ahk_exe keyshot6.exe")
    WheelUp::Send "{WheelDown}" ;zoom-
    WheelDown::Send "{WheelUp}" ;zoom+
    RButton::Mouse "R", "LButton" ;rotate

  #if WinActive("ahk_exe LeoCAD.exe")
    MButton::Mouse "M", "LAlt", "MButton" ;pan
    RButton::Mouse "R", "LAlt", "LButton" ;rotate

  #if WinActive("ahk_exe modo.exe")
    MButton::Mouse "M", "LAlt", "LShift", "LButton" ;pan
    RButton::Mouse "R", "LAlt", "LButton" ;rotate
    $^w::Key "^w" ;close scene

  #if WinActive("ahk_exe Rocket3F.exe")
    MButton::Mouse "M", "LAlt" ;pan
    RButton::Mouse "R", "LAlt", "LButton" ;rotate

  #if WinActive("ahk_exe SketchUp.exe")
    MButton::Mouse "M", "LShift", "MButton" ;pan
    RButton::Mouse "R", "MButton" ;rotate

  #if WinActive("Adobe XD CC")
    WheelUp::Send "!{WheelUp}" ;zoom-
    WheelDown::Send "!{WheelDown}" ;zoom+
    !g::
      Key "^+g" 
      Say "Ungroup"
      return
    ^u::
      Key "^8"
      Say "Expand"
      return
    ![::
      Send "^+["
      Say "Send to Back"
      return
    !]::
      Send "^+]"
      Say "Bring to Front"
      return

 #if