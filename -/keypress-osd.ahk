#SingleInstance force
; #NoEnv
; SetBatchLines, -1
; ListLines Off

; Settings
	global TransN                := .5 
	global ShowSingleKey         := true
	global ShowMouseButton       := true
	global ShowSingleModifierKey := true
	global ShowModifierKeyCount  := true
	global ShowStickyModKeyCount := false
	global DisplayTime           := 2000     ; In milliseconds
	global GuiPosition           := "Bottom" ; Top or Bottom
	global FontSize              := 50
	global GuiHeight             := 115
	global Gui                   := GuiCreate()
	global keyPrefix             := "~*"
	global GuiText

CreateGUI()
CreateHotkey()
return

OnKeyPressed:
	try {
		key := GetKeyStr()
		ShowHotkey(key)
		SetTimer "HideGUI", -1 * DisplayTime
	}
	return

OnKeyUp:
	return

_OnKeyUp:
	tickcount_start := A_TickCount
	return

; ===================================================================================
CreateGUI() {
	global
	Gui.Opt("+AlwaysOnTop -Caption +Owner +LastFound +E0x20")
	Gui.MarginX := Gui.MarginY := 0
	Gui.BackColor := "Black"
	Gui.SetFont("cWhite s" FontSize " light", "Segoe UI")
	GuiText := Gui.Add("Text", "vHotkeyText Center y20")
	WinSetTransparent TransN * 255
}

