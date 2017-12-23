; ^ ctrl, ! alt, + shift, # win
;---------- Autorun

;SetTimer, XaraFail ;close some crap windows
;SetTimer, OutlookTemp ;remove some crap files
SetTimer, MoItrial, 1000 ;Close MoI trial window

MoItrial:
  WinWait MoI, MoI, 1
  if not ErrorLevel
    IfWinExist, MoI trial, MoI
    {
      WinActivate
      WinClose
    }
    IfWinExist, MoI-триал, MoI
    {
      WinActivate
      WinClose
    }
return

OutlookTemp:
  IfExist, \\vmware-host\Shared Folders\Documents\Outlook Temp
  FileRemoveDir \\vmware-host\Shared Folders\Documents\Outlook Temp
return

XaraFail: ;some shit windows
  IfWinExist, Xara, Failed to load file
  {
    WinActivate
    WinClose
  }

  IfWinExist, Xara, Don't show this A&gain
  {
    WinActivate
    WinClose
  }

  IfWinExist, Error from Xara, An error occurred
  {
    WinActivate
    WinClose
  }
return

;---------- Xara HotKeys
#IfWinActive, Xara
{

  ;--- F1 - toggle outline
  F1::
   ControlGet, ViewQuality, Style,, BUTTONSTRIP.21, A
   if ViewQuality & 1
    ControlClick, BUTTONSTRIP.24, A
   else
    ControlClick, BUTTONSTRIP.21, A
  return

  ;--- Ctrl-F1 - toggle line scaling
  ^F1::
   ;ControlGet, TextTool, Style,, TEXTTOOLBMP, A
   ControlClick, BUTTONSTRIP2.18, A
  return

  ;--- Shift-F1 - toggle aspect ratio
  +F1::ControlClick, SMALLBUTTONSTRIP.4, A

  ;--- Ctrl-T - toggle snap to grid
  ^t:: ControlClick, BUTTONSTRIP.6, A

  ;--- Ctrl-Y - toggle show guides
  ^y:: ControlClick, BUTTONSTRIP.62, A

  ;--- Ctrl-Shift-Y - toggle snap to guides
  ^+y::ControlClick, BUTTONSTRIP.63, A

  ;--- Ctrl-M - toggle snap to objects
  ^m:: ControlClick, BUTTONSTRIP2.35, A

  ;--- Alt-R - reverse paths
  !r:: ControlClick, BUTTONSTRIP2.94, A

  ;--- Ctrl-F12 - toggle number of subdivisions snapping (2 or 10)
  ^F12::
    Send ^+{vk4F} ;call preferences

    WinWaitActive, Options
    SendMessage, 0x1330, 1,, SysTabControl321, Options ;select grid settings

    ControlGetText, SnapOption, Edit2, Options
    if (SnapOption = 10)
     ControlSetText, Edit2, 2, Options
    else
     ControlSetText, Edit2, 10, Options

    ControlClick, Button97, Options,,, 5 ;submit window (triple click)
  return

  ;--- Ctrl-` - toggle fill/trasparency profile
  ^`::
  ^\:: ControlClick, BUTTONSTRIP2.89, A

  ;--- Ctrl-5 - flip horizontally
  ^5::
   ControlGet, TextTool, Style,, TEXTTOOLBMP, A
   if TextTool & 1
    Send 5
   else
    ControlClick, BUTTONSTRIP2.13, A
  return

  ;--- Ctrl-6 - flip vertically
  ^6::
   ControlGet, TextTool, Style,, TEXTTOOLBMP, A
   if TextTool & 1
    Send 6
   else
    ControlClick, BUTTONSTRIP2.14, A
  return

  ;--- Some shit
  ;^7::
  ;  ControlSetText, Edit12, 13, A
  ;return

  ;--- Alt-E - toggle color model in "Color Editor"
  !e::
   IfWinExist, Colour editor
   {
     ControlGet, combox, FindString, colour model, ComboBox2, Colour editor

     if combox
      combox = ComboBox3
     else
      combox = ComboBox2

     colorModel +=1
     if (ColorModel = 5)
       colorModel = 1

     Control, Choose, %colorModel%, %combox%, Colour editor
   }
  return

}

;---------- Apple VM hotkeys

#UseHook
  ;--- Win-Tab -> Alt-Tab
  LWin & Tab::AltTab

  ;--- Alt-Tab -> Ctrl-Tab
  !Tab::send ^{Tab}
#UseHook off

;---------- Console Application Hotkeys

#IfWinActive ahk_class ConsoleWindowClass
#IfWinActive ahk_class VirtualConsoleClass
{
 ^c::Send ^{Ins}
 ^v::Send +{Ins}
 ^#c::Send ^C
 ^q::Send ^q
 #BS::Send {Insert}
 ;#h::Send ^h ;virtualbox ^H bug

}

;---------- Global Hotkeys

#IfWinActive
{
  ;!Left::Send ^{Left}
  ;!Right::Send ^{Right}

  ;^Left::Send !{Left}
  ;^Right::Send !{Right}

  RAlt::AppsKey
  RWin::RControl

  ;--- Ctrl-Q - close window
  ^q::Send !{F4}

  ;--- Alt-CapsLock - CapsLock
  ;--- CapsLock, Ctrol-Space - change keyboard layout
  ;CapsLock::
  ;^Space::PostMessage, 0x50, 2, 0,, A ;0x50 is WM_INPUTLANGCHANGEREQUEST

  ;--- ` - `
  SC056::Send ``

  ;--- Shift-` - ~
  +SC056::Send {~}

  ;--- Ctrl-Backspace - delete
  ^BS::Delete

  ;--- Win-Backspace - insert
  #BS::Insert

  ;--- Win-Alt-Z - Reload Autohotkey
  #!z::Reload
}
