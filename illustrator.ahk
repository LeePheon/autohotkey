;---------- illustrator
#if WinActive("ahk_exe Illustrator.exe")

  ;;mouse
    +#LButton:: ;shift-win-lmb - unlock clicked object
      Key "!sd" 
      Key "!ok" 
      Key "{Shift Down}"
      Click
      Key "{Shift Up}"
      SLeep 100
      Key "!ols" 
      Sleep 500
      Click
      Say "Unlock Selected"
      return

    MButton:: ;pan
      Send "{Space down}{LButton down}"
      KeyWait "MButton"
      Send "{Space up}{LButton up}"
      return

    WheelUp:: ;zoom-
      Send "!{WheelUp}"
      return

    WheelDown:: ;zoom+
      Send "!{WheelDown}"
      return

  ;;other
    ~Alt Up:: Send "!" ;disable menu on single alt click

    ~Delete:
      Say "Delete"
      return

    ^BS::
      Key "!op{Enter}c"
      Say "Clean Up..."
      return

    !BS:: ;back one level isolation mode
      MouseGetPos mouseX, mouseY
      isolateBackButton := "ai\back-one-level.png"
      if (!FileExist(isolateBackButton)) {
        Say "Error: some sample file is missing"  
      } else {
        ImageSearch isolateBackButtonX, isolateBackButtonY, 0, 0, A_ScreenWidth, A_ScreenHeight, isolateBackButton
        if ErrorLevel = 0 {
          Click isolateBackButtonX " " isolateBackButtonY
          MouseMove mouseX, mouseY
          Say "Back One Level"
        }
      }
      return

    +^BS:: ;delete unused items
      Key "!frmad{Enter}" 
      Say "Delete Unused Items"
      return

    ;Enter::nudge same distance (after alt-drag)
    ;!Enter::copy same distance (after alt-drag)

    +Space:: ;nonbreakable space
      MouseGetPos mouseX, mouseY
      paletteTitle := "ai\character.png"
      paletteButton := "ai\menu.png"
      if (!FileExist(paletteTitle) || !FileExist(paletteButton)) {
        Say "Error: some sample file is missing"  
      } else {
        Send "{Space}{Left 1}+{Right 2}"
        CoordMode "Pixel", "Screen"
        activatePalette := 0
        SearchCharacter:
        ImageSearch paletteTitleX, paletteTitleY, 0, 0, A_ScreenWidth, A_ScreenHeight, paletteTitle
        if ErrorLevel = 0 {
          ImageSearch paletteButtonX, paletteButtonY, paletteTitleX + 67, paletteTitleY, A_ScreenWidth, paletteTitleY + 18, paletteButton
          if ErrorLevel = 0 {
            Click paletteButtonX " " paletteButtonY
            Send "{Down 10}{Enter}{Right}{Left}"
            MouseMove mouseX, mouseY
            Say "nbsp"
          } else {
            Say "Error (" ErrorLevel "): menu not found"
          }
        } else {
          if activatePalette {
            Say "Error (" ErrorLevel "): palette not found" 
          } else {
            Send "{F3}" ;character palette hotkey
            sleep 200
            activatePalette := 1
            Goto SearchCharacter
          }
        }
      }
      return

  ;;arrows
    ;shift         x10 nudge
    ;alt-cmd       type: x10 leading/x5 tracking
    ;shift-alt-cmd type: x10 leading/tracking
    ;alt           copy & nudge. type: leading/tracking
    ;shift-alt     copy & x10 nudge. type: leading/tracking

    ;;align
      ^#z:: ;toggle align to
        iconsNotFound := 0
        alignTo := ["selection", "keyobject", "artboard"] 
        MouseGetPos mouseX, mouseY
        for k, v in alignTo {
          file := "ai\align-" v ".png"
          if !FileExist(file) {
            Say "Error: file " file " is missing" 
            return
          } else {
            CoordMode "Pixel", "Screen"
            ImageSearch iconX, iconY, 0, 0, A_ScreenWidth, A_ScreenHeight, file
            if ErrorLevel = 0 {
              Click iconX " " iconY
              Send "{Down}{Enter}"
              MouseMove mouseX, mouseY
              Say "Align to " alignTo[k + 1 > alignTo.Length() ? 1 : k + 1] 
              return
            } else {
              iconsNotFound++ 
            }
          }
        }
        if iconsNotFound = alignTo.Length() {
          Say "Error(" ErrorLevel "): icons not found"
        }
        return

      ^#Up::
        Key "!frmaat"
        Say "Align Top"
        return

      ^#Down::
        Key "!frmaab"
        Say "Align Bottom"
        return
        
      ^#Left::
        Key "!frmaal"
        Say "Align Left"
        return
        
      ^#Right::
        Key "!frmaar"
        Say "Align Right"
        return
        
      ^#m::
        Key "!frmaam"
        Say "Align Middle"
        return 

      ^#c::
        Key "!frmaac"
        Say "Align Center"
        return

    ;;distribute
      !^#Up::
        Key "!frmadd{Enter}t" 
        Say "Distribute Top"
        return

      !^#Down::
        Key "!frmadd{Enter}b" 
        Say "Distribute Bottom"
        return

      !^#Left::
        Key "!frmadd{Enter}l" 
        Say "Distribute Left"
        return

      !^#Right::
        Key "!frmadd{Enter}r" 
        Say "Distribute Right"
        return

      !^#m::
        Key "!frmadd{Enter}m" 
        Say "Distribute Middle"
        return

      !^#c::
        Key "!frmadd{Enter}c" 
        Say "Distribute Center"
        return

      !^#h::
        Key "!frmadd{Enter}h" 
        Say "Distribute Horizontal"
        return

      !^#v::
        Key "!frmadd{Enter}v" 
        Say "Distribute Vertical"
        return

  ;;f1-f12
    ;;astute
      ~^f1::
        Say "DirectPrefs"
        return

      ~^f2::
        Say "Texture"
        return

    ~f1::
      ;Key "!vo" 
      Say "Preview/Outline"
      return

    +f1::
      Key "!wl"
      Say "Layers"
      return

    ~!^f1::
      Key "!vx{Enter}"
      Say "Pixel Preview"
      return

    !f1::
      Key "!wd"
      Say "Document Info"
      return

    #f1::
      return

    ~f2::
      ; Key "!w{Down 16}{Enter}"
      Say "Color"
      return

    +f2::
      Key "!wttt{Enter}"
      Say "Transform"
      return

    #f2::
      Key "!wn" 
      Say "Actions"
      return

    ~f3::
      ; Key "!wttttt{Enter}c" 
      Say "Character"
      return

    +f3::
      Key "!w{Down 9}{Enter}" 
      Say "Align"
      return

    !f3::
      Key "!w{Down 12}{Enter}" 
      Say "Asset Export"
      return

    #f3::
      Key "!w" 
      Key "tttt{Enter}g" 
      Say "Type/Glyphs"
      return

    f4::
      Key "!frmal" 
      Say "Locate Objects"
      return

    +f4::
      Key "!wp" 
      Say "PathFinder"
      return

    f5::
      Key "!frmaff{Enter}" 
      Say "Flip Vertical"
      return

    !f5::
      Key "!frmar{Enter}" 
      Say "Rotate Left"
      return

    +f5::
      Key "!wm{Enter}"
      Say "Magic Wand"
      return

    f6::
      Key "!frmaf{Enter}" 
      Say "Flip Horizontal"
      return

    !f6::
      Key "!frmarr{Enter}" 
      Say "Rotate Right"
      return

    f7::
      Key "!sb" 
      Say "Next Object Below"
      return

    f8::
      Key "!sv" 
      Say "Next Object Above"
      return

    f9::
      Key "!frmas" 
      Say "Scripts/Scale 122 and Expand"
      return

    f10::
      Key "!w{Down 3}{Right}{Enter}" 
      Say "Workspase/my"
      return

    !f10::
      Key "!w{Down 3}{Right}{Down 2}{Enter}" 
      Say "Workspase/Essential"
      return

    f11::
      Key "!frtt{Enter}ss{Enter}"
      Say "Scripts/Swap Objects"
      return

  ;;0-9
    ;1
      ;<astute inkscribe>
      ;<pen>

      ^1::
        Key "!ve"
        Say "View/Actual Size"
        return

      !1::
        Key "!frmapa" 
        Say "Pathfinder/Add"
        return
      
      !^1::
        Key "!frmapc{Enter}" 
        Say "Pathfinder/Compound Add"
        return
      
      #1::
        Key "!v1" 
        Say "View/1"
        return

    ;2
      ;<anchor point>
      ;<astute pathscribe>

      ^2::
        Key "!op{Enter}a" 
        Say "Path/Add Anchor Points"
        return

      !2::
        Key "!frmaps" 
        Say "Pathfinder/Subtract"
        return

      !^2::
        Key "!frmapccccc{Enter}" 
        Say "Pathfinder/Compound Subtract"
        return

      #2::
        Key "!v2" 
        Say "View/2"
        return

    ;3
      ;<astute extend path>
      ;<astute dynamic corners>

      ^3::
        Key "!v{Down 18}{Enter}"
        Say "Hide Bounding Box"
        return

      +!^3::
        Key "!v{Down 11}{Enter}" 
        Say "Hide Edges"
        return

      !3::
        Key "!frmapi" 
        Say "Pathfinder/Intersect"
        return

      !^3::
        Key "!frmapcccc{Enter}" 
        Say "Pathfinder/Compound Intersect"
        return

      #3::
        Key "!otb" 
        Say "Reset Bounding Box"
        return

    ;4
      ;<astute smart remove brush>
      ;<astute straighten>

      ^4::
        Key "!op{Enter}r" 
        Say "Path/Remove Anchor Points"
        return

      +^4::
        Key "!op{Enter}m" 
        Say "Path/Simplify..."
        return

      !4::
        Key "!frmape" 
        Say "Pathfinder/Exclude"
        return

      !^4::
        Key "!frmapcc{Enter}" 
        Say "Pathfinder/Compound Exclude"
        return

      #4:: ;cut path
        Key "!frpcccccc{Enter}" 
        Say "Cut Path"
        ; MouseGetPos mouseX, mouseY
        ; file := "ai\cut-path.png"
        ; if !FileExist(file) {
        ;   Say "Error: file " file " is missing" 
        ; } else {
        ;   CoordMode "Pixel", "Screen"
        ;   ImageSearch iconX, iconY, 0, 0, A_ScreenWidth, A_ScreenHeight, file
        ;   if ErrorLevel = 0 {
        ;     Click iconX " " iconY
        ;     MouseMove mouseX, mouseY
        ;     Say "Cut Path"
        ;   }
        ; }
        return

    ;5
      ;<astute reposition point>
      ;<table saw>

      ;^5::Key "Other Objects/Repeat Pathfinder"
      !5::
        Key "!op{Enter}d" 
        Say "Path/Divide Objects Below"
        return

      !^5::
        Key "!frmapccc{Enter}" 
        Say "Pathfinder/Compound Expand"
        return

    ;6
      ;<eraser>
      ;<path eraser>

    ;7
      ;<knife>
      ;<scissors>

    ;8
      ;
      ;

    ;9
      ;
      ;

    ;0
      ;<opacity 0%>
      ;<opacity 20%>
      
      ^0::
        Key "!vw{Enter}" 
        Say "View/Fit Artboard in Window"
        return

      !0::
        Key "!vl" 
        Say "View/Fit All in Window"
        return

    ;`
      ;nothing (reserved for pattern resize)
      ;<shape builder>

      ^`::
        Key "!w{Down 5}{Enter 2}" 
        Say "Extensions/Console"
        return

    ;-
      ;<opacity 40%>
      ;<opacity 60%>
      
      ^-::
        Key "!vm" 
        Say "View/Zoom Out"
        return

      ~+^-::
        Say "Type/Discretionary Hyphen"
        return

    ;=
      ;<opacity 80%>
      ;<opacity 100%>

      ^=::
        Key "!vz" 
        Say "View/Zoom In"
        return

      ~+^=::
        Say "Other Text/Toggle Line Composer"
        return

  ;;A-Z
    ;A
      ;<direct selection>
      ;<group selection>

      ^a::
        Key "!sa" 
        Say "Select All"
        return

      +^a::
        Key "!si" 
        Say "Inverse"
        return

      !+^a::
        Key "!sl" 
        Say "Select All on Active Artboard"
        return

      !a::
        Key "!sd" 
        Say "Deselect"
        return

      #a::
        Key "!sr" 
        Say "Reselect"
        return

    ;B
      ;<paintbrush>
      ;<blob brush>
      
      ^b::
        Key "!oom" 
        Say "Compound Path/Make"
        return

      !b::
        Key "!oor" 
        Say "Compound Path/Release"
        return

      #b::
        Key "!op{Enter}o" 
        Say "Path/Offset Path..."
        return

    ;C
      ;<swap fill/stroke>
      ;<artboard>

      ~^c::
        Say "Edit/Copy"
        return

      ~!c::
        Say "[Effect]"
        return

      +!c::
        Key "!vb" 
        Say "Hide Artboards"
        return

      +^c::
        Key "!oaa{Enter}e" 
        Say "Artboards/Rearrange"
        return

      !^c::
        Key "!oaa{Enter}s" 
        Say "Artboards/Fit to Selected Art"
        return

    ;D
      ;<no fill/stroke>
      ;<default fill and stroke>

      ^d::
        Key "!frmd" 
        Say "Duplicate"
        return

      !d::
        Key "!otm" 
        Say "Transform/Move..."
        return

      +^d::
        Key "!ott" 
        Say "Transform/Transform Again"
        return

      #d::
        Key "!otn" 
        Say "Transform/Transform Each..."
        return

    ;E
      ;<ellipse>
      ;<polygon>

      ^e::
        Key "!fe{Enter}" 
        Say "Export for Screens"
        return

      ~!e::
        Say "[Edit]"
        return

      +^e::
        Key "!fee{Enter}" 
        Say "Export as..."
        return

      +!e::
        Key "!fe{Left}{Down}{Enter}" 
        Say "Export Selection..."
        return

    ;F
      ;<live paint bucket>
      ;<live paint selection>

      ^f::
        Key "!onm" 
        Say "Live Paint/Make"
        return

      ~!f::
        Say "[File]"
        return
        
      +^f::
        Key "!ong" 
        Say "Live Paint/Gap Options..."
        return

      +!f::
        Key "!one" 
        Say "Live Paint/Expand"
        return

      #f::
        Key "!onm{Enter}" 
        Say "Live Paint/Merge"
        return

    ;G
      ;<gradient>
      ;<select gradient fill>

      ^g::
        Key "!og" 
        Say "Group"
        return

      !g::
        Key "!ou" 
        Say "Ungroup"
        return

      #g::
        Key "!frcf"
        Say "Flat Gradient"
        return

      #^g::
        Key "!vww{Up}{Enter}" 
        Say "Gradient Annotator"
        return

    ;H
      ;
      ;

      ^h::
        Key "!ohs" 
        Say "Hide/Selection"
        return

      +^h::
        Key "!oha" 
        Say "Hide/All Artwork Above"
        return

      !^h::
        Key "!{Space}{Down 4}{Enter}" 
        Say "Hide Illustrator"
        return

      !h::
        Key "!o{Down 8}{Enter}" 
        Say "Show All"
        return

      #h:: 
        Key "!si"
        Key "!ohs"
        Say "Hide Other"
        return

    ;I
      ;<line width>
      ;<reshape>

      ^i::
        Key "!frtt{Enter}ii{Enter}" 
        Say "Transform/Isometric Right"
        return

      +^i::
        Key "!frtt{Enter}uu{Enter}" 
        Say "Transform/unIsometric Right"
        return

      #i::
        Key "!frtt{Enter}i{Enter}" 
        Say "Transform/Isometric Left"
        return

      +#i::
         Key "!frtt{Enter}u{Enter}" 
        Say "Transform/unIsometric Left"
        return

      !i::
        Key "!frtt{Enter}iii{Enter}" 
        Say "Transform/Isometric Top"
        return

      +!i::
        Key "!frtt{Enter}uuu{Enter}" 
        Say "Transform/Isometric Top"
        return

    ;J
      ;<join>
      ;<astute connect>

      ^j::
        Key "!op{Enter}j" 
        Say "Path/Join"
        return

     !^j::
        Key "!frpcccc{Enter}" 
        Say "Path/Close"
        return

      +^j::
        Key "!op{Enter}{Down 3}{Enter}" 
        Say "Path/Concatenate"
        return

      !j::
        Key "!op{Enter}{Down 4}{Enter}" 
        Say "Path/Assimilate"
        return

      +!j::
        Key "!op{Enter}v" 
        Say "Path/Average..."
        return

      #j::
        Key "!frpm" 
        Say "Merge Overlapped Points"
        return

    ;K
      ;<pattern tile>
      ;<gradient mesh>

      ^k::
        Key "!oee{Enter}m" 
        Say "Pattern/Make"
        return

      +^k::
        Key "!oee{Enter}p" 
        Say "Pattern/Edit"
        return

      !k::
        Key "!oee{Enter}t" 
        Say "Pattern/Tile Edge Color..."
        return

    ;L
      ;<astute rotate at collision>
      ;<astute rotate to collision>

      ^l::
        Key "!ols" 
        Say "Lock Selection"
        return

      !l::
        Key "!ok" 
        Say "Unlock All"
        return

      #l::
        Key "!olo" 
        Say "Lock Other Layers"
        return

    ;M
      ;<drawing mode> (normal/behind/inside)
      ;<screen mode> (window/fullscreen)

      ^m::
        Key "!omm{Enter}m" 
        Say "Clipping Mask/Make"
        return

      !m::
        Key "!omm{Enter}r" 
        Say "Clipping Mask/Release"
        return

      +^m::
        Key "!omm{Enter}e" 
        Say "Clipping Mask/Edit Contents"
        return

      #m::
        Key "!fracc{Enter}" 
        Say "Arrange Clipper"
        return

      !#m::
        Key "!frab{Enter}" 
        Say "Arrange BottomClipper"
        return

    ;N
      ;<pen>
      ;<astute dynamic sketch>

      ^n::
        Key "!fn" 
        Say "New"
        return
        
      !n::
        Key "!ft" 
        Say "New From Template..."
        return

      ~+^n::
        Say "New from Template"
        return

    ;O
      ;<free transform>
      ;<snap to collision>

      ~^o::
        Say "File/Open"
        return

      ~!o::
        Say "[Object]"
        return

      #o::
        Key "!c3e"
        Say "3d Extrude & Bevel"
        return

    ;P
      ;<puppet warp>
      ;

      ^p::
        Key "!vpg" 
        Say "Perspective Grid/Show Grid"
        return

      +^p::
        Key "!vpd" 
        Say "Perspective Grid/Define Grid..."
        return

      !^p::
        Key "!fp" 
        Say "Print"
        return

      !p::
        Key "!vp" 
        Say "Perspective Grid Presets..."
        return

      #p::
        Key "!vps" 
        Say "Perspective Grid/Lock Station Point"
        return

    ;Q
      ;<rotate>
      ;<astute orient>

      ^q::
        Key "!vi{Enter}" 
        Say "View/Smart Guides"
        return

      ~!^q::
        Say "Quit"
        return

      !q::
        Key "!otr" 
        Say "Transform/Rotate..."
        return

      #q::
        Key "!frmtt{Enter}" 
        Sleep 300
        Say FileRead(EnvGet("TMP") "\ai_state.txt")
        ; Say "Toggle Selection by Path Only"
        return

    ;R
      ;<rectangle>
      ;<rectangular grid>

      ^r::
        Key "!frmrr{Enter}" 
        Say "Rename All Selected Objects"
        return

      !r::
        Key "!vrr" 
        Say "Show Rulers"
        return

      #r::
        Key "!op{Enter}e" 
        Say "Path/Reverse Path Direction"
        return

    ;S
      ;<scale>
      ;<shear>

      ~^s::
        Say "Save"
        return

      ~!s::
        Say "[Select]"
        return

      ~+^s::
        Say "Save As"
        return

      ~!^s::
        Say "Save a Copy"
        return

      +!s::
        Key "!ots" 
        Say "Transform/Scale..."
        return

      #s::
        Key "!oth" 
        Say "Transform/Shear..."
        return

    ;T
      ;<type>
      ;<touch type>

      ~^t::
        Say "Other Text/Highlight Font"
        return

      +^t::
        Key "!tpt"
        Say "Type on a Path Options..."
        return

      ~!t::
        Say "[Type]"
        return

      +!t::
        Key "!ts"
        Say "Show Hidden Characters"
        return

      #t::
        Key "!w{t 5}{Enter}t"
        Say "Type/Tabs"
        return

    ;U
      ;<spiro spline tool>
      ;<curvature>

      ^u::
        Key "!ox" 
        Say "Object/Expand..."
        return

      +^u::
        Key "!op{Enter}u" 
        Say "Object/Path/Outline Stroke"
        return

      !u::
        Key "!oe{Enter}" 
        Say "Object/Expand Appearance"
        return

      #u::
        Key "!to" 
        Say "Type/Create Outlines"
        return

    ;V
      ;<selection>
      ;<lasso>
      
      ~^v::
        Say "Paste"
        return

      ~!v::
        Say "[View]"
        return

      +^v::
        Key "!es{Enter}" 
        Say "Paste in Place"
        return

      +!v::
        Key "!ef" 
        Say "Paste in Front"
        return

      ~!^v::
        Say "Switch Selection Tool"
        return

      #v::
        Key "!eb" 
        Say "Paste in Back"
        return

    ;W
      ;<reflect>
      ;<astute mirrorme>

      ^w::
        Key "!fc" 
        Say "File/Close"
        return

      ~!w::
        Say "[Window]"
        return

      ^!w::
        Key "!ote" 
        Say "Transform/Reflect..."
        return

      #w::
        Key "!frmt{Enter}" 
        Sleep 300
        Say FileRead(EnvGet("TMP") "\ai_state.txt")
        ; Say "Toggle Preview Bounds"
        return

    ;X
      ;<toggle fill/stroke>
      ;<shaper tool>

      ~^x::
        Say "Cut"
        return

      ~+^x::
        Say "Other Panels/Add New Fill"
        return

      ~!^x::
        Say "Other Panels/Add New Stroke"
        return

      !x::
        Key "!frcs" 
        Say "Swap Object Colors"
        return

      #x::
        Key "!fl" 
        Say "File/Place..."
        return

    ;Y
      ;<line segment>
      ;<axonometric line>

      ^y::
        Key "!oa{Enter}l" 
        Say "Arrange/Send to Current Layer"
        return

      +^y::
        Key "+^y" 
        Say "Other Panel/New Layer..."
        return

      !^y::
        Key "!^y" 
        Say "Other Panel/New Layer"
        return

    ;Z
      ;<eyedropper>
      ;<fill solid color>

      ~^z::
        Say "Edit/Undo"
        return

      ^!z::
        MouseGetPos mouseX, mouseY
        paletteTitle := "ai\color.png"
        paletteButton := "ai\menu.png"
        if (!FileExist(paletteTitle) || !FileExist(paletteButton)) {
          Say "Error: some sample file is missing"  
        } else {
          CoordMode "Pixel", "Screen"
          paletteActive := 0
          SearchColor:
          ImageSearch paletteTitleX, paletteTitleY, 0, 0, A_ScreenWidth, A_ScreenHeight, paletteTitle
          if ErrorLevel = 0 {
            ImageSearch paletteButtonX, paletteButtonY, paletteTitleX + 48, paletteTitleY, A_ScreenWidth, paletteTitleY + 18, paletteButton
            if ErrorLevel = 0 {
              Click paletteButtonX " " paletteButtonY
              menuItem := menuItem = 4 ? 3 : 4
              Send "{Down " menuItem "}{Enter}"
              MouseMove mouseX, mouseY
              Say menuItem = 4 ? "Switch to HSB" : "Switch to RGB"
            } else {
              Say "Error (" ErrorLevel "): menu not found"
            }
          } else {
            if paletteActive {
              Say "Palette Error: " ErrorLevel 
            } else {
              key "{F2}" ;color palette hotkey 
              Sleep 200
              paletteActive := 1
              Goto SearchColor
            }
          }
        }
        return

      ~+^z::
        Say "Edit/Redo"
        return

      !z::
        Key "!frsz" 
        Say "Zoom to Selection"
        return

      #z::
        +^f1
        Say "Isolate"
        return

  ;;symbols
    ;[
      ;decrease diameter
      ;decrease intensity
      
      ^[::
        Key "!oa{Enter}b" 
        Say "Arrange/Send Backward"
        return

      ![::
        Key "!oa{Enter}a" 
        Say "Arrange/Send to Back"
        return

      #[::
        Key "!fras{Enter}" 
        Say "Arrange/Send Behind"
        return

    ;]
      ;increase diameter
      ;increase intensity
      
      ^]::
        Key "!oa{Enter}o" 
        Say "Arrange/Bring Forward"
        return

      !]::
        Key "!oa{Enter}f" 
        Say "Arrange/Bring to Front"
        return

      #]::
        Key "!frabb{Enter}" 
        Say "Arrange/Bring in Front of"
        return

    ;;
      ;<axonometric rectangle>
      ;<axonometric cube>

      ^`;::
        Key "!vuu" 
        Say "Show/Hide Guides"
        return

      !`;:: ;???
        Key "!vuk" 
        Say "Lock/Unlock Guides"
        return

      #`;::
        Key "!vum" 
        Say "Make Guides"
        return

      #!`;::
        Key "!vul" 
        Say "Release Guides"
        return

      #!^`;::
        Key "!vuc" 
        Say "Clear Guides"
        return

    ;'
      ;<axonometric ellipse>
      ;<axonometric cylinder>

      ^'::
        Key "!vg" 
        Say "Show Grid"
        return

      !'::
        Key "!vp{Left}{Down 2}{Enter}" 
        Say "Snap to Grid"
        return

    ;\
      ;<ag tangent line>
      ;<extend>

      ^\::
        Key "!vss{Enter}" 
        Say "Snap to Pixel"
        return

      !\::
        Key "!vsn" 
        Say "Snap to Point"
        return
    ;,
      ;<blend mode - previous>
      ;<blend mode - normal>

      !,::
        Key "!eng"
        Say "Preferences/General..."
        return

      !#,::
        Key "!ek"
        Say "Keyboard Shortcuts..."
        return

      #,::
        Key "!frmss{Enter}"
        Say "Set Unit Type to Pixel"
        return
      
      ~+^,::
        Say "Other Text/Point Size Down"
        return

      ~+!^,::
        Say "Other Text/Font Size Step Down"
        return

    ;.
      ;<blend mode - next>
      ;<blend mode - darken>

      ^.::
        Key "!^." 
        Say "Other Misc/Switch Ruler Units"
        return

      #.::
        Key "!frms{Enter}" 
        Say "Set Unit Type to Milimeters"
        return

      ~+^.::
        Say "Other Text/Point Size Up"
        return

      ~+!^.::
        Say "Other Text/Font Size Step Up"
        return

    ;/
      ;<blend>
      ;<type on a path>

      ^/::
        Key "!obm" 
        Say "Blend/Make"
        return

      +^/::
        Key "!obo" 
        Say "Blend/Blend Options..."
        return

      !/::
        Key "!obr" 
        Say "Blend/Release"
        return

      +!/::
        Key "!obe" 
        Say "Blend/Expand"
        return

      #/::
        Key "!obv" 
        Say "Blend/Reverse Front to Back"
        return

      !#/::
        Key "!obs" 
        Say "Blend/Replace Spine"
        return

      +#/::
        Key "!obv" 
        Say "Blend/Reverse Spine"
        return

#if