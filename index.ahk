;!alt ^ctrl +shift #win

SetKeyDelay -1
#Include functions.ahk
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
#ifWinActive

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
  #Include *i snippets.ahk

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

  #IfWinActive
  ;win-1..0 - disable taskbar application hotkeys
    *#1::
    *#2::
    *#3::
    *#4::
    *#5::
    *#6::
    *#7::
    *#8::
    *#9::
    *#0::
    return

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

;fn-delete - dropbox url patch
  Break::
    if SubStr(Clipboard, 1, 19) = "https://www.dropbox" {
      Clipboard := RegexReplace(Clipboard, "^(.*?)www\.dropbox(.*?)(?:\?.*?)*$", "$1dl.dropboxusercontent$2")
      Say "DropBox link converted"
    } else {
      Say "No DropBox link in clipboard"
    }
    return

;win-f12 - toggle window transparency
  #f12::
    steps := 4
    trans := WinGetTransparent("A")
    trans := trans ? trans - 255/steps : 255 - 255/steps
    WinSetTransparent trans > 0 ? trans : "OFF", "A"
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
  #ifWinActive ahk_exe chrome.exe
    f1::Key "^t"                  ;new tab
    f2::Key "^{PgUp}"             ;prev tab
    f3::Key "^{PgDn}"             ;next tab
    f4::Key "+^t"                 ;undo close tab

  #IfWinActive ahk_exe Code.exe   ;VSCode
    #.::Send "^,"                 ;prefs

  #ifWinActive ahk_class CabinetWClass ;explorer.exe (QTTabBar)
    #.::Key "!o"                  ;prefs
    $f2::Key "+{f3}"              ;prev tab
    $+f2::Key "{f2}"              ;shift-f2 - rename
    ^+Del::                       ;shift-del - empty recycle bin
      FileRecycleEmpty
      if !ErrorLevel {
        Say "Recycled"
      }
      return
    ^i::Send "!{Enter}"           ;ctrl-i - show file info
      return
    !n::                          ;alt-n - move selected files to new folder
      Say "Move selected to new folder"
      ClipSaved := ClipboardAll()
      Send "^{vk58}"  ;cut selection
      Sleep 200
      Send "^+{vk4E}" ;new folder
      Sleep 200
      Send "{Enter}"
      Sleep 200
      Send "{Enter}"  ;enter new folder
      Sleep 800
      Send "^{vk56}"  ;paste selection
      Sleep 200
      Send "{BS}"     ;go back
      Sleep 200
      Send "{f2}"     ;rename folder
      Clipboard := ClipSaved
      ClipSaved := ""
      return

  #ifWinActive ahk_exe firefox.exe
    #.::                          ;prefs
      Key "!t"
      Sleep 100
      Key "o"
      return
    #!.::Key "^+a"                ;extensions
    f1::Key "^{vk54}"             ;new tab
    f2::Key "^{PgUp}"             ;prev tab
    f3::Key "^{PgDn}"             ;next tab
    f4::Key "+^t"                 ;undo close tab
    f11::                         ;toggle vpn
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

  #ifWinActive ahk_exe hh.exe     ;windows help
    Escape::WinClose "A"
  #Include *i illustrator.ahk

;------ Graphics
  #ifWinActive ANSYS SpaceClaim
    #.::Key "^+."                 ;prefs
    f1::Click "100 40"            ;first tab
    f2::Click "1100 40 WheelUp"   ;prev tab
    f3::Click "1100 40 WheelDown" ;next tab
    f4::Click "660 40"            ;middle tab
    $!f1::Send "{f1}"             ;alt-f1 - help
   ^+z::Key "^y"                  ;redo
     `::Key "o"                   ;pie menu
     y::Key "p"                   ;push
     g::Key "m"                   ;move
    $!1::                         ;alt-1 - toggle transparent/opaque
      if scTransparent := !scTransparent {
        Key "+!1"
        Say "Transparent"
      } else {
        Key "!1"
        Say "Opaque"
      }
      return
    $!2::                         ;alt-2 - toggle perspective/ortho
      if scPerspective := !scPerspective {
        Key "+!2"
        Say "Perspective"
      } else {
        Key "!2"
        Say "Ortho"
      }
      return
    !3::
      Send "{RButton}{Down 6}{Right}{Enter}"
      return
    ^!3::
      Send "{RButton}{Down 6}{Right}{Down}{Enter}"
      return
    ^+3::
      Send "{RButton}{Down 6}{Right}{Down 2}"
      Sleep 50
      Send "{Enter}"
      return
     !4::
       Send "{RButton}{Down 4}{Rigt}"
       return

  #ifWinActive ahk_exe blender.exe
    #.::Key "^!u"                 ;prefs
    #`::Key "^!+c"                ;set origin
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
    return

  #IfWinActive ahk_exe CINEMA 4D.exe
    MButton::Mouse "M", "LAlt", "MButton"
    RButton::Mouse "R", "LAlt", "LButton"

  #ifWinActive ahk_exe FreeCAD.exe
    RButton::Mouse "R", "MButton", "LButton"

  #ifWinActive ahk_exe Fusion360.exe
    MButton::Mouse "M", "LCtrl", "LShift", "MButton"
    RButton::Mouse "R", "MButton"

  #ifWinActive ahk_exe GravitDesigner.exe
    MButton::Mouse "M", "Space", "LButton"
    WheelDown::Send "^{WheelDown}"
    WheelUp::Send "^{WheelUp}"

  #ifWinActive ahk_exe LeoCAD.exe
    MButton::Mouse "M", "LAlt", "MButton"
    RButton::Mouse "R", "LAlt", "LButton"

  #IfWinActive ahk_exe modo.exe
    MButton::Mouse "M", "LAlt", "LShift", "LButton"
    RButton::Mouse "R", "LAlt", "LButton"
    $^w::Key "^w" ;close scene

  #ifWinActive ahk_exe keyshot6.exe
    RButton::Mouse "R", "LButton"

  #IfWinActive ahk_exe Rocket3F.exe
    MButton::Mouse "M", "LAlt"
    RButton::Mouse "R", "LAlt", "LButton"

  #ifWinActive ahk_exe SketchUp.exe
    MButton::Mouse "M", "LShift", "MButton"
    RButton::Mouse "R", "MButton"

 #IfWinActive