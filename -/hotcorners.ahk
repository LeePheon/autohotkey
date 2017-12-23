SetTimer(HotCorners, 0) ; HotCorners is name of timer, will be reset every 0 seconds until process is killed
return
HotCorners: ; Timer content 
CoordMode (Mouse, Screen) ; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 

 
IsCorner(cornerID)
{
  WinGetPos(X, Y, Xmax, Ymax, "Program Manager") ; get desktop size
  MouseGetPos(MouseX, MouseY) ; Function MouseGetPos retrieves the current position of the mouse cursor
  GetKeyState("controlKeyState", "Control") ; Function GetKeyState retrieves the current status ("U"p or "D"own) of a key
 
  T := 2 ; adjust tolerance value (pixels to corner) if desired
  
  if controlKeyState = U ; use hot corners only if control is not pressed
  {
    CornerTopLeft := (MouseY < T and MouseX < T) ; Boolean stores whether mouse cursor is in top left corner
    CornerTopRight := (MouseY < T and MouseX > Xmax - T) ; Boolean stores whether mouse cursor is in top right corner
    CornerBottomLeft := (MouseY > Ymax - T and MouseX < T) ; Boolean stores whether mouse cursor is in bottom left corner
    CornerBottomRight := (MouseY > Ymax - T and MouseX > Xmax - T) ; Boolean stores whether mouse cursor is in top left corner
  }
  
  if (cornerID = "TopLeft"){
    return CornerTopLeft
  }
  else if (cornerID = "TopRight"){
    return CornerTopRight
  }
  else if (cornerID = "BottomLeft"){
    return CornerBottomLeft
  }
  else if  (cornerID = "BottomRight") {
    return CornerBottomRight
  }
}
 
; Show Task View (Open Apps Overview)
if IsCorner("TopLeft")
{
  Send "#{tab}"
  Loop 
  {
    if ! IsCorner("TopLeft")
      break ; exits loop when mouse is no longer in the corner
  }
}
 
; Show Action Center
if IsCorner("TopRight")
{  
  Send "#a" 
  Loop
  {
    if ! IsCorner("TopRight")
      break ; exits loop when mouse is no longer in the corner
  }  
}
 
; Press Windows 
if IsCorner("BottomLeft")
{  
  Send "{LWin}"
  Loop
  {
    if ! IsCorner("BottomLeft")
      break ; exits loop when mouse is no longer in the corner
  }  
}

; Show Calendar
if IsCorner("BottomRight")
{  
  Send "#b{left}{enter}"
  Loop
  {
    if ! IsCorner("BottomRight")
      break ; exits loop when mouse is no longer in the corner
  }  
}
