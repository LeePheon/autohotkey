;tooltip
Say(text, time := 1.5, x := 0, y := 0) {
  if (x && y) {
    ToolTip text, x, y
  } else {
    ToolTip text
  }
  SetTimer "stop", time * 1000
  return

  stop:
    ToolTip
    SetTimer , "Off"
    return
}

;send with keyboard layout correction
Key(string, allowInTextField := true) {
  if !allowInTextField {
    if SubStr(ControlGetFocus(), 1, 4) = "Edit" {
      return
    }
  }
  if GetLang() = "Russian" {
    Lang "English"
    Sleep 180
  }
  Send string
}
; Key(string) {
;   global KeyString
;   if GetLang() = "Russian" {
;     KeyString := ""
;     RegExReplace(string, "i)([^{}])(?:{.*?})*(?CKeyRepl)")
;   } else {
;     KeyString := string
;   }
;   Log KeyString
;   Send KeyString
; }
; KeyRepl(match) {
;   global KeyString 
;   if RegExMatch(match.1, "i)[a-z]") {
;     KeyString .= Format("{SC{:03X}}", GetKeySC(match.1)) 
;   } else {
;     KeyString .= match.1
;   }
;   KeyString .= SubStr(match.0, 2)
; }

;send with optional modifiers
KeyMod(string, exclude := "") {
  mods := ""
  for name, mod in {"Alt": "!", "Ctrl": "^", "Shift": "+", "LWin": "#"} {
    if !InStr(exclude, mod) {
      if GetKeyState(name) {
        mods .= mod ;add modifier to combo if it has been pressed
      }
    }
  }
  Key mods string
}

;emulate mouse click with modifier (for 3d apps)
Mouse(action, keys*) { 
  ;action - L/M/R - bound mouse button
  
  MouseGetPos mouseX1, mouseY1
  loop keys.Length() {
    Send "{" keys[A_Index] " down}"
  }

  KeyWait action "Button"
  loop keys.Length() {
    Send "{" keys[A_Index] " up}"
  }

  MouseGetPos mouseX2, mouseY2
  if mouseX1 = mouseX2 && mouseY1 = mouseY2 {
    Sleep 100
    Send "{" action "Button}"
  } 
}

;send marked message to debugView.exe
Log(msg) {
  OutputDebug "ahk: " msg 
}

;keyboard layout switch
Lang(lng := "") {
  if lng = "Russian" {
    SendMessage(0x50,, 0x4190419,, "A")
    if GetLang() = "English" {
      Send "#{Space}" 
    }
  } else if lng = "English" {
    SendMessage(0x50,, 0x4090409,, "A") 
    if GetLang() = "Russian" {
      Send "#{Space}" 
    }
  } else {
    lng := GetLang()
    SendMessage(0x50, 2,,, "A")
    if GetLang() = lng {
      Send "#{Space}"
    }
  }
}

;get keyboard layout name of active app
GetLang() {
  return GetInputLangName(GetInputLangID("A"))
}

;get keyboard layout id 
GetInputLangID(window) {
  if !(hWnd := WinExist(window)) {
    return
  }
  WinGetClass(Class)

  if (Class == "ConsoleWindowClass") {
    ConsolePID := WinGetPID
    DllCall("AttachConsole", Ptr, ConsolePID)
    VarSetCapacity(buff, 16)
    DllCall("GetConsoleKeyboardLayoutName", Str, buff)
    DllCall("FreeConsole")
    langID := "0x" . SubStr(buff, -3)
  } else {
    langID := DllCall("GetKeyboardLayout", Ptr, DllCall("GetWindowThreadProcessId", Ptr, hWnd, UInt, 0, Ptr), Ptr) & 0xFFFF
  }
  return langID
}
 
;get keyboard layout name
GetInputLangName(LangId) {
  Size := (DllCall("GetLocaleInfo", UInt, LangId, UInt, 0x1001, UInt, 0, UInt, 0) * 2) ;LOCALE_SENGLANGUAGE := 0x1001
  VarSetCapacity(LocaleSig, Size, 0)
  DllCall("GetLocaleInfo", UInt, LangId, UInt, 0x1001, Str, LocaleSig, UInt, Size)
  return LocaleSig
}
