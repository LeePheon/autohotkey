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

#ifWinActive ahk_class illustrator
  ^#z:: ;ctrl-win-z toggle align to selection/artboard
    MouseGetPos mouseX, mouseY
    menuItem := 2 
    alignSelection := "ai-align-selection.png"
    alignArtboard := "ai-align-artboard.png"
    alignWhat := alignSelection
    if (!FileExist(alignSelection) || !FileExist(alignSelection)) {
      Say "Error: some sample file is missing"  
    } else {
      CoordMode "Pixel", "Screen"
      SearchIcon:
      ImageSearch iconX, iconY, 0, 0, A_ScreenWidth, A_ScreenHeight, alignWhat
      if ErrorLevel = 0 {
        Click iconX " " iconY
        Send "{Down " . menuItem . "}{Enter}"
        MouseMove mouseX, mouseY
      } else {
        if alignWhat = alignArtboard {
          Say "Error (" ErrorLevel "): icon not found"
          return
        } else {
          menuItem := 1 
          alignWhat := alignArtboard 
          Goto SearchIcon
        }
      }
    }
    return

