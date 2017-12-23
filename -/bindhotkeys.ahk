; #SingleInstance force

; When any hotkey is pressed, call the "MyFunc" function with the key and whether it went up or down
kd := new KeyDetector("Myfunc")
kd.BindHotkeys()
return 
 
MyFunc(key, event){
	global kd
	if (event){
		; If Escape was pressed, ex
		if (key == "Escape"){
			kd.UnBindHotkeys()
		} else {
			; Key pressed - show tooltip
			Tooltip "You pressed: " key
		}
	} else {
		; Key released - clear tooltip
		Tooltip
	}
}

class KeyDetector {
	__New(name){
		replacements := {33: "PgUp", 34: "PgDn", 35: "End", 36: "Home", 37: "Left", 38: "Up", 39: "Right", 40: "Down", 45: "Insert", 46: "Delete"}
		this.FuncName := name
		keys := {}
		Loop 350 {
			; Get the key name
			code := Format("{:x}", A_Index)
			if ObjHasKey(replacements, A_Index) {
				n := replacements[A_Index]
			} else {
				n := GetKeyName("vk" code)
			}
			if (n = "" || ObjHasKey(keys, n))
				continue
			keys[code] := n
		}
		this.keys := keys
	}
	
	BindHotkeys() {
		for code, n in this.keys {
			fn := Func(this.FuncName).Bind(n, 1)
			hotkey("~" . n, fn)
			fn := Func(this.FuncName).Bind(n, 0)
			hotkey("~" . n . " up", fn)
		}
	}

	UnBindHotkeys(){
		for code, n in this.keys {
			hotkey("~" . n, Off)
			hotkey("~" . n . " up", Off)
		}
	}
}