CreateHotkey() {
	Loop 95 {
		k := Chr(A_Index + 31)
		k := (k = " ") ? "Space" : k
		Hotkey keyPrefix . k, "OnKeyPressed"
		Hotkey keyPrefix . k " Up", "_OnKeyUp"
	}

	Loop 24 { ;F1-F24
		Hotkey keyPrefix "F" A_Index, "OnKeyPressed"
		Hotkey keyPrefix "F" A_Index " Up", "_OnKeyUp"
	}

	Loop 10 { ;Numpad0 - Numpad9
		Hotkey keyPrefix "Numpad" A_Index - 1, "OnKeyPressed"
		Hotkey keyPrefix "Numpad" A_Index - 1 " Up", "_OnKeyUp"
	}

	Otherkeys := "WheelDown|WheelUp|WheelLeft|WheelRight|XButton1|XButton2|Browser_Forward|Browser_Back|Browser_Refresh"
						 . "|Browser_Stop|Browser_Search|Browser_Favorites|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|Media_Next"
						 . "|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|Launch_App1|Launch_App2|Help|Sleep"
						 . "|PrintScreen|CtrlBreak|Break|AppsKey|NumpadDot|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|Tab"
						 . "|Enter|Esc|BackSpace|Del|Insert|Home|End|PgUp|PgDn|Up|Down|Left|Right|ScrollLock|CapsLock|NumLock|Pause"
						 . "|sc145|sc146|sc046|sc123"
	Loop Parse, Otherkeys, "|"
	{
		Hotkey keyPrefix . A_LoopField, "OnKeyPressed"
		Hotkey keyPrefix . A_LoopField " Up", "_OnKeyUp"
	}

	If ShowMouseButton {
		Loop Parse, "LButton|MButton|RButton", "|"
			Hotkey keyPrefix . A_LoopField, "OnKeyPressed"
	}

	; for i, mod in ["Ctrl", "Shift", "Alt"] {
	for i, mod in ["LCtrl", "RCtrl", "LShift", "RShift", "LAlt", "RAlt"] {
		Hotkey keyPrefix . mod, "OnKeyPressed"
		Hotkey keyPrefix . mod " Up", "OnKeyUp"
	}
	for i, mod in ["LWin", "RWin"]
		Hotkey keyPrefix . mod, "OnKeyPressed"
}

ShowHotkey(HotkeyStr) {
	WinGetPos ActWin_X, ActWin_Y, ActWin_W, ActWin_H, "A"
	if !ActWin_W
		throw

	text_w := (ActWin_W > A_ScreenWidth) ? A_ScreenWidth : ActWin_W
	text_w := A_ScreenWidth
	GuiText.Value := HotkeyStr
	GuiText.Move("w" text_w " Center")

	if (GuiPosition = "Top")
		gui_y := ActWin_Y
	else
		gui_y := (ActWin_Y + ActWin_H) - GuiHeight
		
	gui_x := 0
	gui_y := A_ScreenHeight - GuiHeight - 30
	Gui.Show("NoActivate x" gui_x " y" gui_y " h" GuiHeight " w" text_w)
}

GetKeyStr() {
	; static modifiers := ["Ctrl", "Shift", "Alt", "LWin", "RWin"]
	static modifiers := ["LCtrl", "RCtrl", "LShift", "RShift", "LAlt", "RAlt"]
	static repeatCount := 1

	for i, mod in modifiers {
		if GetKeyState(mod)
			prefix .= mod " + "
	}

	if (!prefix && !ShowSingleKey)
		throw

	key := SubStr(A_ThisHotkey, 3)

	; if (key ~= "i)^(Ctrl|Shift|Alt|LWin|RWin)$") {
	if (key ~= "i)^(LCtrl|RCtrl|LShift|RShift|LAlt|RAlt|LWin|RWin)$") {
		if !ShowSingleModifierKey {
			throw
		}
		key := ""
		prefix := RTrim(prefix, "+ ")

		if ShowModifierKeyCount {
			if !InStr(prefix, "+") && IsDoubleClickEx() {
				if (A_ThisHotKey != A_PriorHotKey) || ShowStickyModKeyCount {
					if (++repeatCount > 1) {
						prefix .= " ( * " repeatCount " )"
					}
				} else {
					repeatCount := 0
				}
			} else {
				repeatCount := 1
			}
		}
	} else {
		if ( StrLen(key) = 1 ) {
			key := GetKeyChar(key, "A")
		} else if ( SubStr(key, 1, 2) = "sc" ) {
			key := SpecialSC(key)
		} else if (key = "LButton") && IsDoubleClick() {
			key := "Double-Click"
		}
		_key := (key = "Double-Click") ? "LButton" : key

		static pre_prefix, pre_key, keyCount := 1
		global tickcount_start
		if (prefix && pre_prefix) && (A_TickCount-tickcount_start < 300) {
			if (prefix != pre_prefix) {
				result := pre_prefix pre_key ", " prefix key
			} else {
				keyCount := (key=pre_key) ? (keyCount+1) : 1
				key := (keyCount>2) ? (key " (" keyCount ")") : (pre_key ", " key)
			}
		} else {
			keyCount := 1
		}

		pre_prefix := prefix
		pre_key := _key

		repeatCount := 1
	}
	return result ? result : prefix . key
}

SpecialSC(sc) {
	static k := {sc046: "ScrollLock", sc145: "NumLock", sc146: "Pause", sc123: "Genius LuxeMate Scroll"}
	return k[sc]
}

; by Lexikos -- https://autohotkey.com/board/topic/110808-getkeyname-for-other-languages/#entry682236
GetKeyChar(Key, WinTitle := 0) {
	thread := !WinTitle? 0 : DllCall("GetWindowThreadProcessId", "ptr", WinExist(WinTitle), "ptr", 0)
	hkl := DllCall("GetKeyboardLayout", "uint", thread, "ptr")
	vk := GetKeyVK(Key), sc := GetKeySC(Key)
	VarSetCapacity(state, 256, 0)
	VarSetCapacity(char, 4, 0)
	n := DllCall("ToUnicodeEx", "uint", vk, "uint", sc, "ptr", &state, "ptr", &char, "int", 2, "uint", 0, "ptr", hkl)
	return StrGet(&char, n, "utf-16")
}

IsDoubleClick(MSec := 300) {
	Return (A_ThisHotKey = A_PriorHotKey) && (A_TimeSincePriorHotkey < MSec)
}

IsDoubleClickEx(MSec := 300) {
	preHotkey := RegExReplace(A_PriorHotkey, "i) Up$")
	Return (A_ThisHotKey = preHotkey) && (A_TimeSincePriorHotkey < MSec)
}

HideGUI() {
	Gui.Hide()
}