; ***********************************
; TULULOO GAME MAKER
; Created by Zoltan Percsich
; 2011-2014 SilentWorks
; ***********************************
; Go-Scintilla
; nxSoftWare (www.nxSoftware.com)
; ***********************************

; Init libraries
UsePNGImageDecoder()
UsePNGImageEncoder()
UseJPEGImageDecoder()
InitNetwork()
InitSound()

; Include Scintilla DLL
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
	If FileSize("Scintilla.dll") > 0
		InitScintilla()
	Else
		MessageRequester("Error", "An important system DLL (Scintilla.dll) is missing.")
		End
	EndIf
CompilerEndIf

IncludePath "system"

; Include the scintilla header
XIncludeFile "GoScintilla.pbi"

; Scintilla related constants
Enumeration ;#PB_Compiler_EnumerationValue
	#STYLES_COMMANDS
	#STYLES_COMMENTS
	#STYLES_LITERALSTRINGS
	#STYLES_NUMBERS
	#STYLES_FUNCTIONS
	#STYLES_ITEM
	#STYLES_GM_FUNCTION
	#STYLES_GM_VARIABLE
	#STYLES_GM_CONSTANT
	#STYLES_ERROR
EndEnumeration

; Main program version
Global Version.i = 200

; Scintilla editor globals
Global sci_color_fore.i = RGB(0, 0, 0)
Global sci_color_selection_back.i = RGB(0, 0, 64)
Global sci_color_selection_fore.i = RGB(255, 255, 255)
Global sci_color_command.i = RGB(54, 45, 227)
Global sci_color_comment.i = RGB(160,160,160)
Global sci_color_string.i = RGB(198, 0, 198)
Global sci_color_number.i = RGB(208, 64, 64)
Global sci_color_function.i = RGB(35, 163, 35)
Global sci_color_resource.i = RGB(49, 170, 187)
Global sci_color_tu_function.i = RGB(32, 106, 34)
Global sci_color_tu_variable.i = RGB(81, 80, 19)
Global sci_color_tu_constant.i = RGB(60, 60, 60)
Global sci_color_caret.i = RGB(255, 240, 240)
Global sci_font_family.s = "Consolas"
Global sci_font_size.i = 11

; Script editor window globals
Global ScriptEditorX.i = -1
Global ScriptEditorY.i = -1
Global ScriptEditorWidth.i = -1
Global ScriptEditorHeight.i = -1
Global ScriptEditorMaximized.i = -1
Global Zoom.i = 1

; Preferences default values
Global AddFileProtocol.i = 0
Global Dim FrameBox(0)
Global FrameEditorSelectedBox.i = 0
Global CheckProgramVersion.i = 1
Global GenerateIndexHTML.i = 1
Global ConfirmExit.i = 1
Global ImgFolder.s = "img"
Global AudioFolder.s = "aud"

; Globals
Global ProjectName.s = ""
Global TempName.s = ""
Global DirtyFlag = 0
Global AnimSpeed = 30
Global UID = 1
Global ShowGrid.i = 1
Global GridSize.i = 20
Global SnapToGrid.i = 1
Global ShowCollisionShape.i = 1
Global NewVersion.i = 0
Global DefaultJS.s = ""
Global ShowObjects.i = 1
Global ShowTiles.i = 1
Global TempEFXSound.i = 0
Global ObjectsOrder.s = ""
Global ConflictInfo.s = ""

Enumeration #PB_Compiler_EnumerationValue
	#DebugWindow
	#DebugInput
	#MainPanel
	#MainWindow
	#MainWindowMenu
	#MainWindowMenuNew
	#MainWindowMenuOpen
	#MainWindowMenuMerge
	#MainWindowMenuSave
	#MainWindowMenuSaveAs
	#MainWindowMenuRun
	#MainWindowMenuExit
	#MainWindowMenuPreferences
	#MainWindowMenuAddSprite
	#MainWindowMenuAddSound
	#MainWindowMenuAddMusic
	#MainWindowMenuAddFont
	#MainWindowMenuAddBackground
	#MainWindowMenuAddObject
	#MainWindowMenuAddScene
	#MainWindowMenuAddFunction
	#MainWindowMenuHelp
	#MainWindowMenuAbout
	#MainWindowMenuVersionCheck
	#MainWindowResourceTree
	#MainWindowInfoText
	#PopupMenuGlobals
	#PopupMenuGlobalsEdit
	#PopupMenuFunctions
	#PopupMenuFunctionsEdit
	#PopupMenuSpriteItem
	#PopupMenuSpriteItemEdit
	#PopupMenuSpriteItemDelete
	#PopupMenuBackgroundItem
	#PopupMenuBackgroundItemEdit
	#PopupMenuBackgroundItemDelete
	#PopupMenuFontItem
	#PopupMenuFontItemEdit
	#PopupMenuFontItemDelete
	#PopupMenuObjectItem
	#PopupMenuObjectItemEdit
	#PopupMenuObjectItemDuplicate
	#PopupMenuObjectItemDelete
	#PopupMenuSoundItem
	#PopupMenuSoundItemEdit
	#PopupMenuSoundItemDelete
	#PopupMenuMusicItem
	#PopupMenuMusicItemEdit
	#PopupMenuMusicItemDelete
	#PopupMenuSceneItem
	#PopupMenuSceneItemEdit
	#PopupMenuSceneItemDelete
	#PopupMenuSceneItemMoveBackward
	#PopupMenuSceneItemMoveForward
	#PopupMenuSceneDuplicate
	#PopupMenuFunctionItem
	#PopupMenuFunctionItemEdit
	#PopupMenuFunctionItemDelete
	#SubWindow
	#GeneralCancelButton
	#GeneralOKButton
	#EventList
	#EditorFont
	#CodePreview
	#PopupEventItem = 75
	#PopupEventItemEdit
	#PopupEventItemDelete
	#GlobalsEditor
	#FunctionsEditor
	#GlobalsButtonGadget
	#FunctionsButtonGadget	
	#GameCommentsButtonGadget
	#ManageExtensionsButtonGadget
	#PopupMenuFrame
	#PopupMenuFrameReplace
	#PopupMenuFrameDelete
	#TabFont
	#GameScroller
	#SpriteScroller
	#SoundScroller
	#MusicScroller
	#BackgroundScroller
	#FontScroller
	#ObjectScroller
	#SceneScroller
	#FunctionScroller
	#MiscScroller
	#BoxEmpty
	#BoxInvalid
	#BoxSound
	#BoxMusic
	#BoxFont
	#BoxNew
	#BoxFunction
	#TestButton
	#TabHeaderSprites
	#TabHeaderSounds
	#TabHeaderMusics
	#TabHeaderBackgrounds
	#TabHeaderFonts
	#TabHeaderObjects
	#TabHeaderScenes
	#TabHeaderFunctions
	#TabHeaderSpritesGadget
	#TabHeaderSoundsGadget
	#TabHeaderMusicsGadget
	#TabHeaderBackgroundsGadget
	#TabHeaderFontsGadget
	#TabHeaderObjectsGadget
	#TabHeaderScenesGadget
	#TabHeaderFunctionsGadget
	#IconCreation
	#IconCollision
	#IconStep
	#IconEndStep
	#IconDraw
	#IconAnimationEnd
	#IconDestroy
	#IconRoomStart
	#IconRoomEnd
	#Processing
	#NewSpriteButton
	#NewSoundButton
	#NewMusicButton
	#NewBackgroundButton
	#NewFontButton
	#NewObjectButton
	#NewSceneButton
	#NewFunctionButton
	#ItemFont
	#EventSelectorWindow
	#ImportedImage
	#SpritePreviewCanvas
	#TransGrid
	#NoSprite
	#CodeGadget
	#GlobalsButton
	#CustomFunctions
	#GameComments
	#ManageExtensions
	#AboutScreen
	#NullImage
	#ScriptModeCheckbox
	#GameCommentWindow
	#CollectingExt
	#NewIcon
	#ArrowIcon
	#OpenIcon
	#MergeIcon
	#SaveIcon
	#ZoomInIcon
	#ZoomOutIcon
	#ZoomResetIcon
	#EraseIcon
	#PickerIcon
	#LineIcon
	#BoxIcon
	#CircleIcon
	#FillIcon
	#PlayIcon
	#SpriteIcon
	#SoundIcon
	#MusicIcon
	#FontIcon
	#BackgroundIcon
	#ObjectIcon
	#SceneIcon
	#FunctionIcon
	#GridIcon
	#SnapIcon
	#SaveAsIcon
	#PreferencesIcon
	#ExitIcon
	#HelpIcon
	#AboutIcon
	#VersionIcon
	#MissingSprite
	#CreateIcon
	#SelectIcon
	#EditIcon
	#DeleteIcon
	#AddIcon
	#DuplicateIcon
	#MoveLeftIcon
	#MoveRightIcon
	#ShiftIcon
	#MirrorIcon
	#RotateIcon
	#ScaleIcon
	#ResizeIcon
	#StretchIcon
	#GrayscaleIcon
	#SwapRGBIcon
	#ColorizeIcon
	#InvertIcon
	#ColorBalanceIcon
	#EraseColorIcon
	#OpacityIcon
	#BrightnessIcon
	#PosterizeIcon
	#NoiseIcon
	#MakeOpaqueIcon
	#FrameEditorScroller
	#FramesEditorMenu
	#FramesEditorFileNew
	#FramesEditorFileAdd
	#FramesEditorFileSavePNG
	#FramesEditorEditDuplicate
	#FramesEditorEditMoveLeft
	#FramesEditorEditMoveRight
	#FramesEditorEditEditFrame
	#FramesEditorEditDeleteFrame
	#FramesEditorTransformShift
	#FramesEditorTransformMirror
	#FramesEditorTransformRotate
	#FramesEditorTransformScale
	#FramesEditorTransformResizeCanvas
	#FramesEditorTransformStretch
	#FramesEditorEffectsBW
	#FramesEditorEffectsInvert
	#FramesEditorEffectsColorize
	#FramesEditorEffectsColorFlip
	#FramesEditorEffectsColorBalance
	#FramesEditorEffectsEraseColor
	#FramesEditorEffectsOpacity
	#FramesEditorEffectsBrightness
	#FramesEditorEffectsPosterize
	#FramesEditorEffectsNoise
	#FramesEditorEffectsMakeOpaque
	#ProjectListFont
	#Selector
	#HueBar
	#NoProjectImage
	#ExportFunctionButton
	#ImportFunctionButton
	#SpriteSearchField
	#SpriteSortReset
	#SpriteSortAsc
	#SpriteSortDesc
	#SpriteSearchCombo
	#SoundSearchField
	#SoundSearchCombo
	#SoundSortReset
	#SoundSortAsc
	#SoundSortDesc
	#MusicSearchField
	#MusicSearchCombo
	#MusicSortReset
	#MusicSortAsc
	#MusicSortDesc
	#FontSearchField
	#FontSearchCombo
	#FontSortReset
	#FontSortAsc
	#FontSortDesc
	#BackgroundSearchField
	#BackgroundSearchCombo
	#BackgroundSortReset
	#BackgroundSortAsc
	#BackgroundSortDesc
	#ObjectSearchField
	#ObjectSearchCombo
	#ObjectSortReset
	#ObjectSortAsc
	#ObjectSortDesc
	#SceneSearchField
	#SceneSearchCombo
	#SceneSortReset
	#SceneSortAsc
	#SceneSortDesc
	#FunctionSearchField
	#FunctionSearchCombo
	#FunctionSortReset
	#FunctionSortAsc
	#FunctionSortDesc
	#SortResetImage
	#SortAscImage
	#SortDescImage
	#ImageEditorMenu
	#ImageEditorMenuNew
	#ImageEditorMenuOpen
	#ImageEditorMenuSaveAsPNG
	#ImageEditorMenuClose
	#ColorMatrix
	#ColorRainbow
EndEnumeration

; Helper class for checking name conflicts
Structure NameConflict
	Name.s
	NameNew.s
	Type.s
EndStructure

; Game class
Structure Game
	Title.s
	Globals.s
	Functions.s
	ScriptMode.i
	GameComment.s
	
	GadgetGlobalsWindow.i
	GadgetGlobalsCancel.i
	GadgetGlobalsOK.i
	GadgetGlobalsScintilla.i
	GadgetGlobalsHoverText.i
	GadgetGlobalsHoverDescription.i
	GlobalsTimer.i
	
	GadgetFunctionsWindow.i
	GadgetFunctionsCancel.i
	GadgetFunctionsOK.i
	GadgetFunctionsScintilla.i
	GadgetFunctionsHoverText.i
	GadgetFunctionsHoverDescription.i
	FunctionsTimer.i
	
	GadgetCommentsWindow.i
	GadgetCommentsOk.i
	GadgetCommentsEditor.i
	
	SpriteSearch.s
	SoundSearch.s
	MusicSearch.s
	FontSearch.s
	BackgroundSearch.s
	ObjectSearch.s
	SceneSearch.s
	FunctionSearch.s
	
	ExtensionWindow.i
	ExtInfoGadget.i
	ExtCancelButton.i
	ExtOpenButton.i
	ExtExtensionList.i
EndStructure

; Sprite class
Structure Sprite
	Name.s
	Preview.i
	CollisionShape.s
	CollisionRadius.i
	CollisionLeft.i
	CollisionRight.i
	CollisionTop.i
	CollisionBottom.i
	CenterX.i
	CenterY.i
	Keywords.s
	UID.i
	
	GadgetWindow.i
	GadgetOK.i
	GadgetDelete.i
	GadgetName.i
	GadgetImportStrip.i
	GadgetSaveStrip.i
	GadgetEditStrip.i
	GadgetSize.i
	GadgetPreviewScroller.i
	GadgetSpritePreview.i
	GadgetShowCollisionShape.i
	GadgetCollectionShapeEdit.i
	GadgetAnimSpeed.i
	GadgetZoomTrackbar.i
	GadgetCenterX.i
	GadgetCenterY.i
	GadgetCenter.i
	GadgetCollisionShape.i
	GadgetCollisionRadius.i
	GadgetCollisionLeft.i
	GadgetCollisionRight.i
	GadgetCollisionTop.i
	GadgetCollisionBottom.i
	ThisWidth.i
	ThisHeight.i
	ShowCollisionShape.i
	Zoom.i
	GadgetZoom.i
	Timer.i
	AnimSpeed.i
	MaxFrames.i
	CurrentFrame.i
	Errors.i
	GadgetKeywords.i
	
	GadgetShapeWindow.i
	Timer2.i
	GadgetShapeOK.i
	GadgetShapePointList.i
	GadgetShapePointDelete.i
	GadgetShapeSnapToGrid.i
	ShapeEditorSnapToGrid.i
	GadgetShapeGridWidth.i
	ShapeEditorGridWidth.i
	GadgetShapeGridHeight.i
	ShapeEditorGridHeight.i
	GadgetShapeCanvasScoller.i
	GadgetShapeCanvas.i
	ShapeEditorZoom.i
	GadgetShapeZoom.i
	GadgetShapeNextFrame.i
	GadgetShapePrevFrame.i
	ShapeEditorCurrentFrame.i
	ShapeEditorCanvasDown.i
	ShapeEditorPickedPointLocal.i
	ShapeEditorPickedPointGlobal.i
	
EndStructure

; Collision point class
Structure CollisionPoint
	Sprite.s
	X.i
	Y.i
EndStructure

; Frame (animated sprite) class
Structure Frame
	File.s
	Sprite.s
	Image.i
EndStructure

; Sequence (animated sprite) class
Structure Sequence
	Image.i
EndStructure

; Background class
Structure Background
	Name.s
	File.s
	Preview.i
	Tile.i
	TileWidth.i
	TileHeight.i
	TileXOffset.i
	TileYOffset.i
	TileXSpace.i
	TileYSpace.i
	Keywords.s
	UID.i
	
	GadgetWindow.i
	Timer.i
	SelectedFile.s
	BackgroundImage.i
	GadgetOK.i
	GadgetDelete.i
	GadgetName.i
	GadgetFileName.i
	GadgetFileSelector.i
	GadgetScroller.i
	GadgetBackgroundCanvas.i
	GadgetTileCheckbox.i
	TileContainerX.i
	GadgetTileContainer.i
	GadgetTileWidth.i
	GadgetTileHeight.i
	GadgetTileXoffset.i
	GadgetTileYoffset.i
	GadgetTileXSpace.i
	GadgetTileYSpace.i
	Errors.i
	GadgetKeywords.i
EndStructure

; Tile class
Structure Tile
	Name.s
	Background.s
	Left.i
	Top.i
	Width.i
	Height.i
	X.i
	Y.i
	Depth.i
	Scene.s
	Image.i
	Selected.i
EndStructure

; Layer class
Structure Layer
	Name.s
	Value.i
	Scene.s
EndStructure

; Font class
Structure Font
	Name.s
	Family.s
	Size.i
	Bold.i
	Italic.i
	Keywords.s
	UID.i
	
	GadgetWindow.i
	GadgetOK.i
	GadgetDelete.i
	GadgetName.i
	GadgetFamily.i
	GadgetSize.i
	GadgetBold.i
	GadgetItalic.i
	Errors.i
	PreviewFont.i
	PreviewCanvas.i
	GadgetKeywords.i
EndStructure

; Object class
Structure Object
	Proto.i
	TemplateObject.s
	Name.s
	Sprite.s
	Scene.s
	X.i
	Y.i
	Selected.i
	TImage.i
	TImageModified.i
	TWidth.i
	THeight.i
	Visible.i
	Depth.i
	Collide.i
	Parent.s
	Direction.i
	ImageAngle.i
	Keywords.s
	UID.i
	ChildNum.i
	
	GadgetWindow.i
	GadgetEventList.i
	GadgetCodePreview.i
	GadgetOK.i
	GadgetDelete.i
	GadgetName.i
	GadgetDepth.i
	GadgetSprite.i
	GadgetDimensions.i
	GadgetSpritePreview.i
	PreviewImage.i
	GadgetVisible.i
	GadgetCollide.i
	GadgetParent.i
	GadgetNewEvent.i
	GadgetEvents.i
	Errors.i
	GadgetCodeWindow.i
	GadgetCodeCancel.i
	GadgetCodeOK.i
	GadgetCodeEvents.i
	GadgetCodeParameterText.i
	GadgetCodeParameter.i
	GadgetScintilla.i
	GadgetCodeHoverText.i
	GadgetCodeHoverDescription.i
	Timer.i
	ScriptIndex.i
	GadgetKeywords.i
EndStructure

; Sound class
Structure Sound
	Name.s
	File.s
	File2.s
	File3.s
	Keywords.s
	UID.i
	
	GadgetWindow.i
	GadgetName.i
	SelectedFile.s
	SelectedFile2.s
	SelectedFile3.s
	GadgetOK.i
	GadgetDelete.i
	GadgetFileSelector.i
	GadgetFileName.i
	GadgetFileRemover.i
	GadgetFile2Selector.i
	GadgetFile2Name.i
	GadgetFile2Remover.i
	GadgetFile3Selector.i
	GadgetFile3Name.i
	GadgetFile3Remover.i
	Errors.i
	GadgetKeywords.i
EndStructure

; Music class
Structure Music
	Name.s
	File.s
	File2.s
	File3.s
	Keywords.s
	UID.i
	
	GadgetWindow.i
	GadgetName.i
	SelectedFile.s
	SelectedFile2.s
	SelectedFile3.s
	GadgetOK.i
	GadgetDelete.i
	GadgetFileSelector.i
	GadgetFileName.i
	GadgetFileRemover.i
	GadgetFile2Selector.i
	GadgetFile2Name.i
	GadgetFile2Remover.i
	GadgetFile3Selector.i
	GadgetFile3Name.i
	GadgetFile3Remover.i
	Errors.i
	GadgetKeywords.i
EndStructure

; Scene class
Structure Scene
	Name.s
	Preview.i
	Width.i
	Height.i
	ViewportWidth.i
	ViewportHeight.i
	R.i
	G.i
	B.i
	Code.s
	Speed.i
	Background.s
	BackgroundTileX.i
	BackgroundTileY.i
	BackgroundStretch.i
	ViewportObject.s
	ViewportXBorder.i
	ViewportYBorder.i
	Keywords.s
	UID.i
	
	GadgetWindow.i
	InnerTimer.i
	InnerSelectedObjectSpriteImage.i
	InnerSelectedObjectSpriteIndex.i
	InnerMouseInScene.i
	InnerTileBackground.i
	InnerTileX.i
	InnerTileY.i
	InnerTileWidth.i
	InnerTileHeight.i
	InnerTilePreviewImage.i
	InnerTileCursorImage.i
	InnerKey.i
	InnerShift.i
	InnerAlt.i
	InnerCtrl.i
	InnerBlockX.i
	InnerBlockY.i
	InnerOldBlockX.i
	InnerOldBlockY.i
	InnerBackgroundImage.i
	InnerOK.i
	InnerNameGadget.i
	InnerTabPanel.i
	InnerWidthGadget.i
	InnerHeightGadget.i
	InnerViewportWidthGadget.i
	InnerViewportHeightGadget.i
	InnerObjectToFollowCombo.i
	InnerImage.i
	InnerMarginWidthGadget.i
	InnerMarginHeightGadget.i
	InnerSceneSpeedGadget.i
	InnerSceneCodeButton.i
	InnerObjectActionMode.i
	InnerObjectsList.i
	InnerObjectPreview.i
	InnerIW.i
	InnerIH.i
	InnerWS.f
	InnerHS.f
	InnerPreviewImage.i
	InnerEditInstance.i
	InnerBackgroundColor.i
	InnerosxBGcolorsize.i
	InnerBackgroundChangeButton.i
	InnerBackgroundImageCombo.i
	InnerTileXCheckbox.i
	InnerTileYCheckbox.i
	InnerStretchCheckbox.i
	InnerTileImageCombo.i
	InnerTileActionMode.i
	InnerTileScroller.i
	InnerTileCanvas.i
	InnerLayerCombo.i
	InnerLayerAddButton.i
	InnerLayerDeleteButton.i
	InnerLayerChangeButton.i
	InnerTilePreview.i
	InnerosxGameButton.i
	InnerNewButton.i
	InnerShiftButton.i
	InnerShowGridButton.i
	InnerShowGrid.i
	InnerSnapToGridButton.i
	InnerSnapToGrid.i
	InnerGridSizeGadget.i
	InnerGridSize.i
	InnerShowObjectsCheckbox.i
	InnerShowObjects.i
	InnerShowTilesCheckbox.i
	InnerShowTiles.i
	InnerSelectedObjectInfo.i
	InnerScrollerGadget.i
	InnerSceneCanvas.i
	InnerMoveSpeed.i
	InnerTileLoaded.i
	InnerTileX2.i
	InnerTileY2.i
	InnerErrors.i
	InnerMouseStartX.i
	InnerMouseStartY.i
	InnerPropWindow.i
	InnerPropGadgetX.i
	InnerPropGadgetY.i
	InnerPropGadgetDirection.i
	InnerPropGadgetImageAngle.i
	InnerPropOKButton.i
	InnerPropCancelButton.i
	CodeEditorWindow.i
	CodeCancelButton.i
	CodeOKButton.i
	CodeScintilla.i
	GadgetKeywords.i
	InnerObjectSelector.i
EndStructure

; Function class
Structure Function
	Name.s
	Params.s
	Description.s
	Code.s
	Keywords.s
	UID.i
	
	GadgetWindow.i
	GadgetName.i
	GadgetCode.i
	GadgetParams.i
	GadgetOK.i
	GadgetDelete.i
	Errors.i
	GadgetKeywords.i
EndStructure

; Script class
Structure Script
	Name.s
	Parent.s
	Type.s
	Parameter.s
	Code.s
EndStructure

; Item class for handling clickable items in tabs
Structure Item
	Tab.s
	Name.s
	Gadget.i
	Menu.i
	Selected.i
EndStructure

; Keyword class (scintilla editor)
Structure Keyword
	Word.s
	Type.s
	Help.s
	Description.s
EndStructure

; Extension class
Structure Extension
	File.s
	Name.s
	Author.s
	Description.s
	Help.s
	Code.s
	Installed.i
EndStructure

; Helper for handling elements in the sceen editor
Structure SEE ; Scene Editor Element
	Init.i
	Depth.i
	Object.i
	Tile.i
EndStructure

Structure FunctionCheckbox
	Gadget.i
	Function.s
EndStructure

; Global arrays of classes
Global Dim NameConflicts.NameConflict(0)
Global Dim Games.Game(1)
Global Dim Sprites.Sprite(0)
Global Dim Frames.Frame(0)
Global Dim Sequences.Sequence(0)
Global Dim Backgrounds.Background(0)
Global Dim Tiles.Tile(0)
Global Dim Layers.Layer(0)
Global Dim Fonts.Font(0)
Global Dim Objects.Object(0)
Global Dim Sounds.Sound(0)
Global Dim Musics.Music(0)
Global Dim Scenes.Scene(0)
Global Dim Functions.Function(0)
Global Dim Scripts.Script(0)
Global Dim Items.Item(0)
Global Dim CollisionPoints.CollisionPoint(0)
Global Dim Keywords.Keyword(0)
Global Dim Projects.s(0)
Global Dim Extensions.Extension(0)
Global Dim InstalledExtensions.s(0)
Global NewList Sees.See()
Global Dim FunctionCheckboxes.FunctionCheckbox(0)
;Global AppPath$ = ""

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
	SetCurrentDirectory(RemoveString(GetCurrentDirectory(), GetFilePart(ProgramFilename()) + ".app/Contents/"))
CompilerEndIf

; ************************************************************************************************************************
; Functions
; ************************************************************************************************************************
; Some needs to be declared (see PureBasic help for details: Declare)
Declare.i DeleteTile(TileName.s)
Declare RefreshObjectSprite(s)
Declare RefreshSceneObjectsList(s)
Declare RefreshSceneObjectToFollowCombo(s)
Declare RefreshSceneBackgroundImage(s)
Declare RefreshSceneBackgroundsCombo(s)
Declare RefreshSceneTilesCombo(s)
Declare RefreshSceneSelectedTile(s)
Declare RefreshTileImage(gadget, scroller, background.s)
Declare StoreResources()
Declare RefreshSceneObjectSelector(s)
Declare RefreshItems()

; Include scintilla related
IncludeFile "tululoo_external.pbi"

; Set the window caption (current project name)
Procedure SetCaption()
	
	v1.s = Mid(Str(Version),1,1)
	v2.s = Mid(Str(Version),2,1)
	v3.s = Mid(Str(Version),3,1)
	VersionText.s = "v" + v1 + "." + v2 + "." + v3
	
	Caption.s = ""
	If ProjectName <> ""
		Caption = " - " + ProjectName
	EndIf
	
	SetWindowTitle(#MainWindow, "Tululoo Game Maker " + VersionText + Caption)
	
EndProcedure

; Collect the project files
Procedure GetProjects() 
	ReDim Projects(0)
	If ExamineDirectory(0, "Projects", "*.xml") 
		While NextDirectoryEntry(0)
			If DirectoryEntryType(0) = #PB_DirectoryEntry_File
				Index = ArraySize(Projects())
				ReDim Projects(Index + 1)
				Projects(Index) = ReplaceString(DirectoryEntryName(0), ".xml", "")
			EndIf
		Wend
		FinishDirectory(0)
	EndIf
EndProcedure

; Project selector window
Procedure.s SelectProject()
	
	PreviewImage = -1
	
	GetProjects()
	
	ProjectFile.s = ""
	
	ProjectWindow = OpenWindow(#PB_Any, 0, 0, 640, 400, "Open a project...", #PB_Window_ScreenCentered | #PB_Window_Tool)
	DisableWindow(#MainWindow, 1)
	StickyWindow(ProjectWindow, 1)
	
	CancelButton = ButtonGadget(#PB_Any, 10, 365, 100, 25, "Cancel")
	OpenButton = ButtonGadget(#PB_Any, WindowWidth(ProjectWindow) - 110, 365, 100, 25, "Open")
	
	ProjectList = ListViewGadget(#PB_Any, 10, 10, 370, 340)
	SetGadgetFont(ProjectList, FontID(#ProjectListFont))
	For p = 0 To ArraySize(Projects()) - 1
		AddGadgetItem(ProjectList, -1, Projects(p))
	Next
	
	PreviewBox = ImageGadget(#PB_Any, 390, 10, 240, 240, 0, #PB_Image_Border)
	InfoText = TextGadget(#PB_Any, 390, 260, 240, 25, "")
	
	Done = 0
	Repeat
		SetActiveWindow(ProjectWindow)
		Select WaitWindowEvent()

			Case #PB_Event_Gadget
				Select EventGadget()
						
					Case ProjectList
						Select EventType()
								
							Case #PB_EventType_LeftClick
								; Project selected
								If GetGadgetText(ProjectList) <> ""
									ImageFile.s = GetGadgetText(ProjectList)
									; Display project preview
									If IsImage(PreviewImage) : FreeImage(PreviewImage) : EndIf
									SetGadgetState(PreviewBox, 0)
									If FileSize("Projects/" + ImageFile + ".png") > 0
										PreviewImage = LoadImage(#PB_Any, "Projects/" + ImageFile + ".png")
										If IsImage(PreviewImage)
											SetGadgetState(PreviewBox, ImageID(PreviewImage))
										EndIf
									Else
										SetGadgetState(PreviewBox, ImageID(#NoProjectImage))
									EndIf
									
									SetGadgetText(InfoText, "Project started: " + FormatDate("%yyyy-%mm-%dd %HH:%ii", GetFileDate("Projects/" + ImageFile + ".xml", #PB_Date_Modified)))
									
								EndIf
								
							Case #PB_EventType_LeftDoubleClick
								; Select for opening
								If GetGadgetText(ProjectList) <> ""
									ProjectFile = GetGadgetText(ProjectList)
									Done = 1
								EndIf
						EndSelect
						
					; Open
					Case OpenButton
						ProjectFile = GetGadgetText(ProjectList)
						Done = 1
						
					; Cancel
					Case CancelButton
						ProjectFile = ""
						Done = 1
					
				EndSelect
				
		EndSelect
	Until Done = 1
	
	; Close window
	StickyWindow(ProjectWindow, 0)
	DisableWindow(#MainWindow, 0)			
	CloseWindow(ProjectWindow)
	SetActiveWindow(#MainWindow)
	
	; Returns selected project
	ProcedureReturn ProjectFile
	
EndProcedure

; Project name input
Procedure GetProjectName()
	
	ProjectWindow = OpenWindow(#PB_Any, 0, 0, 400, 100, "Enter the project name", #PB_Window_ScreenCentered | #PB_Window_Tool)
	DisableWindow(#MainWindow, 1)
	StickyWindow(ProjectWindow, 1)
	
	CancelButton = ButtonGadget(#PB_Any, 10, 65, 100, 25, "Cancel")
	OKButton = ButtonGadget(#PB_Any, 290, 65, 100, 25, "OK")
	
	NameGadget = StringGadget(#PB_Any, 10, 10, 380, 25, ProjectName)
	
	Done = 0
	Repeat
		SetActiveWindow(ProjectWindow)
		Select WaitWindowEvent()

			Case #PB_Event_Gadget
				Select EventGadget()
						
					; Open
					Case OKButton
						ProjectName = GetGadgetText(NameGadget)
						Done = 1
						
					; Cancel
					Case CancelButton
						ProjectName = ""
						Done = 1
					
				EndSelect
				
		EndSelect
	Until Done = 1
	
	; Close window
	StickyWindow(ProjectWindow, 0)
	DisableWindow(#MainWindow, 0)			
	CloseWindow(ProjectWindow)
	SetActiveWindow(#MainWindow)
	
EndProcedure

; Collect installed extensions
Procedure GetInstalledExtensions ()
	ReDim InstalledExtensions(0)
	If FileSize("Projects/" + ProjectName + "/extensions.dat") > 0
		fp = OpenFile(#PB_Any, "Projects/" + ProjectName + "/extensions.dat")
		While Eof(fp) = 0
			Index = ArraySize(InstalledExtensions())
			ReDim InstalledExtensions(Index + 1)
			InstalledExtensions(Index) = ReadString(fp)
		Wend
		CloseFile(fp)
	EndIf
EndProcedure

; Collect the available extensions
Procedure GetExtensions()
	
	GetInstalledExtensions()
	
	ReDim Extensions(0)
	If ExamineDirectory(0, "Extensions", "*.tex") 
		While NextDirectoryEntry(0)
			If DirectoryEntryType(0) = #PB_DirectoryEntry_File
				
				Ext.s = ReplaceString(DirectoryEntryName(0), ".tex", "")
				
				; Get extension details
				E_name.s = ""
				E_author.s = ""
				E_description.s = ""
				E_help.s = ""
				E_code.s = ""
				
				fp = OpenFile(#PB_Any, "Extensions/" + Ext + ".tex")
				
				section.s = ""
				While Eof(fp) = 0
					
					row.s = ReadString(fp)
					
					Select row
						Case "[EXTENSION]" : row = ReplaceString(row, row, "") : section = "extension"
						Case "[AUTHOR]" : row = ReplaceString(row, row, "") : section = "author"
						Case "[DESCRIPTION]" : row = ReplaceString(row, row, "") : section = "description"
						Case "[HELP]" : row = ReplaceString(row, row, "") : section = "help"
						Case "[CODE]" : row = ReplaceString(row, row, "") : section = "code"
					EndSelect
					
					Select section
						Case "extension" : E_name = E_name + row
						Case "author" : E_author = E_author + row
						Case "description" : E_description = E_description + row + Chr(13) + Chr(10)
						Case "help" : E_help = E_help + row + Chr(13) + Chr(10)
						Case "code" : E_code = E_code + row + Chr(13) + Chr(10)
					EndSelect
					
				Wend
				
				CloseFile(fp)
				
				Index = ArraySize(Extensions())
				ReDim Extensions(Index + 1)
				
				Extensions(Index) \ File = Ext
				Extensions(Index) \ Name = E_name
				Extensions(Index) \ Author = E_author
				Extensions(Index) \ Description = E_description
				Extensions(Index) \ Help = E_help
				Extensions(Index) \ Code = E_code
				Extensions(Index) \ Installed = 0
				
				; Check extension if installed
				For c = 0 To ArraySize(InstalledExtensions()) - 1
					If InstalledExtensions(c) = Extensions(Index) \ File
						Extensions(Index) \ Installed = 1
					EndIf
				Next
				
			EndIf
		Wend
		FinishDirectory(0)
	EndIf
	
EndProcedure

; Create/Update extensions file
Procedure ManageExtensionsStore(close)
	DeleteFile("Projects/" + ProjectName + "/extensions.dat")
	fp = CreateFile(#PB_Any, "Projects/" + ProjectName + "/extensions.dat")
	For e = 0 To CountGadgetItems(Games(0) \ ExtExtensionList) - 1
		; Checked?
		If GetGadgetItemState(Games(0) \ ExtExtensionList, e) >= 2 
			WriteStringN(fp, Extensions(GetGadgetItemData(Games(0) \ ExtExtensionList, e)) \ File, #PB_UTF8)
		EndIf
	Next
	CloseFile(fp)
	If close = 1
		CloseWindow(Games(0) \ ExtensionWindow)
		Games(0) \ ExtensionWindow = 0
	EndIf
EndProcedure

; Check / uncheck extensions
Procedure.s ManageExtensions()
	
	If ProjectName = ""
		
		MessageRequester("Message", "Please save your project.")
		
	Else
		
		If IsWindow(Games(0) \ ExtensionWindow)
			ProcedureReturn ""
		EndIf
		
		GetExtensions()
		
		Games(0) \ ExtensionWindow = OpenWindow(#PB_Any, 0, 0, 640, 480, "Installed extensions", #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget, WindowID(#MainWindow))
		
		; Name
		Games(0) \ ExtInfoGadget = EditorGadget(#PB_Any, 200, 10, 430, 420, #PB_Editor_ReadOnly)
		SetGadgetColor(Games(0) \ ExtInfoGadget, #PB_Gadget_BackColor, $EEEEEE)
		SetGadgetFont(Games(0) \ ExtInfoGadget, FontID(#EditorFont))
		
		Games(0) \ ExtCancelButton = ButtonGadget(#PB_Any, 10, 440, 100, 25, "Cancel")
		Games(0) \ ExtOpenButton = ButtonGadget(#PB_Any, 530, 440, 100, 25, "OK")
		
		Games(0) \ ExtExtensionList = ListIconGadget(#PB_Any, 10, 10, 180, 420, "Name", 160, #PB_ListIcon_CheckBoxes | #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect )
		SetGadgetFont(Games(0) \ ExtExtensionList, FontID(#EditorFont))
		For p = 0 To ArraySize(Extensions()) - 1
			AddGadgetItem(Games(0) \ ExtExtensionList, p, Extensions(p) \ Name)
			SetGadgetItemData(Games(0) \ ExtExtensionList, p, p)
			If Extensions(p) \Installed = 1
				SetGadgetItemState(Games(0) \ ExtExtensionList, p, #PB_ListIcon_Checked)
			EndIf
		Next
		
	EndIf
	
EndProcedure

; Add a new scintilla keyword to the system (for code completion)
Procedure AddKeyword(Word.s, Type.s, Help.s, Description.s)
	Index = ArraySize(Keywords())
	ReDim Keywords(Index + 1)
	Keywords(Index) \ Word = Word
	Keywords(Index) \ Type = Type
	Keywords(Index) \ Help = Help
	Keywords(Index) \ Description = Description
EndProcedure

; Load and parse the keywords file (for editor help)
Procedure LoadKeywords ()
	If FileSize( GetCurrentDirectory()  + "keywords.dat") > 0
		FP = OpenFile(#PB_Any, "keywords.dat")
		While Not Eof(FP)
			Line1.s = ReadString(FP)
			Line2.s = ReadString(FP)
			Line3.s = ReadString(FP)
			
			KeywordType.s = Left(Line1, 1)
			Line1.s = RemoveString(Line1, KeywordType, #PB_String_NoCase, 0, 1)
			
			Select KeywordType
				Case "."
					AddKeyword(Line1, "Var", Line2, Line3)
				Case "!"
					AddKeyword(Line1, "Fn", Line2, Line3)
				Case "#"
					AddKeyword(Line1, "Cons", Line2, Line3)
			EndSelect
		Wend
		CloseFile(FP)
	EndIf
EndProcedure

; Check program version and notify
Procedure CheckVersion()
	VersionCheck.i = ReceiveHTTPFile("http://www.tululoo.com/version.txt", "__ver__")
	If VersionCheck <> 0
		FP = OpenFile(#PB_Any, "__ver__")
		NewVersion = Val(ReadString(FP))
		CloseFile(FP)
		DeleteFile("__ver__")
		If NewVersion > Version
			MessageRequester("Version information", "A new version has been released.")
		Else
			MessageRequester("Version information", "You are using the latest version.")
		EndIf
	EndIf	
EndProcedure

; Check program version in the background (notify when new version is available)
Procedure CheckVersionSilent()
	If CheckProgramVersion = 1
		VersionCheck.i = ReceiveHTTPFile("http://www.tululoo.com/version.txt", "__ver__")
		If VersionCheck <> 0
			FP = OpenFile(#PB_Any, "__ver__")
			NewVersion = Val(ReadString(FP))
			CloseFile(FP)
			DeleteFile("__ver__")
			If NewVersion > Version
				MessageRequester("Version information", "A new version has been released.")
			EndIf
		EndIf	
	EndIf
EndProcedure

; Returns the last clicked item
Procedure SelectedItem()
	For k = 0 To ArraySize(Items()) - 1
		If Items(k) \ Selected > 0
			ProcedureReturn k
			Break
		EndIf
	Next
EndProcedure

; Returns the higher value
Procedure Max(v1, v2)
	If v1 > v2
		ProcedureReturn v1
	Else
		ProcedureReturn v2
	EndIf
EndProcedure

; Return a new UID
Procedure UID()
	UID = UID + 1
	ProcedureReturn UID
EndProcedure

; Display the ABOUT screen
Procedure About()
	
	v1.s = Mid(Str(Version),1,1)
	v2.s = Mid(Str(Version),2,1)
	v3.s = Mid(Str(Version),3,1)
	
	OpenWindow(#SubWindow, 0, 0, 500, 350, "Tululoo Game Maker v" + v1 + "." + v2 + "." + v3, #PB_Window_ScreenCentered | #PB_Window_BorderLess)
	DisableWindow(#MainWindow, 1)
	
	Image = ImageGadget(#PB_Any, 0, 0, 500, 350, ImageID(#AboutScreen))
	VersionText = TextGadget(#PB_Any, 380, 122, 80, 18, "version " + v1 + "." + v2 + "." + v3)
	SetGadgetColor(VersionText, #PB_Gadget_FrontColor, RGB(255, 255, 255))
	SetGadgetColor(VersionText, #PB_Gadget_BackColor, RGB(0,0,0))
	
	Done = 0
	Repeat
		SetActiveWindow(#SubWindow)
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case Image: Done = 1
				EndSelect
		EndSelect
	Until Done = 1
	
	DisableWindow(#MainWindow, 0)
	CloseWindow(#SubWindow)
	
EndProcedure

; Set the Dirty Flag
Procedure Dirty(Status)
	DirtyFlag = Status
EndProcedure

; Lazy Confirm popup(using MessageRequester)
Procedure Confirm(Title.s, Text.s)
	If MessageRequester(Title, Text, #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
		ProcedureReturn 1
	Else
		ProcedureReturn 0
	EndIf
EndProcedure

; Store game comments
Procedure EditGameCommentStore(close)
	Games(0) \ GameComment = GetGadgetText(Games(0) \ GadgetCommentsEditor)
	If close = 1
		CloseWindow(Games(0) \ GadgetCommentsWindow)
		Games(0) \ GadgetCommentsWindow = 0
	EndIf
	Dirty(1)
EndProcedure

; Game comment edit window
Procedure EditGameComment ()
	
	If IsWindow(Games(0) \ GadgetCommentsWindow)
		ProcedureReturn
	EndIf
	
	Games(0) \ GadgetCommentsWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Game comments", #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget, WindowID(#MainWindow))
	
	; OK button
	Games(0) \ GadgetCommentsOK = ButtonGadget(#PB_Any, WindowWidth(Games(0) \ GadgetCommentsWindow) - 75, WindowHeight(Games(0) \ GadgetCommentsWindow) - 35, 65, 25, "OK")
	
	; Editor
	Games(0) \ GadgetCommentsEditor = EditorGadget(#PB_Any, 10,10, 780, 540)
	SetGadgetText(Games(0) \ GadgetCommentsEditor, Games(0) \ GameComment)
	SetGadgetFont(Games(0) \ GadgetCommentsEditor, FontID(#EditorFont))
	
EndProcedure

; Game comment show window
Procedure ShowGameComment ()
	
	OpenWindow(#GameCommentWindow, 0, 0, 800, 600, "Game comments", #PB_Window_ScreenCentered | #PB_Window_Tool, WindowID(#MainWindow))
	
	; OK button
	OKButton = ButtonGadget(#PB_Any, WindowWidth(#GameCommentWindow) - 75, WindowHeight(#GameCommentWindow) - 35, 65, 25, "OK")
	
	; Editor
	Editor = EditorGadget(#PB_Any, 10,10, 780, 540, #PB_Editor_ReadOnly)
	SetGadgetText(Editor, Games(0) \ GameComment)
	SetGadgetFont(Editor, FontID(#EditorFont))
	
	Done = 0
	Repeat
		SetActiveWindow(#GameCommentWindow)
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
						
					Case OKButton
						Done = 1
				EndSelect
		EndSelect
	Until Done = 1
	
	; StickyWindow(#GameCommentWindow, 0)	
	CloseWindow(#GameCommentWindow)
	
EndProcedure

; Add a new game
Procedure CreateNewGame()
	Games(0) \ Title = ""
	Games(0) \ Globals = ""
	Games(0) \ Functions = ""
	Games(0) \ ScriptMode = 0
	Games(0) \ GameComment = ""
	Games(0) \ GlobalsTimer = UID()
	Games(0) \ FunctionsTimer = UID()
EndProcedure

; Save the preferences
Procedure SavePreferences()
	OpenPreferences("preferences.dat")
	PreferenceGroup("Code editor")
	WritePreferenceInteger("sci_color_fore", sci_color_fore)
	WritePreferenceInteger("sci_color_selection_back", sci_color_selection_back)
	WritePreferenceInteger("sci_color_selection_fore", sci_color_selection_fore)
	WritePreferenceInteger("sci_color_command", sci_color_command)
	WritePreferenceInteger("sci_color_comment", sci_color_comment)
	WritePreferenceInteger("sci_color_function", sci_color_function)
	WritePreferenceInteger("sci_color_number", sci_color_number)
	WritePreferenceInteger("sci_color_resource", sci_color_resource)
	WritePreferenceInteger("sci_color_string", sci_color_string)
	WritePreferenceInteger("sci_color_tu_constant", sci_color_tu_constant)
	WritePreferenceInteger("sci_color_tu_function", sci_color_tu_function)
	WritePreferenceInteger("sci_color_tu_variable", sci_color_tu_variable)
	WritePreferenceInteger("sci_color_caret", sci_color_caret)
	WritePreferenceString("sci_font_family", sci_font_family)
	WritePreferenceInteger("sci_font_size", sci_font_size)
	WritePreferenceInteger("x", ScriptEditorX)
	WritePreferenceInteger("y", ScriptEditorY)
	WritePreferenceInteger("width", ScriptEditorWidth)
	WritePreferenceInteger("height", ScriptEditorHeight)
	WritePreferenceInteger("maximized", ScriptEditorMaximized)
	PreferenceGroup("Browser")
	WritePreferenceInteger("add_file_protocol", AddFileProtocol)
	PreferenceGroup("Misc")
	WritePreferenceInteger("CheckProgramVersion", CheckProgramVersion)
	WritePreferenceInteger("GenerateIndexHTML", GenerateIndexHTML)
	WritePreferenceInteger("ConfirmExit", ConfirmExit)
	PreferenceGroup("Export")
	WritePreferenceString("ImgFolder", ImgFolder)
	WritePreferenceString("AudFolder", AudioFolder)
	ClosePreferences()
EndProcedure

; Close all opened windows
Procedure CloseWindows()

	For s = 0 To ArraySize(Sprites()) - 1
		If IsWindow(Sprites(s) \ GadgetWindow) : CloseWindow(Sprites(s) \ GadgetWindow) : EndIf
		If IsWindow(Sprites(s) \ GadgetShapeWindow) : CloseWindow(Sprites(s) \ GadgetShapeWindow) : EndIf
	Next
	
	For s = 0 To ArraySize(Sounds()) - 1
		If IsWindow(Sounds(s) \ GadgetWindow) : CloseWindow(Sounds(s) \ GadgetWindow) : EndIf
	Next
	
	For s = 0 To ArraySize(Musics()) - 1
		If IsWindow(Musics(s) \ GadgetWindow) : CloseWindow(Musics(s) \ GadgetWindow) : EndIf
	Next
	
	For s = 0 To ArraySize(Fonts()) - 1
		If IsWindow(Fonts(s) \ GadgetWindow) : CloseWindow(Fonts(s) \ GadgetWindow) : EndIf
	Next
	
	For s = 0 To ArraySize(Backgrounds()) - 1
		If IsWindow(Backgrounds(s) \ GadgetWindow) : CloseWindow(Backgrounds(s) \ GadgetWindow) : EndIf
	Next
	
	For s = 0 To ArraySize(Functions()) - 1
		If IsWindow(Functions(s) \ GadgetWindow) : CloseWindow(Functions(s) \ GadgetWindow) : EndIf
	Next
	
	For s = 0 To ArraySize(Objects()) - 1
		If IsWindow(Objects(s) \ GadgetWindow) : CloseWindow(Objects(s) \ GadgetWindow) : EndIf
		If IsWindow(Objects(s) \ GadgetCodeWindow) : CloseWindow(Objects(s) \ GadgetCodeWindow) : EndIf
	Next
	
	For s = 0 To ArraySize(Scenes()) - 1
		If IsWindow(Scenes(s) \ GadgetWindow) : CloseWindow(Scenes(s) \ GadgetWindow) : EndIf
		If IsWindow(Scenes(s) \ CodeEditorWindow) : CloseWindow(Scenes(s) \ CodeEditorWindow) : EndIf
	Next
	
	If IsWindow(Games(0)  \ GadgetGlobalsWindow) : CloseWindow(Games(0)  \ GadgetGlobalsWindow) : EndIf
	If IsWindow(Games(0)  \ GadgetFunctionsWindow) : CloseWindow(Games(0)  \ GadgetFunctionsWindow) : EndIf
	If IsWindow(Games(0)  \ GadgetCommentsWindow) : CloseWindow(Games(0)  \ GadgetCommentsWindow) : EndIf
	If IsWindow(Games(0)  \ ExtensionWindow) : CloseWindow(Games(0)  \ ExtensionWindow) : EndIf
	
EndProcedure

; Main window NEW menu item
Procedure New()
  
	; Confirm new when dirty
	ok = 1
	If DirtyFlag = 1 : ok = Confirm("Confirm", "Unsaved changes will be lost. New?") : EndIf
	
	; Start a new project
	If ok = 1
	  
		; Delete temp directory before exit
		If FileSize(TempName) = -2 : DeleteDirectory(TempName, "") : EndIf
		
		TempName = "_temp_" + FormatDate("%hh%ii%ss", Date())
		
		SetGadgetState(#MainPanel, 0)
		
		Dirty(0)
		UID = 1
		
		; Remove all virtual items from the panels
		For w = 0 To ArraySize(Items()) - 1 : FreeGadget(Items(w) \ Gadget) : Next
		
		; Close opened forms
		CloseWindows()
		
		; Empty resources
		ReDim Games(1)
		For s = 0 To ArraySize(NameConflicts()) - 1: NameConflicts(s) \ Name = "" : Next : ReDim NameConflicts(0)
		For s = 0 To ArraySize(Sprites()) - 1: Sprites(s) \ Name = "" : Next : ReDim Sprites(0)
		For s = 0 To ArraySize(Frames()) - 1: Frames(s) \ Sprite = "" : Next : ReDim Frames(0)
		For s = 0 To ArraySize(Sequences()) - 1: Sequences(s) \ Image = -1 : Next : ReDim Sequences(0)
		For s = 0 To ArraySize(Backgrounds()) - 1: Backgrounds(s) \ Name = "" : Next : ReDim Backgrounds(0)
		For s = 0 To ArraySize(Tiles()) - 1: Tiles(s) \ Name = "" : Next : ReDim Tiles(0)
		For s = 0 To ArraySize(Layers()) - 1: Layers(s) \ Name = "" : Next : ReDim Layers(0)
		For s = 0 To ArraySize(Fonts()) - 1: Fonts(s) \ Name = "" : Next : ReDim Fonts(0)
		For s = 0 To ArraySize(Objects()) - 1: Objects(s) \ Name = "" : Next : ReDim Objects(0)
		For s = 0 To ArraySize(Sounds()) - 1: Sounds(s) \ Name = "" : Next : ReDim Sounds(0)
		For s = 0 To ArraySize(Musics()) - 1: Musics(s) \ Name = "" : Next : ReDim Musics(0)
		For s = 0 To ArraySize(Scenes()) - 1: Scenes(s) \ Name = "" : Next : ReDim Scenes(0)
		For s = 0 To ArraySize(Functions()) - 1: Functions(s) \ Name = "" : Next : ReDim Functions(0)
		For s = 0 To ArraySize(Scripts()) - 1: Scripts(s) \ Name = "" : Next : ReDim Scripts(0)
		For s = 0 To ArraySize(Items()) - 1: Items(s) \ Name = "" : Next : ReDim Items(0)
		For s = 0 To ArraySize(CollisionPoints()) - 1: CollisionPoints(s) \ Sprite = "" : Next : ReDim CollisionPoints(0)
		
		ObjectsOrder = ""
		
		CreateNewGame()
		
		; Create an preference file if not exists
		If OpenPreferences("preferences.dat") = 0
			CreatePreferences("preferences.dat")
			ClosePreferences()
			SavePreferences()
		EndIf
		
		OpenPreferences("preferences.dat")
		PreferenceGroup("Code editor")
		sci_color_back = ReadPreferenceInteger("sci_color_back", RGB(255, 255, 255))
		sci_color_fore = ReadPreferenceInteger("sci_color_fore", RGB(255, 255, 255))
		sci_color_selection_fore = ReadPreferenceInteger("sci_color_selection_fore", RGB(255, 255, 255))
		sci_color_command = ReadPreferenceInteger("sci_color_command", RGB(54, 45, 227))
		sci_color_comment = ReadPreferenceInteger("sci_color_comment", RGB(160,160,160))
		sci_color_function = ReadPreferenceInteger("sci_color_function", RGB(160,160,160))
		sci_color_number = ReadPreferenceInteger("sci_color_number", RGB(208, 64, 64))
		sci_color_resource = ReadPreferenceInteger("sci_color_resource", RGB(49, 170, 187))
		sci_color_string = ReadPreferenceInteger("sci_color_string", RGB(198, 0, 198))
		sci_color_tu_constant = ReadPreferenceInteger("sci_color_tu_constant", RGB(60, 60, 60))
		sci_color_tu_function = ReadPreferenceInteger("sci_color_tu_function", RGB(32, 106, 34))
		sci_color_tu_variable = ReadPreferenceInteger("sci_color_tu_variable", RGB(81, 80, 19))
		sci_color_caret = ReadPreferenceInteger("sci_color_caret", RGB(255, 240, 240))
		sci_font_family = ReadPreferenceString("sci_font_family", "Consolas")
		sci_font_size = ReadPreferenceInteger("sci_font_size", 11)
		ScriptEditorX = ReadPreferenceInteger("x", -1)
		ScriptEditorY = ReadPreferenceInteger("y", -1)
		ScriptEditorWidth = ReadPreferenceInteger("width", -1)
		ScriptEditorHeight = ReadPreferenceInteger("height", -1)
		ScriptEditorMaximized = ReadPreferenceInteger("maximized", -1)
		PreferenceGroup("Browser")
		AddFileProtocol = ReadPreferenceInteger("add_file_protocol", 0)
		PreferenceGroup("Misc")
		CheckProgramVersion = ReadPreferenceInteger("CheckProgramVersion", 1)
		GenerateIndexHTML = ReadPreferenceInteger("GenerateIndexHTML", 1)
		ConfirmExit = ReadPreferenceInteger("ConfirmExit", 1)
		PreferenceGroup("Export")
		ImgFolder = ReadPreferenceString("ImgFolder", "img")
		AudioFolder = ReadPreferenceString("AudFolder", "aud")
		ClosePreferences()
		
		; Create a Extensions folder if not exists
		If FileSize("Extensions") <> -2 : CreateDirectory("Extensions") : EndIf
		
		; Create a Projects folder if not exists
		If FileSize("Projects") <> -2 : CreateDirectory("Projects") : EndIf
		ProjectName = ""
		
		; Empty or create temp folder for the resource files
		; No _temp_ single file is available
		If FileSize(TempName) >= 0 : DeleteFile(TempName) : EndIf
		
		; delete existing _temp_ folder
		If FileSize(TempName) = -2 : DeleteDirectory(TempName, "") : EndIf
		
		; create new _temp_ folder
		If FileSize(TempName) <> -2 : CreateDirectory(TempName) : EndIf
		
	EndIf
	
EndProcedure

; Recreate all box images
Procedure RefreshBoxImages()
	; Sprite box
	For s = 0 To ArraySize(Sprites()) - 1
		TempImage = CreateImage(#PB_Any, 150, 100, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(TempImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		If IsImage(#BoxEmpty) : DrawImage(ImageID(#BoxEmpty), 0, 0) : EndIf
		; Find first frame of this sprite
		BoxImage = -1
		For f = 0 To ArraySize(Frames()) - 1
			If Frames(f) \ Sprite = Sprites(s) \ Name
				BoxImage = Frames(f) \ Image 
				Break
			EndIf
		Next
		If IsImage(BoxImage)
			IW = ImageWidth(BoxImage)
			IH = ImageHeight(BoxImage)
			If IW >= IH
				WS.f = 1
				HS.f = IH / IW
			Else
				WS.f = IW / IH
				HS.f = 1
			EndIf
			DrawImage(ImageID(BoxImage), 45, 20, 60 * WS, 60 * HS)
		Else
			DrawImage(ImageID(#BoxInvalid), 0, 0)
		EndIf
		StopDrawing()
		Sprites(s) \ Preview = CopyImage(TempImage, #PB_Any)
		If IsImage(TempImage) : FreeImage(TempImage) : EndIf			
	Next
	
	; Background box
	For s = 0 To ArraySize(Backgrounds()) - 1
		If Backgrounds(s) \ File <> ""
			TempImage = CreateImage(#PB_Any, 150, 100, 32, #PB_Image_Transparent)
			StartDrawing(ImageOutput(TempImage))
			DrawingMode(#PB_2DDrawing_AlphaBlend)
			If IsImage(#BoxEmpty) : DrawImage(ImageID(#BoxEmpty), 0, 0) : EndIf
			BoxImage = LoadImage(#PB_Any, "Projects/" + ProjectName + "/" + ImgFolder + "/" + Backgrounds(s) \ File)
			IW = ImageWidth(BoxImage)
			IH = ImageHeight(BoxImage)
			WS.f = 1
			HS.f = 1
			If IW >= IH
				WS.f = 1
				HS.f = IH / IW
			Else
				WS.f = IW / IH
				HS.f = 1
			EndIf
			If IsImage(BoxImage) : DrawImage(ImageID(BoxImage), 45, 20, 60 * WS, 60 * HS) : EndIf
			StopDrawing()
			Backgrounds(s) \ Preview = CopyImage(TempImage, #PB_Any)
			If IsImage(TempImage) : FreeImage(TempImage) : EndIf
		EndIf
	Next
	
	; Object box
	For s = 0 To ArraySize(Objects()) - 1
		If Objects(s) \ Sprite <> ""
			TempImage = CreateImage(#PB_Any, 150, 100, 32, #PB_Image_Transparent)
			StartDrawing(ImageOutput(TempImage))
			DrawingMode(#PB_2DDrawing_AlphaBlend)
			If IsImage(#BoxEmpty) : DrawImage(ImageID(#BoxEmpty), 0, 0) : EndIf
			; Find first frame of this sprite
			BoxImage = -1
			For f = 0 To ArraySize(Frames()) - 1
				If Frames(f) \ Sprite = Objects(s) \ Sprite
					BoxImage = Frames(f) \ Image
					Objects(s) \ TImage = Frames(f) \ Image
					Objects(s) \ TWidth = ImageWidth(Frames(f) \ Image)
					Objects(s) \ THeight = ImageHeight(Frames(f) \ Image)
					Break
				EndIf
			Next
			If IsImage(BoxImage)
				IW = ImageWidth(BoxImage)
				IH = ImageHeight(BoxImage)
				If IW >= IH
					WS.f = 1
					HS.f = IH / IW
				Else
					WS.f = IW / IH
					HS.f = 1
				EndIf
				DrawImage(ImageID(BoxImage), 45, 20, 60 * WS, 60 * HS)
			Else
				DrawImage(ImageID(#BoxInvalid), 0, 0)
			EndIf
			StopDrawing()
			If IsImage(TempImage) : FreeImage(TempImage) : EndIf
		EndIf
	Next				
EndProcedure

; Display name conflicts
Procedure DisplayConflictInfo()
	
	If ConflictInfo = ""
		ProcedureReturn 0
	EndIf
	
	ConflictInfo = "The following items had name conflicts during the merging process and they have been renamed:" + Chr(13) + ConflictInfo
	
	Window = OpenWindow(#PB_Any, 0, 0, 800, 600, "Merge result", #PB_Window_ScreenCentered | #PB_Window_Tool, WindowID(#MainWindow))
	
	; OK button
	OKButton = ButtonGadget(#PB_Any, WindowWidth(Window) - 75, WindowHeight(Window) - 35, 65, 25, "OK")
	
	; Editor
	Editor = EditorGadget(#PB_Any, 10,10, 780, 540, #PB_Editor_ReadOnly)
	SetGadgetText(Editor, ConflictInfo)
	SetGadgetFont(Editor, FontID(#EditorFont))
	
	Done = 0
	Repeat
		SetActiveWindow(Window)
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
						
					Case OKButton
						Done = 1
				EndSelect
		EndSelect
	Until Done = 1
	CloseWindow(Window)
EndProcedure

; Add name as conflicted
Procedure.s AddNameConflict(Name.s, Type.s)
	index = ArraySize(NameConflicts())
	NameConflicts(index) \ Name = Name.s
	NameConflicts(index) \ NameNew = Name.s + "_" + UID()
	NameConflicts(index) \ Type = UCase(Type.s)
	Select UCase(type)
		Case "SPRITE", "SOUND", "MUSIC", "FONT", "BACKGROUND", "OBJECT", "SCENE", "FUNCTION"
			If UCase(Left(Name, 11)) <> "SCENEOBJECT"
				ConflictInfo  = ConflictInfo + Type + " -> " + Name + " to " + NameConflicts(index) \ NameNew + Chr(13)
			EndIf
	EndSelect
	ReDim NameConflicts(index + 1)
	ProcedureReturn NameConflicts(index) \ NameNew
EndProcedure

; Check name for conflict
Procedure CheckNameConflict(Name.s, Type.s)
	
	Conflict = 0
	
	Select UCase(Type)
		Case "SPRITE" : For s = 0 To ArraySize(Sprites()) - 1 : If Sprites(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "SOUND" : For s = 0 To ArraySize(Sounds()) - 1 : If Sounds(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "MUSIC" : For s = 0 To ArraySize(Musics()) - 1 : If Musics(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "FONT" : For s = 0 To ArraySize(Fonts()) - 1 : If Fonts(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "BACKGROUND" : For s = 0 To ArraySize(Backgrounds()) - 1 : If Backgrounds(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "OBJECT" : For s = 0 To ArraySize(Objects()) - 1 : If Objects(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "SCENE" : For s = 0 To ArraySize(Scenes()) - 1 : If Scenes(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "FUNCTION" : For s = 0 To ArraySize(Functions()) - 1 : If Functions(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "LAYER" : For s = 0 To ArraySize(Layers()) - 1 : If Layers(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "TILE" : For s = 0 To ArraySize(Tiles()) - 1 : If Tiles(s) \ Name = Name : Conflict = 1 : EndIf : Next
		Case "SCRIPT" : For s = 0 To ArraySize(Scripts()) - 1 : If Scripts(s) \ Name = Name : Conflict = 1 : EndIf : Next
	EndSelect
	
	ProcedureReturn Conflict
	
EndProcedure

; Handle name conflict
Procedure.s HandleConflicts(Name.s, Type.s)
	If CheckNameConflict(Name, Type)
		Name.s = AddNameConflict(Name.s, Type.s)
	EndIf
	ProcedureReturn Name.s
EndProcedure

; Fix the conflicted name
Procedure.s FixNameConflict(Name.s, Type.s)
	For s = 0 To ArraySize(NameConflicts()) - 1
		If UCase(NameConflicts(s) \ Name) = UCase(Name) And UCase(NameConflicts(s) \ Type) = UCase(Type)
			Name = NameConflicts(s) \ NameNew
		EndIf
	Next
	ProcedureReturn Name.s	
EndProcedure

; Main window OPEN menu item
Procedure Open(Merge)
	
	ReDim NameConflicts(0)
	Dim NewObjects.Object(0)
	ConflictInfo = ""
	
	temp_ProjectName.s = ProjectName
	temp_ImgFolder.s = ImgFolder
	temp_AudioFolder.s = AudioFolder
	
	; Confirm open when dirty
	ok = 1
	If DirtyFlag = 1 And Merge = 0
		ok = Confirm("Confirm", "Unsaved changes will be lost. Open a new project?")
	EndIf
	
	If Merge And ProjectName = ""
		ok = 0
		MessageRequester("Error", "Please save your current project or open the base project.")
	EndIf
	
	; Open selected game
	If ok = 1
	  
		SelectedProjectName.s = SelectProject()
		
		Openable = 0
		
		If SelectedProjectName <> ""
			; Check file version saved with newer version?
			temp = LoadXML(#PB_Any, "Projects/" + SelectedProjectName + ".xml")
			tululoo_node = MainXMLNode(temp)
			FileVersion.i = Val(GetXMLAttribute(tululoo_node, "version"))
			If FileVersion <= Version
				Openable = 1
			Else
				Openable = 0
				MessageRequester("Error", "This project requires a new program version (v" + Str(FileVersion) + ").")
			EndIf
			FreeXML(temp)
		EndIf
		
		; Everything looks fine
		If SelectedProjectName <> "" And Openable = 1
			
			Dirty(0)
			
			; DROP CURRENT PROJECT IF IT IS NOT A MERGE
			If Not Merge
				New()
			EndIf
			
			ProjectName = SelectedProjectName
			
			SetGadgetText(#MainWindowInfoText, "OPENING PROJECT...")
			
			DirName.s = "Projects/" + ProjectName + "/"
			
			; **********************************************************************
			; * XML START
			; **********************************************************************
			; There are some file version checking for handling backward compatibility
			
			xml = LoadXML(#PB_Any, "Projects/" + ProjectName + ".xml")
			tululoo_node = MainXMLNode(xml)
			functions_node = ChildXMLNode(tululoo_node, 1)
			variables_node = ChildXMLNode(tululoo_node, 2)
			comments_node = ChildXMLNode(tululoo_node, 3)
			sprites_node = ChildXMLNode(tululoo_node, 4)
			frames_node = ChildXMLNode(tululoo_node, 5)
			sounds_node = ChildXMLNode(tululoo_node, 6)
			musics_node = ChildXMLNode(tululoo_node, 7)
			backgrounds_node = ChildXMLNode(tululoo_node, 8)
			fonts_node = ChildXMLNode(tululoo_node, 9)
			objects_node = ChildXMLNode(tululoo_node, 10)
			scripts_node = ChildXMLNode(tululoo_node, 11)
			scenes_node = ChildXMLNode(tululoo_node, 12)
			layers_node = ChildXMLNode(tululoo_node, 13)
			tiles_node = ChildXMLNode(tululoo_node, 14)
			If FileVersion >= 129
				fns_node = ChildXMLNode(tululoo_node, 15)
			EndIf
			If FileVersion >= 200
				points_node = ChildXMLNode(tululoo_node, 16)
			EndIf			
			
			; ****************************************************
			; Version
			; ****************************************************
			
			FileVersion.i = Val(GetXMLAttribute(tululoo_node, "version"))
			
			If Not Merge
				Games(0) \ Title = GetXMLAttribute(tululoo_node, "title")
				Games(0) \ ScriptMode = Val(GetXMLAttribute(tululoo_node, "advancedscriptmode"))
				Games(0) \ Functions = GetXMLNodeText(functions_node)
				Games(0) \ Globals = GetXMLNodeText(variables_node)
				Games(0) \ GameComment = GetXMLNodeText(comments_node)
			Else
				Games(0) \ Functions + GetXMLNodeText(functions_node)
				Games(0) \ Globals + GetXMLNodeText(variables_node)
				Games(0) \ GameComment + GetXMLNodeText(comments_node)
			EndIf
			If FileVersion >= 129
				ImgFolder = GetXMLAttribute(tululoo_node, "imgfolder")
				AudioFolder = GetXMLAttribute(tululoo_node, "audfolder")
			EndIf
			
			ImgDirName.s = "Projects/" + ProjectName + "/" + ImgFolder + "/"
			AudDirName.s = "Projects/" + ProjectName + "/" + AudioFolder + "/"
			
			; ****************************************************
			; Sprite
			; ****************************************************
			
			; Number of sprites
			Num.i = Val(GetXMLAttribute(sprites_node, "count"))
			CNum.i = ArraySize(Sprites()); Current number of ...
			ReDim Sprites(CNum + Num)
			
			; Sprite details
			For w = 0 To Num - 1
				sprite_node = ChildXMLNode(sprites_node, w + 1)
				Sprites(Cnum + w) \ Name = HandleConflicts(GetXMLAttribute(sprite_node, "name"), "SPRITE")
				Sprites(Cnum + w) \ CenterX = Val(GetXMLAttribute(sprite_node, "centerx"))
				Sprites(Cnum + w) \ CenterY = Val(GetXMLAttribute(sprite_node, "centery"))
				Sprites(Cnum + w) \ CollisionShape = GetXMLAttribute(sprite_node, "collisionshape")
				Sprites(Cnum + w) \ CollisionRadius = Val(GetXMLAttribute(sprite_node, "collisionradius"))
				Sprites(Cnum + w) \ CollisionLeft = Val(GetXMLAttribute(sprite_node, "collisionleft"))
				Sprites(Cnum + w) \ CollisionRight = Val(GetXMLAttribute(sprite_node, "collisionright"))
				Sprites(Cnum + w) \ CollisionTop = Val(GetXMLAttribute(sprite_node, "collisiontop"))
				Sprites(Cnum + w) \ CollisionBottom = Val(GetXMLAttribute(sprite_node, "collisionbottom"))
				Sprites(Cnum + w) \ Keywords = GetXMLAttribute(sprite_node, "keywords")
				If FileVersion < 200
					Sprites(Cnum + w) \ UID = UID()
				Else
					Sprites(Cnum + w) \ UID = Val(GetXMLAttribute(sprite_node, "uid"))
				EndIf
				
				Sprites(Cnum + w) \ Timer = UID()
				Sprites(Cnum + w) \ Zoom = 1
				Sprites(Cnum + w) \ AnimSpeed = 30
				Sprites(Cnum + w) \ ShowCollisionShape = 1
				Sprites(Cnum + w) \ Timer2 = UID()
				Sprites(Cnum + w) \ ShapeEditorSnapToGrid = 1
				Sprites(Cnum + w) \ ShapeEditorGridWidth = 5
				Sprites(Cnum + w) \ ShapeEditorGridHeight = 5
				Sprites(Cnum + w) \ ShapeEditorZoom = 1
			Next
			
			; ****************************************************
			; Frames (sprite animation)
			; ****************************************************
			
			; Number of frames
			Num = Val(GetXMLAttribute(frames_node, "count"))
			CNum = ArraySize(Frames())
			ReDim Frames(Cnum + Num)
						
			; Frame details
			For w = 0 To Num - 1
				frame_node = ChildXMLNode(frames_node, w + 1)
				Frames(CNum + w) \ File = GetXMLAttribute(frame_node, "file")
				OriginalSpriteName.s = GetXMLAttribute(frame_node, "sprite")
				Frames(CNum + w) \ Sprite = FixNameConflict(OriginalSpriteName, "SPRITE")
				If FileVersion >= 129
					If OriginalSpriteName <> Frames(CNum + w) \ Sprite
						CopyFile(ImgDirName + OriginalSpriteName + "_" + Frames(CNum + w) \ File + ".png", ImgDirName + Frames(Cnum + w) \ Sprite + "_" + Frames(CNum + w) \ File + ".png")
					EndIf
					Frames(CNum + w) \ Image = LoadImage(#PB_Any, ImgDirName + Frames(Cnum + w) \ Sprite + "_" + Frames(CNum + w) \ File + ".png")
				Else
					If OriginalSpriteName <> Frames(CNum + w) \ Sprite
						CopyFile(DirName + OriginalSpriteName + "_" + Frames(CNum + w) \ File + ".png", DirName + Frames(CNum + w) \ Sprite + "_" + Frames(CNum + w) \ File + ".png")
					EndIf
					Frames(CNum + w) \ Image = LoadImage(#PB_Any, DirName + Frames(CNum + w) \ Sprite + "_" + Frames(CNum + w) \ File + ".png")
				EndIf
			Next
			
			; ****************************************************
			; Sound
			; ****************************************************
			
			; Number of sounds
			Num = Val(GetXMLAttribute(sounds_node, "count"))
			CNum = ArraySize(Sounds())
			ReDim Sounds(CNum + Num)
			
			; Sound details
			For w = 0 To Num - 1
				
				sound_node = ChildXMLNode(sounds_node, w + 1)
				Sounds(CNum + w) \ Name = HandleConflicts(GetXMLAttribute(sound_node, "name"), "SOUND")
				Sounds(CNum + w) \ File = GetXMLAttribute(sound_node, "wav")
				Sounds(CNum + w) \ File2 = GetXMLAttribute(sound_node, "mp3")
				Sounds(CNum + w) \ File3 = GetXMLAttribute(sound_node, "ogg")
				Sounds(CNum + w) \ Keywords = GetXMLAttribute(sound_node, "keywords")
				If FileVersion < 200
					Sounds(CNum + w) \ UID = UID()
				Else
					Sounds(CNum + w) \ UID = Val(GetXMLAttribute(sound_node, "uid"))
				EndIf
				
				If FileVersion >= 129
					Res.i = CopyFile(AudDirName + Sounds(CNum + w) \ File, GetCurrentDirectory() + TempName + "/" + Sounds(CNum + w) \ File)
					Res.i = CopyFile(AudDirName + Sounds(CNum + w) \ File2, GetCurrentDirectory() + TempName + "/" + Sounds(CNum + w) \ File2)
					Res.i = CopyFile(AudDirName + Sounds(CNum + w) \ File3, GetCurrentDirectory() + TempName + "/" + Sounds(CNum + w) \ File3)
				Else
					Res.i = CopyFile(DirName + Sounds(CNum + w) \ File, GetCurrentDirectory() + TempName + "/" + Sounds(CNum + w) \ File)
					Res.i = CopyFile(DirName + Sounds(CNum + w) \ File2, GetCurrentDirectory() + TempName + "/" + Sounds(CNum + w) \ File2)
					Res.i = CopyFile(DirName + Sounds(CNum + w) \ File3, GetCurrentDirectory() + TempName + "/" + Sounds(CNum + w) \ File3)
				EndIf
				
			Next
			
			; ****************************************************
			; Music
			; ****************************************************
			
			; Number of musics
			Num = Val(GetXMLAttribute(musics_node, "count"))
			CNum = ArraySize(Musics())
			ReDim Musics(CNum + Num)
			
			; Music details
			For w = 0 To Num - 1
				music_node = ChildXMLNode(musics_node, w + 1)
				Musics(CNum + w) \ Name = HandleConflicts(GetXMLAttribute(music_node, "name"), "MUSIC")
				Musics(CNum + w) \ File = GetXMLAttribute(music_node, "wav")
				Musics(CNum + w) \ File2 = GetXMLAttribute(music_node, "mp3")
				Musics(CNum + w) \ File3 = GetXMLAttribute(music_node, "ogg")
				Musics(CNum + w) \ Keywords = GetXMLAttribute(music_node, "keywords")
				If FileVersion < 200
					Musics(CNum + w) \ UID = UID()
				Else
					Musics(CNum + w) \ UID = Val(GetXMLAttribute(music_node, "uid"))
				EndIf
				
				If FileVersion >= 129
					Res = CopyFile(AudDirName + Musics(CNum + w) \ File, GetCurrentDirectory() + TempName + "/" + Musics(CNum + w) \ File)
					Res.i = CopyFile(AudDirName + Musics(CNum + w) \ File2, GetCurrentDirectory() + TempName + "/" + Musics(CNum + w) \ File2)
					Res.i = CopyFile(AudDirName + Musics(CNum + w) \ File3, GetCurrentDirectory() + TempName + "/" + Musics(CNum + w) \ File3)
				Else
					Res = CopyFile(DirName + Musics(CNum + w) \ File, GetCurrentDirectory() + TempName + "/" + Musics(CNum + w) \ File)
					Res.i = CopyFile(DirName + Musics(CNum + w) \ File2, GetCurrentDirectory() + TempName + "/" + Musics(CNum + w) \ File2)
					Res.i = CopyFile(DirName + Musics(CNum + w) \ File3, GetCurrentDirectory() + TempName + "/" + Musics(CNum + w) \ File3)
				EndIf
			Next
			
			; ****************************************************
			; Background
			; ****************************************************
			
			; Number of backgrounds
			Num = Val(GetXMLAttribute(backgrounds_node, "count"))
			CNum = ArraySize(Backgrounds())
			ReDim Backgrounds(CNum + Num)
			
			; Background details
			For w = 0 To Num - 1
				background_node = ChildXMLNode(backgrounds_node, w + 1)
				OriginalBackgroundName.s = GetXMLAttribute(background_node, "name")
				Backgrounds(CNum + w) \ Name = HandleConflicts(OriginalBackgroundName, "BACKGROUND")
				Backgrounds(CNum + w) \ File = GetXMLAttribute(background_node, "file")
				Backgrounds(CNum + w) \ Preview = -1
				Backgrounds(CNum + w) \ Tile = Val(GetXMLAttribute(background_node, "tile"))
				Backgrounds(CNum + w) \ TileHeight = Val(GetXMLAttribute(background_node, "tileheight"))
				Backgrounds(CNum + w) \ TileWidth = Val(GetXMLAttribute(background_node, "tilewidth"))
				Backgrounds(CNum + w) \ TileXOffset = Val(GetXMLAttribute(background_node, "tilexoffset"))
				Backgrounds(CNum + w) \ TileYOffset = Val(GetXMLAttribute(background_node, "tileyoffset"))
				Backgrounds(CNum + w) \ TileXSpace = Val(GetXMLAttribute(background_node, "tilexspace"))
				Backgrounds(CNum + w) \ TileYSpace = Val(GetXMLAttribute(background_node, "tileyspace"))
				Backgrounds(CNum + w) \ Keywords = GetXMLAttribute(background_node, "keywords")
				If FileVersion < 200
					Backgrounds(CNum + w) \ UID = UID()
				Else
					Backgrounds(CNum + w) \ UID = Val(GetXMLAttribute(background_node, "uid"))
				EndIf
				
				If FileVersion >= 129
					Res = CopyFile(ImgDirName + Backgrounds(CNum + w) \ File, GetCurrentDirectory() + TempName + "/" + Backgrounds(CNum + w) \ File)
					; COPY THE LOADED BACKGROUND TO THE BASE (ORIGNAL PROJECT) DIRECTORY -> BOX IMAGE NEEDS IT
					If Merge
						CopyFile(ImgDirName + Backgrounds(CNum + w) \ File, "Projects/" + temp_ProjectName + "/" + Temp_ImgFolder + "/" + Backgrounds(CNum + w) \ File)
					EndIf
				Else
					Res = CopyFile(DirName + Backgrounds(CNum + w) \ File, GetCurrentDirectory() + TempName + "/" + Backgrounds(CNum + w) \ File)
					; COPY THE LOADED BACKGROUND TO THE BASE (ORIGNAL PROJECT) DIRECTORY -> BOX IMAGE NEEDS IT
					If Merge
						CopyFile(DirName + Backgrounds(CNum + w) \ File, "Projects/" + temp_ProjectName + "/" + Temp_ImgFolder + "/" + Backgrounds(CNum + w) \ File)
					EndIf
				EndIf
				
				Backgrounds(CNum + w) \ Timer = UID()
				
			Next
			
			; ****************************************************
			; Font
			; ****************************************************
			
			; Number of fonts
			Num = Val(GetXMLAttribute(fonts_node, "count"))
			CNum = ArraySize(Fonts())
			ReDim Fonts(CNum + Num)
			
			; Font details
			For w = 0 To Num - 1
				font_node = ChildXMLNode(fonts_node, w + 1)
				Fonts(CNum + w) \ Name = HandleConflicts(GetXMLAttribute(font_node, "name"), "FONT")
				Fonts(CNum + w) \ Family = GetXMLAttribute(font_node, "family")
				Fonts(CNum + w) \ Size = Val(GetXMLAttribute(font_node, "size"))
				Fonts(CNum + w) \ Bold = Val(GetXMLAttribute(font_node, "bold"))
				Fonts(CNum + w) \ Italic = Val(GetXMLAttribute(font_node, "italic"))
				Fonts(CNum + w) \ Keywords = GetXMLAttribute(font_node, "keywords")
				If FileVersion < 200
					Fonts(CNum + w) \ UID = UID()
				Else
					Fonts(CNum + w) \ UID = Val(GetXMLAttribute(font_node, "uid"))
				EndIf
				
			Next		
			
			; ****************************************************
			; Object
			; ****************************************************
			
			; Number of objects
			Num = Val(GetXMLAttribute(objects_node, "count"))
			CNum = ArraySize(Objects())
			ReDim Objects(CNum + Num)
			
			; Object details
			For w = 0 To Num - 1
				object_node = ChildXMLNode(objects_node, w + 1)
				Objects(CNum + w) \ Name = HandleConflicts(GetXMLAttribute(object_node, "name"), "OBJECT")
				Objects(CNum + w) \ TemplateObject = FixNameConflict(GetXMLAttribute(object_node, "template"), "OBJECT")
				Objects(CNum + w) \ Proto = Val(GetXMLAttribute(object_node, "prototype"))
				Objects(CNum + w) \ Scene = GetXMLAttribute(object_node, "scene")
				Objects(CNum + w) \ Sprite = FixNameConflict(GetXMLAttribute(object_node, "sprite"), "SPRITE")
				Objects(CNum + w) \ X = Val(GetXMLAttribute(object_node, "x"))
				Objects(CNum + w) \ Y = Val(GetXMLAttribute(object_node, "y"))
				Objects(CNum + w) \ Visible = Val(GetXMLAttribute(object_node, "visible"))
				Objects(CNum + w) \ Depth = Val(GetXMLAttribute(object_node, "depth"))
				Objects(CNum + w) \ Collide = Val(GetXMLAttribute(object_node, "collision"))
				Objects(CNum + w) \ Parent = FixNameConflict(GetXMLAttribute(object_node, "parent"), "OBJECT")
				If FileVersion >= 129
					Objects(CNum + w) \ Direction = Val(GetXMLAttribute(object_node, "direction"))
					Objects(CNum + w) \ ImageAngle = Val(GetXMLAttribute(object_node, "image_angle"))
				EndIf
				Objects(CNum + w) \ Keywords = GetXMLAttribute(object_node, "keywords")
				Objects(CNum + w) \ TImage = -1
				If FileVersion < 200
					Objects(CNum + w) \ UID = UID()
				Else
					Objects(CNum + w) \ UID = Val(GetXMLAttribute(object_node, "uid"))
				EndIf
				
				; STORE AS A NEW OBJECT (FOR MERGE)
				; MAYBE ITS SCENE PARAM NEEDS TO BE CHANGED (IF SCENE IS IN CONFLICT)
				i = ArraySize(NewObjects())
				NewObjects(i) = Objects(CNum + w)
				ReDim NewObjects(i + 1)
				
			Next		
			
			; ****************************************************
			; Scripts
			; ****************************************************
			
			; Number of scripts
			Num = Val(GetXMLAttribute(scripts_node, "count"))
			CNum = ArraySize(Scripts())
			ReDim Scripts(CNum + Num)
			
			; Script details
			For w = 0 To Num - 1
				script_node = ChildXMLNode(scripts_node, w + 1)
				Scripts(CNum + w) \ Name = HandleConflicts(GetXMLAttribute(script_node, "name"), "SCRIPT")
				Scripts(CNum + w) \ Parent = FixNameConflict(GetXMLAttribute(script_node, "object"), "OBJECT")
				Scripts(CNum + w) \ Type = GetXMLAttribute(script_node, "event")
				Scripts(CNum + w) \ Parameter = GetXMLAttribute(script_node, "parameter")
				Scripts(CNum + w) \ Code = GetXMLNodeText(script_node)
			Next				
			
			; ****************************************************
			; Scene
			; ****************************************************
			
			; Number of scenes
			Num = Val(GetXMLAttribute(scenes_node, "count"))
			CNUm = ArraySize(Scenes())
			ReDim Scenes(CNum + Num)
			
			; Scene details
			For w = 0 To Num - 1
				scene_node = ChildXMLNode(scenes_node, w + 1)
				OriginalSceneName.s = GetXMLAttribute(scene_node, "name")
				Scenes(CNum + w) \ Name = HandleConflicts(OriginalSceneName, "SCENE")
				Scenes(CNum + w) \ Width = Val(GetXMLAttribute(scene_node, "width"))
				Scenes(CNum + w) \ Height = Val(GetXMLAttribute(scene_node, "height"))
				Scenes(CNum + w) \ Speed = Val(GetXMLAttribute(scene_node, "speed"))
				Scenes(CNum + w) \ R = Val(GetXMLAttribute(scene_node, "red"))
				Scenes(CNum + w) \ G = Val(GetXMLAttribute(scene_node, "green"))
				Scenes(CNum + w) \ B = Val(GetXMLAttribute(scene_node, "blue"))
				Scenes(CNum + w) \ Background = FixNameConflict(GetXMLAttribute(scene_node, "background"), "BACKGROUND")
				Scenes(CNum + w) \ BackgroundStretch = Val(GetXMLAttribute(scene_node, "backgroundstretch"))
				Scenes(CNum + w) \ BackgroundTileX = Val(GetXMLAttribute(scene_node, "backgroundtilex"))
				Scenes(CNum + w) \ BackgroundTileY = Val(GetXMLAttribute(scene_node, "backgroundtiley"))
				Scenes(CNum + w) \ ViewportHeight = Val(GetXMLAttribute(scene_node, "viewportheight"))
				Scenes(CNum + w) \ ViewportWidth = Val(GetXMLAttribute(scene_node, "viewportwidth"))
				Scenes(CNum + w) \ ViewportXBorder = Val(GetXMLAttribute(scene_node, "viewportxborder"))
				Scenes(CNum + w) \ ViewportYBorder = Val(GetXMLAttribute(scene_node, "viewportyborder"))
				Scenes(CNum + w) \ ViewportObject = FixNameConflict(GetXMLAttribute(scene_node, "viewportobject"), "OBJECT")
				Scenes(CNum + w) \ Keywords = GetXMLAttribute(scene_node, "keywords")
				If FileVersion < 200
					Scenes(CNum + w) \ UID = UID()
				Else
					Scenes(CNum + w) \ UID = Val(GetXMLAttribute(scene_node, "uid"))
				EndIf
				Scenes(CNum + w) \ Code = GetXMLNodeText(scene_node)
				Scenes(CNum + w) \ Preview = #BoxEmpty
				Scenes(CNum + w) \ InnerTimer = UID()
				Scenes(CNum + w) \ InnerShowGrid = 1
				Scenes(CNum + w) \ InnerShowObjects = 1
				Scenes(CNum + w) \ InnerShowTiles = 1
				Scenes(CNum + w) \ InnerGridSize = 20
				
				; CHECK IF ANY OF THE NEW OBJECTS USE THIS SCENE
				; BUT THIS SCENE IS IN CONFLICT, 
				; CHANGE THE OBJECTS SCENE PARAM
				For s = 0 To ArraySize(NewObjects()) - 1
					If NewObjects(s) \ Scene = OriginalSceneName
						; FIND THE OBJECT
						For a = 0 To ArraySize(Objects()) - 1
							If Objects(a) \ Name = NewObjects(s) \ Name
								Objects(a) \ Scene = Scenes(CNum + w) \ Name
							EndIf
						Next
					EndIf
				Next
				
			Next
			
			; ****************************************************
			; Layer
			; ****************************************************
			
			; Number of layers
			Num = Val(GetXMLAttribute(layers_node, "count"))
			CNum = ArraySize(Layers())
			ReDim Layers(Cnum + Num)
			
			; Layer details
			For w = 0 To Num - 1
				layer_node = ChildXMLNode(layers_node, w + 1)
				Layers(CNum + w) \ Name = HandleConflicts(GetXMLAttribute(layer_node, "name"), "LAYER")
				Layers(CNum + w) \ Scene = FixNameConflict(GetXMLAttribute(layer_node, "scene"), "SCENE")
				Layers(CNum + w) \ Value = Val(GetXMLAttribute(layer_node, "value"))
			Next
			
			; ****************************************************
			; Tiles
			; ****************************************************
			
			; Number of tiles
			Num = Val(GetXMLAttribute(tiles_node, "count"))
			CNUm = ArraySize(Tiles())
			ReDim Tiles(CNUm + Num)
			
			; Tile details
			For w = 0 To Num - 1
				tile_node = ChildXMLNode(tiles_node, w + 1)
				Tiles(CNum + w) \ Name = HandleConflicts(GetXMLAttribute(tile_node, "name"), "TILE")
				Tiles(CNum + w) \ Background = FixNameConflict(GetXMLAttribute(tile_node, "background"), "BACKGROUND")
				Tiles(CNum + w) \ Depth = Val(GetXMLAttribute(tile_node, "depth"))
				Tiles(CNum + w) \ Width = Val(GetXMLAttribute(tile_node, "width"))
				Tiles(CNum + w) \ Height = Val(GetXMLAttribute(tile_node, "height"))
				Tiles(CNum + w) \ Left = Val(GetXMLAttribute(tile_node, "left"))
				Tiles(CNum + w) \ Top = Val(GetXMLAttribute(tile_node, "top"))
				Tiles(CNum + w) \ X = Val(GetXMLAttribute(tile_node, "x"))
				Tiles(CNum + w) \ Y = Val(GetXMLAttribute(tile_node, "y"))
				Tiles(CNum + w) \ Scene = FixNameConflict(GetXMLAttribute(tile_node, "scene"), "SCENE")
			Next
			
			If FileVersion >= 129
				; ****************************************************
				; Functions
				; ****************************************************
				
				; Number of functions
				Num = Val(GetXMLAttribute(fns_node, "count"))
				CNum = ArraySize(Functions())
				ReDim Functions(CNum + Num)
				
				; Function details
				For w = 0 To Num - 1
					function_node = ChildXMLNode(fns_node, w + 1)
					Functions(CNum + w) \ Name = HandleConflicts(GetXMLAttribute(function_node, "name"), "FUNCTION")
					Functions(CNum + w) \ Params = GetXMLAttribute(function_node, "params")
					Functions(CNum + w) \ Description = GetXMLAttribute(function_node, "description")
					Functions(CNum + w) \ Keywords = GetXMLAttribute(function_node, "keywords")
					If FileVersion < 200
						Functions(CNum + w) \ UID = UID()
					Else
						Functions(CNum + w) \ UID = Val(GetXMLAttribute(function_node, "uid"))
					EndIf
					Functions(CNum + w) \ Code = GetXMLNodeText(function_node)
				Next				
			EndIf
			
			; ****************************************************
			; Collision points
			; ****************************************************
			
			; Number of collision points
			If FileVersion >= 200
				Num = Val(GetXMLAttribute(points_node, "count"))
				CNum = ArraySize(CollisionPoints())
				ReDim CollisionPoints(Cnum + Num)
							
				; Point details
				For w = 0 To Num - 1
					point_node = ChildXMLNode(points_node, w + 1)
					CollisionPoints(CNum + w) \ Sprite = FixNameConflict(GetXMLAttribute(point_node, "sprite"), "SPRITE")
					CollisionPoints(CNum + w) \ X = Val(GetXMLAttribute(point_node, "x"))
					CollisionPoints(CNum + w) \ Y = Val(GetXMLAttribute(point_node, "y"))
				Next
			EndIf
			
			; Create tile images
			; Loop in each background and each tile and create the tile part
			TempBG = -1
			For b = 0 To ArraySize(Backgrounds()) - 1
				
				; Delete temp background
				If IsImage(TempBG) : FreeImage(TempBG) : EndIf
				
				; Create temp background
				If Backgrounds(b) \ File <> ""
					
					TempBG = LoadImage(#PB_Any, GetCurrentDirectory() + TempName + "/" + Backgrounds(b) \ File)
					
					For t = 0 To ArraySize(Tiles()) - 1
						If Tiles(t) \ Background = Backgrounds(b) \ Name
							Tiles(t) \ Image = CreateImage(#PB_Any, Tiles(t) \ Width, Tiles(t) \ Height, 32, #PB_Image_Transparent)
							StartDrawing(ImageOutput(Tiles(t)\Image))
							DrawingMode(#PB_2DDrawing_AlphaBlend )
							If IsImage(TempBG)
								DrawImage(ImageID(TempBG), -Tiles(t)\Left, -Tiles(t)\Top)
							Else
								Box(0, 0, Tiles(t)\Width, Tiles(t)\Height, RGB(255,0,0))
							EndIf
							StopDrawing()
						EndIf
					Next
					
				EndIf
			Next
			
			; USE BASE (ORIGINAL) NAMES IF PROJECT IS MERGE
			If Merge
				ProjectName = temp_ProjectName
				ImgFolder = temp_ImgFolder
				AudioFolder = temp_AudioFolder
			EndIf			
			
			; *****************************************************
			; Create new box images
			; *****************************************************
			
			RefreshBoxImages()
			
			; Validate scene objects depth by their template depth
			For s = 0 To ArraySize(Objects()) - 1
				If Objects(s) \ Proto = 1
					
					; search all instance of proto
					For i = 0 To ArraySize(Objects()) - 1
						If Objects(i) \ TemplateObject = Objects(s) \ Name
							Objects(i) \ Depth = Objects(s) \ Depth
						EndIf
					Next
					
				EndIf
			Next
			
			SetGadgetText(#MainWindowInfoText, "STATUS: READY.")
			SetGadgetState(#MainPanel, 0)
			FreeXML(xml)
			
		EndIf
		
		; FIX THE UID (number of resources)
		; Re-Calculate it instead of using the saved info
		UID = ArraySize(Sprites()) + ArraySize(Sounds()) + ArraySize(Musics()) + ArraySize(Fonts()) + ArraySize(Backgrounds()) + ArraySize(Objects()) + ArraySize(Scenes()) + ArraySize(Functions()) + ArraySize(Frames()) + ArraySize(Scripts()) + ArraySize(Tiles()) + ArraySize(Layers())
		
	EndIf
	
EndProcedure

; Save the game data (See Save and SaveAs())
Procedure DoSave()
	
	DirName.s = "Projects/" + ProjectName + "/"
	If FileSize("Projects/" + ProjectName) <> -2 : CreateDirectory("Projects/" + ProjectName) : EndIf
	
	; Create the image folder if not exists
	ImgDirName.s = "Projects/" + ProjectName + "/" + ImgFolder + "/"
	If FileSize("Projects/" + ProjectName + "/" + ImgFolder) <> -2 : CreateDirectory("Projects/" + ProjectName + "/" + ImgFolder) : EndIf
	
	; Create the audio folder if not exists
	AudDirName.s = "Projects/" + ProjectName + "/" + AudioFolder + "/"
	If FileSize("Projects/" + ProjectName + "/" + AudioFolder) <> -2 : CreateDirectory("Projects/" + ProjectName + "/" + AudioFolder) : EndIf
	
	; *************************************************************
	; * XML START
	; *************************************************************
	; Delete the existing project file
	If FileSize("Projects/" + ProjectName + ".xml") > 0 : DeleteFile("Projects/" + ProjectName + ".xml") : EndIf
	
	xml = CreateXML(#PB_Any, #PB_UTF8)
	tululoo_node = CreateXMLNode(RootXMLNode(xml))
	SetXMLNodeName(tululoo_node, "tululoo")
	
	; ****************************************************
	; Version
	; ****************************************************
	
	SetXMLAttribute(tululoo_node, "version", Str(Version))
	SetXMLAttribute(tululoo_node, "uid", Str(UID))
	SetXMLAttribute(tululoo_node, "title", Games(0) \ Title)
	SetXMLAttribute(tululoo_node, "advancedscriptmode", Str(Games(0) \ ScriptMode))
	SetXMLAttribute(tululoo_node, "imgfolder", ImgFolder)
	SetXMLAttribute(tululoo_node, "audfolder", AudioFolder)
	
	functions_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(functions_node, "functions")
	SetXMLNodeText(functions_node, Games(0) \ Functions)
	
	variables_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(variables_node, "variables")
	SetXMLNodeText(variables_node, Games(0) \ Globals)
	
	comments_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(comments_node, "comments")
	SetXMLNodeText(comments_node, Games(0) \ GameComment)
	
	; ****************************************************
	; Sprite
	; ****************************************************
	
	sprites_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(sprites_node, "sprites")
	SetXMLAttribute(sprites_node, "count", Str(ArraySize(Sprites())))
	
	; Sprite details
	For w = 0 To ArraySize(Sprites()) - 1
		
		sprite_node = CreateXMLNode(sprites_node)
		SetXMLNodeName(sprite_node, "sprite")
		SetXMLAttribute(sprite_node, "name", Sprites(w) \ Name)
		SetXMLAttribute(sprite_node, "centerx", Str(Sprites(w) \ CenterX))
		SetXMLAttribute(sprite_node, "centery", Str(Sprites(w) \ CenterY))
		SetXMLAttribute(sprite_node, "collisionshape", Sprites(w) \ CollisionShape)
		SetXMLAttribute(sprite_node, "collisionradius", Str(Sprites(w) \ CollisionRadius))
		SetXMLAttribute(sprite_node, "collisionleft", Str(Sprites(w) \ CollisionLeft))
		SetXMLAttribute(sprite_node, "collisionright", Str(Sprites(w) \ CollisionRight))
		SetXMLAttribute(sprite_node, "collisiontop", Str(Sprites(w) \ CollisionTop))
		SetXMLAttribute(sprite_node, "collisionbottom", Str(Sprites(w) \ CollisionBottom))
		SetXMLAttribute(sprite_node, "keywords", Sprites(w) \ Keywords)
		SetXMLAttribute(sprite_node, "uid", Str(Sprites(w) \ UID))
		
		; Save frames of this sprites
		For f = 0 To ArraySize(Frames()) - 1
			If Frames(f) \ Sprite = Sprites(w) \ Name
				SaveImage(Frames(f) \ Image, ImgDirName + Sprites(w) \ Name + "_" + Frames(f) \ File + ".png", #PB_ImagePlugin_PNG)
			EndIf
		Next
		
	Next
	
	; ****************************************************
	; Frames
	; ****************************************************
	
	frames_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(frames_node, "frames")
	SetXMLAttribute(frames_node, "count", Str(ArraySize(Frames())))
	
	; Frame details
	For w = 0 To ArraySize(Frames()) - 1
		frame_node = CreateXMLNode(frames_node)
		SetXMLNodeName(frame_node, "frame")
		SetXMLAttribute(frame_node, "file", Frames(w) \ File)
		SetXMLAttribute(frame_node, "sprite", Frames(w) \ Sprite)
	Next
	
	; ****************************************************
	; Sound
	; ****************************************************
	
	sounds_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(sounds_node, "sounds")
	SetXMLAttribute(sounds_node, "count", Str(ArraySize(Sounds())))
	
	; Sound details
	For w = 0 To ArraySize(Sounds()) - 1
		
		sound_node = CreateXMLNode(sounds_node)
		SetXMLNodeName(sound_node, "sound")
		SetXMLAttribute(sound_node, "name", Sounds(w) \ Name)
		SetXMLAttribute(sound_node, "wav", Sounds(w) \ File)
		SetXMLAttribute(sound_node, "mp3", Sounds(w) \ File2)
		SetXMLAttribute(sound_node, "ogg", Sounds(w) \ File3)
		SetXMLAttribute(sound_node, "keywords", Sounds(w) \ Keywords)
		SetXMLAttribute(sound_node, "uid", Str(Sounds(w) \ UID))
		
		CopyFile(TempName + "/" + Sounds(w) \ File, AudDirName + Sounds(w) \ File)
		CopyFile(TempName + "/" + Sounds(w) \ File2, AudDirName + Sounds(w) \ File2)
		CopyFile(TempName + "/" + Sounds(w) \ File3, AudDirName + Sounds(w) \ File3)
		
	Next
	
	; ****************************************************
	; Music
	; ****************************************************
	
	musics_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(musics_node, "musics")
	SetXMLAttribute(musics_node, "count", Str(ArraySize(Musics())))
	
	; Music details
	For w = 0 To ArraySize(Musics()) - 1
		
		music_node = CreateXMLNode(musics_node)
		SetXMLNodeName(music_node, "music")
		SetXMLAttribute(music_node, "name", Musics(w) \ Name)
		SetXMLAttribute(music_node, "wav", Musics(w) \ File)
		SetXMLAttribute(music_node, "mp3", Musics(w) \ File2)
		SetXMLAttribute(music_node, "ogg", Musics(w) \ File3)
		SetXMLAttribute(music_node, "keywords", Musics(w) \ Keywords)
		SetXMLAttribute(music_node, "uid", Str(Musics(w) \ UID))
		
		CopyFile(TempName + "/" + Musics(w) \ File, AudDirName + Musics(w) \ File)
		CopyFile(TempName + "/" + Musics(w) \ File2, AudDirName + Musics(w) \ File2)
		CopyFile(TempName + "/" + Musics(w) \ File3, AudDirName + Musics(w) \ File3)
		
	Next
	
	; ****************************************************
	; Background
	; ****************************************************
	
	backgrounds_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(backgrounds_node, "backgrounds")
	SetXMLAttribute(backgrounds_node, "count", Str(ArraySize(Backgrounds())))
	
	; Background details
	For w = 0 To ArraySize(Backgrounds()) - 1
		
		background_node = CreateXMLNode(backgrounds_node)
		SetXMLNodeName(background_node, "background")
		SetXMLAttribute(background_node, "name", Backgrounds(w) \ Name)
		SetXMLAttribute(background_node, "file", Backgrounds(w) \ File)
		SetXMLAttribute(background_node, "tile", Str(Backgrounds(w) \ Tile))
		SetXMLAttribute(background_node, "tileheight", Str(Backgrounds(w) \ TileHeight))
		SetXMLAttribute(background_node, "tilewidth", Str(Backgrounds(w) \ TileWidth))
		SetXMLAttribute(background_node, "tilexoffset", Str(Backgrounds(w) \ TileXOffset))
		SetXMLAttribute(background_node, "tileyoffset", Str(Backgrounds(w) \ TileYOffset))
		SetXMLAttribute(background_node, "tilexspace", Str(Backgrounds(w) \ TileXSpace))
		SetXMLAttribute(background_node, "tileyspace", Str(Backgrounds(w) \ TileYSpace))
		SetXMLAttribute(background_node, "keywords", Backgrounds(w) \ Keywords)
		SetXMLAttribute(background_node, "uid", Str(Backgrounds(w) \ UID))
		
		CopyFile(TempName + "/" + Backgrounds(w) \ File, ImgDirName + Backgrounds(w) \ File)		
		
	Next
	
	; ****************************************************
	; Font
	; ****************************************************
	
	fonts_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(fonts_node, "fonts")
	SetXMLAttribute(fonts_node, "count", Str(ArraySize(Fonts())))
	
	; Font details
	For w = 0 To ArraySize(Fonts()) - 1
		
		font_node = CreateXMLNode(fonts_node)
		SetXMLNodeName(font_node, "font")
		SetXMLAttribute(font_node, "name", Fonts(w) \ Name)
		SetXMLAttribute(font_node, "family", Fonts(w) \ Family)
		SetXMLAttribute(font_node, "size", Str(Fonts(w) \ Size))
		SetXMLAttribute(font_node, "bold", Str(Fonts(w) \ Bold))
		SetXMLAttribute(font_node, "italic", Str(Fonts(w) \ Italic))
		SetXMLAttribute(font_node, "keywords", Fonts(w) \ Keywords)
		SetXMLAttribute(font_node, "uid", Str(Fonts(w) \ UID))
		
	Next		
	
	; ****************************************************
	; Object
	; ****************************************************
	
	objects_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(objects_node, "objects")
	SetXMLAttribute(objects_node, "count", Str(ArraySize(Objects())))
	
	; Object details
	For w = 0 To ArraySize(Objects()) - 1
		
		object_node = CreateXMLNode(objects_node)
		SetXMLNodeName(object_node, "object")
		SetXMLAttribute(object_node, "name", Objects(w) \ Name)
		SetXMLAttribute(object_node, "template", Objects(w) \ TemplateObject)
		SetXMLAttribute(object_node, "prototype", Str(Objects(w) \ Proto))
		SetXMLAttribute(object_node, "scene", Objects(w) \ Scene)
		SetXMLAttribute(object_node, "sprite", Objects(w) \ Sprite)
		SetXMLAttribute(object_node, "x", Str(Objects(w) \ X))
		SetXMLAttribute(object_node, "y", Str(Objects(w) \ Y))
		SetXMLAttribute(object_node, "visible", Str(Objects(w) \ Visible))
		SetXMLAttribute(object_node, "depth", Str(Objects(w) \ Depth))
		SetXMLAttribute(object_node, "collision", Str(Objects(w) \ Collide))
		SetXMLAttribute(object_node, "parent", Objects(w) \ Parent)
		SetXMLAttribute(object_node, "direction", Str(Objects(w) \ Direction))
		SetXMLAttribute(object_node, "image_angle", Str(Objects(w) \ ImageAngle))
		SetXMLAttribute(object_node, "keywords", Objects(w) \ Keywords)
		SetXMLAttribute(object_node, "uid", Str(Objects(w) \ UID))
	Next		
	
	; ****************************************************
	; Scripts
	; ****************************************************
	
	scripts_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(scripts_node, "scripts")
	SetXMLAttribute(scripts_node, "count", Str(ArraySize(Scripts())))
	
	; Script details
	For w = 0 To ArraySize(Scripts()) - 1
		
		script_node = CreateXMLNode(scripts_node)
		SetXMLNodeName(script_node, "script")
		SetXMLAttribute(script_node, "name", Scripts(w) \ Name)
		SetXMLAttribute(script_node, "object", Scripts(w) \ Parent)
		SetXMLAttribute(script_node, "event", Scripts(w) \ Type)
		SetXMLAttribute(script_node, "parameter", Scripts(w) \ Parameter)
		SetXMLNodeText(script_node, Scripts(w) \ Code)
		
	Next				
	
	; ****************************************************
	; Scene
	; ****************************************************
	
	scenes_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(scenes_node, "scenes")
	SetXMLAttribute(scenes_node, "count", Str(ArraySize(Scenes())))
	
	; Scene details
	For w = 0 To ArraySize(Scenes()) - 1
		
		scene_node = CreateXMLNode(scenes_node)
		SetXMLNodeName(scene_node, "scene")
		SetXMLAttribute(scene_node, "name", Scenes(w) \ Name)
		SetXMLAttribute(scene_node, "width", Str(Scenes(w) \ Width))
		SetXMLAttribute(scene_node, "height", Str(Scenes(w) \ Height))
		SetXMLAttribute(scene_node, "speed", Str(Scenes(w) \ Speed))
		SetXMLAttribute(scene_node, "red", Str(Scenes(w) \ R))
		SetXMLAttribute(scene_node, "green", Str(Scenes(w) \ G))
		SetXMLAttribute(scene_node, "blue", Str(Scenes(w) \ B))
		SetXMLAttribute(scene_node, "background", Scenes(w) \ Background)
		SetXMLAttribute(scene_node, "backgroundstretch", Str(Scenes(w) \ BackgroundStretch))
		SetXMLAttribute(scene_node, "backgroundtilex", Str(Scenes(w) \ BackgroundTileX))
		SetXMLAttribute(scene_node, "backgroundtiley", Str(Scenes(w) \ BackgroundTileY))
		SetXMLAttribute(scene_node, "viewportwidth", Str(Scenes(w) \ ViewportWidth))
		SetXMLAttribute(scene_node, "viewportheight", Str(Scenes(w) \ ViewportHeight))
		SetXMLAttribute(scene_node, "viewportxborder", Str(Scenes(w) \ ViewportXBorder))
		SetXMLAttribute(scene_node, "viewportyborder", Str(Scenes(w) \ ViewportYBorder))
		SetXMLAttribute(scene_node, "viewportobject", Scenes(w) \ ViewportObject)
		SetXMLAttribute(scene_node, "keywords", Scenes(w) \ Keywords)
		SetXMLAttribute(scene_node, "uid", Str(Scenes(w) \ UID))
		SetXMLNodeText(scene_node, Scenes(w) \ Code)
		
	Next
	
	; ****************************************************
	; LAYER
	; ****************************************************
	
	layers_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(layers_node, "layers")
	SetXMLAttribute(layers_node, "count", Str(ArraySize(Layers())))
	
	; Layer details
	For w = 0 To ArraySize(Layers()) - 1
		
		layer_node = CreateXMLNode(layers_node)
		SetXMLNodeName(layer_node, "layer")
		SetXMLAttribute(layer_node, "name", Layers(w) \ Name)
		SetXMLAttribute(layer_node, "scene", Layers(w) \ Scene)
		SetXMLAttribute(layer_node, "value", Str(Layers(w) \ Value))
		
	Next
	
	; ****************************************************
	; TILES
	; ****************************************************
	
	tiles_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(tiles_node, "tiles")
	SetXMLAttribute(tiles_node, "count", Str(ArraySize(Tiles())))
	
	; Tile details
	For w = 0 To ArraySize(Tiles()) - 1
		
		tile_node = CreateXMLNode(tiles_node)
		SetXMLNodeName(tile_node, "tile")
		SetXMLAttribute(tile_node, "name", Tiles(w) \ Name)
		SetXMLAttribute(tile_node, "background", Tiles(w) \ Background)
		SetXMLAttribute(tile_node, "width", Str(Tiles(w) \ Width))
		SetXMLAttribute(tile_node, "height", Str(Tiles(w) \ height))
		SetXMLAttribute(tile_node, "x", Str(Tiles(w) \ X))
		SetXMLAttribute(tile_node, "y", Str(Tiles(w) \ Y))
		SetXMLAttribute(tile_node, "top", Str(Tiles(w) \ Top))
		SetXMLAttribute(tile_node, "left", Str(Tiles(w) \ Left))
		SetXMLAttribute(tile_node, "depth", Str(Tiles(w) \ Depth))
		SetXMLAttribute(tile_node, "scene", Tiles(w) \ Scene)
		
	Next
	
	; ****************************************************
	; Functions
	; ****************************************************
	
	functions_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(functions_node, "fns")
	SetXMLAttribute(functions_node, "count", Str(ArraySize(Functions())))
	
	; Function details
	For w = 0 To ArraySize(Functions()) - 1
		
		function_node = CreateXMLNode(functions_node)
		SetXMLNodeName(function_node, "fn")
		SetXMLAttribute(function_node, "name", Functions(w) \ Name)
		SetXMLAttribute(function_node, "params", Functions(w) \ Params)
		SetXMLAttribute(function_node, "description", Functions(w) \ Description)
		SetXMLAttribute(function_node, "keywords", Functions(w) \ Keywords)
		SetXMLAttribute(function_node, "uid", Str(Functions(w) \ UID))
		SetXMLNodeText(function_node, Functions(w) \ Code)
		
	Next	
	
	; ****************************************************
	; Collision points
	; ****************************************************
	
	points_node = CreateXMLNode(tululoo_node)
	SetXMLNodeName(points_node, "points")
	SetXMLAttribute(points_node, "count", Str(ArraySize(CollisionPoints())))
	
	; Point details
	For w = 0 To ArraySize(CollisionPoints()) - 1
		point_node = CreateXMLNode(points_node)
		SetXMLNodeName(point_node, "point")
		SetXMLAttribute(point_node, "sprite", CollisionPoints(w) \ Sprite)
		SetXMLAttribute(point_node, "x", Str(CollisionPoints(w) \ X))
		SetXMLAttribute(point_node, "y", Str(CollisionPoints(w) \ Y))
	Next	
	
	SaveXML(xml, "Projects/" + ProjectName + ".xml")
	
	; *************************************************************
	; * XML END
	; *************************************************************	
	
	Dirty(0)
	SetCaption()
	
	FreeXML(xml)
	
EndProcedure

; Main window SAVE menu item
Procedure Save()
	
	If ProjectName <> ""
		StoreResources()
		DoSave()
	Else
		GetProjectName()
		If ProjectName <> ""
			StoreResources()
			DoSave()
		EndIf
	EndIf
	
EndProcedure

; Main window SAVEAS menu item
Procedure SaveAs()
	
	GetProjectName()
	If ProjectName <> ""
		StoreResources()
		DoSave()
	EndIf
	
EndProcedure

; Check if object has this type of script
Procedure CodeExists(Object.s, Type.s)
	
	For s = 0 To ArraySize(Scripts()) - 1
		If Scripts(s) \ Parent = Object And Scripts(s) \ Type = Type
			ProcedureReturn 1
		EndIf
	Next
	
	ProcedureReturn 0
	
EndProcedure

; Generate the program version
Procedure.s Create_JS_Version()
	
	v1.s = Mid(Str(Version),1,1)
	v2.s = Mid(Str(Version),2,1)
	v3.s = Mid(Str(Version),3,1)
	VersionText.s = "v" + v1 + "." + v2 + "." + v3
	
	ProcedureReturn VersionText
	
EndProcedure

; Generate extensions
Procedure.s Create_JS_Extensions()
	
	ext.s = ""
	
	For e = 0 To ArraySize(Extensions()) - 1
		If Extensions(e) \ Installed = 1
			ext = ext + "/* " + Extensions(e) \ Name + " by " + Extensions(e) \ Author + " */" + Chr(13) + Chr(10)
			ext = ext + Extensions(e) \ Code
		EndIf
		ext = ext + Chr(13) + Chr(10)
	Next
	
	ProcedureReturn ext
	
EndProcedure

; Generate custom variables
Procedure.s Create_JS_CustomVariables()
	ProcedureReturn Games(0) \ Globals
EndProcedure

; Generate custom functions
Procedure.s Create_JS_CustomFunctions()
	
	code.s = Games(0) \ Functions
	br.s = Chr(13) + Chr(10)
	
	code.s = code.s + br
	
	For e = 0 To ArraySize(Functions()) - 1
		code = code + "function " + Functions(e) \ Name + "(" + Functions(e) \ Params +") { " + br
		code = code + Functions(e) \ Code
		code = code + br + "}" + br
	Next	
	
	ProcedureReturn code
EndProcedure

; Generate sprites classes
Procedure.s Create_JS_Sprites()
	
	code.s = ""
	br.s = Chr(13) + Chr(10)
	
	For e = 0 To ArraySize(Sprites()) - 1
		
		need_comma = 0
		
		; Calculate dimensions
		FrameWidth = 0
		FrameHeight = 0
		
		; Add frames
		For f = 0 To ArraySize(Frames()) - 1
			If Frames(f) \ Sprite = Sprites(e) \ Name
				FrameWidth = ImageWidth(Frames(f) \ Image)
				FrameHeight = ImageHeight(Frames(f) \ Image)
			EndIf
		Next
		
		code = code + "function __" + Sprites(e) \ Name + "() { " + br
		code = code + "__sprite_init__(this, " + Sprites(e) \ Name + ", " + Str(FrameWidth) + ", " + Str(FrameHeight) + ", " + Str(Sprites(e) \ CenterX) + ", " + Str(Sprites(e) \ CenterY) + ", '" + Sprites(e) \ CollisionShape + "', " + Str(Sprites(e) \ CollisionRadius) + ", " + Str(Sprites(e) \ CollisionLeft) + ", " + Str(Sprites(e) \ CollisionRight) + ", " + Str(Sprites(e) \ CollisionTop) + ", " + Str(Sprites(e) \ CollisionBottom) + ", ["
		For f = 0 To ArraySize(Frames()) - 1
			If Frames(f) \ Sprite = Sprites(e) \ Name
				If need_comma = 1
					code = code + ","
				EndIf
				code = code + "'" + ImgFolder + "/" + Frames(f) \ Sprite + "_" + Frames(f) \ File + ".png'"
				need_comma = 1
			EndIf
		Next
		code = code + "]);" + br
		
		code = code + "}; "
		code = code + "var " + Sprites(e) \ Name + " = new __" + Sprites(e) \ Name + "();" + br + br
		
	Next
	
	ProcedureReturn code
	
EndProcedure

; Generate sound classes
Procedure.s Create_JS_Sounds()
	
	code.s = ""
	br.s = Chr(13) + Chr(10)
	
	For e = 0 To ArraySize(Sounds()) - 1
		
		If Sounds(e) \ File <> "" Or Sounds(e) \ File2 <> "" Or Sounds(e) \ File3 <> ""
			code = code + "function __" + Sounds(e) \ Name + "() { " + br
			
			snd_file1.s = ""
			snd_file2.s = ""
			snd_file3.s = ""
			If Sounds(e) \ File <> "" : snd_file1 = AudioFolder + "/" + Sounds(e) \ File : EndIf
			If Sounds(e) \ File2 <> "" : snd_file2 = AudioFolder + "/" + Sounds(e) \ File2 : EndIf
			If Sounds(e) \ File3 <> "" : snd_file3 = AudioFolder + "/" + Sounds(e) \ File3 : EndIf
			
			code = code + "__audio_init__(this, " + Sounds(e) \ Name + ", '" + snd_file1 + "', '" + snd_file2 + "', '" + snd_file3 + "');" + br
			code = code + "}; "
			code = code + "var " + Sounds(e) \ Name + " = new __" + Sounds(e) \ Name + "();" + br + br
		EndIf
		
	Next
	
	ProcedureReturn code
	
EndProcedure

; Generate music classes
Procedure.s Create_JS_Musics()
	
	code.s = ""
	br.s = Chr(13) + Chr(10)
	
	For e = 0 To ArraySize(Musics()) - 1
		
		If Musics(e) \ File <> "" Or Musics(e) \ File2 <> "" Or Musics(e) \ File3 <> ""
			code = code + "function __" + Musics(e) \ Name + "() { " + br
			
			snd_file1.s = ""
			snd_file2.s = ""
			snd_file3.s = ""
			If Musics(e) \ File <> "" : snd_file1 = AudioFolder + "/" + Musics(e) \ File : EndIf
			If Musics(e) \ File2 <> "" : snd_file2 = AudioFolder + "/" + Musics(e) \ File2 : EndIf
			If Musics(e) \ File3 <> "" : snd_file3 = AudioFolder + "/" + Musics(e) \ File3 : EndIf
			
			code = code + "__audio_init__(this, " + Musics(e) \ Name + ", '" + snd_file1 + "', '" + snd_file2 + "', '" + snd_file3 + "');" + br			
			code = code + "}; " 
			code = code + "var " + Musics(e) \ Name + " = new __" + Musics(e) \ Name + "();" + br + br
		EndIf
		
	Next
	
	ProcedureReturn code
	
EndProcedure

; Generate background classes
Procedure.s Create_JS_Backgrounds()
	
	code.s = ""
	br.s = Chr(13) + Chr(10)
	
	For e = 0 To ArraySize(Backgrounds()) - 1
		
		If Backgrounds(e) \ File <> ""
			code = code + "function __" + Backgrounds(e) \ Name + "() { " + br
			code = code + "__background_init__(this, " + Backgrounds(e) \ Name + ", '" + ImgFolder + "/" + Backgrounds(e) \ File + "')"
			code = code + "}; " 
			code = code + "var " + Backgrounds(e) \ Name + " = new __" + Backgrounds(e) \ Name + "();" + br + br
		EndIf
		
	Next
	
	ProcedureReturn code
	
EndProcedure

; Generate fonts
Procedure.s Create_JS_Fonts()
	
	code.s = ""
	br.s = Chr(13) + Chr(10)
	
	For e = 0 To ArraySize(Fonts()) - 1
		code = code + "function __" + Fonts(e) \ Name + "() { " + br
		code = code + "__font_init__(this, " + Fonts(e) \ Name + ", '" + Fonts(e) \ Family + "', " + Str(Fonts(e) \ Size) + ", " + Str(Fonts(e) \ Bold) + ", " + Str(Fonts(e) \ Italic) + ")"
		code = code + "}; " 
		code = code + "var " + Fonts(e) \ Name + " = new __" + Fonts(e) \ Name + "();" + br + br
	Next
	
	ProcedureReturn code
	
EndProcedure

Procedure SwitchObjects(index1, index2)
	Dim TempObject.Object(1)
	TempObject(0) = Objects(Index1)
	Objects(Index1) = Objects(Index2)
	Objects(Index2) = TempObject(0)
EndProcedure

; Generate object classes
Procedure.s Create_JS_Objects()
	
	code.s = ""
	
	br.s = Chr(13) + Chr(10)
	
	ScriptMode = Games(0)\ScriptMode
	
	; *****************************************************************************************
	; Loop on each objects
	; *****************************************************************************************
	
	; REARRANGE OBJECTS CHECK PARENT/CHILD CONNECTIONS
	; BRING PARENT BEFORE CHILD
	For q = 0 To ArraySize(Objects()) - 1
		For e = 0 To ArraySize(Objects()) - 1
			For m = 0 To ArraySize(Objects()) - 1
				If Objects(e) \ Parent = Objects(m) \ Name And Objects(e) \ Proto = 1
					If m > e
						SwitchObjects(e, m)
					EndIf
				EndIf
			Next
		Next
	Next
	
	For e = 0 To ArraySize(Objects()) - 1
		
		If Objects(e) \ Proto = 1
		
			; Create a new JS Object class
			code = code + "function __" + Objects(e) \ Name + "() {" + br
			
			Parent.s = "null"
			If Objects(e) \ Parent <> ""
				Parent = Objects(e) \ Parent
			EndIf
			
			SpriteName.s = "null"
			If Objects(e) \ Sprite <> ""
				SpriteName = Objects(e) \ Sprite
			EndIf
			
			code = code + "__instance_init__(this, " + Objects(e) \ Name + ", " + Parent + ", " + Str(Objects(e) \ Visible) + ", " + Str(Objects(e) \ Depth) + ", " + SpriteName + ", " + Str(Objects(e) \ Collide) + ", " + Str(e) + ");" + br
			
			; *****************************************************************************************
			; Creation event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "Creation");
			
			If HasCode = 1
				code = code + "this.on_creation = function() {" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "Creation"
						code = code + Scripts(s) \ Code + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "};" + br
			Else
				code = code + "this.on_creation = on_creation_i;" + br
			EndIf
			
			; *****************************************************************************************
			; Destroy event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "Destroy");
			If HasCode = 1
				code = code + "this.on_destroy = function() {" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "Destroy"
						code = code + Scripts(s) \ Code + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "};" + br
			Else
				code = code + "this.on_destroy = on_destroy_i;" + br
			EndIf			
			
			; *****************************************************************************************
			; Step event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "Step");
			If HasCode = 1
				code = code + "this.on_step = function() {" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "Step"
						code = code + Scripts(s) \ Code + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "};" + br
			Else
				code = code + "this.on_step = on_step_i;" + br
			EndIf
			
			; *****************************************************************************************
			; End Step event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "End step");
			If HasCode = 1
				code = code + "this.on_end_step = function() {" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "End step"
						code = code + Scripts(s) \ Code + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "};" + br
			Else
				code = code + "this.on_end_step = on_end_step_i;" + br
			EndIf
			
			; *****************************************************************************************
			; Collision event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "Collision");
			If HasCode = 1
				code = code + "this.on_collision = function() {" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "Collision" And Scripts(s) \ Parameter <> ""
						code = code + "this.other = this.place_meeting(this.x, this.y, " + Scripts(s) \ Parameter + ");" + br
						code = code + "if(this.other != null) {" + br
						code = code + Scripts(s) \ Code + br
						code = code + "}" + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "};" + br
			Else
				code = code + "this.on_collision = on_collision_i;" + br
			EndIf
			
			; *****************************************************************************************
			; Room start event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "Room start");
			
			If HasCode = 1
				code = code + "this.on_roomstart = function() {" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "Room start"
						code = code + Scripts(s) \ Code + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "};" + br
			Else
				code = code + "this.on_roomstart = on_roomstart_i;" + br
			EndIf
			
			; *****************************************************************************************
			; Room end event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "Room end");
			
			If HasCode = 1
				code = code + "this.on_roomend = function() {" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "Room end"
						code = code + Scripts(s) \ Code + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "};" + br
			Else
				code = code + "this.on_roomend = on_roomend_i;" + br
			EndIf
			
			; *****************************************************************************************
			; Animation end event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "Animation end");
			If HasCode = 1
				code = code + "this.on_animationend = function() {" + br
				code = code + "if(this.image_index >= this.image_number - 1) {" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "Animation end"
						code = code + Scripts(s) \ Code + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "}" + br
				code = code + "};" + br
			Else
				code = code + "this.on_animationend = on_animationend_i;" + br
			EndIf
			
			; *****************************************************************************************
			; Draw event
			; *****************************************************************************************
			
			HasCode = CodeExists(Objects(e) \ Name, "Draw");
			
			If HasCode = 1
				code = code + "this.on_draw = function() {" + br
				code = code + "if (this.visible == 1) {" + br
				code = code + "__handle_sprite__(this);" + br
				If ScriptMode = 0 : code = code + "with(this) {" + br : EndIf
				For s = 0 To ArraySize(Scripts()) - 1
					If Scripts(s) \ Parent = Objects(e) \ Name And Scripts(s) \ Type = "Draw"
						code = code + Scripts(s) \ Code + br
					EndIf
				Next
				If ScriptMode = 0 : code = code + "}" + br : EndIf
				code = code + "}" + br
				code = code + "};" + br
			Else
				code = code + "this.on_draw = on_draw_i;" + br
			EndIf
			
			; ****************************************************************************************
			
			code = code + "}; " 
			code = code + "var " + Objects(e) \ Name + " = new __" + Objects(e) \ Name + "();" + br + br
			
		EndIf
		
	Next
	
	; SORT BACK THE OBJECTS LIST
	Select ObjectsOrder
		Case "" : SortStructuredArray(Objects(), #PB_Sort_Ascending, OffsetOf(Object\UID), #PB_Integer, 0, ArraySize(Objects()) - 1)
		Case "ASC" : SortStructuredArray(Objects(), #PB_Sort_Ascending, OffsetOf(Object\Name), #PB_String, 0, ArraySize(Objects()) - 1)
		Case "DESC" : SortStructuredArray(Objects(), #PB_Sort_Descending, OffsetOf(Object\Name), #PB_String, 0, ArraySize(Objects()) - 1)
	EndSelect
	RefreshItems()
	
	ProcedureReturn code
	
EndProcedure

; Check if this scene / background / depth has a layer
Procedure HasTile(Scene.s, Background.s, Layer.i)
	For t = 0 To ArraySize(Tiles()) - 1
		If Tiles(t) \ Scene = Scene And Tiles(t)\Background = Background And Tiles(t)\Depth = Layer
			ProcedureReturn 1
		EndIf
	Next
	ProcedureReturn 0
EndProcedure

; Generate scenes
Procedure.s Create_JS_Scenes()
	
	code.s = ""
	br.s = Chr(13) + Chr(10)
	
	For e = 0 To ArraySize(Scenes()) - 1
		
		code = code + "function __" + Scenes(e) \ Name + "() { " + br
		
		; Find tiles
		code = code + "this.tiles = [" + br
		
		; Collecting tiles of this scene
		
		; Backgrounds in this scene
		Dim SceneBGs.s(0)
		
		; Layers in this scene
		Dim SceneLayers.i(0)
		
		; Find unique backgrounds from tiles
		For t = 0 To ArraySize(Tiles()) - 1
			If Tiles(t) \ Scene = Scenes(e) \ Name
				
				; Name already in the array?
				Found = 0
				For b = 0 To ArraySize(SceneBGs()) - 1
					If SceneBGs(b) = Tiles(t) \ Background
						Found = 1
						Break
					EndIf
				Next
				
				; Not exists
				If Found = 0
					Index = ArraySize(SceneBGs())
					ReDim SceneBGs(Index + 1)
					SceneBGs(Index) = Tiles(t) \ Background
				EndIf
				
			EndIf
		Next
		
		; Find unique layers from tiles
		For t = 0 To ArraySize(Tiles()) - 1
			If Tiles(t) \ Scene = Scenes(e) \ Name
				
				; Name already in the array?
				Found = 0
				For l = 0 To ArraySize(SceneLayers()) - 1
					If SceneLayers(l) = Tiles(t) \ Depth
						Found = 1
						Break
					EndIf
				Next
				
				; Not exists
				If Found = 0
					Index = ArraySize(SceneLayers())
					ReDim SceneLayers(Index + 1)
					SceneLayers(Index) = Tiles(t) \ Depth
				EndIf
				
			EndIf
		Next		
		
		; Loop on each background / layer and get tiles
		need_comma_1 = 0
		For l = 0 To ArraySize(SceneLayers()) - 1
			
			If need_comma_1 = 1
				code = code + "," + br
			EndIf
			
			code = code + "[" + Str( SceneLayers(l) ) + "," + br
			need_comma_2 = 0
			For b = 0 To ArraySize(SceneBGs()) - 1
				
				; There are layers in this background/layer
				If HasTile(Scenes(e) \ Name, SceneBGs(b), SceneLayers(l)) = 1
					
					If need_comma_2 = 1
						code = code + "," + br
					EndIf
					
					code = code + "[" + SceneBGs(b) + "," + br
				
					need_comma_3 = 0
					For t = 0 To ArraySize(Tiles()) - 1
						If Tiles(t) \ Scene = Scenes(e) \ Name And Tiles(t) \ Depth = SceneLayers(l) And Tiles(t) \ Background = SceneBGs(b)
							If need_comma_3 = 1
								code = code + "," + br
							EndIf
							code = code + "[" + Str(Tiles(t) \ Left) + "," + Str(Tiles(t) \ Top) + "," + Str(Tiles(t) \ Width) + "," + Str(Tiles(t) \ Height) + "," + Str(Tiles(t) \ X) + "," + Str(Tiles(t) \ Y) + "]"
							need_comma_3 = 1
						EndIf
					Next
				
					code = code + "]"
					need_comma_2 = 1
				EndIf
				
			Next
			code = code + "]"
			need_comma_1 = 1
		Next
		
		code = code + "];" + br
		
		code = code + "this.objects = [" + br
		
		; Collecting object of this scene
		need_object_comma = 0
		For c = 0 To ArraySize(Objects()) - 1
			If Objects(c) \ Scene = Scenes(e) \ Name
				If need_object_comma = 1
					code = code + "," + br
				EndIf
				;code = code + "[" + Objects(c) \ TemplateObject + "," + Str(Objects(c) \ X) + "," + Str(Objects(c) \ Y) + "]"
				code = code + "[{o:" + Objects(c) \ TemplateObject + ", x:" + Str(Objects(c) \ X) + ", y:" + Str(Objects(c) \ Y) 
				If Objects(c) \ Direction <> 0 : code = code + ", d:" + Str(Objects(c) \ Direction) : EndIf
				If Objects(c) \ ImageAngle <> 0 : code = code + ", a:" + Str(Objects(c) \ ImageAngle) : EndIf
				code = code + "}]"
				need_object_comma = 1
			EndIf
		Next
		code = code + "];" + br
		
		; Init
		code = code + "this.start = function() {" + br
		
		BackImage.s = "null"
		If Scenes(e) \ Background <> "" : BackImage = Scenes(e) \ Background + ".image" : EndIf
		
		FollowObj.s = "null"
		If Scenes(e) \ ViewportObject <> "" : FollowObj = Scenes(e) \ ViewportObject : EndIf

		code = code + "__room_start__(this, " + Scenes(e) \ Name + ", " + Str(Scenes(e) \ Width) + ", " + Str(Scenes(e) \ Height) + ", " + Str(Scenes(e) \ Speed) + ", " + Str(Scenes(e) \ R) + ", " + Str(Scenes(e) \ G) + ", " + Str(Scenes(e) \ B) + ", " + BackImage + ", " + Str(Scenes(e) \ BackgroundTileX) + ", " + Str(Scenes(e) \ BackgroundTileY) + ", " + Str(Scenes(e) \ BackgroundStretch) + ", " + Str(Scenes(e) \ ViewportWidth) + ", " + Str(Scenes(e) \ ViewportHeight) + ", " + FollowObj + ", " + Str(Scenes(e) \ ViewportXBorder) + ", " + Str(Scenes(e) \ ViewportYBorder) + ");" + br

		If Scenes(e) \ Code <> "" : code = code + br + Scenes(e) \ Code + br : EndIf
		
		code = code + "};" + br
		code = code + "}" + br
		code = code + "var " + Scenes(e) \ Name + " = new __" + Scenes(e) \ Name + "();" + br
		code = code + "tu_scenes.push(" + Scenes(e) \ Name + ");" + br
		
	Next
	
	If ArraySize(Scenes()) > 0
		code = code + "tu_room_to_go = " + Scenes(0) \ Name + ";"+ br
	EndIf
	
	ProcedureReturn code
	
EndProcedure

; NOT USED
Procedure.s DecodeJSEngine() 
	
	js.s = ""
	
	fp = OpenFile(#PB_Any, "export.js")
	For i = 0 To FileSize("export.js") - 1 : js = js + Chr(ReadByte(fp)) :	Next
	CloseFile(fp)
	
	ProcedureReturn js
	
EndProcedure

; Main window EXPORT menu item
Procedure Export()
	
	GetExtensions()
	
	If ProjectName = ""
		ProcedureReturn 0
	EndIf
	
	ProjectFolder.s = "Projects/" + ProjectName + "/"
	
	br.s = Chr(13) + Chr(10)
	DeleteFile(ProjectFolder + "game.js")
	
	NeedHTML = 0
	If FileSize(ProjectFolder + "index.html") = -1
		NeedHTML = 1
	EndIf
	
	; Create new game html file
	If GenerateIndexHTML = 1 Or NeedHTML = 1
		DeleteFile(ProjectFolder + "index.html")
		fp = OpenFile(#PB_Any, ProjectFolder + "index.html")
		WriteStringN(fp, "<!DOCTYPE html>", #PB_UTF8)
		WriteStringN(fp, "<html lang='en'>", #PB_UTF8)
		WriteStringN(fp, "<head>", #PB_UTF8)
		WriteStringN(fp, "<meta http-equiv='X-UA-Compatible' content='IE=edge' />", #PB_UTF8)
		WriteStringN(fp, "<meta http-equiv='pragma' content='no-cache' />", #PB_UTF8)
		WriteStringN(fp, "<meta name='apple-mobile-web-app-capable' content='yes' />", #PB_UTF8)
		WriteStringN(fp, "<meta name='viewport' content='initial-scale=1.0, maximum-scale=1.0, user-scalable=0, width=device-width, height=device-height' />", #PB_UTF8)
		WriteStringN(fp, "<meta name='apple-mobile-web-app-status-bar-style' content='black-translucent' />", #PB_UTF8)
		WriteStringN(fp, "<meta charset='utf-8' />", #PB_UTF8)
		WriteStringN(fp, "</head>", #PB_UTF8)
		WriteStringN(fp, "<body style='background: black; margin: 0; padding: 0; overflow: hidden;'>", #PB_UTF8)
		WriteStringN(fp, "<div id='tululoogame'></div>", #PB_UTF8)
		WriteStringN(fp, "<a style='text-decoration:none;font-size:11px;font-family:arial;color:rgb(255,255,255);' href='http://www.tululoo.com'>Made with Tululoo Game Maker</a>", #PB_UTF8)
		WriteStringN(fp, "<script type='text/javascript' src='game.js'></script>", #PB_UTF8)
		WriteStringN(fp, "</body>", #PB_UTF8)
		WriteStringN(fp, "</html>", #PB_UTF8)
		CloseFile(fp)
	EndIf
	
	fp = OpenFile(#PB_Any, ProjectFolder + "game.js")
	complex_code.s = DefaultJS
	complex_code = ReplaceString(complex_code, "//TULULOO_VERSION", Create_JS_Version())
	complex_code = ReplaceString(complex_code, "//TULULOO_EXTENSIONS", Create_JS_Extensions())
	complex_code = ReplaceString(complex_code, "//TULULOO_GLOBAL_VARIABLES", Create_JS_CustomVariables())
	complex_code = ReplaceString(complex_code, "//TULULOO_GLOBAL_FUNCTIONS", Create_JS_CustomFunctions())
	complex_code = ReplaceString(complex_code, "//TULULOO_SPRITES", Create_JS_Sprites())
	complex_code = ReplaceString(complex_code, "//TULULOO_SOUNDS", Create_JS_Sounds())
	complex_code = ReplaceString(complex_code, "//TULULOO_MUSICS", Create_JS_Musics())
	complex_code = ReplaceString(complex_code, "//TULULOO_BACKGROUNDS", Create_JS_Backgrounds())
	complex_code = ReplaceString(complex_code, "//TULULOO_FONTS", Create_JS_Fonts())
	complex_code = ReplaceString(complex_code, "//TULULOO_OBJECTS", Create_JS_Objects())
	complex_code = ReplaceString(complex_code, "//TULULOO_SCENES", Create_JS_Scenes())

	WriteString(fp, complex_code, #PB_UTF8)
	CloseFile(fp)
	
	SetGadgetText(#MainWindowInfoText, "PROJECT SAVED.")
	Delay(500)
	SetGadgetText(#MainWindowInfoText, "STATUS: READY.")
	
	If ArraySize(Scenes()) = 0
		MessageRequester("Warning", "There is no scene added.")
	EndIf
	
EndProcedure

; Exit from app when confirmed
Procedure Exit()
	
	_exit.i = 1
	
	If ConfirmExit = 1
		_exit = Confirm("Confirm", "Exit from Tululoo Game Maker?")
	EndIf
	
	If _exit = 1
		
		; Delete temp directory before exit
		If FileSize(TempName) = -2 : DeleteDirectory(TempName, "") : EndIf
		
		; Exit from program
		SavePreferences()
		End
		
	EndIf
	
EndProcedure

; Add a new Virtual item to the system
; Virtual items handle the tab items
Procedure AddItem(Tab.s, Name.s, Gadget.i, Menu.i)
	
	index = ArraySize(Items())
	Items(index) \ Tab = Tab
	Items(index) \ Name = Name
	Items(index) \ Gadget = Gadget
	Items(index) \ Menu = Menu
	
	SetGadgetData(Gadget, index)
	ReDim Items(index + 1)
	
EndProcedure

Procedure CheckComboBoxItemExists(Item.s, ComboBox.i)
	exists = 0
	
	For c = 0 To CountGadgetItems(ComboBox)
		If Item = GetGadgetItemText(ComboBox, c)
			exists = 1
		EndIf
	Next
	
	ProcedureReturn exists
EndProcedure

Procedure RefreshSearchCombos()
	
	; SPRITES SEARCH COMBO
	ClearGadgetItems(#SpriteSearchCombo)
	AddGadgetItem(#SpriteSearchCombo, -1, "")
	For s = 0 To ArraySize(Sprites()) - 1
		If Sprites(s) \ Keywords <> ""
			kw = CountString(Sprites(s) \ Keywords, ",")
			For k = 1 To (kw + 1)
				If CheckComboBoxItemExists(Trim(StringField(Sprites(s) \ Keywords, k, ",")), #SpriteSearchCombo) = 0
					AddGadgetItem(#SpriteSearchCombo, -1, Trim(StringField(Sprites(s) \ Keywords, k, ",")))
				EndIf
			Next
		EndIf
	Next
	SetGadgetText(#SpriteSearchCombo, GetGadgetText(#SpriteSearchField))
	
	; SOUNDS SEARCH COMBO
	ClearGadgetItems(#SoundSearchCombo)
	AddGadgetItem(#SoundSearchCombo, -1, "")
	For s = 0 To ArraySize(Sounds()) - 1
		If Sounds(s) \ Keywords <> ""
			kw = CountString(Sounds(s) \ Keywords, ",")
			For k = 1 To (kw + 1)
				If CheckComboBoxItemExists(Trim(StringField(Sounds(s) \ Keywords, k, ",")), #SoundSearchCombo) = 0
					AddGadgetItem(#SoundSearchCombo, -1, Trim(StringField(Sounds(s) \ Keywords, k, ",")))
				EndIf
			Next
		EndIf
	Next
	SetGadgetText(#SoundSearchCombo, GetGadgetText(#SoundSearchField))
	
	; MUSICS SEARCH COMBO
	ClearGadgetItems(#MusicSearchCombo)
	AddGadgetItem(#MusicSearchCombo, -1, "")
	For s = 0 To ArraySize(Musics()) - 1
		If Musics(s) \ Keywords <> ""
			kw = CountString(Musics(s) \ Keywords, ",")
			For k = 1 To (kw + 1)
				If CheckComboBoxItemExists(Trim(StringField(Musics(s) \ Keywords, k, ",")), #MusicSearchCombo) = 0
					AddGadgetItem(#MusicSearchCombo, -1, Trim(StringField(Musics(s) \ Keywords, k, ",")))
				EndIf
			Next
		EndIf
	Next
	SetGadgetText(#MusicSearchCombo, GetGadgetText(#MusicSearchField))
	
	; FONTS SEARCH COMBO
	ClearGadgetItems(#FontSearchCombo)
	AddGadgetItem(#FontSearchCombo, -1, "")
	For s = 0 To ArraySize(Fonts()) - 1
		If Fonts(s) \ Keywords <> ""
			kw = CountString(Fonts(s) \ Keywords, ",")
			For k = 1 To (kw + 1)
				If CheckComboBoxItemExists(Trim(StringField(Fonts(s) \ Keywords, k, ",")), #FontSearchCombo) = 0
					AddGadgetItem(#FontSearchCombo, -1, Trim(StringField(Fonts(s) \ Keywords, k, ",")))
				EndIf
			Next
		EndIf
	Next
	SetGadgetText(#FontSearchCombo, GetGadgetText(#FontSearchField))
	
	; BACKGROUNDS SEARCH COMBO
	ClearGadgetItems(#BackgroundSearchCombo)
	AddGadgetItem(#BackgroundSearchCombo, -1, "")
	For s = 0 To ArraySize(Backgrounds()) - 1
		If Backgrounds(s) \ Keywords <> ""
			kw = CountString(Backgrounds(s) \ Keywords, ",")
			For k = 1 To (kw + 1)
				If CheckComboBoxItemExists(Trim(StringField(Backgrounds(s) \ Keywords, k, ",")), #BackgroundSearchCombo) = 0
					AddGadgetItem(#BackgroundSearchCombo, -1, Trim(StringField(Backgrounds(s) \ Keywords, k, ",")))
				EndIf
			Next
		EndIf
	Next
	SetGadgetText(#BackgroundSearchCombo, GetGadgetText(#BackgroundSearchField))
	
	; OBJECTS SEARCH COMBO
	ClearGadgetItems(#ObjectSearchCombo)
	AddGadgetItem(#ObjectSearchCombo, -1, "")
	For s = 0 To ArraySize(Objects()) - 1
		If Objects(s) \ Keywords <> ""
			kw = CountString(Objects(s) \ Keywords, ",")
			For k = 1 To (kw + 1)
				If CheckComboBoxItemExists(Trim(StringField(Objects(s) \ Keywords, k, ",")), #ObjectSearchCombo) = 0
					AddGadgetItem(#ObjectSearchCombo, -1, Trim(StringField(Objects(s) \ Keywords, k, ",")))
				EndIf
			Next
		EndIf
	Next
	SetGadgetText(#ObjectSearchCombo, GetGadgetText(#ObjectSearchField))
	
	; SCENES SEARCH COMBO
	ClearGadgetItems(#SceneSearchCombo)
	AddGadgetItem(#SceneSearchCombo, -1, "")
	For s = 0 To ArraySize(Scenes()) - 1
		If Scenes(s) \ Keywords <> ""
			kw = CountString(Scenes(s) \ Keywords, ",")
			For k = 1 To (kw + 1)
				If CheckComboBoxItemExists(Trim(StringField(Scenes(s) \ Keywords, k, ",")), #SceneSearchCombo) = 0
					AddGadgetItem(#SceneSearchCombo, -1, Trim(StringField(Scenes(s) \ Keywords, k, ",")))
				EndIf
			Next
		EndIf
	Next
	SetGadgetText(#SceneSearchCombo, GetGadgetText(#SceneSearchField))
	
	; FUNCTIONS SEARCH COMBO
	ClearGadgetItems(#FunctionSearchCombo)
	AddGadgetItem(#FunctionSearchCombo, -1, "")
	For s = 0 To ArraySize(Functions()) - 1
		If Functions(s) \ Keywords <> ""
			kw = CountString(Functions(s) \ Keywords, ",")
			For k = 1 To (kw + 1)
				If CheckComboBoxItemExists(Trim(StringField(Functions(s) \ Keywords, k, ",")), #FunctionSearchCombo) = 0
					AddGadgetItem(#FunctionSearchCombo, -1, Trim(StringField(Functions(s) \ Keywords, k, ",")))
				EndIf
			Next
		EndIf
	Next
	SetGadgetText(#FunctionSearchCombo, GetGadgetText(#FunctionSearchField))
	
EndProcedure

; Redraws all program items, gadgets
Procedure RefreshItems()
	
	; Temporarily move gadgets out of the screen for faster refresh
	ResizeGadget(#SpriteScroller, -5000, -5000, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#SoundScroller, -5000, -5000, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#MusicScroller, -5000, -5000, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#BackgroundScroller, -5000, -5000, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#FontScroller, -5000, -5000, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#ObjectScroller, -5000, -5000, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#SceneScroller, -5000, -5000, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#FunctionScroller, -5000, -5000, #PB_Ignore, #PB_Ignore)
	
	SetCaption()
	
	; Get the main panel dimensions
	PanelWidth = GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth)
	PanelHeight = GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight)
	
	; Set item dimensions
	BoxWidth = 150
	BoxHeight = 100
	x = 10
	y = 60
	
	; Remove all virtual items from the panels
	For w = 0 To ArraySize(Items()) - 1
		FreeGadget(Items(w) \ Gadget)
	Next
	ReDim Items(0)
	; **************************************************************************************************************
	; Add sprite gadgets
	; **************************************************************************************************************
	; Resize the sprite tab scroller area
	SetGadgetAttribute(#SpriteScroller, #PB_ScrollArea_InnerWidth, PanelWidth)
	
	; Start the tab
	OpenGadgetList(#SpriteScroller)
	If Not IsGadget(#TabHeaderSpritesGadget)
		ImageGadget(#TabHeaderSpritesGadget, 0, 0, 2880, 50, ImageID(#TabHeaderSprites))
		DisableGadget(#TabHeaderSpritesGadget, 1)		
		StringGadget(#SpriteSearchField, 400, 10, 300, 25, Games(0) \ SpriteSearch)
		GadgetToolTip(#SpriteSearchField, "Enter keywords to refine results.")
		SetGadgetFont(#SpriteSearchField, FontID(#ItemFont))
		ComboBoxGadget(#SpriteSearchCombo, 710, 10, 100, 25)
		GadgetToolTip(#SpriteSearchCombo, "Select a keyword to refine results.")
		ButtonImageGadget(#SpriteSortReset, 850, 10, 25, 25, ImageID(#SortResetImage))
		ButtonImageGadget(#SpriteSortAsc, 880, 10, 25, 25, ImageID(#SortAscImage))
		ButtonImageGadget(#SpriteSortDesc, 910, 10, 25, 25, ImageID(#SortDescImage))
		GadgetToolTip(#SpriteSortReset, "Reset order")
		GadgetToolTip(#SpriteSortAsc, "Sort by names in ascending order")
		GadgetToolTip(#SpriteSortDesc, "Sort by names in descending order")
	EndIf
	
	; DETERMINE SPRITE SEARCH KEYWORDS
	Dim SpriteKeywords.s(0)
	Dim SpriteSearchKeywords.s(0)
	kw = CountString(GetGadgetText(#SpriteSearchField), ",")
	For k = 1 To (kw + 1)
		index = ArraySize(SpriteSearchKeywords())
		SpriteSearchKeywords(index) = UCase(Trim(StringField(GetGadgetText(#SpriteSearchField), k, ",")))
		ReDim SpriteSearchKeywords(index + 1)
	Next
	
	scrollercolor = RGB(200, 200, 200)
	If GetGadgetText(#SpriteSearchField) <> ""
		scrollercolor = RGB(170,170,200)
	EndIf
	SetGadgetColor(#SpriteScroller, #PB_Gadget_BackColor, scrollercolor)
	
	NewHeight = 10
	col = 0
	row = 0
	For w = 0 To ArraySize(Sprites()) - 1
		
		; DETERMINE CURRENT SPRITE KEYWORDS
		ReDim SpriteKeywords.s(0)
		kw = CountString(Sprites(w) \ Keywords, ",")
		For k = 1 To (kw + 1)
			index = ArraySize(SpriteKeywords())
			SpriteKeywords(index) = UCase(Trim(StringField(Sprites(w) \ Keywords, k, ",")))
			ReDim SpriteKeywords(index + 1)
		Next
		
		visible = 1
		
		; CHECK IF SPRITE KEYWORDS FITS IN SEARCH KEYWORDS
		If GetGadgetText(#SpriteSearchField) <> ""
			visible = 0
			For gk = 0 To ArraySize(SpriteSearchKeywords()) - 1
				For sk = 0 To ArraySize(SpriteKeywords()) - 1
					If FindString(SpriteKeywords(sk), SpriteSearchKeywords(gk))
						visible = 1
					EndIf
				Next
			Next
		EndIf
		
		If visible
		
			; Find the box preview image(start as missing sprite)
			Image = ImageID(#BoxInvalid)
			If IsImage(Sprites(w) \ Preview) : Image = ImageID(Sprites(w) \ Preview) : EndIf
			
			; Place the actual sprite box
			AddItem("Sprites", Sprites(w) \ Name, ImageGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, Image), #PopupMenuSpriteItem)
			
			; Place the name
			Name = TextGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30) + BoxHeight + 5, BoxWidth, 20, Sprites(w) \ Name, #PB_Text_Center)
			AddItem("Sprites", "", Name, -1)
			
			; Set name properties(font, color)
			SetGadgetFont(Name, FontID(#ItemFont))
			SetGadgetColor(Name, #PB_Gadget_BackColor, scrollercolor)
			
			; Do a next row when reach the tab border
			col = col + 1
			If col *(BoxWidth + 10) >(PanelWidth - BoxWidth - 10)
				col = 0
				row = row + 1
				NewHeight = NewHeight + BoxHeight + 30 + 50
			EndIf
		
		EndIf
		
	Next
	
	; Place the NEW button at the end of the list
	ImageGadget(#NewSpriteButton, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxNew))
	AddItem("Sprites", "", #NewSpriteButton, -1)
	
	; The new height is calculated based on the number of item heights
	NewHeight = NewHeight + BoxHeight + 30 + 50
	
	; Close the tab
	CloseGadgetList()
	
	; Set the sprite scroller height
	SetGadgetAttribute(#SpriteScroller, #PB_ScrollArea_InnerHeight, NewHeight)
	
	; **************************************************************************************************************
	; Add sound gadgets
	; **************************************************************************************************************
	; Resize the sound scroller area based on the tab width
	SetGadgetAttribute(#SoundScroller, #PB_ScrollArea_InnerWidth, PanelWidth)
	
	; Start the tab
	OpenGadgetList(#SoundScroller)
	If Not IsGadget(#TabHeaderSoundsGadget)
		ImageGadget(#TabHeaderSoundsGadget, 0, 0, 2880, 50, ImageID(#TabHeaderSounds))
		DisableGadget(#TabHeaderSoundsGadget, 1)
		StringGadget(#SoundSearchField, 400, 10, 300, 25, Games(0) \ SoundSearch)
		GadgetToolTip(#SoundSearchField, "Enter keywords to refine results.")
		SetGadgetFont(#SoundSearchField, FontID(#ItemFont))
		ComboBoxGadget(#SoundSearchCombo, 710, 10, 100, 25)
		GadgetToolTip(#SoundSearchCombo, "Select a keyword to refine results.")
		ButtonImageGadget(#SoundSortReset, 850, 10, 25, 25, ImageID(#SortResetImage))
		ButtonImageGadget(#SoundSortAsc, 880, 10, 25, 25, ImageID(#SortAscImage))
		ButtonImageGadget(#SoundSortDesc, 910, 10, 25, 25, ImageID(#SortDescImage))
		GadgetToolTip(#SoundSortReset, "Reset order")
		GadgetToolTip(#SoundSortAsc, "Sort by names in ascending order")
		GadgetToolTip(#SoundSortDesc, "Sort by names in descending order")
	EndIf
	
	; DETERMINE SOUND SEARCH KEYWORDS
	Dim SoundKeywords.s(0)
	Dim SoundSearchKeywords.s(0)
	kw = CountString(GetGadgetText(#SoundSearchField), ",")
	For k = 1 To (kw + 1)
		index = ArraySize(SoundSearchKeywords())
		SoundSearchKeywords(index) = UCase(Trim(StringField(GetGadgetText(#SoundSearchField), k, ",")))
		ReDim SoundSearchKeywords(index + 1)
	Next
	
	scrollercolor = RGB(200, 200, 200)
	If GetGadgetText(#SoundSearchField) <> ""
		scrollercolor = RGB(170,170,200)
	EndIf
	SetGadgetColor(#SoundScroller, #PB_Gadget_BackColor, scrollercolor)
	
	NewHeight = 10
	col = 0
	row = 0
	
	For w = 0 To ArraySize(Sounds()) - 1
		
		; DETERMINE CURRENT SOUND KEYWORDS
		ReDim SoundKeywords.s(0)
		kw = CountString(Sounds(w) \ Keywords, ",")
		For k = 1 To (kw + 1)
			index = ArraySize(SoundKeywords())
			SoundKeywords(index) = UCase(Trim(StringField(Sounds(w) \ Keywords, k, ",")))
			ReDim SoundKeywords(index + 1)
		Next		
		
		visible = 1
		
		; CHECK IF SOUND KEYWORDS FITS IN SEARCH KEYWORDS
		If GetGadgetText(#SoundSearchField) <> ""
			visible = 0
			For gk = 0 To ArraySize(SoundSearchKeywords()) - 1
				For sk = 0 To ArraySize(SoundKeywords()) - 1
					If FindString(SoundKeywords(sk), SoundSearchKeywords(gk))
						visible = 1
					EndIf
				Next
			Next
		EndIf
		
		If visible
		
			; Place the actual sound box
			AddItem("Sounds", Sounds(w) \ Name, ImageGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxSound)), #PopupMenuSoundItem)
			
			; Place the name of the sound
			Name = TextGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30) + BoxHeight + 5, BoxWidth, 20, Sounds(w) \ Name, #PB_Text_Center)
			AddItem("Sounds", "", Name, -1)
			
			; Set the name properties(color, font)
			SetGadgetFont(Name, FontID(#ItemFont))
			SetGadgetColor(Name, #PB_Gadget_BackColor, scrollercolor)
			
			; Do a next row when reach the border of the panel
			col = col + 1
			If col *(BoxWidth + 10) >(PanelWidth - BoxWidth - 10)
				col = 0
				row = row + 1
				NewHeight = NewHeight + BoxHeight + 30 + 50
			EndIf
			
		EndIf
		
	Next
	
	; Place a NEW item button
	ImageGadget(#NewSoundButton, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxNew))
	AddItem("Sounds", "", #NewSoundButton, -1)
	
	; Calculate the new panel height
	NewHeight = NewHeight + BoxHeight + 30 + 50
	
	; Close the tab
	CloseGadgetList()
	
	; Set the new scroller height based on the number of sound boxes
	SetGadgetAttribute(#SoundScroller, #PB_ScrollArea_InnerHeight, NewHeight)	
	; **************************************************************************************************************
	; Add music gadgets
	; **************************************************************************************************************
	; Set the music scroller area width
	SetGadgetAttribute(#MusicScroller, #PB_ScrollArea_InnerWidth, PanelWidth)
	
	; Start the music tab
	OpenGadgetList(#MusicScroller)
	If Not IsGadget(#TabHeaderMusicsGadget)
		ImageGadget(#TabHeaderMusicsGadget, 0, 0, 2880, 50, ImageID(#TabHeaderMusics))
		DisableGadget(#TabHeaderMusicsGadget, 1)		
		StringGadget(#MusicSearchField, 400, 10, 300, 25, Games(0) \ MusicSearch)
		GadgetToolTip(#MusicSearchField, "Enter keywords to refine results.")
		SetGadgetFont(#MusicSearchField, FontID(#ItemFont))
		ComboBoxGadget(#MusicSearchCombo, 710, 10, 100, 25)
		GadgetToolTip(#MusicSearchCombo, "Select a keyword to refine results.")
		ButtonImageGadget(#MusicSortReset, 850, 10, 25, 25, ImageID(#SortResetImage))
		ButtonImageGadget(#MusicSortAsc, 880, 10, 25, 25, ImageID(#SortAscImage))
		ButtonImageGadget(#MusicSortDesc, 910, 10, 25, 25, ImageID(#SortDescImage))
		GadgetToolTip(#MusicSortReset, "Reset order")
		GadgetToolTip(#MusicSortAsc, "Sort by names in ascending order")
		GadgetToolTip(#MusicSortDesc, "Sort by names in descending order")
	EndIf
	
	; DETERMINE MUSIC SEARCH KEYWORDS
	Dim MusicKeywords.s(0)
	Dim MusicSearchKeywords.s(0)
	kw = CountString(GetGadgetText(#MusicSearchField), ",")
	For k = 1 To (kw + 1)
		index = ArraySize(MusicSearchKeywords())
		MusicSearchKeywords(index) = UCase(Trim(StringField(GetGadgetText(#MusicSearchField), k, ",")))
		ReDim MusicSearchKeywords(index + 1)
	Next
	
	scrollercolor = RGB(200, 200, 200)
	If GetGadgetText(#MusicSearchField) <> ""
		scrollercolor = RGB(170,170,200)
	EndIf
	SetGadgetColor(#MusicScroller, #PB_Gadget_BackColor, scrollercolor)	
	
	NewHeight = 10
	col = 0
	row = 0
	For w = 0 To ArraySize(Musics()) - 1
		
		; DETERMINE CURRENT MUSIC KEYWORDS
		ReDim MusicKeywords.s(0)
		kw = CountString(Musics(w) \ Keywords, ",")
		For k = 1 To (kw + 1)
			index = ArraySize(MusicKeywords())
			MusicKeywords(index) = UCase(Trim(StringField(Musics(w) \ Keywords, k, ",")))
			ReDim MusicKeywords(index + 1)
		Next
		
		visible = 1
		
		; CHECK IF MUSIC KEYWORDS FITS IN SEARCH KEYWORDS
		If GetGadgetText(#MusicSearchField) <> ""
			visible = 0
			For gk = 0 To ArraySize(MusicSearchKeywords()) - 1
				For sk = 0 To ArraySize(MusicKeywords()) - 1
					If FindString(MusicKeywords(sk), MusicSearchKeywords(gk))
						visible = 1
					EndIf
				Next
			Next
		EndIf
		
		If visible
		
			; Place the actual music box
			AddItem("Musics", Musics(w) \ Name, ImageGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxMusic)), #PopupMenuMusicItem)
			
			; Place the name of the box
			Name = TextGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30) + BoxHeight + 5, BoxWidth, 20, Musics(w) \ Name, #PB_Text_Center)
			AddItem("Musics", "", Name, -1)
			
			; Set the name properties(color, font)
			SetGadgetFont(Name, FontID(#ItemFont))
			SetGadgetColor(Name, #PB_Gadget_BackColor, scrollercolor)
			
			; Do a next row when reach the border of the panel
			col = col + 1
			If col *(BoxWidth + 10) >(PanelWidth - BoxWidth - 10)
				col = 0
				row = row + 1
				NewHeight = NewHeight + BoxHeight + 30 + 50
			EndIf
		
		EndIf
		
	Next
	
	; Place the new music button
	ImageGadget(#NewMusicButton, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxNew))
	AddItem("Musics", "", #NewMusicButton, -1)
	
	; Calculate the new panel height
	NewHeight = NewHeight + BoxHeight + 30 + 50
	
	; Close the music tab
	CloseGadgetList()
	
	; Set the new music scroller height 
	SetGadgetAttribute(#MusicScroller, #PB_ScrollArea_InnerHeight, NewHeight)
	; **************************************************************************************************************
	; Add background gadgets
	; **************************************************************************************************************
	; Set the width of the background scroll area
	SetGadgetAttribute(#BackgroundScroller, #PB_ScrollArea_InnerWidth, PanelWidth)
	
	; Start the tab
	OpenGadgetList(#BackgroundScroller)
	If Not IsGadget(#TabHeaderBackgroundsGadget)
		ImageGadget(#TabHeaderBackgroundsGadget, 0, 0, 2880, 50, ImageID(#TabHeaderBackgrounds))
		DisableGadget(#TabHeaderBackgroundsGadget, 1)		
		StringGadget(#BackgroundSearchField, 400, 10, 300, 25, Games(0) \ BackgroundSearch)
		GadgetToolTip(#BackgroundSearchField, "Enter keywords to refine results.")
		SetGadgetFont(#BackgroundSearchField, FontID(#ItemFont))
		ComboBoxGadget(#BackgroundSearchCombo, 710, 10, 100, 25)
		GadgetToolTip(#BackgroundSearchCombo, "Select a keyword to refine results.")
		ButtonImageGadget(#BackgroundSortReset, 850, 10, 25, 25, ImageID(#SortResetImage))
		ButtonImageGadget(#BackgroundSortAsc, 880, 10, 25, 25, ImageID(#SortAscImage))
		ButtonImageGadget(#BackgroundSortDesc, 910, 10, 25, 25, ImageID(#SortDescImage))
		GadgetToolTip(#BackgroundSortReset, "Reset order")
		GadgetToolTip(#BackgroundSortAsc, "Sort by names in ascending order")
		GadgetToolTip(#BackgroundSortDesc, "Sort by names in descending order")
	EndIf
	
	; DETERMINE BACKGROUND SEARCH KEYWORDS
	Dim BackgroundKeywords.s(0)
	Dim BackgroundSearchKeywords.s(0)
	kw = CountString(GetGadgetText(#BackgroundSearchField), ",")
	For k = 1 To (kw + 1)
		index = ArraySize(BackgroundSearchKeywords())
		BackgroundSearchKeywords(index) = UCase(Trim(StringField(GetGadgetText(#BackgroundSearchField), k, ",")))
		ReDim BackgroundSearchKeywords(index + 1)
	Next
	
	scrollercolor = RGB(200, 200, 200)
	If GetGadgetText(#BackgroundSearchField) <> ""
		scrollercolor = RGB(170,170,200)
	EndIf
	SetGadgetColor(#BackgroundScroller, #PB_Gadget_BackColor, scrollercolor)	
	
	NewHeight = 10
	col = 0
	row = 0
	
	For w = 0 To ArraySize(Backgrounds()) - 1
		
		; DETERMINE CURRENT BACKGROUND KEYWORDS
		ReDim BackgroundKeywords.s(0)
		kw = CountString(Backgrounds(w) \ Keywords, ",")
		For k = 1 To (kw + 1)
			index = ArraySize(BackgroundKeywords())
			BackgroundKeywords(index) = UCase(Trim(StringField(Backgrounds(w) \ Keywords, k, ",")))
			ReDim BackgroundKeywords(index + 1)
		Next
		
		visible = 1
		
		; CHECK IF BACKGROUND KEYWORDS FITS IN SEARCH KEYWORDS
		If GetGadgetText(#BackgroundSearchField) <> ""
			visible = 0
			For gk = 0 To ArraySize(BackgroundSearchKeywords()) - 1
				For sk = 0 To ArraySize(BackgroundKeywords()) - 1
					If FindString(BackgroundKeywords(sk), BackgroundSearchKeywords(gk))
						visible = 1
					EndIf
				Next
			Next
		EndIf
		
		If visible
		
			; Find the preview image of the background(start as missing)
			Image = ImageID(#BoxInvalid)
			If Backgrounds(w) \ Preview > -1 : Image = ImageID(Backgrounds(w) \ Preview) : EndIf
			
			; Place the actual background button
			AddItem("Backgrounds", Backgrounds(w) \ Name, ImageGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, Image), #PopupMenuBackgroundItem)
			
			; Place the name of the background
			Name = TextGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30) + BoxHeight + 5, BoxWidth, 20, Backgrounds(w) \ Name, #PB_Text_Center)
			AddItem("Backgrounds", "", Name, -1)
			
			; Set the name properties
			SetGadgetFont(Name, FontID(#ItemFont))
			SetGadgetColor(Name, #PB_Gadget_BackColor, scrollercolor)
			
			; Do a next row when reach the border of the panel
			col = col + 1
			If col * (BoxWidth + 10) > (PanelWidth - BoxWidth - 10)
				col = 0
				row = row + 1
				NewHeight = NewHeight + BoxHeight + 30 + 50
			EndIf
			
		EndIf
		
	Next
	
	; Place the new background button
	ImageGadget(#NewBackgroundButton, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxNew))
	AddItem("Backgrounds", "", #NewBackgroundButton, -1)
	
	; Calculate the new panel height based on the items height
	NewHeight = NewHeight + BoxHeight + 30 + 50
	
	; Close the tab
	CloseGadgetList()
	
	; Set the new scroller height
	SetGadgetAttribute(#BackgroundScroller, #PB_ScrollArea_InnerHeight, NewHeight)	
	; **************************************************************************************************************
	; Add font gadgets
	; **************************************************************************************************************
	; Set the width of the font scroller area
	SetGadgetAttribute(#FontScroller, #PB_ScrollArea_InnerWidth, PanelWidth)
	
	; Start the font tab
	OpenGadgetList(#FontScroller)
	If Not IsGadget(#TabHeaderFontsGadget)
		ImageGadget(#TabHeaderFontsGadget, 0, 0, 2880, 50, ImageID(#TabHeaderFonts))
		DisableGadget(#TabHeaderFontsGadget, 1)		
		StringGadget(#FontSearchField, 400, 10, 300, 25, Games(0) \ FontSearch)
		GadgetToolTip(#FontSearchField, "Enter keywords to refine results.")
		SetGadgetFont(#FontSearchField, FontID(#ItemFont))
		ComboBoxGadget(#FontSearchCombo, 710, 10, 100, 25)
		GadgetToolTip(#FontSearchCombo, "Select a keyword to refine results.")
		ButtonImageGadget(#FontSortReset, 850, 10, 25, 25, ImageID(#SortResetImage))
		ButtonImageGadget(#FontSortAsc, 880, 10, 25, 25, ImageID(#SortAscImage))
		ButtonImageGadget(#FontSortDesc, 910, 10, 25, 25, ImageID(#SortDescImage))
		GadgetToolTip(#FontSortReset, "Reset order")
		GadgetToolTip(#FontSortAsc, "Sort by names in ascending order")
		GadgetToolTip(#FontSortDesc, "Sort by names in descending order")
	EndIf
	
	; DETERMINE FONT SEARCH KEYWORDS
	Dim FontKeywords.s(0)
	Dim FontSearchKeywords.s(0)
	kw = CountString(GetGadgetText(#FontSearchField), ",")
	For k = 1 To (kw + 1)
		index = ArraySize(FontSearchKeywords())
		FontSearchKeywords(index) = UCase(Trim(StringField(GetGadgetText(#FontSearchField), k, ",")))
		ReDim FontSearchKeywords(index + 1)
	Next
	
	scrollercolor = RGB(200, 200, 200)
	If GetGadgetText(#FontSearchField) <> ""
		scrollercolor = RGB(170,170,200)
	EndIf
	SetGadgetColor(#FontScroller, #PB_Gadget_BackColor, scrollercolor)	
	
	NewHeight = 10
	col = 0
	row = 0
	For w = 0 To ArraySize(Fonts()) - 1
		
		; DETERMINE CURRENT FONT KEYWORDS
		ReDim FontKeywords.s(0)
		kw = CountString(Fonts(w) \ Keywords, ",")
		For k = 1 To (kw + 1)
			index = ArraySize(FontKeywords())
			FontKeywords(index) = UCase(Trim(StringField(Fonts(w) \ Keywords, k, ",")))
			ReDim FontKeywords(index + 1)
		Next
		
		visible = 1
		
		; CHECK IF FONT KEYWORDS FITS IN SEARCH KEYWORDS
		If GetGadgetText(#FontSearchField) <> ""
			visible = 0
			For gk = 0 To ArraySize(FontSearchKeywords()) - 1
				For sk = 0 To ArraySize(FontKeywords()) - 1
					If FindString(FontKeywords(sk), FontSearchKeywords(gk))
						visible = 1
					EndIf
				Next
			Next
		EndIf
		
		If visible
		
			; Place the actual font box
			AddItem("Fonts", Fonts(w) \ Name, ImageGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxFont)), #PopupMenuFontItem)
			
			; Place the name of the font
			Name = TextGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30) + BoxHeight + 5, BoxWidth, 20, Fonts(w) \ Name, #PB_Text_Center)
			AddItem("Fonts", "", Name, -1)
			
			; Set the name properties(color, font)
			SetGadgetFont(Name, FontID(#ItemFont))
			SetGadgetColor(Name, #PB_Gadget_BackColor, scrollercolor)
			
			; Do a next row when reach the border of the panel
			col = col + 1
			If col *(BoxWidth + 10) >(PanelWidth - BoxWidth - 10)
				col = 0
				row = row + 1
				NewHeight = NewHeight + BoxHeight + 30 + 50
			EndIf
		
		EndIf
		
	Next
	
	; Place the new font button
	ImageGadget(#NewFontButton, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxNew))
	AddItem("Fonts", "", #NewFontButton, -1)
	
	; Calculate the new height
	NewHeight = NewHeight + BoxHeight + 30 + 50
	
	; Close the font tab
	CloseGadgetList()
	
	; Set the new font scroller height
	SetGadgetAttribute(#FontScroller, #PB_ScrollArea_InnerHeight, NewHeight)		
	; **************************************************************************************************************
	; Add object gadgets
	; **************************************************************************************************************
	; Set the width of the object scroller area
	SetGadgetAttribute(#ObjectScroller, #PB_ScrollArea_InnerWidth, PanelWidth)
	
	; Start the object tab
	OpenGadgetList(#ObjectScroller)
	If Not IsGadget(#TabHeaderObjectsGadget)
		ImageGadget(#TabHeaderObjectsGadget, 0, 0, 2880, 50, ImageID(#TabHeaderObjects))
		DisableGadget(#TabHeaderObjectsGadget, 1)		
		StringGadget(#ObjectSearchField, 400, 10, 300, 25, Games(0) \ ObjectSearch)
		GadgetToolTip(#ObjectSearchField, "Enter keywords to refine results.")
		SetGadgetFont(#ObjectSearchField, FontID(#ItemFont))
		ComboBoxGadget(#ObjectSearchCombo, 710, 10, 100, 25)
		GadgetToolTip(#ObjectSearchCombo, "Select a keyword to refine results.")
		ButtonImageGadget(#ObjectSortReset, 850, 10, 25, 25, ImageID(#SortResetImage))
		ButtonImageGadget(#ObjectSortAsc, 880, 10, 25, 25, ImageID(#SortAscImage))
		ButtonImageGadget(#ObjectSortDesc, 910, 10, 25, 25, ImageID(#SortDescImage))
		GadgetToolTip(#ObjectSortReset, "Reset order")
		GadgetToolTip(#ObjectSortAsc, "Sort by names in ascending order")
		GadgetToolTip(#ObjectSortDesc, "Sort by names in descending order")
	EndIf
	
	; DETERMINE OBJECT SEARCH KEYWORDS
	Dim ObjectKeywords.s(0)
	Dim ObjectSearchKeywords.s(0)
	kw = CountString(GetGadgetText(#ObjectSearchField), ",")
	For k = 1 To (kw + 1)
		index = ArraySize(ObjectSearchKeywords())
		ObjectSearchKeywords(index) = UCase(Trim(StringField(GetGadgetText(#ObjectSearchField), k, ",")))
		ReDim ObjectSearchKeywords(index + 1)
	Next
	
	scrollercolor = RGB(200, 200, 200)
	If GetGadgetText(#ObjectSearchField) <> ""
		scrollercolor = RGB(170,170,200)
	EndIf
	SetGadgetColor(#ObjectScroller, #PB_Gadget_BackColor, scrollercolor)	
	
	NewHeight = 10
	col = 0
	row = 0
	For w = 0 To ArraySize(Objects()) - 1
		
		; Detect if the object is a prototype object
		If Objects(w) \ Proto = 1
			
			; DETERMINE CURRENT OBJECT KEYWORDS
			ReDim ObjectKeywords.s(0)
			kw = CountString(Objects(w) \ Keywords, ",")
			For k = 1 To (kw + 1)
				index = ArraySize(ObjectKeywords())
				ObjectKeywords(index) = UCase(Trim(StringField(Objects(w) \ Keywords, k, ",")))
				ReDim ObjectKeywords(index + 1)
			Next
			
			visible = 1
			
			; CHECK IF OBJECT KEYWORDS FITS IN SEARCH KEYWORDS
			If GetGadgetText(#ObjectSearchField) <> ""
				visible = 0
				For gk = 0 To ArraySize(ObjectSearchKeywords()) - 1
					For sk = 0 To ArraySize(ObjectKeywords()) - 1
						If FindString(ObjectKeywords(sk), ObjectSearchKeywords(gk))
							visible = 1
						EndIf
					Next
				Next
			EndIf
			
			If visible
			
				; Get the box image of the object(same as the sprite box image)
				Image = ImageID(#BoxInvalid)
				If Objects(w) \ Sprite <> ""
					
					; Find the sprite of this object
					For m = 0 To ArraySize(Sprites()) - 1
						If Sprites(m) \ Name = Objects(w) \ Sprite And Sprites(m) \ Preview > -1
							Image = ImageID(Sprites(m) \ Preview)
							Break
						EndIf
					Next
				EndIf
				
				; Place the object box button
				AddItem("Objects", Objects(w) \ Name, ImageGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, Image), #PopupMenuObjectItem)
				
				; Place the name of the object
				Name = TextGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30) + BoxHeight + 5, BoxWidth, 20, Objects(w) \ Name, #PB_Text_Center)
				AddItem("Objects", "", Name, -1)
				
				; Set the name properties(color, font)
				SetGadgetFont(Name, FontID(#ItemFont))
				SetGadgetColor(Name, #PB_Gadget_BackColor, scrollercolor)
				
				; Do a next row when reach the border of the panel
				col = col + 1
				If col *(BoxWidth + 10) >(PanelWidth - BoxWidth - 10)
					col = 0
					row = row + 1
					NewHeight = NewHeight + BoxHeight + 30 + 50
				EndIf
				
			EndIf
			
		EndIf
		
	Next
	
	; Place the new object button
	ImageGadget(#NewObjectButton, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxNew))
	AddItem("Objects", "", #NewObjectButton, -1)
	
	; Calculate the new scroller height
	NewHeight = NewHeight + BoxHeight + 30 + 50
	
	; Close the object tab
	CloseGadgetList()
	
	; Set the new scroller height
	SetGadgetAttribute(#ObjectScroller, #PB_ScrollArea_InnerHeight, NewHeight)
	; **************************************************************************************************************
	; Add scene gadgets
	; **************************************************************************************************************
	; Set the width of the scene scroller area
	SetGadgetAttribute(#SceneScroller, #PB_ScrollArea_InnerWidth, PanelWidth)
	
	; Start the scene tab
	OpenGadgetList(#SceneScroller)
	If Not IsGadget(#TabHeaderScenesGadget)
		ImageGadget(#TabHeaderScenesGadget, 0, 0, 2880, 50, ImageID(#TabHeaderScenes))
		DisableGadget(#TabHeaderScenesGadget, 1)		
		StringGadget(#SceneSearchField, 400, 10, 300, 25, Games(0) \ SceneSearch)
		GadgetToolTip(#SceneSearchField, "Enter keywords to refine results.")
		SetGadgetFont(#SceneSearchField, FontID(#ItemFont))
		ComboBoxGadget(#SceneSearchCombo, 710, 10, 100, 25)
		GadgetToolTip(#SceneSearchCombo, "Select a keyword to refine results.")
		ButtonImageGadget(#SceneSortReset, 850, 10, 25, 25, ImageID(#SortResetImage))
		ButtonImageGadget(#SceneSortAsc, 880, 10, 25, 25, ImageID(#SortAscImage))
		ButtonImageGadget(#SceneSortDesc, 910, 10, 25, 25, ImageID(#SortDescImage))
		GadgetToolTip(#SceneSortReset, "Reset order")
		GadgetToolTip(#SceneSortAsc, "Sort by names in ascending order")
		GadgetToolTip(#SceneSortDesc, "Sort by names in descending order")
	EndIf
	
	; DETERMINE SCENE SEARCH KEYWORDS
	Dim SceneKeywords.s(0)
	Dim SceneSearchKeywords.s(0)
	kw = CountString(GetGadgetText(#SceneSearchField), ",")
	For k = 1 To (kw + 1)
		index = ArraySize(SceneSearchKeywords())
		SceneSearchKeywords(index) = UCase(Trim(StringField(GetGadgetText(#SceneSearchField), k, ",")))
		ReDim SceneSearchKeywords(index + 1)
	Next
	
	scrollercolor = RGB(200, 200, 200)
	If GetGadgetText(#SceneSearchField) <> ""
		scrollercolor = RGB(170,170,200)
	EndIf
	SetGadgetColor(#SceneScroller, #PB_Gadget_BackColor, scrollercolor)	
	
	NewHeight = 10
	col = 0
	row = 0
	For w = 0 To ArraySize(Scenes()) - 1
		
		; DETERMINE CURRENT SCENE KEYWORDS
		ReDim SceneKeywords.s(0)
		kw = CountString(Scenes(w) \ Keywords, ",")
		For k = 1 To (kw + 1)
			index = ArraySize(SceneKeywords())
			SceneKeywords(index) = UCase(Trim(StringField(Scenes(w) \ Keywords, k, ",")))
			ReDim SceneKeywords(index + 1)
		Next
		
		visible = 1
		
		; CHECK IF SCENE KEYWORDS FITS IN SEARCH KEYWORDS
		If GetGadgetText(#SceneSearchField) <> ""
			visible = 0
			For gk = 0 To ArraySize(SceneSearchKeywords()) - 1
				For sk = 0 To ArraySize(SceneKeywords()) - 1
					If FindString(SceneKeywords(sk), SceneSearchKeywords(gk))
						visible = 1
					EndIf
				Next
			Next
		EndIf
		
		If visible
		
			; Find the preview image of the scene(start as missing)
			Image = ImageID(#BoxInvalid)
			If Scenes(w) \ Preview > -1 : Image = ImageID(Scenes(w) \ Preview) : EndIf
			
			; Place the scene box button
			AddItem("Scenes", Scenes(w) \ Name, ImageGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, Image), #PopupMenuSceneItem)
			
			; Place the name of the scene
			Name = TextGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30) + BoxHeight + 5, BoxWidth, 20, Scenes(w) \ Name, #PB_Text_Center)
			AddItem("Scenes", "", Name, -1)
			
			; Set the name properties(color, font)
			SetGadgetFont(Name, FontID(#ItemFont))
			SetGadgetColor(Name, #PB_Gadget_BackColor, scrollercolor)
			
			; Do a next row when reach the border of the panel
			col = col + 1
			If col *(BoxWidth + 10) >(PanelWidth - BoxWidth - 10)
				col = 0
				row = row + 1
				NewHeight = NewHeight + BoxHeight + 30 + 50
			EndIf
			
		EndIf
		
	Next
	
	; Place the new scene button
	ImageGadget(#NewSceneButton, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxNew))
	AddItem("Scenes", "", #NewSceneButton, -1)
	
	; Calculate the new scroller height
	NewHeight = NewHeight + BoxHeight + 30 + 50
	
	; Close the scene tab
	CloseGadgetList()
	
	; Set the new height of the scene scroller
	SetGadgetAttribute(#SceneScroller, #PB_ScrollArea_InnerHeight, NewHeight)	
	
	; **************************************************************************************************************
	; Add function gadgets
	; **************************************************************************************************************
	; Set the width of the function scroller area
	SetGadgetAttribute(#FunctionScroller, #PB_ScrollArea_InnerWidth, PanelWidth)
	
	; Start the function tab
	OpenGadgetList(#FunctionScroller)
	If Not IsGadget(#TabHeaderFunctionsGadget)
		ImageGadget(#TabHeaderFunctionsGadget, 0, 0, 2880, 50, ImageID(#TabHeaderFunctions))
		DisableGadget(#TabHeaderFunctionsGadget, 1)
		ButtonGadget(#ExportFunctionButton, 240, 10, 60, 25, "Export...")
		ButtonGadget(#ImportFunctionButton, 310, 10, 60, 25, "Import...")
		
		StringGadget(#FunctionSearchField, 400, 10, 300, 25, Games(0) \ FunctionSearch)
		GadgetToolTip(#FunctionSearchField, "Enter keywords to refine results.")
		SetGadgetFont(#FunctionSearchField, FontID(#ItemFont))
		ComboBoxGadget(#FunctionSearchCombo, 710, 10, 100, 25)
		GadgetToolTip(#FunctionSearchCombo, "Select a keyword to refine results.")
		
		ButtonImageGadget(#FunctionSortReset, 850, 10, 25, 25, ImageID(#SortResetImage))
		ButtonImageGadget(#FunctionSortAsc, 880, 10, 25, 25, ImageID(#SortAscImage))
		ButtonImageGadget(#FunctionSortDesc, 910, 10, 25, 25, ImageID(#SortDescImage))
		GadgetToolTip(#FunctionSortReset, "Reset order")
		GadgetToolTip(#FunctionSortAsc, "Sort by names in ascending order")
		GadgetToolTip(#FunctionSortDesc, "Sort by names in descending order")
		
	EndIf
	
	; DETERMINE FUNCTION SEARCH KEYWORDS
	Dim FunctionKeywords.s(0)
	Dim FunctionSearchKeywords.s(0)
	kw = CountString(GetGadgetText(#FunctionSearchField), ",")
	For k = 1 To (kw + 1)
		index = ArraySize(FunctionSearchKeywords())
		FunctionSearchKeywords(index) = UCase(Trim(StringField(GetGadgetText(#FunctionSearchField), k, ",")))
		ReDim FunctionSearchKeywords(index + 1)
	Next
	
	scrollercolor = RGB(200, 200, 200)
	If GetGadgetText(#FunctionSearchField) <> ""
		scrollercolor = RGB(170,170,200)
	EndIf
	SetGadgetColor(#FunctionScroller, #PB_Gadget_BackColor, scrollercolor)	
	
	NewHeight = 10
	col = 0
	row = 0
	For w = 0 To ArraySize(Functions()) - 1
		
		; DETERMINE CURRENT FUNCTION KEYWORDS
		ReDim FunctionKeywords.s(0)
		kw = CountString(Functions(w) \ Keywords, ",")
		For k = 1 To (kw + 1)
			index = ArraySize(FunctionKeywords())
			FunctionKeywords(index) = UCase(Trim(StringField(Functions(w) \ Keywords, k, ",")))
			ReDim FunctionKeywords(index + 1)
		Next
		
		visible = 1
		
		; CHECK IF FUNCTION KEYWORDS FITS IN SEARCH KEYWORDS
		If GetGadgetText(#FunctionSearchField) <> ""
			visible = 0
			For gk = 0 To ArraySize(FunctionSearchKeywords()) - 1
				For sk = 0 To ArraySize(FunctionKeywords()) - 1
					If FindString(FunctionKeywords(sk), FunctionSearchKeywords(gk))
						visible = 1
					EndIf
				Next
			Next
		EndIf
		
		If visible
		
			; Place the actual function box
			AddItem("Functions", Functions(w) \ Name, ImageGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxFunction)), #PopupMenuFunctionItem)
			
			; Place the name of the function
			Name = TextGadget(#PB_Any, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30) + BoxHeight + 5, BoxWidth, 20, Functions(w) \ Name, #PB_Text_Center)
			AddItem("Functions", "", Name, -1)
			
			; Set the name properties(color, font)
			SetGadgetFont(Name, FontID(#ItemFont))
			SetGadgetColor(Name, #PB_Gadget_BackColor, scrollercolor)
			
			; Do a next row when reach the border of the panel
			col = col + 1
			If col *(BoxWidth + 10) >(PanelWidth - BoxWidth - 10)
				col = 0
				row = row + 1
				NewHeight = NewHeight + BoxHeight + 30 + 50
			EndIf
			
		EndIf
		
	Next
	
	; Place the new function button
	ImageGadget(#NewFunctionButton, x + col *(BoxWidth + 10), y + row *(BoxHeight + 30), BoxWidth, BoxHeight, ImageID(#BoxNew))
	AddItem("Functions", "", #NewFunctionButton, -1)
	
	; Calculate the new height
	NewHeight = NewHeight + BoxHeight + 30 + 50
	
	; Close the script tab
	CloseGadgetList()
	
	; Set the new function scroller height
	SetGadgetAttribute(#FunctionScroller, #PB_ScrollArea_InnerHeight, NewHeight)	
	
	; Script mode
	SetGadgetState(#ScriptModeCheckbox, Games(0)\ScriptMode)
	
	RefreshSearchCombos()
	
	; Move back all gadgets to the screen when refresh is ready
	ResizeGadget(#SpriteScroller, 0, 0, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#SoundScroller, 0, 0, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#MusicScroller, 0, 0, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#BackgroundScroller, 0, 0, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#FontScroller, 0, 0, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#ObjectScroller, 0, 0, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#SceneScroller, 0, 0, #PB_Ignore, #PB_Ignore)
	ResizeGadget(#FunctionScroller, 0, 0, #PB_Ignore, #PB_Ignore)
	
EndProcedure

; Add a new sprite
Procedure.s CreateNewSprite()
	
	Dirty(1)
	
	index = ArraySize(Sprites())
	Sprites(index) \ Name = "sprite_" + Str(UID())
	Sprites(index) \ Preview = -1
	Sprites(index) \ CenterX = 0
	Sprites(index) \ CenterY = 0
	Sprites(index) \ CollisionShape = "Box"
	Sprites(index) \ CollisionRadius = 0
	Sprites(index) \ CollisionLeft = 0
	Sprites(index) \ CollisionRight = 0
	Sprites(index) \ CollisionTop = 0
	Sprites(index) \ CollisionBottom = 0
	Sprites(index) \ Timer = UID()
	Sprites(index) \ Timer2 = UID()
	Sprites(index) \ ShapeEditorSnapToGrid = 1
	Sprites(index) \ ShapeEditorGridWidth = 5
	Sprites(index) \ ShapeEditorGridHeight = 5
	Sprites(index) \ ShapeEditorZoom = 1
	Sprites(index) \ Zoom = 1
	Sprites(index) \ AnimSpeed = 30
	Sprites(index) \ ShowCollisionShape = 1
	Sprites(index) \ Keywords = GetGadgetText(#SpriteSearchField)
	Sprites(index) \ UID = UID()
	ReDim Sprites(index + 1)
	
	ProcedureReturn Sprites(index) \ Name
	
EndProcedure

; Add a new background
Procedure.s CreateNewBackground()
	
	Dirty(1)
	
	index = ArraySize(Backgrounds())
	Backgrounds(index) \ Name = "background_" + Str(UID())
	Backgrounds(index) \ File = ""
	Backgrounds(index) \ Preview = -1
	Backgrounds(index) \ Tile = 0
	Backgrounds(index) \ TileWidth = 32
	Backgrounds(index) \ TileHeight = 32
	Backgrounds(index) \ TileXOffset = 0
	Backgrounds(index) \ TileYOffset = 0
	Backgrounds(index) \ TileXSpace = 0
	Backgrounds(index) \ TileYSpace = 0
	Backgrounds(index) \ Timer = UID()
	Backgrounds(index) \ Keywords = GetGadgetText(#BackgroundSearchField)
	Backgrounds(index) \ UID = UID()
	ReDim Backgrounds(index + 1)
	
	ProcedureReturn Backgrounds(index) \ Name
	
EndProcedure

; Add a new font
Procedure.s CreateNewFont()
	
	Dirty(1)
	
	index = ArraySize(Fonts())
	Fonts(index) \ Name = "font_" + Str(UID())
	Fonts(index) \ Family = "Arial"
	Fonts(index) \ Size = 12
	Fonts(index) \ Bold = 0
	Fonts(index) \ Italic = 0
	Fonts(index) \ Keywords = GetGadgetText(#FontSearchField)
	Fonts(index) \ UID = UID()
	ReDim Fonts(index + 1)
	
	ProcedureReturn Fonts(index) \ Name
	
EndProcedure

; Create a new object
Procedure.s CreateNewObject()
	
	Dirty(1)
	
	index = ArraySize(Objects())
	Objects(index) \ Name = "object_" + Str(UID())
	Objects(index) \ Proto = 1
	Objects(index) \ TemplateObject = ""
	Objects(index) \ X = 0
	Objects(index) \ Y = 0
	Objects(index) \ Sprite = ""
	Objects(index) \ Scene = ""
	Objects(index) \ TImage = -1
	Objects(index) \ TWidth = 0
	Objects(index) \ THeight = 0
	Objects(index) \ Selected = 0
	Objects(index) \ Visible = 1
	Objects(index) \ Depth = 0
	Objects(index) \ Collide = 1
	Objects(index) \ Parent = ""
	Objects(index) \ ImageAngle = 0
	Objects(index) \ Direction = 0
	Objects(index) \ Timer = UID()
	Objects(index) \ Keywords = GetGadgetText(#ObjectSearchField)
	Objects(index) \ UID = UID()
	ReDim Objects(index + 1)
	
	ProcedureReturn Objects(index) \ Name
	
EndProcedure

; Create a new sound
Procedure.s CreateNewSound()
	
		Dirty(1)
		
		Index = ArraySize(Sounds())
		Sounds(Index) \ Name = "sound_" + Str(UID())
		Sounds(Index) \ File = ""
		Sounds(Index) \ File2 = ""
		Sounds(Index) \ File3 = ""
		Sounds(index) \ Keywords = GetGadgetText(#SoundSearchField)
		Sounds(index) \ UID = UID()
		ReDim Sounds(Index + 1)
		
		ProcedureReturn Sounds(index) \ Name
		
EndProcedure

; Create a new music
Procedure.s CreateNewMusic()
		
		Dirty(1)
		
		Index = ArraySize(Musics())
		Musics(Index) \ Name = "music_" + Str(UID())
		Musics(Index) \ File = ""
		Musics(Index) \ File2 = ""
		Musics(Index) \ File3 = ""
		Musics(index) \ Keywords = GetGadgetText(#MusicSearchField)
		Musics(index) \ UID = UID()
		ReDim Musics(Index + 1)
		
		ProcedureReturn Musics(index) \ Name
		
EndProcedure

; Create a new layer
Procedure.s CreateNewLayer(Scene.s)
	
	index = ArraySize(Layers())
	Layers(index) \ Name = "layer_" + Str(UID())
	Layers(index) \ Scene = Scene
	Layers(index) \ Value = 1000000
	ReDim Layers(index + 1)
	
	ProcedureReturn Layers(index) \ Name
	
EndProcedure

; Create a new scene
Procedure.s CreateNewScene()
	
	Dirty(1)
	
	index = ArraySize(Scenes())
	Scenes(index) \ Name = "scene_" + Str(UID())
	Scenes(index) \ Code = ""
	Scenes(index) \ Preview = -1
	Scenes(index) \ Width = 640
	Scenes(index) \ Height = 480
	Scenes(index) \ ViewportWidth = 640
	Scenes(index) \ ViewportHeight = 480
	Scenes(index) \ R = 0
	Scenes(index) \ G = 0
	Scenes(index) \ B = 0
	Scenes(index) \ Speed = 30
	Scenes(index) \ Background = ""
	Scenes(index) \ BackgroundTileX = 0
	Scenes(index) \ BackgroundTileY = 0
	Scenes(index) \ BackgroundStretch = 0
	Scenes(index) \ ViewportXBorder = 50
	Scenes(index) \ ViewportYBorder = 50
	Scenes(index) \ ViewportObject = ""
	Scenes(index) \ InnerTimer = UID()
	Scenes(index) \ InnerShowGrid = 1
	Scenes(index) \ InnerShowObjects = 1
	Scenes(index) \ InnerShowTiles = 1
	Scenes(index) \ InnerGridSize = 20
	Scenes(index) \ Keywords = GetGadgetText(#SceneSearchField)
	Scenes(index) \ UID = UID()
	
	ReDim Scenes(index + 1)
	
	CreateNewLayer(Scenes(index) \ Name)
	
	ProcedureReturn Scenes(index) \ Name
	
EndProcedure

; Add a new script
Procedure.s CreateNewFunction()
	
	Dirty(1)
	
	index = ArraySize(Functions())
	Functions(index) \ Name = "function_" + Str(UID())
	Functions(index) \ Params = ""
	Functions(index) \ Description = ""
	Functions(index) \ Code = ""
	Functions(index) \ Keywords = GetGadgetText(#FunctionSearchField)
	Functions(index) \ UID = UID()
	ReDim Functions(index + 1)
	
	ProcedureReturn Functions(index) \ Name
	
EndProcedure

; Check if the sprite name is free
Procedure SpriteNameIsFree(NameToCheck.s, NotMe.i)
	Free = 1	
	For s = 0 To ArraySize(Sprites()) - 1
		If s <> NotMe And Sprites(s) \ Name = NameToCheck : Free = 0 : EndIf
	Next
	ProcedureReturn Free
EndProcedure

; Check if the background name is free
Procedure BackgroundNameIsFree(NameToCheck.s, NotMe.i)
	Free = 1	
	For s = 0 To ArraySize(Backgrounds()) - 1
		If s <> NotMe And Backgrounds(s) \ Name = NameToCheck : Free = 0 : EndIf
	Next
	ProcedureReturn Free
EndProcedure

; Check if the font name is free
Procedure FontNameIsFree(NameToCheck.s, NotMe.i)
	Free = 1	
	For s = 0 To ArraySize(Fonts()) - 1
		If s <> NotMe And Fonts(s) \ Name = NameToCheck : Free = 0 : EndIf
	Next
	ProcedureReturn Free
EndProcedure

; Check if the object name is free
Procedure ObjectNameIsFree(NameToCheck.s, NotMe.i)
	Free = 1	
	For s = 0 To ArraySize(Objects()) - 1
		If s <> NotMe And Objects(s) \ Name = NameToCheck : Free = 0 : EndIf
	Next
	ProcedureReturn Free
EndProcedure

; Check if the sound name is free
Procedure SoundNameIsFree(NameToCheck.s, NotMe.i)
	Free = 1	
	For s = 0 To ArraySize(Sounds()) - 1
		If s <> NotMe And Sounds(s) \ Name = NameToCheck : Free = 0 : EndIf
	Next
	ProcedureReturn Free
EndProcedure

; Check if the music name is free
Procedure MusicNameIsFree(NameToCheck.s, NotMe.i)
	Free = 1	
	For s = 0 To ArraySize(Musics()) - 1
		If s <> NotMe And Musics(s) \ Name = NameToCheck : Free = 0 : EndIf
	Next
	ProcedureReturn Free
EndProcedure

; Check if the scene name is free
Procedure SceneNameIsFree(NameToCheck.s, NotMe.i)
	Free = 1	
	For s = 0 To ArraySize(Scenes()) - 1
		If s <> NotMe And Scenes(s) \ Name = NameToCheck : Free = 0 : EndIf
	Next
	ProcedureReturn Free
EndProcedure

; Check if the script name is free
Procedure ScriptNameIsFree(NameToCheck.s, NotMe.i)
	Free = 1	
	For s = 0 To ArraySize(Functions()) - 1
		If s <> NotMe And Functions(s) \ Name = NameToCheck : Free = 0 : EndIf
	Next
	ProcedureReturn Free
EndProcedure

; Resize panels when window is resized
Procedure WindowResized()
	ResizeGadget(#MainPanel, 5, 45, WindowWidth(#MainWindow) - 10, WindowHeight(#MainWindow) - MenuHeight() - 10 - 40)
	ResizeGadget(#SpriteScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	ResizeGadget(#SoundScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	ResizeGadget(#MusicScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	ResizeGadget(#BackgroundScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	ResizeGadget(#FontScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	ResizeGadget(#ObjectScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	ResizeGadget(#SceneScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	ResizeGadget(#GameScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	ResizeGadget(#FunctionScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight))
	RefreshItems()
EndProcedure

; Display the preferences form
Procedure PreferencesForm()
	
	; Form window
	DisableWindow(#MainWindow, 1)
	OpenWindow(#SubWindow, 0, 0, 640, 480, "Preferences", #PB_Window_ScreenCentered | #PB_Window_Tool)
	
	PrefButtonWidth = 25
	
	CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
	 PrefButtonWidth = 40
	CompilerEndIf
	
	PrefEditorPanel = PanelGadget(#PB_Any, 10, 10, 620, 425)
	  
	AddGadgetItem(PrefEditorPanel, -1, " Code editor")
	
	; Text
	TextGadget(#PB_Any, 10, 15, 120, 25, "Text")
	ForegroundColorDisplay = StringGadget(#PB_Any, 130, 10, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(ForegroundColorDisplay, #PB_Gadget_BackColor, sci_color_fore)
	ForegroundColorPicker = ButtonGadget(#PB_Any, 240, 10, PrefButtonWidth, 25, "...")	
	
	; Caret
	TextGadget(#PB_Any, 10, 45, 120, 25, "Caret")
	CaretColorDisplay = StringGadget(#PB_Any, 130, 40, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(CaretColorDisplay, #PB_Gadget_BackColor, sci_color_caret)
	CaretColorPicker = ButtonGadget(#PB_Any, 240, 40, PrefButtonWidth, 25, "...")	
	
	; Selection back
	TextGadget(#PB_Any, 10, 75, 120, 25, "Selection background")
	SelectionBackgroundColorDisplay = StringGadget(#PB_Any, 130, 70, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(SelectionBackgroundColorDisplay, #PB_Gadget_BackColor, sci_color_selection_back)
	SelectionBackgroundColorPicker = ButtonGadget(#PB_Any, 240, 70, PrefButtonWidth, 25, "...")		
	
	; Selection foreground
	TextGadget(#PB_Any, 10, 105, 120, 25, "Selection foreground")
	SelectionForegroundColorDisplay = StringGadget(#PB_Any, 130, 100, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(SelectionForegroundColorDisplay, #PB_Gadget_BackColor, sci_color_selection_fore)
	SelectionForegroundColorPicker = ButtonGadget(#PB_Any, 240, 100, PrefButtonWidth, 25, "...")			
	
	; Command
	TextGadget(#PB_Any, 10, 135, 120, 25, "Command")
	CommandColorDisplay = StringGadget(#PB_Any, 130, 130, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(CommandColorDisplay, #PB_Gadget_BackColor, sci_color_command)
	CommandColorPicker = ButtonGadget(#PB_Any, 240, 130, PrefButtonWidth, 25, "...")
	
	; Comment
	TextGadget(#PB_Any, 10, 165, 120, 25, "Comment")
	CommentColorDisplay = StringGadget(#PB_Any, 130, 160, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(CommentColorDisplay, #PB_Gadget_BackColor, sci_color_comment)
	CommentColorPicker = ButtonGadget(#PB_Any, 240, 160, PrefButtonWidth, 25, "...")
	
	; Font family
	TextGadget(#PB_Any, 10, 195, 120, 25, "Font family")
	FontFamilyDisplay = StringGadget(#PB_Any, 130, 190, 100, 20, sci_font_family)
	
	; Font size
	TextGadget(#PB_Any, 10, 225, 120, 25, "Font size")
	FontSizeDisplay = StringGadget(#PB_Any, 130, 220, 100, 20, Str(sci_font_size))
	
	; String
	TextGadget(#PB_Any, 300, 15, 120, 25, "String")
	StringColorDisplay = StringGadget(#PB_Any, 430, 10, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(StringColorDisplay, #PB_Gadget_BackColor, sci_color_string)
	StringColorPicker = ButtonGadget(#PB_Any, 540, 10, PrefButtonWidth, 25, "...")
	
	; Number
	TextGadget(#PB_Any, 300, 45, 120, 25, "Number")
	NumberColorDisplay = StringGadget(#PB_Any, 430, 40, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(NumberColorDisplay, #PB_Gadget_BackColor, sci_color_number)
	NumberColorPicker = ButtonGadget(#PB_Any, 540, 40, PrefButtonWidth, 25, "...")	
	
	; Function
	TextGadget(#PB_Any, 300, 75, 120, 25, "User function")
	FunctionColorDisplay = StringGadget(#PB_Any, 430, 70, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(FunctionColorDisplay, #PB_Gadget_BackColor, sci_color_function)
	FunctionColorPicker = ButtonGadget(#PB_Any, 540, 70, PrefButtonWidth, 25, "...")	
	
	; Resource
	TextGadget(#PB_Any, 300, 105, 120, 25, "Resource")
	ResourceColorDisplay = StringGadget(#PB_Any, 430, 100, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(ResourceColorDisplay, #PB_Gadget_BackColor, sci_color_resource)
	ResourceColorPicker = ButtonGadget(#PB_Any, 540, 100, PrefButtonWidth, 25, "...")	
	
	; Constant
	TextGadget(#PB_Any, 300, 135, 120, 25, "Constant")
	ConstantColorDisplay = StringGadget(#PB_Any, 430, 130, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(ConstantColorDisplay, #PB_Gadget_BackColor, sci_color_tu_constant)
	ConstantColorPicker = ButtonGadget(#PB_Any, 540, 130, PrefButtonWidth, 25, "...")	
	
	; TU function
	TextGadget(#PB_Any, 300, 165, 120, 25, "Tululoo function")
	TuFunctionColorDisplay = StringGadget(#PB_Any, 430, 160, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(TuFunctionColorDisplay, #PB_Gadget_BackColor, sci_color_tu_function)
	TuFunctionColorPicker = ButtonGadget(#PB_Any, 540, 160, PrefButtonWidth, 25, "...")	
	
	; TU variable
	TextGadget(#PB_Any, 300, 195, 120, 25, "Tululoo variable")
	TuVariableColorDisplay = StringGadget(#PB_Any, 430, 190, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
	SetGadgetColor(TuVariableColorDisplay, #PB_Gadget_BackColor, sci_color_tu_variable)
	TuVariableColorPicker = ButtonGadget(#PB_Any, 540, 190, PrefButtonWidth, 25, "...")
	
	AddGadgetItem(PrefEditorPanel, -1, "Misc")
	
	; Add FILE protocol when running game
	AddFileProtocolCheckbox = CheckBoxGadget(#PB_Any, 10, 10, 300, 25, "Add file protocol (file://) when running game from IDE")
	SetGadgetState(AddFileProtocolCheckbox, AddFileProtocol)
	
	; CheckProgramVersion
	CheckProgramVersionCheckbox = CheckBoxGadget(#PB_Any, 10, 40, 300, 25, "Check program version at startup")
	SetGadgetState(CheckProgramVersionCheckbox, CheckProgramVersion)
	
	; GenerateIndexHTML
	GenerateIndexHTMLCheckbox = CheckBoxGadget(#PB_Any, 10, 70, 300, 25, "Generate INDEX.HTML when saving project")
	SetGadgetState(GenerateIndexHTMLCheckbox, GenerateIndexHTML)
	
	; Confirm exit from program
	ConfirmExitCheckbox = CheckBoxGadget(#PB_Any, 10, 100, 300, 25, "Confirm exit from Tululoo")
	SetGadgetState(ConfirmExitCheckbox, ConfirmExit)
	
	AddGadgetItem(PrefEditorPanel, -1, "Export")
	
	; Image folder
	TextGadget(#PB_Any, 10, 15, 120, 25, "Image folder")
	ImageFolderName = StringGadget(#PB_Any, 130, 10, 100, 20, ImgFolder)
	
	; Audio folder
	TextGadget(#PB_Any, 10, 45, 120, 25, "Audio folder")
	AudioFolderName = StringGadget(#PB_Any, 130, 40, 100, 20, AudioFolder)
	
	CloseGadgetList()
	
	; OK button
	ButtonGadget(#GeneralOKButton, WindowWidth(#SubWindow) - 75, WindowHeight(#SubWindow) - 35, 65, 25, "Save")
	
	; Cancel button
	CancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(#SubWindow) - 35, 65, 25, "Cancel")
	
	; Window handling
	Done = 0
	Repeat
		SetActiveWindow(#SubWindow)
		Select WaitWindowEvent()

			Case #PB_Event_Gadget
				Select EventGadget()
						
					Case ForegroundColorPicker
						t.i = ColorRequester(GetGadgetColor(ForegroundColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(ForegroundColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case SelectionBackgroundColorPicker
						t.i = ColorRequester(GetGadgetColor(SelectionBackgroundColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(SelectionBackgroundColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case SelectionForegroundColorPicker
						t.i = ColorRequester(GetGadgetColor(SelectionForegroundColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(SelectionForegroundColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case CommandColorPicker
						t.i = ColorRequester(GetGadgetColor(CommandColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(CommandColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case CommentColorPicker
						t.i = ColorRequester(GetGadgetColor(CommentColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(CommentColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case StringColorPicker
						t.i = ColorRequester(GetGadgetColor(StringColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(StringColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case NumberColorPicker
						t.i = ColorRequester(GetGadgetColor(NumberColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(NumberColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case FunctionColorPicker
						t.i = ColorRequester(GetGadgetColor(FunctionColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(FunctionColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case ResourceColorPicker
						t.i = ColorRequester(GetGadgetColor(ResourceColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(ResourceColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case ConstantColorPicker
						t.i = ColorRequester(GetGadgetColor(ConstantColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(ConstantColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case TuFunctionColorPicker
						t.i = ColorRequester(GetGadgetColor(TuFunctionColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(TuFunctionColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case TuVariableColorPicker
						t.i = ColorRequester(GetGadgetColor(TuVariableColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(TuVariableColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case CaretColorPicker
						t.i = ColorRequester(GetGadgetColor(CaretColorDisplay, #PB_Gadget_BackColor))
						If t > -1 :	SetGadgetColor(CaretColorDisplay, #PB_Gadget_BackColor, t) : EndIf
						
					Case CancelButton
						Done = 1
					
					; Apply form changes
				Case #GeneralOKButton
					sci_color_fore = GetGadgetColor(ForegroundColorDisplay, #PB_Gadget_BackColor)
					sci_color_selection_back = GetGadgetColor(SelectionBackgroundColorDisplay, #PB_Gadget_BackColor)
					sci_color_selection_fore = GetGadgetColor(SelectionForegroundColorDisplay, #PB_Gadget_BackColor)
					sci_color_caret = GetGadgetColor(CaretColorDisplay, #PB_Gadget_BackColor)
					sci_color_command = GetGadgetColor(CommandColorDisplay, #PB_Gadget_BackColor)
					sci_color_comment = GetGadgetColor(CommentColorDisplay, #PB_Gadget_BackColor)
					sci_color_function = GetGadgetColor(FunctionColorDisplay, #PB_Gadget_BackColor)
					sci_color_number = GetGadgetColor(NumberColorDisplay, #PB_Gadget_BackColor)
					sci_color_resource = GetGadgetColor(ResourceColorDisplay, #PB_Gadget_BackColor)
					sci_color_string = GetGadgetColor(StringColorDisplay, #PB_Gadget_BackColor)
					sci_color_tu_constant = GetGadgetColor(ConstantColorDisplay, #PB_Gadget_BackColor)
					sci_color_tu_function = GetGadgetColor(TuFunctionColorDisplay, #PB_Gadget_BackColor)
					sci_color_tu_variable = GetGadgetColor(TuVariableColorDisplay, #PB_Gadget_BackColor)
					sci_font_family = GetGadgetText(FontFamilyDisplay)
					sci_font_size = Val(GetGadgetText(FontSizeDisplay))
					
					AddFileProtocol = GetGadgetState(AddFileProtocolCheckbox)
					CheckProgramVersion = GetGadgetState(CheckProgramVersionCheckbox)
					GenerateIndexHTML = GetGadgetState(GenerateIndexHTMLCheckbox)
					ConfirmExit = GetGadgetState(ConfirmExitCheckbox)
					ImgFolder = GetGadgetText(ImageFolderName)
					AudioFolder = GetGadgetText(AudioFolderName)
					
					SavePreferences()
					
					Done = 1
						
				EndSelect
				
		EndSelect
	Until Done = 1
	
	; Close window
	DisableWindow(#MainWindow, 0)			
	CloseWindow(#SubWindow)
	
EndProcedure

; Import spritestrips, create frames
Procedure ImportSpriteStrip(SpriteIndex)
	
	Dim GrabbedImages.i(0)
	
	; Select an image strip from the HD
	FileName.s = OpenFileRequester("Select an image strip", "", "Image strips (jpg, bmp, png)|*.jpg;*.bmp;*.png|JPG files(*.jpg)|*.jpg|BMP files(*.bmp)|*.bmp|PNG files(*.png)|*.png", 0)
	
	If FileName <> ""
		
		; Load the opened image
		LoadedImageTemp = LoadImage(#PB_Any, FileName)
		; CONVERT TO 32 BIT TRANSPARENT
		LoadedWidth = ImageWidth(LoadedImageTemp)
		LoadedHeight = ImageHeight(LoadedImageTemp)
		CreateImage(#ImportedImage, LoadedWidth, LoadedHeight, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(#ImportedImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(LoadedImageTemp), 0, 0)
		StopDrawing()
		FreeImage(LoadedImageTemp)
		
		If IsImage(#ImportedImage)
			
			; Display the sprite strip window
			ImportWindow = OpenWindow(#PB_Any, 0, 0, 550, 400, "Importing image strips", #PB_Window_ScreenCentered | #PB_Window_Tool | #PB_Window_SizeGadget)
			StickyWindow(ImportWindow, 1)
			OkButton = ButtonGadget(#PB_Any, 10, WindowHeight(ImportWindow) - 35, 65, 25, " Import! ")
			
			; Image info
			TextGadget(#PB_Any, 250, 15, 150, 25, "Dimensions: " + Str(ImageWidth(#ImportedImage)) + " x " + Str(ImageHeight(#ImportedImage)) + " pixels")
			
			; Image scroller
			ImageScroller = ScrollAreaGadget(#PB_Any, 10, 45, 400, 300, ImageWidth(#ImportedImage), ImageHeight(#ImportedImage), 32, #PB_ScrollArea_Single)
			ImageGadget = ImageGadget(#PB_Any, 0, 0, ImageWidth(#ImportedImage), ImageHeight(#ImportedImage), ImageID(#ImportedImage))
			CloseGadgetList()
			
			; Grab preview
			GrabbedPreview = ImageGadget(#PB_Any, 420, 45, 100, 100, 0, #PB_Image_Border)
			
			; Columns gadget
			TextGadget(#PB_Any, 10, 15, 40, 25, "Columns")
			ColumnsGadget = SpinGadget(#PB_Any, 60, 10, 50, 25, 1, 256, #PB_Spin_Numeric)
			SetGadgetState(ColumnsGadget, 1)
			
			; Rows gadget
			TextGadget(#PB_Any, 120, 15, 40, 25, "Rows")
			RowsGadget = SpinGadget(#PB_Any, 160, 10, 50, 25, 1, 256, #PB_Spin_Numeric)			
			SetGadgetState(RowsGadget, 1)
			
			; create new preview
			GrabbedFrameWidth = ImageWidth(#ImportedImage) / Val(GetGadgetText(ColumnsGadget))
			GrabbedFrameHeight = ImageHeight(#ImportedImage) / Val(GetGadgetText(RowsGadget))
			sn = 0
			ReDim GrabbedImages(0)
			For r = 0 To Val(GetGadgetText(RowsGadget)) - 1
				For c = 0 To Val(GetGadgetText(ColumnsGadget)) - 1
					Index = ArraySize(GrabbedImages())
					GrabbedImages(Index)  = GrabImage(#ImportedImage, #PB_Any, c * GrabbedFrameWidth, r * GrabbedFrameHeight, GrabbedFrameWidth, GrabbedFrameHeight)
					ReDim GrabbedImages(Index + 1)
					sn = sn + 1
				Next
			Next
			GrabImageCurrent = 0
			GrabImageMax = sn
			
			AddWindowTimer(ImportWindow, 10000, 60)
			
			GrabImage = -1
			GrabImageCurrent = 0
			GrabImageMax = 0
			
			done = 0
			Repeat
				SetActiveWindow(ImportWindow)
				Select WaitWindowEvent()
						
					Case #PB_Event_Timer
						GrabImageCurrent = GrabImageCurrent + 1
						If GrabImageCurrent > GrabImageMax - 1
							GrabImageCurrent = 0
						EndIf
						If IsImage(GrabbedImages(0))
							SetGadgetState(GrabbedPreview, ImageID(GrabbedImages(GrabImageCurrent)))
						EndIf
						
					Case #PB_Event_Gadget
						Select EventGadget()
								
							Case ColumnsGadget, RowsGadget
								Select EventType()
									Case #PB_EventType_Change, #PB_EventType_LostFocus
										
										If Val(GetGadgetText(ColumnsGadget)) > 0 And Val(GetGadgetText(RowsGadget)) > 0
											; delete previous images
											For g = 0 To ArraySize(GrabbedImages()) - 1
												If IsImage(GrabbedImages(g)) : FreeImage(GrabbedImages(g)) : EndIf
											Next
											
											; create new preview
											GrabbedFrameWidth = ImageWidth(#ImportedImage) / Val(GetGadgetText(ColumnsGadget))
											GrabbedFrameHeight = ImageHeight(#ImportedImage) / Val(GetGadgetText(RowsGadget))
											sn = 0
											ReDim GrabbedImages(0)
											For r = 0 To Val(GetGadgetText(RowsGadget)) - 1
												For c = 0 To Val(GetGadgetText(ColumnsGadget)) - 1
													Index = ArraySize(GrabbedImages())
													GrabbedImages(Index)  = GrabImage(#ImportedImage, #PB_Any, c * GrabbedFrameWidth, r * GrabbedFrameHeight, GrabbedFrameWidth, GrabbedFrameHeight)
													ReDim GrabbedImages(Index + 1)
													sn = sn + 1
												Next
											Next
											GrabImageCurrent = 0
											GrabImageMax = sn
										EndIf
										
								EndSelect
								
							Case OkButton
								; Valid ROW and COLUMN value?
								If Val(GetGadgetText(ColumnsGadget)) > 0 And Val(GetGadgetText(RowsGadget)) > 0
									
									done = 1
									
									; Destroy existing frames of this sprite
									Dim Temp.Frame(0)
									For d = 0 To ArraySize(Frames()) - 1
										If Frames(d) \ Sprite = Sprites(SpriteIndex) \ Name
											; Free the old image
											If IsImage(Frames(d) \ Image)
												FreeImage(Frames(d) \ Image)
											EndIf
										Else
											; Store other frames
											Index = ArraySize(Temp())
											ReDim Temp(Index + 1)
											Temp(Index) \ File = Frames(d) \ File
											Temp(Index) \ Sprite = Frames(d) \ Sprite
											Temp(Index) \ Image = Frames(d) \ Image
										EndIf
									Next
									
									; Recreate the frames array
									ReDim Frames(Index)
									CopyArray(Temp(), Frames())
									
									; Make animation frames based on the columns and rows value
									FrameWidth = ImageWidth(#ImportedImage) / Val(GetGadgetText(ColumnsGadget))
									FrameHeight = ImageHeight(#ImportedImage) / Val(GetGadgetText(RowsGadget))
									sn = 0
									For r = 0 To Val(GetGadgetText(RowsGadget)) - 1
										For c = 0 To Val(GetGadgetText(ColumnsGadget)) - 1
											
											Index = ArraySize(Frames())
											Frames(Index) \ Sprite = Sprites(SpriteIndex) \ Name
											Frames(Index) \ File = Str(sn)
											Frames(Index) \ Image = GrabImage(#ImportedImage, #PB_Any, c * FrameWidth, r * FrameHeight, FrameWidth, FrameHeight)
											ReDim Frames(Index + 1)
											sn = sn + 1
											
										Next
									Next
									
									; Reset sprite origin
									Sprites(SpriteIndex) \ CenterX = 0
									Sprites(SpriteIndex) \ CenterY = 0
									Sprites(SpriteIndex) \ CollisionRadius = FrameWidth / 2
									Sprites(SpriteIndex) \ CollisionLeft = 0
									Sprites(SpriteIndex) \ CollisionRight = FrameWidth
									Sprites(SpriteIndex) \ CollisionTop = 0
									Sprites(SpriteIndex) \ CollisionBottom = FrameHeight
									Sprites(SpriteIndex) \ CurrentFrame = 0
									
								Else
									MessageRequester("Error", "Invalid column or row number")
								EndIf

						EndSelect
				EndSelect
			Until done = 1
			
			; Destroy temp imported image
			If IsImage(#ImportedImage) : FreeImage(#ImportedImage) : EndIf
			
			; Close window
			CloseWindow(ImportWindow)
			
			; Delete the actual box image
			If IsImage(Sprites(SpriteIndex) \ Preview) : FreeImage(Sprites(SpriteIndex) \ Preview) : EndIf
			
			; Create new box image
			NewSpriteImage = CreateImage(#PB_Any, 150, 100, 32, #PB_Image_Transparent)
			StartDrawing(ImageOutput(NewSpriteImage))
			DrawingMode(#PB_2DDrawing_AlphaBlend)
			If IsImage(#BoxEmpty) : DrawImage(ImageID(#BoxEmpty), 0, 0) : EndIf
			If IsImage(Frames(ArraySize(Frames()) - sn) \ Image)
				IW = ImageWidth(Frames(ArraySize(Frames()) - sn) \ Image)
				IH = ImageHeight(Frames(ArraySize(Frames()) - sn) \ Image)
				If IW >= IH
					WS.f = 1
					HS.f = IH / IW
				Else
					WS.f = IW / IH
					HS.f = 1
				EndIf
				DrawImage(ImageID(Frames(ArraySize(Frames()) - sn) \ Image), 45, 20, 60 * WS, 60 * HS)
			EndIf
			StopDrawing()
			Sprites(SpriteIndex) \ Preview = CopyImage(NewSpriteImage, #PB_Any)
			If IsImage(NewSpriteImage) : FreeImage(NewSpriteImage) : EndIf
			
		EndIf
		
	EndIf
	
EndProcedure

; Return the first image of the specified sprite
Procedure GetSpriteImage(Sprite.s)
	For d = 0 To ArraySize(Frames()) - 1 
		If Frames(d) \ Sprite = Sprite
			ProcedureReturn Frames(d) \ Image
		EndIf
	Next
	ProcedureReturn -1
EndProcedure

; Return the index of the specified sprite
Procedure GetSpriteIndex(Sprite.s)
	For d = 0 To ArraySize(Sprites()) - 1 
		If Sprites(d) \ Name = Sprite
			ProcedureReturn d
		EndIf
	Next
	ProcedureReturn -1
EndProcedure

; Return the sprite name of the object
Procedure.s GetObjectSprite(Object.s)
	For d = 0 To ArraySize(Objects()) - 1
		If Objects(d) \ Name = Object
			ProcedureReturn Objects(d) \ Sprite
		EndIf
	Next
	ProcedureReturn ""
EndProcedure

; Return the depth of the object
Procedure GetObjectDepth(Object.s)
	For d = 0 To ArraySize(Objects()) - 1
		If Objects(d) \ Name = Object
			ProcedureReturn Objects(d) \ Depth
		EndIf
	Next
	ProcedureReturn 0
EndProcedure

; Confirm to delete the selected sprite
Procedure DeleteSprite(Sprite.s)
	
	; Update objects using this sprite: reset sprite name to ""
	For o = 0 To ArraySize(Objects()) - 1
		If Objects(o) \ Sprite = Sprite
			Objects(o) \ Sprite = ""
			Objects(o) \ TImage = -1
		EndIf
	Next
	
	; Temp arrays to store the remaining items
	Dim TempFrames.Frame(0)
	Dim TempSprites.Sprite(0)
	
	; Delete frames using this sprite
	For f = 0 To ArraySize(Frames()) - 1
		If Frames(f) \ Sprite = Sprite
			; Free the image
			If IsImage(Frames(f) \ Image) : FreeImage(Frames(f) \ Image) : EndIf
		Else
			; Store other frames
			Index = ArraySize(TempFrames())
			ReDim TempFrames(Index + 1)
			TempFrames(Index) = Frames(f)
		EndIf
	Next
	; Copy back the orginal items
	CopyArray(TempFrames(), Frames())
	
	; Delete from sprites array
	For x = 0 To ArraySize(Sprites()) - 1
		If Sprites(x) \ Name <> Sprite
			; Store other sprites
			Index = ArraySize(TempSprites())
			ReDim TempSprites(Index + 1)
			TempSprites(Index) = Sprites(x)
		Else
			; Free the box image
			If IsImage(Sprites(x) \ Preview) : FreeImage(Sprites(x) \ Preview) : EndIf
		EndIf
	Next
	; Copy back the orginal items
	CopyArray(TempSprites(), Sprites())
	
	; Update objects TImage data based on the new frame index
	For w = 0 To ArraySize(Objects()) - 1
		; If the object has a sprite
		If Objects(w) \ Sprite <> ""
			; Get the image
			Objects(w) \ TImage = GetSpriteImage(Objects(w) \ Sprite)
			; If it is a valid image
			If Objects(w) \ TImage > -1
				; Set the image dimensions
				Objects(w) \ TWidth = ImageWidth(Objects(w) \ TImage)
				Objects(w) \ THeight = ImageHeight(Objects(w) \ TImage)
			EndIf
		Else
			; No sprite is set
			Objects(w) \ TImage = -1
		EndIf
	Next
	
EndProcedure

; Redraw the frame boxes in the Frame editor window
Procedure RedrawSpriteFrames(Sprite.s, RemoveOld.i)
	
	; Delete old boxes from the scroller
	If RemoveOld = 1
		For d = 0 To ArraySize(FrameBox()) - 1
			If IsGadget(FrameBox(d)) 
				FreeGadget(FrameBox(d))
			EndIf
		Next		
	EndIf
	
	ReDim FrameBox(0)
	
	; Place new boxes on the scroller
	OpenGadgetList(#FrameEditorScroller)
	; Place frames as image gadgets
	ScrollerWidth = 10
	ScrollerHeight = 0
	For f = 0 To ArraySize(Frames()) - 1
		If Frames(f) \ Sprite = Sprite
			Index = ArraySize(FrameBox())
			ImgWidth = ImageWidth(Frames(f) \ Image)
			ImgHeight = ImageHeight(Frames(f) \ Image)
			Temp = CanvasGadget(#PB_Any, ScrollerWidth, 10, ImgWidth, ImgHeight)
			StartDrawing(CanvasOutput(Temp))
			DrawingMode(#PB_2DDrawing_Default)
			DrawImage(ImageID(#TransGrid), 0, 0)
			DrawingMode(#PB_2DDrawing_AlphaBlend)
			DrawImage(ImageID(Frames(f) \ Image), 0, 0)
			; selected?
			If f = FrameEditorSelectedBox
				DrawImage(ImageID(#Selector), 0, 0)
			EndIf
			StopDrawing()
			SetGadgetData(Temp, f)
			FrameBox(Index) = Temp
			ReDim FrameBox(Index + 1)
			ScrollerWidth = ScrollerWidth + ImgWidth + 10
			If ImgHeight > ScrollerHeight
				ScrollerHeight = ImgHeight
			EndIf
			
		EndIf
	Next
	CloseGadgetList()
	
	; Set the scroller inner width
	SetGadgetAttribute(#FrameEditorScroller, #PB_ScrollArea_InnerWidth, ScrollerWidth)
	SetGadgetAttribute(#FrameEditorScroller, #PB_ScrollArea_InnerHeight, ScrollerHeight + 10)
	
EndProcedure

; Create a new sprite
Procedure FrameNew(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	; Window
	NewFramesWindow = OpenWindow(#PB_Any, 0, 0, 200, 120, "Create new sprite", #PB_Window_ScreenCentered | #PB_Window_Tool)
	DisableWindow(FrameWindow, 1)
	StickyWindow(NewFramesWindow, 1)
	; OK button
	NewFramesOKButton = ButtonGadget(#PB_Any, WindowWidth(NewFramesWindow) - 75, WindowHeight(NewFramesWindow) - 35, 65, 25, "OK")
	; Cancel button
	NewFramesCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(NewFramesWindow) - 35, 65, 25, "Cancel")			
	; Width
	TextGadget(#PB_Any, 10, 15, 90, 25, "Width")
	NewFramesWidthGadget = StringGadget(#PB_Any, 110, 10, 80, 25, "40", #PB_String_Numeric)
	; Height
	TextGadget(#PB_Any, 10, 45, 90, 25, "Height")
	NewFramesHeightGadget = StringGadget(#PB_Any, 110, 40, 80, 25, "40", #PB_String_Numeric)
	NewFramesWindowDone = 0
	Repeat
		SetActiveWindow(NewFramesWindow)
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case NewFramesOKButton
						NewFramesWindowDone = 1
						; Delete all frames using this sprite
						Dim TempFrames.Frame(0)
						For f = 0 To ArraySize(Frames()) - 1
							If Frames(f) \ Sprite = Sprite
								; Free the image
								If IsImage(Frames(f) \ Image) : FreeImage(Frames(f) \ Image) : EndIf
							Else
								; Store other frames
								Index = ArraySize(TempFrames())
								ReDim TempFrames(Index + 1)
								TempFrames(Index) \ File = Frames(f) \ File
								TempFrames(Index) \ Image = Frames(f) \ Image
								TempFrames(Index) \ Sprite = Frames(f) \ Sprite
							EndIf
						Next
						; Copy back the orginal items
						CopyArray(TempFrames(), Frames())
						; Add empty image
						EmptyImage = CreateImage(#PB_Any, Val(GetGadgetText(NewFramesWidthGadget)), Val(GetGadgetText(NewFramesHeightGadget)), 32, #PB_Image_Transparent)
						Index = ArraySize(Frames())
						FrameEditorSelectedBox = Index
						Frames(Index) \ File = "0"
						Frames(Index) \ Image = CopyImage(EmptyImage, #PB_Any)
						Frames(Index) \ Sprite = Sprite
						ReDim Frames(Index + 1)
						FreeImage(EmptyImage)
					Case NewFramesCancelButton
						NewFramesWindowDone = 1
				EndSelect
		EndSelect
	Until NewFramesWindowDone = 1
	DisableWindow(FrameWindow, 0)
	CloseWindow(NewFramesWindow)
	RedrawSpriteFrames(Sprite, 1)	
EndProcedure

; Add a sprite from file
Procedure FrameAddFromFile(FrameWindow, Sprite.s, SelectedFrame)
	
	; Store original framenum in Index for further usage
	Index = SelectedFrame
	
	FileName.s = OpenFileRequester("Select an image", "", "Images (jpg, bmp, png)|*.jpg;*.bmp;*.png|JPG files (*.jpg)|*.jpg|BMP files (*.bmp)|*.bmp|PNG files (*.png)|*.png", 0)
	If FileName <> ""
		; Load the new image
		LoadedImageTemp = LoadImage(#PB_Any, FileName)
		LoadedWidth = ImageWidth(LoadedImageTemp)
		LoadedHeight = ImageHeight(LoadedImageTemp)
		; CONVERT TO 32 BIT TRANSPARENT
		LoadedImage = CreateImage(#PB_Any, LoadedWidth, LoadedHeight, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(LoadedImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(LoadedImageTemp), 0, 0)
		StopDrawing()
		FreeImage(LoadedImageTemp)
		; Define last index/file number
		; Define frame dimensions
		FrameWidth = 0
		FrameHeight = 0
		LastIndex = -1
		LastFile = -1
		FirstFrame = 1
		For c = 0 To ArraySize(Frames()) - 1
			If Frames(c) \ Sprite = Sprite
				FirstFrame = 0
				LastIndex = c
				LastFile = Val(Frames(c) \ File)
				FrameWidth = ImageWidth(Frames(c) \ Image)
				FrameHeight = ImageHeight(Frames(c) \ Image)
			EndIf
		Next
		
		; Check image dimensions if it is not the first frame
		If FirstFrame = 0
			If LoadedWidth <> FrameWidth Or LoadedHeight <> FrameHeight
				; The loaded image dimension is different
				OptionsWindow = OpenWindow(#PB_Any, 0, 0, 300, 300, "Adding new frame", #PB_Window_ScreenCentered | #PB_Window_Tool)
				DisableWindow(FrameWindow, 1)
				StickyWindow(OptionsWindow, 1)
				; OK button
				OptionsWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(OptionsWindow) - 75, WindowHeight(OptionsWindow) - 35, 65, 25, "OK")
				; Cancel
				OptionsWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(OptionsWindow) - 35, 65, 25, "Cancel")
				; Different image text
				TextGadget(#PB_Any, 10, 10, 390, 25, "The dimensions of the new image is different.")
				TextGadget(#PB_Any, 10, 30, 390, 25, "Please specify an action.")
				; Option 1: keep old dimensions
				KeepOldSize = OptionGadget(#PB_Any, 10, 60, 380, 25, "Keep the original image size (" + Str(FrameWidth) + " x " + Str(FrameHeight) + ")")
				UseNewSize = OptionGadget(#PB_Any, 10, 90, 380, 25, "Resize all frames to the new image size (" + Str(LoadedWidth) + " x " + Str(LoadedHeight) + ")")
				SetGadgetState(UseNewSize, 1)
				TextGadget(#PB_Any, 10, 130, 390, 25, "Specify the placement of the images.")
				PlacementLeftTop = OptionGadget(#PB_Any, 10, 160, 380, 25, "Place images at left-top (0, 0)")
				PlacementCenter = OptionGadget(#PB_Any, 10, 190, 380, 25, "Place images in center")
				PlacementStretch = OptionGadget(#PB_Any, 10, 220, 380, 25, "Stretch images")
				SetGadgetState(PlacementStretch, 1)
				OptionsWindowDone = 0
				Repeat
					SetActiveWindow(OptionsWindow)
					Select WaitWindowEvent()
						Case #PB_Event_Gadget
							Select EventGadget()
								Case OptionsWindowOKButton
									
									; Keep original size
									If GetGadgetState(KeepOldSize) = 1
										TempImage = CreateImage(#PB_Any, FrameWidth, FrameHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										If GetGadgetState(PlacementCenter) = 1
											DrawImage(ImageID(LoadedImage), FrameWidth / 2 - ImageWidth(LoadedImage) / 2, FrameHeight / 2 - ImageHeight(LoadedImage) / 2)
										EndIf
										If GetGadgetState(PlacementLeftTop) = 1
											DrawImage(ImageID(LoadedImage), 0, 0)
										EndIf
										If GetGadgetState(PlacementStretch) = 1
											DrawImage(ImageID(LoadedImage), 0, 0, FrameWidth, FrameHeight)
										EndIf
										StopDrawing()
										FreeImage(LoadedImage)
										LoadedImage = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
									
									; Use new size
									If GetGadgetState(UseNewSize) = 1
										; Resize and place old frames
										For r = 0 To ArraySize(Frames()) - 1
											If Frames(r) \ Sprite = Sprite
												
												; Place top left or center
												If GetGadgetState(PlacementLeftTop) = 1 Or GetGadgetState(PlacementCenter) = 1
													TempImage = CreateImage(#PB_Any, LoadedWidth, LoadedHeight, 32, #PB_Image_Transparent)
													StartDrawing(ImageOutput(TempImage))
													DrawingMode(#PB_2DDrawing_AlphaBlend)
													; Left top placement
													If GetGadgetState(PlacementLeftTop) = 1
														DrawImage(ImageID(Frames(r) \ Image), 0, 0)
													EndIf
													; Center placement
													If GetGadgetState(PlacementCenter) = 1
														DrawImage(ImageID(Frames(r) \ Image), LoadedWidth / 2 - FrameWidth / 2, LoadedHeight / 2 - FrameHeight / 2)
													EndIf
													StopDrawing()
													Frames(r) \ Image = CopyImage(TempImage, #PB_Any)
													FreeImage(TempImage)
												EndIf
												
												; Stretch old images to the new loaded size
												If GetGadgetState(PlacementStretch) = 1
													ResizeImage(Frames(r) \ Image, LoadedWidth, LoadedHeight, #PB_Image_Raw)
												EndIf
												
											EndIf
										Next
									EndIf
									
									; Add the new frame
									Index = ArraySize(Frames())
									ReDim Frames(Index + 1)
									Frames(Index) \ File = Str(LastFile + 1)
									Frames(Index) \ Image = CopyImage(LoadedImage, #PB_Any)
									Frames(Index) \ Sprite = Sprite
									
									OptionsWindowDone = 1
									
								Case OptionsWindowCancelButton
									OptionsWindowDone = 1
							EndSelect
					EndSelect
				Until OptionsWindowDone = 1
				DisableWindow(FrameWindow, 0)
				CloseWindow(OptionsWindow)
			Else
				; Add the new frame
				Index = ArraySize(Frames())
				ReDim Frames(Index + 1)
				Frames(Index) \ File = Str(LastFile + 1)
				Frames(Index) \ Image = CopyImage(LoadedImage, #PB_Any)
				Frames(Index) \ Sprite = Sprite
			EndIf
		Else
			; Add the new frame
			Index = ArraySize(Frames())
			ReDim Frames(Index + 1)
			Frames(Index) \ File = Str(LastFile + 1)
			Frames(Index) \ Image = CopyImage(LoadedImage, #PB_Any)
			Frames(Index) \ Sprite = Sprite
		EndIf
		
		; Free the temp image
		If IsImage(LoadedImage)
			FreeImage(LoadedImage)
		EndIf
		
		FrameEditorSelectedBox = Index
		RedrawSpriteFrames(Sprite, 1)
		
	EndIf
EndProcedure

; Save frame as png
Procedure FrameSavePNG(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	ImageNumber = 0
	FrameWidth = 0
	FrameHeight = 0
	For c = 0 To ArraySize(Frames()) - 1
		If Frames(c) \ Sprite = Sprite
			ImageNumber = ImageNumber + 1
			FrameWidth = ImageWidth(Frames(c) \ Image)
			FrameHeight = ImageHeight(Frames(c) \ Image)
		EndIf
	Next
	
	FileName.s = SaveFileRequester("Save sprite as PNG strip", GetCurrentDirectory() + Sprite + "_strip" + Str(ImageNumber), "PNG Images (*.png)|*.png", 0)
	If FileName <> "" And FrameWidth > 0 And FrameHeight > 0
		CombinedImage = CreateImage(#PB_Any, FrameWidth * ImageNumber, FrameHeight, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(CombinedImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For c = 0 To ArraySize(Frames()) - 1
			If Frames(c) \ Sprite = Sprite
				DrawImage(ImageID(Frames(c) \ Image), SN * FrameWidth, 0)
				SN = SN + 1
			EndIf
		Next
		StopDrawing()
		SaveImage(CombinedImage, FileName + ".png", #PB_ImagePlugin_PNG)
		FreeImage(CombinedImage)
	EndIf	
EndProcedure

; Duplicate frame
Procedure FrameDuplicate(FrameWindow, Sprite.s, SelectedFrame)
	If SelectedFrame > -1
		LastFileName.s = ""
		For w = 0 To ArraySize(Frames()) - 1
			If Frames(w) \ Sprite = Sprite
				LastFileName = Frames(w) \ File
			EndIf
		Next
		; Add new frame
		Index = ArraySize(Frames())
		Frames(Index) \ File = Str(Val(LastFileName) + 1)
		Frames(Index) \ Image = CopyImage(Frames(SelectedFrame) \ Image, #PB_Any)
		Frames(Index) \ Sprite = Sprite
		ReDim Frames(Index + 1)
		FrameEditorSelectedBox = Index
		RedrawSpriteFrames(Sprite, 1)	
	EndIf
EndProcedure

; Move frame to left
Procedure FrameMoveLeft(FrameWindow, Sprite.s, SelectedFrame)
	If SelectedFrame > -1
		If SelectedFrame - 1 > -1
			If Frames(SelectedFrame - 1) \ Sprite = Sprite
				
				TempFile.s = Frames(SelectedFrame - 1) \ File
				TempImage = Frames(SelectedFrame - 1) \ Image
				TempSprite.s = Frames(SelectedFrame - 1) \ Sprite
				
				Frames(SelectedFrame - 1) \ File = Frames(SelectedFrame) \ File
				Frames(SelectedFrame - 1) \ Image = Frames(SelectedFrame) \ Image
				Frames(SelectedFrame - 1) \ Sprite = Frames(SelectedFrame) \ Sprite
				
				Frames(SelectedFrame) \ File = TempFile
				Frames(SelectedFrame) \ Image = TempImage
				Frames(SelectedFrame) \ Sprite = TempSprite
				
				FrameEditorSelectedBox = SelectedFrame - 1
				
			EndIf
		EndIf
		
		RedrawSpriteFrames(Sprite, 1)
	EndIf
EndProcedure

; Move frame to right
Procedure FrameMoveRight(FrameWindow, Sprite.s, SelectedFrame)
	If SelectedFrame > -1
		If SelectedFrame < ArraySize(Frames()) - 1
			If Frames(SelectedFrame + 1) \ Sprite = Sprite
				
				TempFile.s = Frames(SelectedFrame + 1) \ File
				TempImage = Frames(SelectedFrame + 1) \ Image
				TempSprite.s = Frames(SelectedFrame + 1) \ Sprite
				
				Frames(SelectedFrame + 1) \ File = Frames(SelectedFrame) \ File
				Frames(SelectedFrame + 1) \ Image = Frames(SelectedFrame) \ Image
				Frames(SelectedFrame + 1) \ Sprite = Frames(SelectedFrame) \ Sprite
				
				Frames(SelectedFrame) \ File = TempFile
				Frames(SelectedFrame) \ Image = TempImage
				Frames(SelectedFrame) \ Sprite = TempSprite
				
				FrameEditorSelectedBox = SelectedFrame + 1
				
			EndIf
		EndIf
		RedrawSpriteFrames(Sprite, 1)
	EndIf						
EndProcedure

Procedure UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
	If IsImage(DataImage) : FreeImage(DataImage) : EndIf
	If IsImage(Image)
		DataImage = CopyImage(Image, #PB_Any)
		ResizeImage(DataImage, ImageWidth * Zoom, ImageHeight * Zoom, #PB_Image_Raw)
	EndIf
EndProcedure

Procedure UndoReset(Image, UndoImage)
	If IsImage(UndoImage) : FreeImage(UndoImage) : EndIf
	UndoImage = CopyImage(Image, #PB_Any)
EndProcedure

Procedure Undo(Image, UndoImage)
	If IsImage(Image) : FreeImage(Image) : EndIf
	If IsImage(UndoImage)
		Image = CopyImage(UndoImage, #PB_Any)
	EndIf
	UndoReset(Image, UndoImage)
EndProcedure

Procedure FrameEditNew(Image, ImageWidth, ImageHeight, DataImage, Zoom, UndoImage)
	If Confirm("Confirm", "Create a new empty image?") = 1
		StartDrawing(ImageOutput(Image))
		DrawingMode(#PB_2DDrawing_AllChannels)
		Box(0, 0, ImageWidth, ImageHeight, RGBA(0,0,0,0))
		StopDrawing()
		If IsImage(TempImage) : FreeImage(TempImage) : EndIf
		UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
		UndoReset(Image, UndoImage)
	EndIf	
EndProcedure

Procedure FrameEditOpen(Image, ImageWidth, ImageHeight, DataImage, Zoom, UndoImage)
	FileName.s = OpenFileRequester("Select an image", "", "Images (jpg, bmp, png)|*.jpg;*.bmp;*.png|JPG files (*.jpg)|*.jpg|BMP files (*.bmp)|*.bmp|PNG files (*.png)|*.png", 0)
	If FileName <> ""
		I = LoadImage(#PB_Any, FileName)
		If IsImage(I)
			If IsImage(Image) : FreeImage(Image) : EndIf
			ResizeImage(I, ImageWidth, ImageHeight)
			Image = CopyImage(I, #PB_Any)
			FreeImage(I)
			UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
			UndoReset(Image, UndoImage)
		EndIf
	EndIf	
EndProcedure

Procedure FrameEditSave(Image, Sprite.s)
	FileName.s = SaveFileRequester("Save image as PNG ", GetCurrentDirectory() + Sprite, "PNG Images (*.png)|*.png", 0)
	If FileName <> ""
		SaveImage(Image, FileName + ".png", #PB_ImagePlugin_PNG)
	EndIf	
EndProcedure

; Edit frame
Procedure FrameEdit(FrameWindow, Sprite.s, SelectedFrame)
	
	; No frame is selected
	If SelectedFrame = -1
		ProcedureReturn
	EndIf
	
	Dim ImageList.i(0)
	MaxFrames = 0
	CurrentFrame = 0
	
	; Find the image
	Image = -1
	For f = 0 To ArraySize(Frames()) - 1
		If Frames(f) \ Sprite = Sprite
			index = ArraySize(ImageList())
			ImageList(index) = f
			ReDim ImageList(index + 1)
			MaxFrames = MaxFrames + 1
		EndIf
		If f = SelectedFrame
			CurrentFrame = index
			; Free the image
			If IsImage(Frames(f) \ Image)
				Image = Frames(f) \ Image
			EndIf
		EndIf
	Next		
	
	; Image does not exists
	If Image = -1
		ProcedureReturn
	EndIf
	
	MX = 0
	MY = 0
	MXP = 0
	MYP = 0
	MXS = 0
	MYS = 0
	DataImage = CopyImage(Image, #PB_Any)
	UndoImage = CopyImage(Image, #PB_Any)
	TransImage = CopyImage(#TransGrid, #PB_Any)
	ImageWidth = ImageWidth(Image)
	ImageHeight = ImageHeight(Image)
	Zoom = 1
	Grid = 1
	Alpha = 255
	Color1 = RGBA(255, 255, 255, Alpha)
	Color2 = RGBA(0, 0, 0, Alpha)
	Mode = #PB_2DDrawing_AllChannels ; (blending: #PB_2DDrawing_AlphaBlend)
	LeftButton = 0
	RightButton = 0
	
	ResizeImage(DataImage, ImageWidth * Zoom, ImageHeight * Zoom, #PB_Image_Raw)
	ResizeImage(TransImage, Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), #PB_Image_Raw)
	
	Action.s = "Draw"
	
	; IMAGE EDITOR...
	EditorWindow = OpenWindow(#PB_Any, 0, 0, 760, 600, "Image editor - " + Sprite, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget, WindowID(FrameWindow))
	DisableWindow(#MainWindow, 1)
	
	CreateImageMenu(#ImageEditorMenu, WindowID(EditorWindow))
	MenuTitle("File")
	MenuItem(#ImageEditorMenuNew, "New..." + Chr(9) + "Ctrl + N", ImageID(#NewIcon))
	MenuItem(#ImageEditorMenuOpen, "Open..." + Chr(9) + "Ctrl + O", ImageID(#OpenIcon))
	MenuBar()
	MenuItem(#ImageEditorMenuSaveAsPNG, "Save as PNG image..." + Chr(9) + "Ctrl + S", ImageID(#SaveIcon))
	MenuBar()
	MenuItem(#ImageEditorMenuClose, "Done" + Chr(9) + "Alt + F4")
	
	AddKeyboardShortcut(EditorWindow, #PB_Shortcut_Control | #PB_Shortcut_N, #ImageEditorMenuNew)
	AddKeyboardShortcut(EditorWindow, #PB_Shortcut_Control | #PB_Shortcut_O, #ImageEditorMenuOpen)
	AddKeyboardShortcut(EditorWindow, #PB_Shortcut_Control | #PB_Shortcut_S, #ImageEditorMenuSaveAsPNG)
	AddKeyboardShortcut(EditorWindow, #PB_Shortcut_Alt | #PB_Shortcut_F4, #ImageEditorMenuClose)
	
	AddWindowTimer(EditorWindow, 100001, 100)
	
	; TOOLBAR
	DoneButton = ButtonGadget(#PB_Any, 35, 5, 60, 25, "Done")
	NewButton = ButtonImageGadget(#PB_Any, 105, 5, 25, 25, ImageID(#NewIcon)) : GadgetToolTip(NewButton, "Create a new, empty image")
	OpenButton = ButtonImageGadget(#PB_Any, 135, 5, 25, 25, ImageID(#OpenIcon)) : GadgetToolTip(OpenButton, "Open an image")
	SaveButton = ButtonImageGadget(#PB_Any, 165, 5, 25, 25, ImageID(#SaveAsIcon)) : GadgetToolTip(SaveButton, "Save image as PNG")
	
	PrevFrame = ButtonGadget(#PB_Any, 200, 5, 25, 25, "<") : GadgetToolTip(PrevFrame, "Show the previous image in the animation sequence")
	NextFrame = ButtonGadget(#PB_Any, 230, 5, 25, 25, ">") : GadgetToolTip(NextFrame, "Show the next image in the animation sequence")
	
	GridButton = ButtonImageGadget(#PB_Any, 290, 5, 25, 25, ImageID(#GridIcon), #PB_Button_Toggle) : GadgetToolTip(GridButton, "Toggle turn on/off the grid")
	SetGadgetState(GridButton, Grid)
	
	ZoomMinus = ButtonImageGadget(#PB_Any, 320, 5, 25, 25, ImageID(#ZoomOutIcon)) : GadgetToolTip(ZoomMinus, "Zoom out")
	ZoomReset = ButtonImageGadget(#PB_Any, 350, 5, 25, 25, ImageID(#ZoomResetIcon)) : GadgetToolTip(ZoomReset, "Reset zoom (original size)")
	ZoomPlus = ButtonImageGadget(#PB_Any, 380, 5, 25, 25, ImageID(#ZoomInIcon)) : GadgetToolTip(ZoomPlus, "Zoom in")
	
	UndoButton = ButtonGadget(#PB_Any, 460, 5, 60, 25, "Undo") : GadgetToolTip(UndoButton, "Undo the last change")
	
	; LEFT SIDE TOOLS
	DrawButton = ButtonImageGadget(#PB_Any, 5, 35, 25, 25, ImageID(#EditIcon), #PB_Button_Toggle) : GadgetToolTip(DrawButton, "Draw on the image")
	SetGadgetState(DrawButton, 1)
	EraseButton = ButtonImageGadget(#PB_Any, 5, 65, 25, 25, ImageID(#EraseIcon), #PB_Button_Toggle) : GadgetToolTip(EraseButton, "Erase")
	PickerButton = ButtonImageGadget(#PB_Any, 5, 95, 25, 25, ImageID(#PickerIcon), #PB_Button_Toggle) : GadgetToolTip(PickerButton, "Pick a color from the image")
	LineButton = ButtonImageGadget(#PB_Any, 5, 125, 25, 25, ImageID(#LineIcon), #PB_Button_Toggle) : GadgetToolTip(LineButton, "Draw a line")
	BoxButton = ButtonImageGadget(#PB_Any, 5, 155, 25, 25, ImageID(#BoxIcon), #PB_Button_Toggle) : GadgetToolTip(BoxButton, "Draw a rectangle")
	CircleButton = ButtonImageGadget(#PB_Any, 5, 185, 25, 25, ImageID(#CircleIcon), #PB_Button_Toggle) : GadgetToolTip(CircleButton, "Draw an ellipse")
	FillButton = ButtonImageGadget(#PB_Any, 5, 215, 25, 25, ImageID(#FillIcon), #PB_Button_Toggle) : GadgetToolTip(FillButton, "Fill an area")
	
	; CANVAS
	CanvasScroller = ScrollAreaGadget(#PB_Any, 35, 35, 680, 480, ImageWidth * Zoom, ImageHeight * Zoom, 16, #PB_ScrollArea_Flat)
	Canvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth * Zoom, ImageHeight * Zoom, #PB_Canvas_ClipMouse | #PB_Canvas_Keyboard)
	StartDrawing(CanvasOutput(Canvas))
	DrawingMode(#PB_2DDrawing_Default)
	DrawImage(ImageID(#TransGrid), 0, 0)
	DrawingMode(#PB_2DDrawing_AlphaBlend)
	DrawImage(ImageID(DataImage), 0, 0)
	StopDrawing()
	CloseGadgetList()
	SetActiveGadget(Canvas)
	
	; RIGHT SIDE TOOLS
	RightTools = ContainerGadget(#PB_Any, 700, 35, 100, 480, #PB_Container_Raised)
	LeftColorPicker = CanvasGadget(#PB_Any, 5, 5, 40, 30, #PB_Canvas_Border) : GadgetToolTip(LeftColorPicker, "Click to select the left button color")
	RightColorPicker = CanvasGadget(#PB_Any, 50, 5, 40, 30, #PB_Canvas_Border) : GadgetToolTip(RightColorPicker, "Click to select the right button color")
	
	ColorMatrix = CanvasGadget(#PB_Any, 5, 40, 85, 170, #PB_Canvas_Border | #PB_Canvas_ClipMouse) : GadgetToolTip(ColorMatrix, "Pick a color")
	ColorRainbow = CanvasGadget(#PB_Any, 5, 215, 85, 132, #PB_Canvas_Border | #PB_Canvas_ClipMouse) : GadgetToolTip(ColorRainbow, "Pick a color")
	
	TextGadget(#PB_Any, 5, 352, 95, 25, "Opacity")
	AlphaSpinner = SpinGadget(#PB_Any, 5, 380, 85, 25, 0, 255, #PB_Spin_Numeric) : SetGadgetText(AlphaSpinner, Str(Alpha)) : GadgetToolTip(AlphaSpinner, "Set the opacity")
	AlphaPicker = CanvasGadget(#PB_Any, 5, 410, 85, 20, #PB_Canvas_ClipMouse) : GadgetToolTip(AlphaPicker, "Use this slider to select the opacity")
	
	TextGadget(#PB_Any, 5, 435, 85, 25, "Color mode")
	BlendMode = ButtonGadget(#PB_Any, 5, 465, 85, 20, "Alpha blend", #PB_Button_Toggle) : GadgetToolTip(BlendMode, "The drawing color will be blended onto the actual color")
	ReplaceMode = ButtonGadget(#PB_Any, 5, 485, 85, 20, "Replace color", #PB_Button_Toggle) : GadgetToolTip(ReplaceMode, "The actual color will be replaced with the drawing color")
	SetGadgetState(ReplaceMode, 1)
	
	CloseGadgetList() ; Close right panel tools
	
	; STATUS BAR
	StatusBar = ContainerGadget(#PB_Any, 35, 510, 680, 30)
	Info1 = TextGadget(#PB_Any, 5, 2, 200, 23, "")
	Info2 = TextGadget(#PB_Any, 205, 2, 200, 23, "")
	Info3 = TextGadget(#PB_Any, 405, 2, 200, 23, "")
	CloseGadgetList()
	
	StartDrawing(CanvasOutput(ColorMatrix))
	DrawingMode(#PB_2DDrawing_Default)
	DrawImage(ImageID(#ColorMatrix), 0, 0)
	StopDrawing()
	
	StartDrawing(CanvasOutput(ColorRainbow))
	DrawingMode(#PB_2DDrawing_Default)
	DrawImage(ImageID(#ColorRainbow), 0, 0)
	StopDrawing()	
	
	Done = 0
	Repeat
		Select WaitWindowEvent()
				
			Case #PB_Event_Menu
				Select EventMenu()
					Case #ImageEditorMenuNew : FrameEditNew(Image, ImageWidth, ImageHeight, DataImage, Zoom, UndoImage)
					Case #ImageEditorMenuOpen : FrameEditOpen(Image, ImageWidth, ImageHeight, DataImage, Zoom, UndoImage)
					Case #ImageEditorMenuSaveAsPNG : FrameEditSave(Image, Sprite)
					Case #ImageEditorMenuClose : Done = 1
				EndSelect
				
			Case #PB_Event_MaximizeWindow, #PB_Event_SizeWindow, #PB_Event_MinimizeWindow
				ResizeGadget(CanvasScroller, #PB_Ignore, #PB_Ignore, WindowWidth(EditorWindow) - 150, WindowHeight(EditorWindow) - 10 - MenuHeight() - 30 - 25)
				ResizeGadget(RightTools, WindowWidth(EditorWindow) - 105, #PB_Ignore, #PB_Ignore, WindowHeight(EditorWindow) - 10 - MenuHeight() - 30)
				ResizeGadget(StatusBar, #PB_Ignore, WindowHeight(EditorWindow) - MenuHeight() - 30, GadgetWidth(CanvasScroller), #PB_Ignore)
				
			Case #PB_Event_Timer
				
				; Left color picker
				StartDrawing(CanvasOutput(LeftColorPicker))
				DrawingMode(#PB_2DDrawing_Default)
				Box(0, 0, 40, 30, RGB(Red(Color1), Green(Color1), Blue(Color1)))
				StopDrawing()
				
				; Right color picker
				StartDrawing(CanvasOutput(RightColorPicker))
				DrawingMode(#PB_2DDrawing_Default)
				Box(0, 0, 40, 30, RGB(Red(Color2), Green(Color2), Blue(Color2)))
				StopDrawing()
				
				; Alpha picker
				StartDrawing(CanvasOutput(AlphaPicker))
				DrawingMode(#PB_2DDrawing_Default)
				Box(0, 0, 85, 20, RGB(255, 255, 255))
				a.f = (Alpha / 255) * 85
				Box(0, 0, a, 20, RGB(100, 200, 100))
				DrawingMode(#PB_2DDrawing_Outlined)
				Box(0, 0, 85, 19, RGB(0, 0, 0))
				StopDrawing()	
				
				; DRAW THE RESIZED IMAGE
				StartDrawing(CanvasOutput(Canvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(TransImage), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(DataImage), 0, 0)
				
				; GRID
				If Zoom > 3 And Grid
					DrawingMode(#PB_2DDrawing_XOr)
					For gs = 0 To ImageWidth : Line(gs * zoom, 0, 1, ImageHeight * Zoom) : Next
					For gs = 0 To ImageHeight : Line(0, gs * Zoom, ImageWidth * Zoom, 1) : Next							
					DrawingMode(#PB_2DDrawing_Default)
				EndIf
				
				StopDrawing()
				
				SetGadgetText(Info1, "Dimension: " + Str(ImageWidth) + " x " + Str(ImageHeight))
				SetGadgetText(Info2, "X:Y = " + Str(MX) + ":" + Str(MY))
				SetGadgetText(Info3, "Zoom: " + Str(Zoom * 100) + "%")
				
				MXP = MX
				MYP = MY
				
			Case #PB_Event_Gadget
				Select EventGadget()
						
					Case DoneButton : Done = 1
						
					Case NewButton
						FrameEditNew(Image, ImageWidth, ImageHeight, DataImage, Zoom, UndoImage)
						
					Case OpenButton
						FrameEditOpen(Image, ImageWidth, ImageHeight, DataImage, Zoom, UndoImage)
						
					Case SaveButton
						FrameEditSave(Image, Sprite)
						
					Case UndoButton
						Undo(Image, UndoImage)
						UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
						
					Case DrawButton
						Action = "Draw"
						SetGadgetState(DrawButton, 1)
						SetGadgetState(EraseButton, 0)
						SetGadgetState(PickerButton, 0)
						SetGadgetState(LineButton, 0)
						SetGadgetState(BoxButton, 0)
						SetGadgetState(CircleButton, 0)
						SetGadgetState(FillButton, 0)
						
					Case EraseButton
						Action = "Erase"
						SetGadgetState(DrawButton, 0)
						SetGadgetState(EraseButton, 1)
						SetGadgetState(PickerButton, 0)
						SetGadgetState(LineButton, 0)
						SetGadgetState(BoxButton, 0)
						SetGadgetState(CircleButton, 0)
						SetGadgetState(FillButton, 0)
						
					Case PickerButton
						Action = "Picker"
						SetGadgetState(DrawButton, 0)
						SetGadgetState(EraseButton, 0)
						SetGadgetState(PickerButton, 1)
						SetGadgetState(LineButton, 0)
						SetGadgetState(BoxButton, 0)
						SetGadgetState(CircleButton, 0)
						SetGadgetState(FillButton, 0)
						
					Case LineButton
						Action = "Line"
						SetGadgetState(DrawButton, 0)
						SetGadgetState(EraseButton, 0)
						SetGadgetState(PickerButton, 0)
						SetGadgetState(LineButton, 1)
						SetGadgetState(BoxButton, 0)
						SetGadgetState(CircleButton, 0)
						SetGadgetState(FillButton, 0)
						If IsImage(TempImage) : FreeImage(TempImage) : EndIf
						TempImage = CopyImage(Image, #PB_Any)
						
					Case BoxButton
						Action = "Rectangle"
						SetGadgetState(DrawButton, 0)
						SetGadgetState(EraseButton, 0)
						SetGadgetState(PickerButton, 0)
						SetGadgetState(LineButton, 0)
						SetGadgetState(BoxButton, 1)
						SetGadgetState(CircleButton, 0)
						SetGadgetState(FillButton, 0)
						If IsImage(TempImage) : FreeImage(TempImage) : EndIf
						TempImage = CopyImage(Image, #PB_Any)
						
					Case CircleButton
						Action = "Circle"
						SetGadgetState(DrawButton, 0)
						SetGadgetState(EraseButton, 0)
						SetGadgetState(PickerButton, 0)
						SetGadgetState(LineButton, 0)
						SetGadgetState(BoxButton, 0)
						SetGadgetState(CircleButton, 1)
						SetGadgetState(FillButton, 0)
						If IsImage(TempImage) : FreeImage(TempImage) : EndIf
						TempImage = CopyImage(Image, #PB_Any)
						
					Case FillButton
						Action = "Fill"
						SetGadgetState(DrawButton, 0)
						SetGadgetState(EraseButton, 0)
						SetGadgetState(PickerButton, 0)
						SetGadgetState(LineButton, 0)
						SetGadgetState(BoxButton, 0)
						SetGadgetState(CircleButton, 0)
						SetGadgetState(FillButton, 1)
						
					Case PrevFrame
						CurrentFrame = CurrentFrame - 1
						If CurrentFrame < 0 : CurrentFrame = 0 : EndIf
						Image = Frames(ImageList(CurrentFrame)) \ Image
						UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
						UndoReset(Image, UndoImage)
						
					Case NextFrame
						CurrentFrame = CurrentFrame + 1
						If CurrentFrame > MaxFrames - 1 : CurrentFrame = MaxFrames - 1: EndIf
						Image = Frames(ImageList(CurrentFrame)) \ Image
						UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
						UndoReset(Image, UndoImage)
						
					Case GridButton
						Grid = GetGadgetState(GridButton)
						
					Case ZoomPlus
						ZoomPrev = Zoom
						Zoom = Zoom + 1
						; LIMIT MAX ZOOM (AVOID SLOWDOWN)
						If ImageWidth * Zoom > 1024 Or ImageHeight * Zoom > 1024
							Zoom = ZoomPrev
						EndIf
						UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
						FreeImage(TransImage)
						TransImage = CopyImage(#TransGrid, #PB_Any)
						ResizeImage(TransImage, Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), #PB_Image_Raw)
						ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, ImageWidth * Zoom, ImageHeight * Zoom)
						SetGadgetAttribute(CanvasScroller, #PB_ScrollArea_InnerWidth, ImageWidth * Zoom)
						SetGadgetAttribute(CanvasScroller, #PB_ScrollArea_InnerHeight, ImageHeight * Zoom)
						
					Case ZoomMinus
						Zoom = Zoom - 1
						If Zoom < 1 : Zoom = 1 : EndIf
						UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
						FreeImage(TransImage)
						TransImage = CopyImage(#TransGrid, #PB_Any)
						ResizeImage(TransImage, Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), #PB_Image_Raw)
						ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, ImageWidth * Zoom, ImageHeight * Zoom)
						SetGadgetAttribute(CanvasScroller, #PB_ScrollArea_InnerWidth, ImageWidth * Zoom)
						SetGadgetAttribute(CanvasScroller, #PB_ScrollArea_InnerHeight, ImageHeight * Zoom)
						
					Case ZoomReset
						Zoom = 1
						UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
						FreeImage(TransImage)
						TransImage = CopyImage(#TransGrid, #PB_Any)
						ResizeImage(TransImage, Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), #PB_Image_Raw)
						ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, ImageWidth * Zoom, ImageHeight * Zoom)
						SetGadgetAttribute(CanvasScroller, #PB_ScrollArea_InnerWidth, ImageWidth * Zoom)
						SetGadgetAttribute(CanvasScroller, #PB_ScrollArea_InnerHeight, ImageHeight * Zoom)
						
					Case Canvas
						MX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX) / Zoom
						MY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY) / Zoom
						Select EventType()
							Case #PB_EventType_MouseWheel
								
								; RESIZE THE CANVAS, IMAGE, BACKGROUND
								Wheel = GetGadgetAttribute(Canvas, #PB_Canvas_WheelDelta)
								ZoomPrev = Zoom
								Zoom = Zoom - Wheel
								If Zoom < 1 : Zoom = 1 : EndIf
								; LIMIT MAX ZOOM (AVOID SLOWDOWN)
								If ImageWidth * Zoom > 1024 Or ImageHeight * Zoom > 1024
									Zoom = ZoomPrev
								EndIf
								UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
								FreeImage(TransImage)
								TransImage = CopyImage(#TransGrid, #PB_Any)
								ResizeImage(TransImage, Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), Max(800, Max(ImageWidth * Zoom, ImageHeight * Zoom)), #PB_Image_Raw)
								ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, ImageWidth * Zoom, ImageHeight * Zoom)
								SetGadgetAttribute(CanvasScroller, #PB_ScrollArea_InnerWidth, ImageWidth * Zoom)
								SetGadgetAttribute(CanvasScroller, #PB_ScrollArea_InnerHeight, ImageHeight * Zoom)
								
							Case #PB_EventType_LeftButtonDown
								LeftButton = 1
								Select Action
									Case "Draw"
										UndoReset(Image, UndoImage)
										StartDrawing(ImageOutput(Image))
										DrawingMode(Mode)
										Plot(MX, MY, Color1)
										StopDrawing()
										UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
									Case "Erase"
										UndoReset(Image, UndoImage)
										StartDrawing(ImageOutput(Image))
										DrawingMode(#PB_2DDrawing_AllChannels)
										CurrentColor = Point(MX, MY)
										Plot(MX, MY, RGBA(Red(CurrentColor), Green(CurrentColor), Blue(CurrentColor), 255 - Alpha))
										StopDrawing()
										UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
									Case "Picker"
										StartDrawing(ImageOutput(Image))
										DrawingMode(#PB_2DDrawing_AllChannels)
										Color1 = Point(MX, MY)
										Alpha = Alpha(Color1)
										StopDrawing()
										SetGadgetText(AlphaSpinner, Str(Alpha))
									Case "Line", "Rectangle", "Circle"
										UndoReset(Image, UndoImage)
										MXS = MX
										MYS = MY
										If IsImage(TempImage) : FreeImage(TempImage) : EndIf
										TempImage = CopyImage(Image, #PB_Any)
									Case "Fill"
										UndoReset(Image, UndoImage)
										StartDrawing(ImageOutput(Image))
										DrawingMode(#PB_2DDrawing_AllChannels)
										FillArea(MX, MY, -1, Color1)
										StopDrawing()
										UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
								EndSelect
								
							Case #PB_EventType_LeftButtonUp
								Select Action
									Case "Line", "Rectangle", "Circle"
										If IsImage(Image) : FreeImage(Image) : EndIf
										If IsImage(TempImage)
											Image = CopyImage(TempImage, #PB_Any)
											FreeImage(TempImage)
										EndIf
										UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
								EndSelect
								LeftButton = 0
								
							Case #PB_EventType_RightButtonDown
								RightButton = 1
								Select Action
									Case "Draw"
										UndoReset(Image, UndoImage)
										StartDrawing(ImageOutput(Image))
										DrawingMode(Mode)
										Plot(MX, MY, Color2)
										StopDrawing()
										UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
									Case "Erase"
										UndoReset(Image, UndoImage)										
										StartDrawing(ImageOutput(Image))
										DrawingMode(#PB_2DDrawing_AllChannels)
										CurrentColor = Point(MX, MY)
										Plot(MX, MY, RGBA(Red(CurrentColor), Green(CurrentColor), Blue(CurrentColor), 255 - Alpha))
										StopDrawing()
										UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
									Case "Picker"
										StartDrawing(ImageOutput(Image))
										DrawingMode(#PB_2DDrawing_AllChannels)
										Color2 = Point(MX, MY)
										Alpha = Alpha(Color2)
										StopDrawing()
										SetGadgetText(AlphaSpinner, Str(Alpha))
									Case "Line", "Rectangle", "Circle"
										UndoReset(Image, UndoImage)
										MXS = MX
										MYS = MY
										If IsImage(TempImage) : FreeImage(TempImage) : EndIf
										TempImage = CopyImage(Image, #PB_Any)
									Case "Fill"
										UndoReset(Image, UndoImage)
										StartDrawing(ImageOutput(Image))
										DrawingMode(#PB_2DDrawing_AllChannels)
										FillArea(MX, MY, -1, Color2)
										StopDrawing()
										UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
								EndSelect
								
							Case #PB_EventType_RightButtonUp
								Select Action
									Case "Line", "Rectangle", "Circle"
										If IsImage(Image) : FreeImage(Image) : EndIf
										If IsImage(TempImage)
											Image = CopyImage(TempImage, #PB_Any)
											FreeImage(TempImage)
										EndIf
										UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
								EndSelect
								RightButton = 0
								
							Case #PB_EventType_MouseEnter
								SetActiveGadget(Canvas)

							Case #PB_EventType_MouseMove
								Select Action
									Case "Draw"
										If LeftButton Or RightButton
											NewColor = Color1
											If RightButton : NewColor = Color2 : EndIf
											StartDrawing(ImageOutput(Image))
											DrawingMode(Mode)
											LineXY(MXP, MYP, MX, MY, NewColor)
											StopDrawing()
											UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
										EndIf
									Case "Erase"
										If LeftButton Or RightButton
											StartDrawing(ImageOutput(Image))
											DrawingMode(#PB_2DDrawing_AllChannels)
											CurrentColor = Point(MX, MY)
											Plot(MX, MY, RGBA(Red(CurrentColor), Green(CurrentColor), Blue(CurrentColor), 255 - Alpha))
											StopDrawing()
											UpdateFrameEditorCanvasImage(Image, ImageWidth, ImageHeight, DataImage, Zoom)
										EndIf
									Case "Picker"
										If LeftButton
											StartDrawing(ImageOutput(Image))
											DrawingMode(#PB_2DDrawing_AllChannels)
											Color1 = Point(MX, MY)
											Alpha = Alpha(Color1)
											StopDrawing()
										EndIf
										If RightButton
											StartDrawing(ImageOutput(Image))
											DrawingMode(#PB_2DDrawing_AllChannels)
											Color2 = Point(MX, MY)
											Alpha = Alpha(Color2)
											StopDrawing()
										EndIf
										SetGadgetText(AlphaSpinner, Str(Alpha))
									Case "Line"
										If LeftButton
											LineColor = Color1
										Else
											LineColor = Color2
										EndIf
										If LeftButton Or RightButton
											If IsImage(TempImage) : FreeImage(TempImage) : EndIf
											TempImage = CopyImage(Image, #PB_Any)
											StartDrawing(ImageOutput(TempImage))
											DrawingMode(Mode)
											LineXY(MXS, MYS, MX, MY, LineColor)
											StopDrawing()
											UpdateFrameEditorCanvasImage(TempImage, ImageWidth, ImageHeight, DataImage, Zoom)
										EndIf
									Case "Rectangle"
										If LeftButton
											LineColor = Color1
										Else
											LineColor = Color2
										EndIf
										If LeftButton Or RightButton
											If IsImage(TempImage) : FreeImage(TempImage) : EndIf
											TempImage = CopyImage(Image, #PB_Any)
											StartDrawing(ImageOutput(TempImage))
											DrawingMode(Mode)
											Box(MXS, MYS, MX - MXS + 1, MY - MYS + 1, LineColor)
											StopDrawing()
											UpdateFrameEditorCanvasImage(TempImage, ImageWidth, ImageHeight, DataImage, Zoom)
										EndIf
									Case "Circle"
										If LeftButton
											LineColor = Color1
										Else
											LineColor = Color2
										EndIf
										If LeftButton Or RightButton
											If IsImage(TempImage) : FreeImage(TempImage) : EndIf
											TempImage = CopyImage(Image, #PB_Any)
											StartDrawing(ImageOutput(TempImage))
											DrawingMode(Mode)
											Ellipse(MXS, MYS, MX - MXS, MY - MYS, LineColor)
											StopDrawing()
											UpdateFrameEditorCanvasImage(TempImage, ImageWidth, ImageHeight, DataImage, Zoom)
										EndIf
								EndSelect
								
						EndSelect
						
						Case LeftColorPicker
							Select EventType()
								Case #PB_EventType_MouseEnter
									SetActiveGadget(LeftColorPicker)
								Case #PB_EventType_LeftButtonDown
									col = ColorRequester(RGB(Red(Color1), Green(Color1), Blue(Color1)))
									If col > -1 : Color1 = RGBA(Red(col), Green(col), Blue(col), Alpha) : EndIf
							EndSelect
							
						Case RightColorPicker
							Select EventType()
								Case #PB_EventType_MouseEnter
									SetActiveGadget(RightColorPicker)
								Case #PB_EventType_LeftButtonDown
									col = ColorRequester(RGB(Red(Color2), Green(Color2), Blue(Color2)))
									If col > -1 : Color2 = RGBA(Red(col), Green(col), Blue(col), Alpha) : EndIf
							EndSelect
							
						Case ColorMatrix
							MX = GetGadgetAttribute(ColorMatrix, #PB_Canvas_MouseX)
							MY = GetGadgetAttribute(ColorMatrix, #PB_Canvas_MouseY)
							Select EventType()
								Case #PB_EventType_MouseEnter
									SetActiveGadget(ColorMatrix)
								Case #PB_EventType_LeftButtonUp
									LeftButton = 0
								Case #PB_EventType_RightButtonUp
									RightButton = 0
								Case #PB_EventType_LeftButtonDown
									LeftButton = 1
									StartDrawing(CanvasOutput(ColorMatrix)) : DrawingMode(#PB_2DDrawing_AllChannels) : C = Point(MX, MY) : StopDrawing()
									Color1 = RGBA(Red(c), Green(c), Blue(c), Alpha)
								Case #PB_EventType_RightButtonDown
									RightButton = 1
									StartDrawing(CanvasOutput(ColorMatrix)) : DrawingMode(#PB_2DDrawing_AllChannels) : C = Point(MX, MY) : StopDrawing()
									Color2 = RGBA(Red(c), Green(c), Blue(c), Alpha)
								Case #PB_EventType_MouseMove
									If LeftButton
										StartDrawing(CanvasOutput(ColorMatrix)) : DrawingMode(#PB_2DDrawing_AllChannels) : C = Point(MX, MY) : StopDrawing()
										Color1 = RGBA(Red(c), Green(c), Blue(c), Alpha)
									EndIf
									If RightButton
										StartDrawing(CanvasOutput(ColorMatrix)) : DrawingMode(#PB_2DDrawing_AllChannels) : C = Point(MX, MY) : StopDrawing()
										Color2 = RGBA(Red(c), Green(c), Blue(c), Alpha)
									EndIf
							EndSelect
							
						Case ColorRainbow
							MX = GetGadgetAttribute(ColorRainbow, #PB_Canvas_MouseX)
							MY = GetGadgetAttribute(ColorRainbow, #PB_Canvas_MouseY)
							Select EventType()
								Case #PB_EventType_MouseEnter
									SetActiveGadget(ColorRainbow)
								Case #PB_EventType_LeftButtonUp
									LeftButton = 0
								Case #PB_EventType_RightButtonUp
									RightButton = 0
								Case #PB_EventType_LeftButtonDown
									LeftButton = 1
									StartDrawing(CanvasOutput(ColorRainbow)) : DrawingMode(#PB_2DDrawing_AllChannels) : C = Point(MX, MY) : StopDrawing()
									Color1 = RGBA(Red(c), Green(c), Blue(c), Alpha)
								Case #PB_EventType_RightButtonDown
									RightButton = 1
									StartDrawing(CanvasOutput(ColorRainbow)) : DrawingMode(#PB_2DDrawing_AllChannels) : C = Point(MX, MY) : StopDrawing()
									Color2 = RGBA(Red(c), Green(c), Blue(c), Alpha)
								Case #PB_EventType_MouseMove
									If LeftButton
										StartDrawing(CanvasOutput(ColorRainbow)) : DrawingMode(#PB_2DDrawing_AllChannels) : C = Point(MX, MY) : StopDrawing()
										Color1 = RGBA(Red(c), Green(c), Blue(c), Alpha)
									EndIf
									If RightButton
										StartDrawing(CanvasOutput(ColorRainbow)) : DrawingMode(#PB_2DDrawing_AllChannels) : C = Point(MX, MY) : StopDrawing()
										Color2 = RGBA(Red(c), Green(c), Blue(c), Alpha)
									EndIf
							EndSelect
							
						Case AlphaSpinner
							Alpha = Val(GetGadgetText(AlphaSpinner))
							
						Case AlphaPicker
							MX = GetGadgetAttribute(AlphaPicker, #PB_Canvas_MouseX)
							MY = GetGadgetAttribute(AlphaPicker, #PB_Canvas_MouseY)
							Select EventType()
								Case #PB_EventType_MouseEnter
									SetActiveGadget(AlphaPicker)
								Case #PB_EventType_LeftButtonUp
									LeftButton = 0
								Case #PB_EventType_RightButtonUp
									RightButton = 0
								Case #PB_EventType_LeftButtonDown
									LeftButton = 1
									a.f = (MX / 84) * 255
									Alpha = a
								Case #PB_EventType_RightButtonDown
									RightButton = 1
									a.f = (MX / 84) * 255
									Alpha = a
								Case #PB_EventType_MouseMove
									If LeftButton Or RightButton
										a.f = (MX / 84) * 255
										Alpha = a
									EndIf
							EndSelect
							SetGadgetText(AlphaSpinner, Str(Alpha))
							Color1 = RGBA(Red(Color1), Green(Color1), Blue(Color1), Alpha)
							Color2 = RGBA(Red(Color2), Green(Color2), Blue(Color2), Alpha)
							
						Case BlendMode
							Mode = #PB_2DDrawing_AlphaBlend
							SetGadgetState(BlendMode, 1)
							SetGadgetState(ReplaceMode, 0)
							
						Case ReplaceMode
							Mode = #PB_2DDrawing_AllChannels
							SetGadgetState(ReplaceMode, 1)
							SetGadgetState(BlendMode, 0)
				EndSelect
				
			Case #PB_Event_CloseWindow : Done = 1
				
		EndSelect
	Until Done = 1
	DisableWindow(#MainWindow, 0)
	CloseWindow(EditorWindow)
	FreeImage(DataImage)
	FreeImage(TransImage)
	
EndProcedure

; Delete frame
Procedure FrameDelete(FrameWindow, Sprite.s, SelectedFrame)
	If SelectedFrame > -1
		; Temp arrays to store the remaining items
		Dim TempFrames.Frame(0)
		
		; Delete frames using this sprite
		For f = 0 To ArraySize(Frames()) - 1
			If f = SelectedFrame
				; Free the image
				If IsImage(Frames(f) \ Image) : FreeImage(Frames(f) \ Image) : EndIf
			Else
				; Store other frames
				Index = ArraySize(TempFrames())
				ReDim TempFrames(Index + 1)
				TempFrames(Index) \ File = Frames(f) \ File
				TempFrames(Index) \ Image = Frames(f) \ Image
				TempFrames(Index) \ Sprite = Frames(f) \ Sprite
			EndIf
		Next
		; Copy back the orginal items
		CopyArray(TempFrames(), Frames())
		
		; Select first available frame
		FrameEditorSelectedBox = -1
		For k = 0 To ArraySize(Frames()) - 1
			If Frames(k) \ Sprite = Sprite
				FrameEditorSelectedBox = k
				Break
			EndIf
		Next							
		RedrawSpriteFrames(Sprite, 1)
	EndIf
EndProcedure

; Shift the frames
Procedure FrameShift(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Shift the images", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(ModifiedImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		; Trackbars
		TextGadget(#PB_Any, 10, 445, 100, 25, "Horizontal")
		HorizontalTrackBar = TrackBarGadget(#PB_Any, 120, 440, 500, 25, 0, OriginalWidth * 2 + 1)
		HorizontalInput = StringGadget(#PB_Any, 630, 440, 50, 25, "0")
		SetGadgetState(HorizontalTrackBar, OriginalWidth + 1)
		HorizontalWrap = CheckBoxGadget(#PB_Any, 690, 440, 100, 25, "Wrap horizontally")
		TextGadget(#PB_Any, 10, 475, 100, 25, "Vertical")
		VerticalTrackBar = TrackBarGadget(#PB_Any, 120, 470, 500, 25, 0, OriginalHeight * 2 + 1)
		VerticalInput = StringGadget(#PB_Any, 630, 470, 50, 25, "0")
		SetGadgetState(VerticalTrackBar, OriginalHeight + 1)
		VerticalWrap = CheckBoxGadget(#PB_Any, 690, 470, 100, 25, "Wrap vertically")
		ActionWindowDone = 0
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					RefreshImage = 0
					Select EventGadget()
						Case HorizontalTrackBar
							SetGadgetText(HorizontalInput, Str(GetGadgetState(HorizontalTrackBar) - OriginalWidth))
							RefreshImage = 1
						Case VerticalTrackBar
							SetGadgetText(VerticalInput, Str(GetGadgetState(VerticalTrackBar) - OriginalHeight))
							RefreshImage = 1
						Case HorizontalInput
							Select EventType()
								Case #PB_EventType_Change
									SetGadgetState(HorizontalTrackBar, Val(GetGadgetText(HorizontalInput)) + OriginalWidth)
									If Val(GetGadgetText(HorizontalInput)) > OriginalWidth : SetGadgetText(HorizontalInput, Str(OriginalWidth)) : EndIf
									If Val(GetGadgetText(HorizontalInput)) < -OriginalWidth : SetGadgetText(HorizontalInput, Str(-OriginalWidth)) : EndIf
									RefreshImage = 1
							EndSelect
						Case VerticalInput
							Select EventType()
								Case #PB_EventType_Change
									SetGadgetState(VerticalTrackBar, Val(GetGadgetText(VerticalInput)) + OriginalHeight)
									If Val(GetGadgetText(VerticalInput)) > OriginalHeight : SetGadgetText(VerticalInput, Str(OriginalHeight)) : EndIf
									If Val(GetGadgetText(VerticalInput)) < -OriginalHeight : SetGadgetText(VerticalInput, Str(-OriginalHeight)) : EndIf
									RefreshImage = 1
							EndSelect
						Case HorizontalWrap
							RefreshImage = 1
						Case VerticalWrap
							RefreshImage = 1
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										DrawImage(ImageID(Frames(a) \ Image), ShiftX, ShiftY)
										If GetGadgetState(HorizontalWrap) = 1
											
											DrawImage(ImageID(Frames(a) \ Image), ShiftX + OriginalWidth, ShiftY)
											DrawImage(ImageID(Frames(a) \ Image), ShiftX - OriginalWidth, ShiftY)
											
											If GetGadgetState(VerticalWrap) = 1
												DrawImage(ImageID(Frames(a) \ Image), ShiftX + OriginalWidth, ShiftY - OriginalHeight)
												DrawImage(ImageID(Frames(a) \ Image), ShiftX + OriginalWidth, ShiftY + OriginalHeight)
												DrawImage(ImageID(Frames(a) \ Image), ShiftX - OriginalWidth, ShiftY - OriginalHeight)
												DrawImage(ImageID(Frames(a) \ Image), ShiftX - OriginalWidth, ShiftY + OriginalHeight)
											EndIf
										EndIf
										
										If GetGadgetState(VerticalWrap) = 1
											DrawImage(ImageID(Frames(a) \ Image), ShiftX, ShiftY - OriginalHeight)
											DrawImage(ImageID(Frames(a) \ Image), ShiftX, ShiftY + OriginalHeight)
											
											If GetGadgetState(HorizontalWrap) = 1
												DrawImage(ImageID(Frames(a) \ Image), ShiftX - OriginalWidth, ShiftY - OriginalHeight)
												DrawImage(ImageID(Frames(a) \ Image), ShiftX + OriginalWidth, ShiftY - OriginalHeight)
												DrawImage(ImageID(Frames(a) \ Image), ShiftX - OriginalWidth, ShiftY + OriginalHeight)
												DrawImage(ImageID(Frames(a) \ Image), ShiftX + OriginalWidth, ShiftY + OriginalHeight)
											EndIf
											
										EndIf
										
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next
						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			; Refresh the image preview
			If RefreshImage = 1
				ShiftX = Val(GetGadgetText(HorizontalInput))
				ShiftY = Val(GetGadgetText(VerticalInput))
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(OriginalImage), ShiftX, ShiftY)
				If GetGadgetState(HorizontalWrap) = 1
					
					DrawImage(ImageID(OriginalImage), ShiftX + OriginalWidth, ShiftY)
					DrawImage(ImageID(OriginalImage), ShiftX - OriginalWidth, ShiftY)
					
					If GetGadgetState(VerticalWrap) = 1
						DrawImage(ImageID(OriginalImage), ShiftX + OriginalWidth, ShiftY - OriginalHeight)
						DrawImage(ImageID(OriginalImage), ShiftX + OriginalWidth, ShiftY + OriginalHeight)
						DrawImage(ImageID(OriginalImage), ShiftX - OriginalWidth, ShiftY - OriginalHeight)
						DrawImage(ImageID(OriginalImage), ShiftX - OriginalWidth, ShiftY + OriginalHeight)
					EndIf
				EndIf
				
				If GetGadgetState(VerticalWrap) = 1
					DrawImage(ImageID(OriginalImage), ShiftX, ShiftY - OriginalHeight)
					DrawImage(ImageID(OriginalImage), ShiftX, ShiftY + OriginalHeight)
					
					If GetGadgetState(HorizontalWrap) = 1
						DrawImage(ImageID(OriginalImage), ShiftX - OriginalWidth, ShiftY - OriginalHeight)
						DrawImage(ImageID(OriginalImage), ShiftX + OriginalWidth, ShiftY - OriginalHeight)
						DrawImage(ImageID(OriginalImage), ShiftX - OriginalWidth, ShiftY + OriginalHeight)
						DrawImage(ImageID(OriginalImage), ShiftX + OriginalWidth, ShiftY + OriginalHeight)
					EndIf
					
				EndIf
				StopDrawing()
				RefreshImage = 0
			EndIf
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
	EndIf
EndProcedure

; Mirror the frames
Procedure FrameMirror(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Mirror the images", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(ModifiedImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		; Horizontal mirror checkbox gadget
		HorizontalMirrorCheckbox = CheckBoxGadget(#PB_Any, 10, 445, 100, 25, "Mirror horizontally")
		; Vertical mirror checkbox gadget
		VerticalMirrorCheckbox = CheckBoxGadget(#PB_Any, 10, 475, 100, 25, "Mirror vertically")
		ActionWindowDone = 0
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case HorizontalMirrorCheckbox
							RefreshImage = 1
						Case VerticalMirrorCheckbox
							RefreshImage = 1
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Mirror final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN)
												G = PeekA(*GreenBank + SN)
												B = PeekA(*BlueBank + SN)
												AL = PeekA(*AlphaBank + SN)
												PX = ix
												PY = iy
												If GetGadgetState(HorizontalMirrorCheckbox) = 1 : PX = OriginalWidth - 1 - ix : EndIf
												If GetGadgetState(VerticalMirrorCheckbox) = 1 : PY = OriginalHeight - 1 - iy : EndIf
												Plot(PX, PY, RGBA(R, G, B, AL))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						R = PeekA(*RedBank + SN)
						G = PeekA(*GreenBank + SN)
						B = PeekA(*BlueBank + SN)
						A = PeekA(*AlphaBank + SN)
						PX = ix
						PY = iy
						If GetGadgetState(HorizontalMirrorCheckbox) = 1 : PX = OriginalWidth - 1 - ix : EndIf
						If GetGadgetState(VerticalMirrorCheckbox) = 1 : PY = OriginalHeight - 1 - iy : EndIf
						Plot(PX, PY, RGBA(R, G, B, A))
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Rotate the frames
Procedure FrameRotate(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Rotate the images", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(ModifiedImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		; 0 Degree
		Degree0Option = OptionGadget(#PB_Any, 10, 445, 50, 25, "0")
		Degree90Option = OptionGadget(#PB_Any, 70, 445, 50, 25, "90")
		Degree180Option = OptionGadget(#PB_Any, 130, 445, 50, 25, "180")
		Degree270Option = OptionGadget(#PB_Any, 190, 445, 50, 25, "270")
		DegreeFree = OptionGadget(#PB_Any, 250, 445, 50, 25, "Free")
		DegreeTrackBar = TrackBarGadget(#PB_Any, 310, 440, 360, 25, 0, 359)
		SetGadgetState(Degree0Option, 1)
		SetGadgetState(DegreeTrackBar, 0)
		ActionWindowDone = 0
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case Degree0Option
							SetGadgetState(DegreeTrackBar, 0)
							RefreshImage = 1
						Case Degree90Option
							SetGadgetState(DegreeTrackBar, 90)
							RefreshImage = 1
						Case Degree180Option
							SetGadgetState(DegreeTrackBar, 180)
							RefreshImage = 1
						Case Degree270Option
							SetGadgetState(DegreeTrackBar, 270)
							RefreshImage = 1
						Case DegreeFree
							RefreshImage = 1
						Case DegreeTrackBar
							SetGadgetState(DegreeFree, 1)
							RefreshImage = 1
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Rotate final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										Degree = 0
										If GetGadgetState(Degree0Option) = 1
											Degree = 0
										EndIf
										
										If GetGadgetState(Degree90Option) = 1
											Degree = 90
										EndIf
										
										If GetGadgetState(Degree180Option) = 1
											Degree = 180
										EndIf
										
										If GetGadgetState(Degree270Option) = 1
											Degree = 270
										EndIf
										
										If GetGadgetState(DegreeFree) = 1
											Degree = GetGadgetState(DegreeTrackBar)
										EndIf
										
										U = OriginalWidth / 2
										V = OriginalHeight / 2
										
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												
												PX = Round( (ix - U) * Cos(Radian(Degree)) - (iy - V) * Sin(Radian(Degree)) + U, #PB_Round_Nearest)
												PY = Round( (ix - U) * Sin(Radian(Degree)) + (iy - V) * Cos(Radian(Degree)) + V, #PB_Round_Nearest)
												
												If PX >= 0 And PX <= OriginalWidth - 1 And PY >= 0 And PY <= OriginalHeight - 1
													POS = PY * OriginalWidth + PX
													R = PeekA(*RedBank + POS)
													G = PeekA(*GreenBank + POS)
													B = PeekA(*BlueBank + POS)
													AL = PeekA(*AlphaBank + POS)
													Plot(ix, iy, RGBA(R, G, B, AL))
												EndIf
						
												SN = SN + 1
											Next
										Next										
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				
				Degree = 0
				If GetGadgetState(Degree0Option) = 1
					Degree = 0
				EndIf
				
				If GetGadgetState(Degree90Option) = 1
					Degree = 90
				EndIf
				
				If GetGadgetState(Degree180Option) = 1
					Degree = 180
				EndIf
				
				If GetGadgetState(Degree270Option) = 1
					Degree = 270
				EndIf
				
				If GetGadgetState(DegreeFree) = 1
					Degree = GetGadgetState(DegreeTrackBar)
				EndIf
				
				U = OriginalWidth / 2
				V = OriginalHeight / 2
				
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						
						PX = Round( (ix - U) * Cos(Radian(Degree)) - (iy - V) * Sin(Radian(Degree)) + U, #PB_Round_Nearest)
						PY = Round( (ix - U) * Sin(Radian(Degree)) + (iy - V) * Cos(Radian(Degree)) + V, #PB_Round_Nearest)
						
						If PX >= 0 And PX <= OriginalWidth - 1 And PY >= 0 And PY <= OriginalHeight - 1
							POS = PY * OriginalWidth + PX
							R = PeekA(*RedBank + POS)
							G = PeekA(*GreenBank + POS)
							B = PeekA(*BlueBank + POS)
							A = PeekA(*AlphaBank + POS)
							Plot(ix, iy, RGBA(R, G, B, A))
						EndIf

						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Set scale of frames
Procedure FrameScale(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Scale the images", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(ModifiedImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		; Trackbars
		TextGadget(#PB_Any, 10, 445, 100, 25, "Horizontal")
		HorizontalTrackBar = TrackBarGadget(#PB_Any, 120, 440, 500, 25, 1, 400)
		HorizontalInput = StringGadget(#PB_Any, 630, 440, 50, 25, "100")
		SetGadgetState(HorizontalTrackBar, 100)
		TextGadget(#PB_Any, 10, 475, 100, 25, "Vertical")
		VerticalTrackBar = TrackBarGadget(#PB_Any, 120, 470, 500, 25, 1, 400)
		VerticalInput = StringGadget(#PB_Any, 630, 470, 50, 25, "100")
		SetGadgetState(VerticalTrackBar, 100)
		; Quick buttons
		QuickScale14Button = ButtonGadget(#PB_Any, 10, 500, 50, 25, "1/4")
		QuickScale12Button = ButtonGadget(#PB_Any, 70, 500, 50, 25, "1/2")
		QuickScale2xButton = ButtonGadget(#PB_Any, 130, 500, 50, 25, "2x")
		QuickScale4xButton = ButtonGadget(#PB_Any, 190, 500, 50, 25, "4x")
		; Lock Hor/Ver scale
		LockScaleCheckbox = CheckBoxGadget(#PB_Any, 700, 455, 100, 25, "Lock")
		SetGadgetState(LockScaleCheckbox, 1)
		ActionWindowDone = 0
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					RefreshImage = 0
					Select EventGadget()
						Case QuickScale14Button
							SetGadgetText(HorizontalInput, "25")
							SetGadgetState(HorizontalTrackBar, 25)
							SetGadgetText(VerticalInput, "25")
							SetGadgetState(VerticalTrackBar, 25)
							RefreshImage = 1
						Case QuickScale12Button
							SetGadgetText(HorizontalInput, "50")
							SetGadgetState(HorizontalTrackBar, 50)
							SetGadgetText(VerticalInput, "50")
							SetGadgetState(VerticalTrackBar, 50)
							RefreshImage = 1
						Case QuickScale2xButton
							SetGadgetText(HorizontalInput, "200")
							SetGadgetState(HorizontalTrackBar, 200)
							SetGadgetText(VerticalInput, "200")
							SetGadgetState(VerticalTrackBar, 200)
							RefreshImage = 1
						Case QuickScale4xButton
							SetGadgetText(HorizontalInput, "400")
							SetGadgetState(HorizontalTrackBar, 400)
							SetGadgetText(VerticalInput, "400")
							SetGadgetState(VerticalTrackBar, 400)
							RefreshImage = 1
						Case HorizontalTrackBar
							SetGadgetText(HorizontalInput, Str(GetGadgetState(HorizontalTrackBar)))
							If GetGadgetState(LockScaleCheckbox)
								SetGadgetText(VerticalInput, GetGadgetText(HorizontalInput))
								SetGadgetState(VerticalTrackBar, GetGadgetState(HorizontalTrackBar))
							EndIf
							RefreshImage = 1
						Case VerticalTrackBar
							SetGadgetText(VerticalInput, Str(GetGadgetState(VerticalTrackBar)))
							If GetGadgetState(LockScaleCheckbox)
								SetGadgetText(HorizontalInput, GetGadgetText(VerticalInput))
								SetGadgetState(HorizontalTrackBar, GetGadgetState(VerticalTrackBar))
							EndIf
							RefreshImage = 1
						Case HorizontalInput
							Select EventType()
								Case #PB_EventType_Change
									SetGadgetState(HorizontalTrackBar, Val(GetGadgetText(HorizontalInput)))
									If Val(GetGadgetText(HorizontalInput)) > 400 : SetGadgetText(HorizontalInput, "400") : EndIf
									If Val(GetGadgetText(HorizontalInput)) < 1 : SetGadgetText(HorizontalInput, "1") : EndIf
									If GetGadgetState(LockScaleCheckbox)
										SetGadgetText(VerticalInput, GetGadgetText(HorizontalInput))
										SetGadgetState(VerticalTrackBar, GetGadgetState(HorizontalTrackBar))
									EndIf
									RefreshImage = 1
							EndSelect
						Case VerticalInput
							Select EventType()
								Case #PB_EventType_Change
									SetGadgetState(VerticalTrackBar, Val(GetGadgetText(VerticalInput)))
									If Val(GetGadgetText(VerticalInput)) > 400 : SetGadgetText(VerticalInput, "400") : EndIf
									If Val(GetGadgetText(VerticalInput)) < 1 : SetGadgetText(VerticalInput, "1") : EndIf
									If GetGadgetState(LockScaleCheckbox)
										SetGadgetText(HorizontalInput, GetGadgetText(VerticalInput))
										SetGadgetState(HorizontalTrackBar, GetGadgetState(VerticalTrackBar))
									EndIf
									RefreshImage = 1
							EndSelect
						Case ActionWindowOKButton
							ActionWindowDone = 1
							ScaleX.f = ValF(GetGadgetText(HorizontalInput)) * OriginalWidth / 100
							ScaleY.f = ValF(GetGadgetText(VerticalInput)) * OriginalHeight / 100
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										DrawImage(ImageID(Frames(a) \ Image), OriginalWidth / 2 - ScaleX / 2, OriginalHeight / 2 - ScaleY / 2, ScaleX, ScaleY)
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next
						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			; Refresh the image preview
			If RefreshImage = 1
				ScaleX.f = ValF(GetGadgetText(HorizontalInput)) * OriginalWidth / 100
				ScaleY.f = ValF(GetGadgetText(VerticalInput)) * OriginalHeight / 100
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(OriginalImage), OriginalWidth / 2 - ScaleX / 2, OriginalHeight / 2 - ScaleY / 2, ScaleX, ScaleY)
				StopDrawing()
				RefreshImage = 0
			EndIf
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)							
	EndIf	
EndProcedure

; Resize the canvas of the frames
Procedure FrameResizeCanvas(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	; Find Current Size
	FrameWidth = 0
	FrameHeight = 0
	For a = 0 To ArraySize(Frames()) - 1
		If Frames(a) \ Sprite = Sprite
			FrameWidth = ImageWidth(Frames(a) \ Image)
			FrameHeight = ImageHeight(Frames(a) \ Image)
		EndIf
	Next
	If FrameWidth > 0 And FrameHeight > 0
		; Window
		ResizeCanvasWindow = OpenWindow(#PB_Any, 0, 0, 220, 160, "Resize canvas", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ResizeCanvasWindow, 1)
		; OK button
		ResizeCanvasOKButton = ButtonGadget(#PB_Any, WindowWidth(ResizeCanvasWindow) - 75, WindowHeight(ResizeCanvasWindow) - 35, 65, 25, "OK")
		; Cancel button
		ResizeCanvasCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ResizeCanvasWindow) - 35, 65, 25, "Cancel")			
		; Width
		TextGadget(#PB_Any, 10, 15, 40, 25, "Width")
		TextGadget(#PB_Any, 60, 15, 60, 25, "Current: " + Str(FrameWidth))
		TextGadget(#PB_Any, 130, 15, 30, 25, "New:")
		ResizeCanvasWidthGadget = StringGadget(#PB_Any, 170, 10, 40, 25, Str(FrameWidth), #PB_String_Numeric)
		; Height
		TextGadget(#PB_Any, 10, 45, 40, 25, "Height")
		TextGadget(#PB_Any, 60, 45, 60, 25, "Current: " + Str(FrameHeight))
		TextGadget(#PB_Any, 130, 45, 30, 25, "New:")
		ResizeCanvasHeightGadget = StringGadget(#PB_Any, 170, 40, 40, 25, Str(FrameHeight), #PB_String_Numeric)
		; Keep aspect
		KeepAspectRatio = CheckBoxGadget(#PB_Any, 10, 70, 200, 25, "Keep aspect ratio")
		SetGadgetState(KeepAspectRatio, 1)
		ResizeCanvasWindowDone = 0
		Repeat
			SetActiveWindow(ResizeCanvasWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case ResizeCanvasWidthGadget
							Select EventType()
								Case #PB_EventType_Change
									If GetGadgetState(KeepAspectRatio) = 1
										WidthPercent.f = ValF(GetGadgetText(ResizeCanvasWidthGadget)) / FrameWidth
										SetGadgetText(ResizeCanvasHeightGadget, StrF(FrameHeight * WidthPercent, 0))
									EndIf
							EndSelect
						Case ResizeCanvasHeightGadget
							Select EventType()
								Case #PB_EventType_Change
									If GetGadgetState(KeepAspectRatio) = 1
										HeightPercent.f = ValF(GetGadgetText(ResizeCanvasHeightGadget)) / FrameHeight
										SetGadgetText(ResizeCanvasWidthGadget, StrF(FrameWidth * HeightPercent, 0))
									EndIf
							EndSelect
						Case ResizeCanvasOKButton
							ResizeCanvasWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									NewWidth = Val(GetGadgetText(ResizeCanvasWidthGadget))
									NewHeight = Val(GetGadgetText(ResizeCanvasHeightGadget))
									TempImage = CreateImage(#PB_Any, NewWidth, NewHeight, 32, #PB_Image_Transparent)
									StartDrawing(ImageOutput(TempImage))
									DrawingMode(#PB_2DDrawing_AlphaBlend)
									DrawImage(ImageID(Frames(a)\Image), NewWidth / 2 - ImageWidth(Frames(a) \ Image) / 2, NewHeight / 2 - ImageHeight(Frames(a) \ Image) / 2)
									StopDrawing()
									If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
									Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
									FreeImage(TempImage)
								EndIf
							Next
						Case ResizeCanvasCancelButton
							ResizeCanvasWindowDone = 1
					EndSelect
			EndSelect
		Until ResizeCanvasWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ResizeCanvasWindow)
		RedrawSpriteFrames(Sprite, 1)						
	EndIf
EndProcedure

; Stretch the frames
Procedure FrameStretch(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	; Find Current Size
	FrameWidth = 0
	FrameHeight = 0
	For a = 0 To ArraySize(Frames()) - 1
		If Frames(a) \ Sprite = Sprite
			FrameWidth = ImageWidth(Frames(a) \ Image)
			FrameHeight = ImageHeight(Frames(a) \ Image)
		EndIf
	Next
	If FrameWidth > 0 And FrameHeight > 0
		
		; Window
		StretchWindow = OpenWindow(#PB_Any, 0, 0, 220, 200, "Stretch the images", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(StretchWindow, 1)
		; OK button
		StretchOKButton = ButtonGadget(#PB_Any, WindowWidth(StretchWindow) - 75, WindowHeight(StretchWindow) - 35, 65, 25, "OK")
		; Cancel button
		StretchCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(StretchWindow) - 35, 65, 25, "Cancel")			
		; Width
		TextGadget(#PB_Any, 10, 15, 40, 25, "Width")
		TextGadget(#PB_Any, 60, 15, 60, 25, "Current: " + Str(FrameWidth))
		TextGadget(#PB_Any, 130, 15, 30, 25, "New:")
		StretchWidthGadget = StringGadget(#PB_Any, 170, 10, 40, 25, Str(FrameWidth), #PB_String_Numeric)
		; Height
		TextGadget(#PB_Any, 10, 45, 40, 25, "Height")
		TextGadget(#PB_Any, 60, 45, 60, 25, "Current: " + Str(FrameHeight))
		TextGadget(#PB_Any, 130, 45, 30, 25, "New:")
		StretchHeightGadget = StringGadget(#PB_Any, 170, 40, 40, 25, Str(FrameHeight), #PB_String_Numeric)
		; Keep aspect
		KeepAspectRatio = CheckBoxGadget(#PB_Any, 10, 70, 200, 25, "Keep aspect ratio")
		SetGadgetState(KeepAspectRatio, 1)
		; Interpolate
		InterpolatePixels = CheckBoxGadget(#PB_Any, 10, 100, 200, 25, "Smooth (Interpolate pixels)")
		SetGadgetState(InterpolatePixels, 1)
		StretchWindowDone = 0
		Repeat
			SetActiveWindow(StretchWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case StretchWidthGadget
							Select EventType()
								Case #PB_EventType_Change
									If GetGadgetState(KeepAspectRatio) = 1
										WidthPercent.f = ValF(GetGadgetText(StretchWidthGadget)) / FrameWidth
										SetGadgetText(StretchHeightGadget, StrF(FrameHeight * WidthPercent, 0))
									EndIf
							EndSelect
						Case StretchHeightGadget
							Select EventType()
								Case #PB_EventType_Change
									If GetGadgetState(KeepAspectRatio) = 1
										HeightPercent.f = ValF(GetGadgetText(StretchHeightGadget)) / FrameHeight
										SetGadgetText(StretchWidthGadget, StrF(FrameWidth * HeightPercent, 0))
									EndIf
							EndSelect
						Case StretchOKButton
							StretchWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									NewWidth = Val(GetGadgetText(StretchWidthGadget))
									NewHeight = Val(GetGadgetText(StretchHeightGadget))
									If GetGadgetState(InterpolatePixels) = 1
										ResizeImage(Frames(a) \ Image, NewWidth, NewHeight, #PB_Image_Smooth)
									Else
										ResizeImage(Frames(a) \ Image, NewWidth, NewHeight, #PB_Image_Raw)
									EndIf
								EndIf
							Next
						Case StretchCancelButton
							StretchWindowDone = 1
					EndSelect
			EndSelect
		Until StretchWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(StretchWindow)
		RedrawSpriteFrames(Sprite, 1)
	EndIf	
EndProcedure

; Changes frames to grayscale
Procedure FrameGrayscale(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Convert to grayscale", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(TempImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				R = PeekA(*RedBank + SN)
				G = PeekA(*GreenBank + SN)
				B = PeekA(*BlueBank + SN)
				AL = PeekA(*AlphaBank + SN)
				GRAY = Round(R * 0.2126 + G * 0.7152 + B * 0.0722, #PB_Round_Nearest)
				Plot(ix, iy, RGBA(GRAY, GRAY, GRAY, AL))
				SN = SN + 1
			Next
		Next
		StopDrawing()
		StartDrawing(CanvasOutput(ModifiedImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(TempImage), 0, 0)
		StopDrawing()
		FreeImage(TempImage)
		
		ActionWindowDone = 0
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Black and white the final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN)
												G = PeekA(*GreenBank + SN)
												B = PeekA(*BlueBank + SN)
												AL = PeekA(*AlphaBank + SN)
												GRAY = Round(R * 0.2126 + G * 0.7152 + B * 0.0722, #PB_Round_Nearest)
												Plot(ix, iy, RGBA(GRAY, GRAY, GRAY, AL))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Invert the frames
Procedure FrameInvert(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Invert", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(TempImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				R = 255 - PeekA(*RedBank + SN)
				G = 255 - PeekA(*GreenBank + SN)
				B = 255 - PeekA(*BlueBank + SN)
				AL = PeekA(*AlphaBank + SN)
				Plot(ix, iy, RGBA(R, G, B, AL))
				SN = SN + 1
			Next
		Next
		StopDrawing()
		StartDrawing(CanvasOutput(ModifiedImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(TempImage), 0, 0)
		StopDrawing()
		FreeImage(TempImage)
		
		ActionWindowDone = 0
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = 255 - PeekA(*RedBank + SN)
												G = 255 - PeekA(*GreenBank + SN)
												B = 255 - PeekA(*BlueBank + SN)
												AL = PeekA(*AlphaBank + SN)
												Plot(ix, iy, RGBA(R, G, B, AL))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure	

; Colorize the frames
Procedure FrameColorize(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Colorize", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		; Hue trackbar
		TextGadget(#PB_Any, 10, 455, 100, 25, "Hue")
		ImageGadget(#PB_Any, 120, 420, 360, 20, ImageID(#HueBar))
		HueTrackBar = TrackBarGadget(#PB_Any, 120, 450, 360, 25, 0, 359)
		HueInput = StringGadget(#PB_Any, 630, 450, 50, 25, "0")
		SetGadgetState(HueTrackBar, 0)
		
		ActionWindowDone = 0
		RefreshImage = 1
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
							
						Case HueTrackBar
							SetGadgetText(HueInput, Str(GetGadgetState(HueTrackBar)))
							RefreshImage = 1
						Case HueInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(HueInput)) > 359 : SetGadgetText(HueInput, "359") : EndIf
									If Val(GetGadgetText(HueInput)) < 0 : SetGadgetText(HueInput, "0") : EndIf
									SetGadgetState(HueTrackBar, Val(GetGadgetText(HueInput)))
									RefreshImage = 1
							EndSelect
							
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										Hue.f = GetGadgetState(HueTrackBar) / 360
										var_r.f = 0
										var_g.f = 0
										var_b.f = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN)
												G = PeekA(*GreenBank + SN)
												B = PeekA(*BlueBank + SN)
												var_h.f = Hue * 6
												var_i.f = Round(var_h, #PB_Round_Down)
												var_1.f = 0
												var_2.f = 1 - 1 * (var_h - var_i)
												var_3.f = 1 - 1 * (1 - (var_h - var_i))
												Select var_i
													Case 0
														var_r = 1
														var_g = var_3
														var_b = var_1
													Case 1
														var_r = var_2
														var_g = 1
														var_b = var_1
													Case 2
														var_r = var_1
														var_g = 1
														var_b = var_3
													Case 3
														var_r = var_1
														var_g = var_2
														var_b = 1
													Case 4
														var_r = var_3
														var_g = var_1
														var_b = 1
													Case 5 
														var_r = 1
														var_g = var_1
														var_b = var_2
												EndSelect
												Plot(ix, iy, RGBA(R * var_r, G * var_g, B * var_b, PeekA(*AlphaBank + SN)))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				Hue.f = GetGadgetState(HueTrackBar) / 360
				var_r.f = 0
				var_g.f = 0
				var_b.f = 0
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						R = PeekA(*RedBank + SN)
						G = PeekA(*GreenBank + SN)
						B = PeekA(*BlueBank + SN)
						var_h.f = Hue * 6
						var_i.f = Round(var_h, #PB_Round_Down)
						var_1.f = 1 - 1
						var_2.f = 1 - 1 * (var_h - var_i)
						var_3.f = 1 - 1 * (1 - (var_h - var_i))
						Select var_i
							Case 0
								var_r = 1
								var_g = var_3
								var_b = var_1
							Case 1
								var_r = var_2
								var_g = 1
								var_b = var_1
							Case 2
								var_r = var_1
								var_g = 1
								var_b = var_3
							Case 3
								var_r = var_1
								var_g = var_2
								var_b = 1
							Case 4
								var_r = var_3
								var_g = var_1
								var_b = 1
							Case 5 
								var_r = 1
								var_g = var_1
								var_b = var_2
						EndSelect
						Plot(ix, iy, RGBA(R * var_r, G * var_g, B * var_b, PeekA(*AlphaBank + SN)))
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf			
			
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Change the color balance of frames
Procedure FrameColorBalance(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Color balance", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		; RGB trackbars
		TextGadget(#PB_Any, 10, 445, 100, 25, "Red")
		RedTrackBar = TrackBarGadget(#PB_Any, 120, 440, 500, 25, 0, 510)
		SetGadgetState(RedTrackBar, 255)
		RedInput = StringGadget(#PB_Any, 630, 440, 50, 25, "0")
		
		TextGadget(#PB_Any, 10, 475, 100, 25, "Green")
		GreenTrackBar = TrackBarGadget(#PB_Any, 120, 470, 500, 25, 0, 510)
		SetGadgetState(GreenTrackBar, 255)
		GreenInput = StringGadget(#PB_Any, 630, 470, 50, 25, "0")
		
		TextGadget(#PB_Any, 10, 505, 100, 25, "Blue")
		BlueTrackBar = TrackBarGadget(#PB_Any, 120, 500, 500, 25, 0, 510)
		SetGadgetState(BlueTrackBar, 255)
		BlueInput = StringGadget(#PB_Any, 630, 500, 50, 25, "0")
		
		ActionWindowDone = 0
		RefreshImage = 1
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
							
						Case RedTrackBar
							SetGadgetText(RedInput, Str(GetGadgetState(RedTrackBar) - 255))
							RefreshImage = 1
						Case GreenTrackBar
							SetGadgetText(GreenInput, Str(GetGadgetState(GreenTrackBar) - 255))
							RefreshImage = 1
						Case BlueTrackBar
							SetGadgetText(BlueInput, Str(GetGadgetState(BlueTrackBar) - 255))
							RefreshImage = 1
						Case RedInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(RedInput)) > 255 : SetGadgetText(RedInput, "255") : EndIf
									If Val(GetGadgetText(RedInput)) < -255 : SetGadgetText(RedInput, "-255") : EndIf
									SetGadgetState(RedTrackBar, Val(GetGadgetText(RedInput)) + 255)
									RefreshImage = 1
							EndSelect
						Case GreenInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(GreenInput)) > 255 : SetGadgetText(GreenInput, "255") : EndIf
									If Val(GetGadgetText(GreenInput)) < -255 : SetGadgetText(GreenInput, "-255") : EndIf
									SetGadgetState(GreenTrackBar, Val(GetGadgetText(GreenInput)) + 255)
									RefreshImage = 1
							EndSelect
						Case BlueInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(BlueInput)) > 255 : SetGadgetText(BlueInput, "255") : EndIf
									If Val(GetGadgetText(BlueInput)) < -255 : SetGadgetText(BlueInput, "-255") : EndIf
									SetGadgetState(BlueTrackBar, Val(GetGadgetText(BlueInput)) + 255)
									RefreshImage = 1
							EndSelect							
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										RedLevel = GetGadgetState(RedTrackBar) - 255
										GreenLevel = GetGadgetState(GreenTrackBar) - 255
										BlueLevel = GetGadgetState(BlueTrackBar) - 255
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN) + RedLevel
												G = PeekA(*GreenBank + SN) + GreenLevel
												B = PeekA(*BlueBank + SN) + BlueLevel
												
												If R > 255 : R = 255 : EndIf
												If G > 255 : G = 255 : EndIf
												If B > 255 : B = 255 : EndIf
												
												If R < 0 : R = 0 : EndIf
												If G < 0 : G = 0 : EndIf
												If B < 0 : B = 0 : EndIf
												
												AL = PeekA(*AlphaBank + SN)
												Plot(ix, iy, RGBA(R, G, B, AL))
												
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				RedLevel = GetGadgetState(RedTrackBar) - 255
				GreenLevel = GetGadgetState(GreenTrackBar) - 255
				BlueLevel = GetGadgetState(BlueTrackBar) - 255
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						R = PeekA(*RedBank + SN) + RedLevel
						G = PeekA(*GreenBank + SN) + GreenLevel
						B = PeekA(*BlueBank + SN) + BlueLevel
						
						If R > 255 : R = 255 : EndIf
						If G > 255 : G = 255 : EndIf
						If B > 255 : B = 255 : EndIf
						
						If R < 0 : R = 0 : EndIf
						If G < 0 : G = 0 : EndIf
						If B < 0 : B = 0 : EndIf
						
						AL = PeekA(*AlphaBank + SN)
						Plot(ix, iy, RGBA(R, G, B, AL))
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf			
			
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Flip RGB channels
Procedure FrameFlipRGB(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Swap RGB channels", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		; Options
		FlipRBG = OptionGadget(#PB_Any, 10, 445, 120, 25, "RGB ==> RBG")
		FlipGRB = OptionGadget(#PB_Any, 140, 445, 120, 25, "RGB ==> GRB")
		FlipGBR = OptionGadget(#PB_Any, 270, 445, 120, 25, "RGB ==> GBR")
		FlipBRG = OptionGadget(#PB_Any, 400, 445, 120, 25, "RGB ==> BRG")
		FlipBGR = OptionGadget(#PB_Any, 530, 445, 120, 25, "RGB ==> BGR")
		SetGadgetState(FlipRBG, 1)
		ActionWindowDone = 0
		RefreshImage = 1
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case FlipRBG
							RefreshImage = 1
						Case FlipGRB
							RefreshImage = 1
						Case FlipGBR
							RefreshImage = 1
						Case FlipBRG
							RefreshImage = 1
						Case FlipBGR
							RefreshImage = 1
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Rotate final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN)
												G = PeekA(*GreenBank + SN)
												B = PeekA(*BlueBank + SN)
												AL = PeekA(*AlphaBank + SN)
												
												If GetGadgetState(FlipRBG) = 1
													Plot(ix, iy, RGBA(R, B, G, AL))
												EndIf
												
												If GetGadgetState(FlipGRB) = 1
													Plot(ix, iy, RGBA(G, R, B, AL))
												EndIf
												
												If GetGadgetState(FlipGBR) = 1
													Plot(ix, iy, RGBA(G, B, R, AL))
												EndIf
												
												If GetGadgetState(FlipBRG) = 1
													Plot(ix, iy, RGBA(B, R, G, AL))
												EndIf
												
												If GetGadgetState(FlipBGR) = 1
													Plot(ix, iy, RGBA(B, G, R, AL))
												EndIf
												
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						R = PeekA(*RedBank + SN)
						G = PeekA(*GreenBank + SN)
						B = PeekA(*BlueBank + SN)
						AL = PeekA(*AlphaBank + SN)
						
						If GetGadgetState(FlipRBG) = 1
							Plot(ix, iy, RGBA(R, B, G, AL))
						EndIf
						
						If GetGadgetState(FlipGRB) = 1
							Plot(ix, iy, RGBA(G, R, B, AL))
						EndIf
						
						If GetGadgetState(FlipGBR) = 1
							Plot(ix, iy, RGBA(G, B, R, AL))
						EndIf
						
						If GetGadgetState(FlipBRG) = 1
							Plot(ix, iy, RGBA(B, R, G, AL))
						EndIf
						
						If GetGadgetState(FlipBGR) = 1
							Plot(ix, iy, RGBA(B, G, R, AL))
						EndIf
						
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Change the opacity of the frames
Procedure FrameOpacity(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Opacity", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		; Opacity trackbar
		TextGadget(#PB_Any, 10, 445, 100, 25, "Percent")
		PercentTrackBar = TrackBarGadget(#PB_Any, 120, 440, 500, 25, 0, 100)
		PercentInput = StringGadget(#PB_Any, 630, 440, 50, 25, "100")
		SetGadgetState(PercentTrackBar, 100)
		
		ActionWindowDone = 0
		RefreshImage = 1
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
							
						Case PercentTrackBar
							SetGadgetText(PercentInput, Str(GetGadgetState(PercentTrackBar)))
							RefreshImage = 1
						Case PercentInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(PercentInput)) > 100 : SetGadgetText(PercentInput, "100") : EndIf
									If Val(GetGadgetText(PercentInput)) < 0 : SetGadgetText(PercentInput, "0") : EndIf
									SetGadgetState(PercentTrackBar, Val(GetGadgetText(PercentInput)))
									RefreshImage = 1
							EndSelect
							
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN)
												G = PeekA(*GreenBank + SN)
												B = PeekA(*BlueBank + SN)
												AL = Round(PeekA(*AlphaBank + SN) / 100 * Val(GetGadgetText(PercentInput)), #PB_Round_Up)
												Plot(ix, iy, RGBA(R, G, B, AL))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						R = PeekA(*RedBank + SN)
						G = PeekA(*GreenBank + SN)
						B = PeekA(*BlueBank + SN)
						AL = Round(PeekA(*AlphaBank + SN) / 100 * Val(GetGadgetText(PercentInput)), #PB_Round_Up)
						Plot(ix, iy, RGBA(R, G, B, AL))
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf			
			
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Apply posterize to frames
Procedure FramePosterize(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Posterize", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		; Opacity trackbar
		TextGadget(#PB_Any, 10, 445, 100, 25, "Level")
		LevelTrackBar = TrackBarGadget(#PB_Any, 120, 440, 500, 25, 2, 120)
		LevelInput = StringGadget(#PB_Any, 630, 440, 50, 25, "50")
		SetGadgetState(LevelTrackBar, 100)
		
		ActionWindowDone = 0
		RefreshImage = 1
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
							
						Case LevelTrackBar
							SetGadgetText(LevelInput, Str(GetGadgetState(LevelTrackBar)))
							RefreshImage = 1
						Case LevelInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(LevelInput)) > 120 : SetGadgetText(LevelInput, "120") : EndIf
									If Val(GetGadgetText(LevelInput)) < 2 : SetGadgetText(LevelInput, "2") : EndIf
									SetGadgetState(LevelTrackBar, Val(GetGadgetText(LevelInput)))
									RefreshImage = 1
							EndSelect
							
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										Level = Val(GetGadgetText(LevelInput))
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = Round(PeekA(*RedBank + SN) / Level, #PB_Round_Nearest) * Level
												G = Round(PeekA(*GreenBank + SN) / Level, #PB_Round_Nearest) * Level
												B = Round(PeekA(*BlueBank + SN) / Level, #PB_Round_Nearest) * Level
												AL = PeekA(*AlphaBank + SN)
												Plot(ix, iy, RGBA(R, G, B, AL))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				Level = Val(GetGadgetText(LevelInput))
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						R = Round(PeekA(*RedBank + SN) / Level, #PB_Round_Nearest) * Level
						G = Round(PeekA(*GreenBank + SN) / Level, #PB_Round_Nearest) * Level
						B = Round(PeekA(*BlueBank + SN) / Level, #PB_Round_Nearest) * Level
						AL = PeekA(*AlphaBank + SN)
						Plot(ix, iy, RGBA(R, G, B, AL))
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf			
			
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Add noise to frames
Procedure FrameNoise(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		
		; Create noise
		Level = 0
		*NoiseBank = AllocateMemory(OriginalWidth * OriginalHeight)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PokeA(*NoiseBank + SN, Random(Level))
				SN = SN + 1
			Next
		Next
		
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Noise", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		; Opacity trackbar
		TextGadget(#PB_Any, 10, 445, 100, 25, "Level")
		LevelTrackBar = TrackBarGadget(#PB_Any, 120, 440, 500, 25, 0, 100)
		LevelInput = StringGadget(#PB_Any, 630, 440, 50, 25, "0")
		SetGadgetState(LevelTrackBar, 0)
		
		ActionWindowDone = 0
		RefreshImage = 1
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
							
						Case LevelTrackBar
							SetGadgetText(LevelInput, Str(GetGadgetState(LevelTrackBar)))
							RefreshImage = 1
						Case LevelInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(LevelInput)) > 100 : SetGadgetText(LevelInput, "100") : EndIf
									If Val(GetGadgetText(LevelInput)) < 0 : SetGadgetText(LevelInput, "0") : EndIf
									SetGadgetState(LevelTrackBar, Val(GetGadgetText(LevelInput)))
									RefreshImage = 1
							EndSelect
							
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										Level = Val(GetGadgetText(LevelInput))
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN) + PeekA(*NoiseBank + SN)
												G = PeekA(*GreenBank + SN) + PeekA(*NoiseBank + SN)
												B = PeekA(*BlueBank + SN) + PeekA(*NoiseBank + SN)
												AL = PeekA(*AlphaBank + SN)
												
												If R > 255 : R = 255 : EndIf
												If G > 255 : G = 255 : EndIf
												If B > 255 : B = 255 : EndIf
												Plot(ix, iy, RGBA(R, G, B, AL))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			
			; Refresh the image preview
			If RefreshImage = 1
				
				; Create noise
				Level = Val(GetGadgetText(LevelInput))
				SN = 0
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						PokeA(*NoiseBank + SN, 1 + Random(Level))
						SN = SN + 1
					Next
				Next
				
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						R = PeekA(*RedBank + SN) + PeekA(*NoiseBank + SN)
						G = PeekA(*GreenBank + SN) + PeekA(*NoiseBank + SN)
						B = PeekA(*BlueBank + SN) + PeekA(*NoiseBank + SN)
						AL = PeekA(*AlphaBank + SN)
						
						If R > 255 : R = 255 : EndIf
						If G > 255 : G = 255 : EndIf
						If B > 255 : B = 255 : EndIf
						
						Plot(ix, iy, RGBA(R, G, B, AL))
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf			
			
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
		FreeMemory(*NoiseBank)
	EndIf
EndProcedure

; Remove color from frames
Procedure FrameEraseColor(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	
	Color = RGB(0, 0, 0)
	
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Erase a color", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage), #PB_Canvas_ClipMouse)
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		; Opacity trackbar
		TextGadget(#PB_Any, 10, 445, 100, 25, "Tolerance")
		ToleranceTrackBar = TrackBarGadget(#PB_Any, 120, 440, 500, 25, 0, 255)
		ToleranceInput = StringGadget(#PB_Any, 630, 440, 50, 25, "0")
		SetGadgetState(ToleranceTrackBar, 0)
		
		; Color
		ColorPickerColor = StringGadget(#PB_Any, 10, 470, 100, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
		ColorPicker = ButtonGadget(#PB_Any, 120, 470, 25, 25, "...")
		SetGadgetColor(ColorPickerColor, #PB_Gadget_BackColor, Color)
		
		ActionWindowDone = 0
		RefreshImage = 1
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
							
						Case ColorPicker
							TempColor = ColorRequester(Color)
							If TempColor > -1
								Color = TempColor
								SetGadgetColor(ColorPickerColor, #PB_Gadget_BackColor, Color)
								RefreshImage = 1
							EndIf
							
						Case OriginalImageCanvas
							Select EventType()
								Case #PB_EventType_LeftClick
									StartDrawing(CanvasOutput(OriginalImageCanvas))
									Color = Point(GetGadgetAttribute(OriginalImageCanvas, #PB_Canvas_MouseX), GetGadgetAttribute(OriginalImageCanvas, #PB_Canvas_MouseY))
									StopDrawing()
									SetGadgetColor(ColorPickerColor, #PB_Gadget_BackColor, Color)
									RefreshImage = 1
							EndSelect
							
						Case ToleranceTrackBar
							SetGadgetText(ToleranceInput, Str(GetGadgetState(ToleranceTrackBar)))
							RefreshImage = 1
						Case ToleranceInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(ToleranceInput)) > 255 : SetGadgetText(ToleranceInput, "255") : EndIf
									If Val(GetGadgetText(ToleranceInput)) < 0 : SetGadgetText(ToleranceInput, "0") : EndIf
									SetGadgetState(ToleranceTrackBar, Val(GetGadgetText(ToleranceInput)))
									RefreshImage = 1
							EndSelect
							
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										Tolerance = Val(GetGadgetText(ToleranceInput))
										SelectedColor = Round(Red(Color) * 0.2126 + Green(Color) * 0.7152 + Blue(Color) * 0.0722, #PB_Round_Nearest)
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												
												R = PeekA(*RedBank + SN)
												G = PeekA(*GreenBank + SN)
												B = PeekA(*BlueBank + SN)
												AL = PeekA(*AlphaBank + SN)
												
												AverageColor = Round(R * 0.2126 + G * 0.7152 + B * 0.0722, #PB_Round_Nearest)
												If AverageColor >= SelectedColor - Tolerance And AverageColor <= SelectedColor + Tolerance
													R = 0
													G = 0
													B = 0
													AL = 0
												EndIf
												
												Plot(ix, iy, RGBA(R, G, B, AL))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				Tolerance = Val(GetGadgetText(ToleranceInput))
				SelectedColor = Round(Red(Color) * 0.2126 + Green(Color) * 0.7152 + Blue(Color) * 0.0722, #PB_Round_Nearest)
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						
						R = PeekA(*RedBank + SN)
						G = PeekA(*GreenBank + SN)
						B = PeekA(*BlueBank + SN)
						AL = PeekA(*AlphaBank + SN)
						
						AverageColor = Round(R * 0.2126 + G * 0.7152 + B * 0.0722, #PB_Round_Nearest)
						If AverageColor >= SelectedColor - Tolerance And AverageColor <= SelectedColor + Tolerance
							R = 0
							G = 0
							B = 0
							AL = 0
						EndIf
						
						Plot(ix, iy, RGBA(R, G, B, AL))
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf			
			
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Change the brightness
Procedure FrameBrightness(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Brightness", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		; Opacity trackbar
		TextGadget(#PB_Any, 10, 445, 100, 25, "Level")
		LevelTrackBar = TrackBarGadget(#PB_Any, 120, 440, 500, 25, 0, 510)
		LevelInput = StringGadget(#PB_Any, 630, 440, 50, 25, "0")
		SetGadgetState(LevelTrackBar, 255)
		
		ActionWindowDone = 0
		RefreshImage = 1
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
							
						Case LevelTrackBar
							SetGadgetText(LevelInput, Str(GetGadgetState(LevelTrackBar) - 255))
							RefreshImage = 1
						Case LevelInput
							Select EventType()
								Case #PB_EventType_Change
									If Val(GetGadgetText(LevelInput)) > 255 : SetGadgetText(LevelInput, "255") : EndIf
									If Val(GetGadgetText(LevelInput)) < -255 : SetGadgetText(LevelInput, "-255") : EndIf
									SetGadgetState(LevelTrackBar, Val(GetGadgetText(LevelInput)) + 255)
									RefreshImage = 1
							EndSelect
							
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										Level = Val(GetGadgetText(LevelInput))
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN) + Level
												G = PeekA(*GreenBank + SN) + Level
												B = PeekA(*BlueBank + SN) + Level
												
												If R > 255 : R = 255 : EndIf
												If G > 255 : G = 255 : EndIf
												If B > 255 : B = 255 : EndIf
												
												If R < 0 : R = 0 : EndIf
												If G < 0 : G = 0 : EndIf
												If B < 0 : B = 0 : EndIf
												
												AL = PeekA(*AlphaBank + SN)
												Plot(ix, iy, RGBA(R, G, B, AL))
												
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
			
			; Refresh the image preview
			If RefreshImage = 1
				TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
				StartDrawing(ImageOutput(TempImage))
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				SN = 0
				Level = Val(GetGadgetText(LevelInput))
				For iy = 0 To OriginalHeight - 1
					For ix = 0 To OriginalWidth - 1
						R = PeekA(*RedBank + SN) + Level
						G = PeekA(*GreenBank + SN) + Level
						B = PeekA(*BlueBank + SN) + Level
						
						If R > 255 : R = 255 : EndIf
						If G > 255 : G = 255 : EndIf
						If B > 255 : B = 255 : EndIf
						
						If R < 0 : R = 0 : EndIf
						If G < 0 : G = 0 : EndIf
						If B < 0 : B = 0 : EndIf
						
						AL = PeekA(*AlphaBank + SN)
						Plot(ix, iy, RGBA(R, G, B, AL))
						SN = SN + 1
					Next
				Next
				StopDrawing()
				StartDrawing(CanvasOutput(ModifiedImageCanvas))
				DrawingMode(#PB_2DDrawing_Default)
				DrawImage(ImageID(#TransGrid), 0, 0)
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(TempImage), 0, 0)
				StopDrawing()
				FreeImage(TempImage)
				RefreshImage = 0
			EndIf			
			
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Make the frames opaque
Procedure FrameMakeOpaque(FrameWindow, Sprite.s, FrameEditorSelectedBox)
	If FrameEditorSelectedBox > -1
		OriginalImage = Frames(FrameEditorSelectedBox) \ Image
		OriginalWidth = ImageWidth(OriginalImage)
		OriginalHeight = ImageHeight(OriginalImage)
		*RedBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*GreenBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*BlueBank = AllocateMemory(OriginalWidth * OriginalHeight)
		*AlphaBank = AllocateMemory(OriginalWidth * OriginalHeight)
		StartDrawing(ImageOutput(OriginalImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				PixelData = Point(ix, iy)
				PokeA(*RedBank + SN, Red(PixelData))
				PokeA(*GreenBank + SN, Green(PixelData))
				PokeA(*BlueBank + SN, Blue(PixelData))
				If OutputDepth() = 32
					PokeA(*AlphaBank + SN, Alpha(PixelData))
				Else
					PokeA(*AlphaBank + SN, 255)
				EndIf
				SN = SN + 1
			Next
		Next
		StopDrawing()
		
		ActionWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Make opaque", #PB_Window_ScreenCentered | #PB_Window_Tool)
		DisableWindow(FrameWindow, 1)
		StickyWindow(ActionWindow, 1)
		; OK button
		ActionWindowOKButton = ButtonGadget(#PB_Any, WindowWidth(ActionWindow) - 75, WindowHeight(ActionWindow) - 35, 65, 25, "OK")
		; Cancel
		ActionWindowCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ActionWindow) - 35, 65, 25, "Cancel")
		; Apply all
		EffectAllFrames = CheckBoxGadget(#PB_Any, WindowWidth(ActionWindow) - 270, WindowHeight(ActionWindow) - 35, 160, 25, "Apply to all frames in the sprite")
		SetGadgetState(EffectAllFrames, 1)
		; Scrollers / Images
		TextGadget(#PB_Any, 10, 10, 100, 25, "ORIGINAL")
		TextGadget(#PB_Any, 410, 10, 100, 25, "MODIFIED")
		OriginalScroller = ScrollAreaGadget(#PB_Any, 10, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		OriginalImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		StartDrawing(CanvasOutput(OriginalImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(OriginalImage), 0, 0)
		StopDrawing()
		CloseGadgetList()
		ModifiedScroller = ScrollAreaGadget(#PB_Any, 410, 30, 380, 380, ImageWidth(OriginalImage), ImageHeight(OriginalImage), 16, #PB_ScrollArea_Raised)
		ModifiedImageCanvas = CanvasGadget(#PB_Any, 0, 0, ImageWidth(OriginalImage), ImageHeight(OriginalImage))
		CloseGadgetList()
		
		TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(TempImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		SN = 0
		For iy = 0 To OriginalHeight - 1
			For ix = 0 To OriginalWidth - 1
				R = PeekA(*RedBank + SN)
				G = PeekA(*GreenBank + SN)
				B = PeekA(*BlueBank + SN)
				AL = PeekA(*AlphaBank + SN)
				AL = 255
				Plot(ix, iy, RGBA(R, G, B, AL))
				SN = SN + 1
			Next
		Next
		StopDrawing()
		StartDrawing(CanvasOutput(ModifiedImageCanvas))
		DrawingMode(#PB_2DDrawing_Default)
		DrawImage(ImageID(#TransGrid), 0, 0)
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(TempImage), 0, 0)
		StopDrawing()
		FreeImage(TempImage)
		
		ActionWindowDone = 0
		Repeat
			SetActiveWindow(ActionWindow)
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case ActionWindowOKButton
							ActionWindowDone = 1
							For a = 0 To ArraySize(Frames()) - 1
								If Frames(a) \ Sprite = Sprite
									; All frames or selected
									If GetGadgetState(EffectAllFrames) = 1 Or a = FrameEditorSelectedBox
										
										; Store actual frame to memory
										StartDrawing(ImageOutput(Frames(a) \ Image))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												PixelData = Point(ix, iy)
												PokeA(*RedBank + SN, Red(PixelData))
												PokeA(*GreenBank + SN, Green(PixelData))
												PokeA(*BlueBank + SN, Blue(PixelData))
												If OutputDepth() = 32
													PokeA(*AlphaBank + SN, Alpha(PixelData))
												Else
													PokeA(*AlphaBank + SN, 255)
												EndIf
												SN = SN + 1
											Next
										Next
										StopDrawing()
										
										; Final frame image
										TempImage = CreateImage(#PB_Any, OriginalWidth, OriginalHeight, 32, #PB_Image_Transparent)
										StartDrawing(ImageOutput(TempImage))
										DrawingMode(#PB_2DDrawing_AlphaBlend)
										SN = 0
										For iy = 0 To OriginalHeight - 1
											For ix = 0 To OriginalWidth - 1
												R = PeekA(*RedBank + SN)
												G = PeekA(*GreenBank + SN)
												B = PeekA(*BlueBank + SN)
												AL = PeekA(*AlphaBank + SN)
												AL = 255
												Plot(ix, iy, RGBA(R, G, B, AL))
												SN = SN + 1
											Next
										Next
										StopDrawing()
										If IsImage(Frames(a) \ Image) : FreeImage(Frames(a) \ Image) : EndIf
										Frames(a) \ Image = CopyImage(TempImage, #PB_Any)
										FreeImage(TempImage)
									EndIf
								EndIf
							Next

						Case ActionWindowCancelButton
							ActionWindowDone = 1
					EndSelect
			EndSelect
		Until ActionWindowDone = 1
		DisableWindow(FrameWindow, 0)
		CloseWindow(ActionWindow)
		RedrawSpriteFrames(Sprite, 1)
		FreeMemory(*RedBank)
		FreeMemory(*GreenBank)
		FreeMemory(*BlueBank)
		FreeMemory(*AlphaBank)
	EndIf
EndProcedure

; Edit the sprite frames
Procedure EditFrames(Sprite.s)
	
	; First box is selected
	; Find the first frame id
	FrameEditorSelectedBox = -1
	For k = 0 To ArraySize(Frames()) - 1
		If Frames(k) \ Sprite = Sprite
			FrameEditorSelectedBox = k
			Break
		EndIf
	Next
	
	FrameWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Edit sprite frames", #PB_Window_ScreenCentered | #PB_Window_Tool, WindowID(#MainWindow))
	;StickyWindow(FrameWindow, 1)
	
	CreateImageMenu(#FramesEditorMenu, WindowID(FrameWindow))
	MenuTitle("File")
	MenuItem(#FramesEditorFileNew, "New..." + Chr(9) + "Ctrl + N", ImageID(#NewIcon))
	MenuBar()
	MenuItem(#FramesEditorFileAdd, "Add new frame from file..." + Chr(9) + "Ctrl + A", ImageID(#AddIcon))
	MenuItem(#FramesEditorFileSavePNG, "Save as PNG image..." + Chr(9) + "Ctrl + S", ImageID(#SaveIcon))
	MenuTitle("Edit")
	MenuItem(#FramesEditorEditDuplicate, "Duplicate frame" + Chr(9) + "Ctrl + D", ImageID(#DuplicateIcon))
	MenuBar()
	MenuItem(#FramesEditorEditMoveLeft, "Move frame left" + Chr(9) + "Ctrl + Left", ImageID(#MoveLeftIcon))
	MenuItem(#FramesEditorEditMoveRight, "Move frame right" + Chr(9) + "Ctrl + Right", ImageID(#MoveRightIcon))
	MenuBar()
	MenuItem(#FramesEditorEditEditFrame, "Edit current frame" + Chr(9) + "Enter", ImageID(#EditIcon))
	MenuBar()
	MenuItem(#FramesEditorEditDeleteFrame, "Delete current frame" + Chr(9) + "Delete", ImageID(#DeleteIcon))
	MenuTitle("Transform")
	MenuItem(#FramesEditorTransformShift, "Shift", ImageID(#ShiftIcon))
	MenuItem(#FramesEditorTransformMirror, "Mirror/Flip", ImageID(#MirrorIcon))
	MenuItem(#FramesEditorTransformRotate, "Rotate", ImageID(#RotateIcon))
	MenuItem(#FramesEditorTransformScale, "Scale", ImageID(#ScaleIcon))
	MenuBar()
	MenuItem(#FramesEditorTransformResizeCanvas, "Resize canvas", ImageID(#ResizeIcon))
	MenuItem(#FramesEditorTransformStretch, "Stretch", ImageID(#StretchIcon))
	MenuTitle("Effects")
	MenuItem(#FramesEditorEffectsBW, "Grayscale", ImageID(#GrayscaleIcon))
	MenuItem(#FramesEditorEffectsColorize, "Colorize", ImageID(#ColorizeIcon))
	MenuItem(#FramesEditorEffectsColorBalance, "Color balance", ImageID(#ColorBalanceIcon))
	MenuItem(#FramesEditorEffectsColorFlip, "Swap RGB channel", ImageID(#SwapRGBIcon))
	MenuItem(#FramesEditorEffectsInvert, "Invert", ImageID(#InvertIcon))
	MenuItem(#FramesEditorEffectsBrightness, "Brightness", ImageID(#BrightnessIcon))
	MenuItem(#FramesEditorEffectsOpacity, "Opacity", ImageID(#OpacityIcon))
	MenuItem(#FramesEditorEffectsPosterize, "Posterize", ImageID(#PosterizeIcon))
	MenuItem(#FramesEditorEffectsNoise, "Noise", ImageID(#NoiseIcon))
	MenuItem(#FramesEditorEffectsEraseColor, "Erase a color", ImageID(#EraseColorIcon))
	MenuItem(#FramesEditorEffectsMakeOpaque, "Make opaque", ImageID(#MakeOpaqueIcon))
	
	CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
		osxGameButton = 30
	CompilerElse
		osxGameButton = 25
	CompilerEndIf
	
	NewButton = ButtonImageGadget(#PB_Any, 10, 10, osxGameButton, osxGameButton, ImageID(#NewIcon)) : GadgetToolTip(NewButton, "Create new sprite")
	AddButton = ButtonImageGadget(#PB_Any, 40, 10, osxGameButton, osxGameButton, ImageID(#AddIcon)) : GadgetToolTip(AddButton, "Add new frame from file")
	SaveButton = ButtonImageGadget(#PB_Any, 70, 10, osxGameButton, osxGameButton, ImageID(#SaveIcon)) : GadgetToolTip(SaveButton, "Save sprite as PNG strip")
	
	DuplicateButton = ButtonImageGadget(#PB_Any, 110, 10, osxGameButton, osxGameButton, ImageID(#DuplicateIcon)) : GadgetToolTip(DuplicateButton, "Duplicate current frame")
	MoveLeftButton = ButtonImageGadget(#PB_Any, 140, 10, osxGameButton, osxGameButton, ImageID(#MoveLeftIcon)) : GadgetToolTip(MoveLeftButton, "Move current frame to left")
	MoveRightButton = ButtonImageGadget(#PB_Any, 170, 10, osxGameButton, osxGameButton, ImageID(#MoveRightIcon)) : GadgetToolTip(MoveRightButton, "Move current frame to right")
	EditButton = ButtonImageGadget(#PB_Any, 200, 10, osxGameButton, osxGameButton, ImageID(#EditIcon)) : GadgetToolTip(EditButton, "Edit current frame")
	DeleteButton = ButtonImageGadget(#PB_Any, 230, 10, osxGameButton, osxGameButton, ImageID(#DeleteIcon)) : GadgetToolTip(DeleteButton, "Delete current frame")
	
	ShiftButton = ButtonImageGadget(#PB_Any, 270, 10, osxGameButton, osxGameButton, ImageID(#ShiftIcon)) : GadgetToolTip(ShiftButton, "Shift")
	MirrorButton = ButtonImageGadget(#PB_Any, 300, 10, osxGameButton, osxGameButton, ImageID(#MirrorIcon)) : GadgetToolTip(MirrorButton, "Mirror")
	RotateButton = ButtonImageGadget(#PB_Any, 330, 10, osxGameButton, osxGameButton, ImageID(#RotateIcon)) : GadgetToolTip(RotateButton, "Rotate")
	ScaleButton = ButtonImageGadget(#PB_Any, 360, 10, osxGameButton, osxGameButton, ImageID(#ScaleIcon)) : GadgetToolTip(ScaleButton, "Scale")
	ResizeCanvasButton = ButtonImageGadget(#PB_Any, 390, 10, osxGameButton, osxGameButton, ImageID(#ResizeIcon)) : GadgetToolTip(ResizeCanvasButton, "Resize canvas")
	StretchButton = ButtonImageGadget(#PB_Any, 420, 10, osxGameButton, osxGameButton, ImageID(#StretchIcon)) : GadgetToolTip(StretchButton, "Stretch")
	
	GrayscaleButton = ButtonImageGadget(#PB_Any, 460, 10, osxGameButton, osxGameButton, ImageID(#GrayscaleIcon)) : GadgetToolTip(GrayscaleButton, "Grayscale")
	ColorizeButton = ButtonImageGadget(#PB_Any, 490, 10, osxGameButton, osxGameButton, ImageID(#ColorizeIcon)) : GadgetToolTip(ColorizeButton, "Colorize")
	ColorBalanceButton = ButtonImageGadget(#PB_Any, 520, 10, osxGameButton, osxGameButton, ImageID(#ColorBalanceIcon)) : GadgetToolTip(ColorBalanceButton, "Color balance")
	SwapRGBButton = ButtonImageGadget(#PB_Any, 550, 10, osxGameButton, osxGameButton, ImageID(#SwapRGBIcon)) : GadgetToolTip(SwapRGBButton, "Swap RGB channels")
	InvertButton = ButtonImageGadget(#PB_Any, 580, 10, osxGameButton, osxGameButton, ImageID(#InvertIcon)) : GadgetToolTip(InvertButton, "Invert")
	BrightnessButton = ButtonImageGadget(#PB_Any, 610, 10, osxGameButton, osxGameButton, ImageID(#BrightnessIcon)) : GadgetToolTip(BrightnessButton, "Brightness")
	OpacityButton = ButtonImageGadget(#PB_Any, 640, 10, osxGameButton, osxGameButton, ImageID(#OpacityIcon)) : GadgetToolTip(OpacityButton, "Opacity")
	PosterizeButton = ButtonImageGadget(#PB_Any, 670, 10, osxGameButton, osxGameButton, ImageID(#PosterizeIcon)) : GadgetToolTip(PosterizeButton, "Posterize")
	NoiseButton = ButtonImageGadget(#PB_Any, 700, 10, osxGameButton, osxGameButton, ImageID(#NoiseIcon)) : GadgetToolTip(NoiseButton, "Noise")
	EraseColorButton = ButtonImageGadget(#PB_Any, 730, 10, osxGameButton, osxGameButton, ImageID(#EraseColorIcon)) : GadgetToolTip(EraseColorButton, "Erase a color")
	MakeOpaqueButton = ButtonImageGadget(#PB_Any, 760, 10, osxGameButton, osxGameButton, ImageID(#MakeOpaqueIcon)) : GadgetToolTip(MakeOpaqueButton, "Make opaque")
	
	; OK button
	OKButton = ButtonGadget(#PB_Any, WindowWidth(FrameWindow) - 75, WindowHeight(FrameWindow) - 35 - MenuHeight(), 65, 25, "Done")
	
	; Scroller
	ScrollAreaGadget(#FrameEditorScroller, 10, 45, 780, 490 - MenuHeight(), 100, 100, 16, #PB_ScrollArea_Raised)
	CloseGadgetList()
	RedrawSpriteFrames(Sprite, 0)
	
	AddKeyboardShortcut(FrameWindow, #PB_Shortcut_Control | #PB_Shortcut_N, #FramesEditorFileNew)
	AddKeyboardShortcut(FrameWindow, #PB_Shortcut_Control | #PB_Shortcut_A, #FramesEditorFileAdd)
	AddKeyboardShortcut(FrameWindow, #PB_Shortcut_Control | #PB_Shortcut_S, #FramesEditorFileSavePNG)
	AddKeyboardShortcut(FrameWindow, #PB_Shortcut_Control | #PB_Shortcut_D, #FramesEditorEditDuplicate)
	AddKeyboardShortcut(FrameWindow, #PB_Shortcut_Control | #PB_Shortcut_Left, #FramesEditorEditMoveLeft)
	AddKeyboardShortcut(FrameWindow, #PB_Shortcut_Control | #PB_Shortcut_Right, #FramesEditorEditMoveRight)
	AddKeyboardShortcut(FrameWindow, #PB_Shortcut_Delete, #FramesEditorEditDeleteFrame)
	AddKeyboardShortcut(FrameWindow, #PB_Shortcut_Return, #FramesEditorEditEditFrame)
	
	Done = 0
	Repeat
		SetActiveWindow(FrameWindow)
		
		Select WaitWindowEvent()
				
			Case #PB_Event_Menu
				Select EventMenu()
						
					Case #FramesEditorFileNew
						FrameNew(FrameWindow, Sprite, FrameEditorSelectedBox)

					Case #FramesEditorFileAdd
						FrameAddFromFile(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorFileSavePNG
						FrameSavePNG(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEditDuplicate
						FrameDuplicate(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEditMoveLeft
						FrameMoveLeft(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEditMoveRight
						FrameMoveRight(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEditEditFrame
						FrameEdit(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEditDeleteFrame
						FrameDelete(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorTransformShift
						FrameShift(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorTransformMirror
						FrameMirror(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorTransformRotate
						FrameRotate(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorTransformScale
						FrameScale(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorTransformResizeCanvas
						FrameResizeCanvas(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorTransformStretch
						FrameStretch(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsBW
						FrameGrayscale(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsInvert
						FrameInvert(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsColorize
						FrameColorize(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsColorFlip
						FrameFlipRGB(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsOpacity
						FrameOpacity(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsPosterize
						FramePosterize(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsBrightness
						FrameBrightness(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsNoise
						FrameNoise(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsMakeOpaque
						FrameMakeOpaque(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsEraseColor
						FrameEraseColor(FrameWindow, Sprite, FrameEditorSelectedBox)
						
					Case #FramesEditorEffectsColorBalance
						FrameColorBalance(FrameWindow, Sprite, FrameEditorSelectedBox)
						
				EndSelect
				
			Case #PB_Event_Gadget
				
				ClickedGadget = EventGadget()
				
				If ClickedGadget = NewButton : FrameNew(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = AddButton : FrameAddFromFile(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = SaveButton : FrameSavePNG(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = DuplicateButton : FrameDuplicate(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = MoveLeftButton : FrameMoveLeft(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = MoveRightButton : FrameMoveRight(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = EditButton : FrameEdit(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = DeleteButton : FrameDelete(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = ShiftButton : FrameShift(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = MirrorButton : FrameMirror(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = RotateButton : FrameRotate(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = ScaleButton : FrameScale(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = ResizeCanvasButton : FrameResizeCanvas(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = StretchButton : FrameStretch(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = GrayscaleButton : FrameGrayscale(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = ColorizeButton : FrameColorize(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = ColorBalanceButton : FrameColorBalance(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = SwapRGBButton : FrameFlipRGB(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = InvertButton : FrameInvert(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = BrightnessButton : FrameBrightness(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = OpacityButton : FrameOpacity(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = PosterizeButton : FramePosterize(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = NoiseButton : FrameNoise(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = EraseColorButton : FrameEraseColor(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				If ClickedGadget = MakeOpaqueButton : FrameMakeOpaque(FrameWindow, Sprite, FrameEditorSelectedBox) : EndIf
				
				; OK button
				If ClickedGadget = OKButton
					Done = 1
					Dirty(1)
				EndIf
				
				; Click on the frame box
				For w = 0 To ArraySize(FrameBox()) - 1
					StructureIndex = GetGadgetData(FrameBox(w))
					; One of the box is selected
					If ClickedGadget = FrameBox(w) And EventType() = #PB_EventType_LeftClick
						FrameEditorSelectedBox = StructureIndex
					EndIf
				Next
				
				; redraw boxes
				If EventType() = #PB_EventType_LeftClick
					RedrawSpriteFrames(Sprite, 1)
				EndIf
				
		EndSelect
	Until Done = 1
	
	RefreshBoxImages()
	RefreshItems()
	
	CloseWindow(FrameWindow)
	
EndProcedure

; Sprite collision shape editor
Procedure EditCollisionShape(s)
	
	Sprites(s) \ ShapeEditorPickedPointGlobal = -1
	Sprites(s) \ ShapeEditorPickedPointLocal = -1
	
	DisableWindow(Sprites(s) \ GadgetWindow, 1)
	
	Sprites(s) \ GadgetShapeWindow = OpenWindow(#PB_Any, 0, 0, 480, 480, "Sprite collision shape editor - " + Sprites(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_Tool, WindowID(#MainWindow))
	;StickyWindow(Sprites(s) \ GadgetShapeWindow, 1)
	
	AddWindowTimer(Sprites(s) \ GadgetShapeWindow, Sprites(s) \ Timer2, Sprites(s) \ AnimSpeed)
	
	; OK button
	Sprites(s) \ GadgetShapeOK = ButtonGadget(#PB_Any, WindowWidth(Sprites(s) \ GadgetShapeWindow) - 75, WindowHeight(Sprites(s) \ GadgetShapeWindow) - 35, 65, 25, " Done ")
	
	; Sprite info
	TextGadget(#PB_Any, 10, 15, 100, 25, "Point list")
	frames = 0
	For f = 0 To ArraySize(Frames()) - 1
		If Frames(f) \ Sprite = Sprites(s) \ Name
			frames = frames + 1
		EndIf
	Next
	TextGadget(#PB_Any, 120, 15, 200, 25, "Number of frames: " + Str(frames))
	If frames > 1
		Sprites(s) \ GadgetShapePrevFrame = ButtonGadget(#PB_Any, 415, 10, 25, 25, "<")
		Sprites(s) \ GadgetShapeNextFrame = ButtonGadget(#PB_Any, 445, 10, 25, 25, ">")
	EndIf
	
	; Point list
	Sprites(s) \ GadgetShapePointList = ListViewGadget(#PB_Any, 10, 40, 100, 250)
	; Refresh the point list
	ClearGadgetItems(Sprites(s) \ GadgetShapePointList)
	For p = 0 To ArraySize(CollisionPoints()) - 1
		If CollisionPoints(p) \ Sprite = Sprites(s) \ Name
			AddGadgetItem(Sprites(s) \ GadgetShapePointList, -1, "(" + Str(CollisionPoints(p) \ X) + "," + Str(CollisionPoints(p) \ Y) + ")")
		EndIf
	Next
	
	; Point delete button
	Sprites(s) \ GadgetShapePointDelete = ButtonGadget(#PB_Any, 10, 300, 100, 25, "Delete")
	
	; Show grid / snap grid
	Sprites(s) \ GadgetShapeSnapToGrid = CheckBoxGadget(#PB_Any, 10, 330, 100, 25, "Snap to grid")
	SetGadgetState(Sprites(s) \ GadgetShapeSnapToGrid, Sprites(s) \ ShapeEditorSnapToGrid)
	
	; Snap grid size
	TextGadget(#PB_Any, 10, 365, 70, 25, "Width")
	Sprites(s) \ GadgetShapeGridWidth = StringGadget(#PB_Any, 80, 360, 30, 25, Str(Sprites(s) \ ShapeEditorGridWidth))
	TextGadget(#PB_Any, 10, 395, 70, 25, "Height")
	Sprites(s) \ GadgetShapeGridHeight = StringGadget(#PB_Any, 80, 390, 30, 25, Str(Sprites(s) \ ShapeEditorGridHeight))
	
	; Canvas
	Sprites(s) \ GadgetShapeCanvasScoller = ScrollAreaGadget(#PB_Any, 120, 40, 350, 350, 330, 330, 16, #PB_ScrollArea_Single)
	Sprites(s) \ GadgetShapeCanvas = CanvasGadget(#PB_Any, 0, 0, 330, 330)
	CloseGadgetList()
	
	; Zoom bar
	TextGadget(#PB_Any, 120, 395, 50, 25, "Zoom")
	Sprites(s) \ GadgetShapeZoom = TrackBarGadget(#PB_Any, 170, 390, 270, 25, 1, 8, #PB_TrackBar_Ticks)
	SetGadgetState(Sprites(s) \ GadgetShapeZoom, Sprites(s) \ ShapeEditorZoom)
	
EndProcedure

; Sprite STORE
Procedure SpriteFormStore(s, close)
	
	Sprites(s) \ Errors = 0
	
	; Check sprite name (Missing or exists)
	If GetGadgetText(Sprites(s) \ GadgetName) <> ""
		If SpriteNameIsFree(GetGadgetText(Sprites(s) \ GadgetName), s) = 0
			MessageRequester("Error", "The sprite name '" + GetGadgetText(Sprites(s) \ GadgetName) + "' already exists")
			Sprites(s) \ Errors = Sprites(s) \ Errors + 1
		EndIf
	Else
		MessageRequester("Error", "The sprite name is missing")
		Sprites(s) \ Errors = Sprites(s) \ Errors + 1
	EndIf
	
	; Form is correct
	If Sprites(s) \ Errors = 0
		
		Dirty(1)
		
		; Refresh objects using this sprite
		For r = 0 To ArraySize(Objects()) - 1
			If Objects(r) \ Sprite = Sprites(s) \ Name
				
				; Refresh TImage data in objects using the new sprite
				Objects(r) \ TImage = GetSpriteImage(Sprites(s) \ Name)
				If IsImage(Objects(r) \ TImage)
					Objects(r) \ TWidth = ImageWidth(Objects(r) \ TImage)
					Objects(r) \ THeight = ImageHeight(Objects(r) \ TImage)
				EndIf
				
				Objects(r) \ Sprite = GetGadgetText(Sprites(s) \ GadgetName)
				
			EndIf
		Next
		
		; Refresh frames using this name
		For r = 0 To ArraySize(Frames()) - 1
			If Frames(r) \ Sprite = Sprites(s) \ Name
				Frames(r) \ Sprite = GetGadgetText(Sprites(s) \ GadgetName)
			EndIf
		Next
		
		; Refresh points using this name
		For r = 0 To ArraySize(CollisionPoints()) - 1
			If CollisionPoints(r) \ Sprite = Sprites(s) \ Name
				CollisionPoints(r) \ Sprite = GetGadgetText(Sprites(s) \ GadgetName)
			EndIf
		Next		
		
		; SET THE NEW NAME
		Sprites(s) \ Name = GetGadgetText(Sprites(s) \ GadgetName)
		Sprites(s) \ Keywords = GetGadgetText(Sprites(s) \ GadgetKeywords)
		
		; UPDATE OBJECT'S SPRITE PREVIEW
		For r = 0 To ArraySize(Objects()) - 1
			RefreshObjectSprite(r)
		Next
		
		; CLOSE THE FORM OR SILENT SAVE
		If close = 1
			CloseWindow(Sprites(s) \ GadgetWindow)
			Sprites(s) \ GadgetWindow = 0
		EndIf
		RefreshItems()
		
		For a = 0 To ArraySize(Scenes()) - 1
			If IsWindow(Scenes(a) \ GadgetWindow)
				RefreshSceneObjectsList(a)
				RefreshSceneObjectToFollowCombo(a)
			EndIf
		Next
		
	EndIf
EndProcedure

; Sprite editor form
Procedure SpriteForm(Name.s)
	
	; Search the sprite by its name
	For s = 0 To ArraySize(Sprites()) - 1
		If Sprites(s) \ Name = Name
			
			; FORM IS ALREADY OPENED
			If IsWindow(Sprites(s) \ GadgetWindow)
				SetActiveWindow(Sprites(s) \ GadgetWindow)
				ProcedureReturn
			EndIf
			
			; Form window
			Sprites(s) \ GadgetWindow = OpenWindow(#PB_Any, 0, 0, 540, 450, "Sprite properties - " + Sprites(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget, WindowID(#MainWindow))
			;StickyWindow(Sprites(s) \ GadgetWindow, 1)
			
			; OK button
			Sprites(s) \ GadgetOK = ButtonGadget(#PB_Any, WindowWidth(Sprites(s) \ GadgetWindow) - 75, WindowHeight(Sprites(s) \ GadgetWindow) - 35, 65, 25, " Done ")
			
			; Delete button
			Sprites(s) \ GadgetDelete = ButtonGadget(#PB_Any, 10, WindowHeight(Sprites(s) \ GadgetWindow) - 35, 65, 25, "Delete")
			
			; Keywords input
			Sprites(s) \ GadgetKeywords = StringGadget(#PB_Any, WindowWidth(Sprites(s) \ GadgetWindow) / 2 - 100, WindowHeight(Sprites(s) \ GadgetWindow) - 35, 200, 25, Sprites(s) \ Keywords)
			
			; Sprite name
			Sprites(s) \ GadgetName = StringGadget(#PB_Any, 10, 10, 100, 25, Sprites(s) \ Name)
			
			; Import strip button
			Sprites(s) \ GadgetImportStrip = ButtonGadget(#PB_Any, 10, 40, 100, 25, "Load...")
			
			; Save strip button
			Sprites(s) \ GadgetSaveStrip = ButtonGadget(#PB_Any, 10, 70, 100, 25, "Save as PNG...")
			
			; Edit strip button
			Sprites(s) \ GadgetEditStrip = ButtonGadget(#PB_Any, 10, 100, 100, 25, "Edit")
			
			; Sprite dimensions
			Sprites(s) \ GadgetSize = TextGadget(#PB_Any, 10, 135, 100, 25, "")
			
			; Image preview in the scroller area
			Sprites(s) \ GadgetPreviewScroller = ScrollAreaGadget(#PB_Any, 120, 10, 300, 300, 40, 40, 32, #PB_ScrollArea_Single)
			Sprites(s) \ GadgetSpritePreview = CanvasGadget(#PB_Any, 0, 0, 0, 0)
			StartDrawing(CanvasOutput(Sprites(s) \ GadgetSpritePreview))
			DrawingMode(#PB_2DDrawing_Default)
			StopDrawing()
			CloseGadgetList()
			
			; Preview collision shape checkbox
			Sprites(s) \ GadgetShowCollisionShape = CheckBoxGadget(#PB_Any, 125, 320, 150, 25, "Show collision shape")
			SetGadgetState(Sprites(s) \ GadgetShowCollisionShape, Sprites(s) \ ShowCollisionShape)
			
			; Animation speed controller
			TextGadget(#PB_Any, 280, 325, 110, 25, "Preview speed")
			Sprites(s) \ GadgetAnimSpeed = StringGadget(#PB_Any, 370, 320, 50, 25, Str(Sprites(s) \ AnimSpeed), #PB_String_Numeric)
			
			; Zoom trackbar
			TextGadget(#PB_Any, 120, 355, 35, 25, "Zoom")
			Sprites(s) \ GadgetZoomTrackbar = TrackBarGadget(#PB_Any, 165, 350, 260, 25, 1, 64, #PB_TrackBar_Ticks)
			SetGadgetState(Sprites(s) \ GadgetZoomTrackbar, Sprites(s) \ Zoom)
						
			; Origin X/Y
			TextGadget(#PB_Any, 430, 15, 55, 25, "Origin X")
			Sprites(s) \ GadgetCenterX = StringGadget(#PB_Any, 480, 10, 50, 25, Str(Sprites(s) \ CenterX))
			TextGadget(#PB_Any, 430, 45, 55, 25, "Origin Y")
			Sprites(s) \ GadgetCenterY = StringGadget(#PB_Any, 480, 40, 50, 25, Str(Sprites(s) \ CenterY))
			
			; Center button
			Sprites(s) \ GadgetCenter = ButtonGadget(#PB_Any, 430, 70, 100, 25, "Center")
			
			; Collision type
			TextGadget(#PB_Any, 430, 115, 45, 25, "Collision")
			Sprites(s) \ GadgetCollisionShape = ComboBoxGadget(#PB_Any, 480, 110, 50, 25)
			AddGadgetItem(Sprites(s) \ GadgetCollisionShape, -1, "Circle")
			AddGadgetItem(Sprites(s) \ GadgetCollisionShape, -1, "Box")
			AddGadgetItem(Sprites(s) \ GadgetCollisionShape, -1, "Shape")
			SetGadgetText(Sprites(s) \ GadgetCollisionShape, Sprites(s) \ CollisionShape)
			
			; Collision radius
			TextGadget(#PB_Any, 430, 145, 50, 25, "Radius")
			Sprites(s) \ GadgetCollisionRadius = StringGadget(#PB_Any, 480, 140, 50, 25, Str(Sprites(s) \ CollisionRadius), #PB_String_Numeric)
			
			; Collision Left, Right, Top, Bottom
			TextGadget(#PB_Any, 430, 175, 50, 25, "Left")
			Sprites(s) \ GadgetCollisionLeft = StringGadget(#PB_Any, 480, 170, 50, 25, Str(Sprites(s) \ CollisionLeft))
			TextGadget(#PB_Any, 430, 205, 50, 25, "Right")
			Sprites(s) \ GadgetCollisionRight = StringGadget(#PB_Any, 480, 200, 50, 25, Str(Sprites(s) \ CollisionRight))
			TextGadget(#PB_Any, 430, 235, 50, 25, "Top")
			Sprites(s) \ GadgetCollisionTop = StringGadget(#PB_Any, 480, 230, 50, 25, Str(Sprites(s) \ CollisionTop))
			TextGadget(#PB_Any, 430, 265, 50, 25, "Bottom")
			Sprites(s) \ GadgetCollisionBottom = StringGadget(#PB_Any, 480, 260, 50, 25, Str(Sprites(s) \ CollisionBottom))
			
			; Edit collision shape button
			Sprites(s) \ GadgetCollectionShapeEdit = ButtonGadget(#PB_Any, 430, 290, 100, 25, "Shape...")
			
			; Timer for the animation sequence
			AddWindowTimer(Sprites(s) \ GadgetWindow, Sprites(s) \ Timer, Round(1000 / Sprites(s) \ AnimSpeed , #PB_Round_Down))
			
			RefreshItems()
			
			Break
			
		EndIf
	Next
	
EndProcedure

; Refresh the background canvas image
Procedure RefreshBackgroundImage(ScrollerGadget, BackgroundCanvas, Image)
	
	; Valid background image
	If IsImage(Image)
		
		; Get the image dimensions
		NewWidth = ImageWidth(Image)
		NewHeight = ImageHeight(Image)
		
		; Resize the image canvas and the scroller area
		ResizeGadget(BackgroundCanvas, 0, 0, NewWidth, NewHeight)
		SetGadgetAttribute(ScrollerGadget, #PB_ScrollArea_InnerWidth, NewWidth)
		SetGadgetAttribute(ScrollerGadget, #PB_ScrollArea_InnerHeight, NewHeight)
		
		; Draw the background image
		StartDrawing(CanvasOutput(BackgroundCanvas))
		If IsImage(Image)
			DrawImage(ImageID(Image), 0, 0)
		EndIf
		StopDrawing()
		
	EndIf
	
EndProcedure

; Delete the specified background
Procedure DeleteBackground(BackgroundName.s)
	
	; Search for the background
	Dim TempBackgrounds.Background(0)
	For m = 0 To ArraySize(Backgrounds()) - 1
		If Backgrounds(m) \ Name <> BackgroundName
			
			Index = ArraySize(TempBackgrounds())	
			ReDim TempBackgrounds(Index + 1)
			TempBackgrounds(Index) = Backgrounds(m)
		EndIf
	Next
	
	CopyArray(TempBackgrounds(), Backgrounds())
	
	; Reset the scene backgrounds when used the current one
	For w = 0 To ArraySize(Scenes()) - 1
		If Scenes(w) \ Background = BackgroundName
			Scenes(w) \ Background = ""
		EndIf
	Next
	
	; Delete tiles using this background
	Dim TileTrash.s(0)
	For r = 0 To ArraySize(Tiles()) - 1
		If Tiles(r) \ Background = BackgroundName
			Index = ArraySize(TileTrash())
			ReDim TileTrash(Index + 1)
			TileTrash(Index) = Tiles(r) \ Name
		EndIf
	Next
	; Delete trash
	For r = 0 To ArraySize(TileTrash()) - 1
		DeleteTile(TileTrash(r))
	Next
	
EndProcedure

Procedure BackgroundFormStore(s, close)
	Backgrounds(s) \ Errors = 0
	
	; Check background name (Missing or exists)
	If GetGadgetText(Backgrounds(s) \ GadgetName) <> ""
		If BackgroundNameIsFree(GetGadgetText(Backgrounds(s) \ GadgetName), s) = 0
			MessageRequester("Error", "The background name '" + GetGadgetText(Backgrounds(s) \ GadgetName) + "' already exists")
			Backgrounds(s) \ Errors = Backgrounds(s) \ Errors + 1
		EndIf
	Else
		MessageRequester("Error", "The background name is missing")
		Backgrounds(s) \ Errors = Backgrounds(s) \ Errors + 1
	EndIf
	
	; Form is correct
	If Backgrounds(s) \ Errors = 0
		
		Dirty(1)
		
		; Refresh the scene background info
		For w = 0 To ArraySize(Scenes()) - 1
			If Scenes(w) \ Background = Backgrounds(s) \ Name
				Scenes(w) \ Background = GetGadgetText(Backgrounds(s) \ GadgetName)
			EndIf
		Next
		
		; Refresh the tile background info
		For w = 0 To ArraySize(Tiles()) - 1
			If Tiles(w) \ Background = Backgrounds(s) \ Name
				Tiles(w) \ Background = GetGadgetText(Backgrounds(s) \ GadgetName)
			EndIf
		Next
		
		Backgrounds(s) \ Name = GetGadgetText(Backgrounds(s) \ GadgetName)						
		Backgrounds(s) \ Tile = GetGadgetState(Backgrounds(s) \ GadgetTileCheckbox)
		Backgrounds(s) \ TileWidth = Val(GetGadgetText(Backgrounds(s) \ GadgetTileWidth))
		Backgrounds(s) \ TileHeight = Val(GetGadgetText(Backgrounds(s) \ GadgetTileHeight))
		Backgrounds(s) \ TileXOffset = Val(GetGadgetText(Backgrounds(s) \ GadgetTileXoffset))
		Backgrounds(s) \ TileYOffset = Val(GetGadgetText(Backgrounds(s) \ GadgetTileYoffset))
		Backgrounds(s) \ TileXSpace = Val(GetGadgetText(Backgrounds(s) \ GadgetTileXSpace))
		Backgrounds(s) \ TileYSpace = Val(GetGadgetText(Backgrounds(s) \ GadgetTileYSpace))
		Backgrounds(s) \ Keywords = GetGadgetText(Backgrounds(s) \ GadgetKeywords)
		
		Backgrounds(s) \ File = GetFilePart(Backgrounds(s) \ SelectedFile)
		CopyFile(Backgrounds(s) \ SelectedFile, TempName + "/" + GetFilePart(Backgrounds(s) \ SelectedFile))
		
		If close = 1
			CloseWindow(Backgrounds(s) \ GadgetWindow)
			Backgrounds(s) \ GadgetWindow = 0
		EndIf
		
		RefreshItems()
		
		; REFRESH SCENE BACKGROUNDS AND TILES USING THIS BACKGROUND
		For a = 0 To ArraySize(Scenes()) - 1
			If IsWindow(Scenes(a) \ GadgetWindow)
				RefreshSceneBackgroundImage(a)
				RefreshSceneBackgroundsCombo(a)
				RefreshSceneTilesCombo(a)
				SetGadgetText(Scenes(a) \ InnerTileImageCombo, Backgrounds(s) \ Name)
				RefreshSceneSelectedTile(a)
				RefreshTileImage(Scenes(a) \ InnerTileCanvas, Scenes(a) \ InnerTileScroller, Backgrounds(s) \ Name)
			EndIf
		Next
		
	EndIf
	
EndProcedure

; Display the background form
Procedure BackgroundForm(Name.s)
	
	; Search the background by its name
	For s = 0 To ArraySize(Backgrounds()) - 1
		If Backgrounds(s) \ Name = Name
			
			; FORM IS ALREADY OPENED
			If IsWindow(Backgrounds(s) \ GadgetWindow)
				SetActiveWindow(Backgrounds(s) \ GadgetWindow)
				ProcedureReturn
			EndIf			
			
			; Loads the current background image for previewing
			Backgrounds(s) \ SelectedFile = Backgrounds(s) \ File
			If Backgrounds(s) \ File <> ""
				Backgrounds(s) \ BackgroundImage = LoadImage(#PB_Any, TempName + "/" + Backgrounds(s) \ File)
			EndIf
			
			; Form window
			Backgrounds(s) \ GadgetWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Background properties - " + Backgrounds(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget, WindowID(#MainWindow))
			;StickyWindow(Backgrounds(s) \ GadgetWindow, 1)
			
			; OK button
			Backgrounds(s) \ GadgetOK = ButtonGadget(#PB_Any, WindowWidth(Backgrounds(s) \ GadgetWindow) - 75, WindowHeight(Backgrounds(s) \ GadgetWindow) - 35, 65, 25, "Done")
			
			; Delete button
			Backgrounds(s) \ GadgetDelete = ButtonGadget(#PB_Any, 10, WindowHeight(Backgrounds(s) \ GadgetWindow) - 35, 65, 25, "Delete")
			
			; Keywords input
			Backgrounds(s) \ GadgetKeywords = StringGadget(#PB_Any, WindowWidth(Backgrounds(s) \ GadgetWindow) / 2 - 100, WindowHeight(Backgrounds(s) \ GadgetWindow) - 35, 200, 25, Backgrounds(s) \ Keywords)
			
			; Background name
			Backgrounds(s) \ GadgetName = StringGadget(#PB_Any, 10, 10, 100, 25, Backgrounds(s) \ Name)
			
			; File handling
			Backgrounds(s) \ GadgetFileName = TextGadget(#PB_Any, 10, 45, 100, 25, "File: " + Backgrounds(s) \ File)
			Backgrounds(s) \ GadgetFileSelector = ButtonGadget(#PB_Any, 10, 70, 100, 25, "Select image...")
			
			; Scroller area
			Backgrounds(s) \ GadgetScroller = ScrollAreaGadget(#PB_Any, 120, 10, 670, 540, 400, 300, 16, #PB_ScrollArea_Flat | #PB_ScrollArea_BorderLess)
			Backgrounds(s) \ GadgetBackgroundCanvas = CanvasGadget(#PB_Any, 0, 0, 0, 0)
			CloseGadgetList()
			RefreshBackgroundImage(Backgrounds(s) \ GadgetScroller, Backgrounds(s) \ GadgetBackgroundCanvas, Backgrounds(s) \ BackgroundImage)
			
			; Tile
			Backgrounds(s) \ GadgetTileCheckbox = CheckBoxGadget(#PB_Any, 10, 105, 100, 25, "Use as tile set")
			SetGadgetState(Backgrounds(s) \ GadgetTileCheckbox, Backgrounds(s) \ Tile)
			
			Backgrounds(s) \ TileContainerX = 10000
			If Backgrounds(s) \ Tile = 1
				Backgrounds(s) \ TileContainerX = 10
			EndIf
			
			Backgrounds(s) \ GadgetTileContainer = ContainerGadget(#PB_Any, Backgrounds(s) \ TileContainerX, 130, 100, 280, #PB_Container_Raised)
			
			TextGadget(#PB_Any, 10, 15, 50, 25, "Width")
			Backgrounds(s) \ GadgetTileWidth = StringGadget(#PB_Any, 50, 10, 30, 25, Str(Backgrounds(s) \ TileWidth), #PB_String_Numeric)
			TextGadget(#PB_Any, 10, 45, 50, 25, "Height")
			Backgrounds(s) \ GadgetTileHeight = StringGadget(#PB_Any, 50, 40, 30, 25, Str(Backgrounds(s) \ TileHeight), #PB_String_Numeric)
			
			TextGadget(#PB_Any, 10, 105, 50, 25, "X offset")
			Backgrounds(s) \ GadgetTileXoffset = StringGadget(#PB_Any, 50, 100, 30, 25, Str(Backgrounds(s) \ TileXOffset), #PB_String_Numeric)
			TextGadget(#PB_Any, 10, 145, 50, 25, "Y offset")
			Backgrounds(s) \ GadgetTileYoffset = StringGadget(#PB_Any, 50, 140, 30, 25, Str(Backgrounds(s) \ TileYOffset), #PB_String_Numeric)
			
			TextGadget(#PB_Any, 10, 205, 50, 25, "X space")
			Backgrounds(s) \ GadgetTileXSpace = StringGadget(#PB_Any, 50, 200, 30, 25, Str(Backgrounds(s) \ TileXSpace), #PB_String_Numeric)
			TextGadget(#PB_Any, 10, 245, 50, 25, "Y space")
			Backgrounds(s) \ GadgetTileYSpace = StringGadget(#PB_Any, 50, 240, 30, 25, Str(Backgrounds(s) \ TileYSpace), #PB_String_Numeric)
			
			CloseGadgetList()
			
			AddWindowTimer(Backgrounds(s) \ GadgetWindow, Backgrounds(s) \ Timer, 33)
			
			RefreshItems()
			
			Break
			
		EndIf
	Next
	
EndProcedure

; Delete the specified font
Procedure DeleteFont(FontName.s)
	
	; Search for the font
	Dim TempFonts.Font(0)
	For m = 0 To ArraySize(Fonts()) - 1
		If Fonts(m) \ Name <> FontName
			
			Index = ArraySize(TempFonts())	
			ReDim TempFonts(Index + 1)
			TempFonts(Index) = Fonts(m)
		EndIf
	Next
	CopyArray(TempFonts(), Fonts())
	
EndProcedure

Procedure FontFormStore(s, close)
	Fonts(s) \ Errors = 0
	
	; Check font name (Missing or exists)
	If GetGadgetText(Fonts(s) \ GadgetName) <> ""
		
		If FontNameIsFree(GetGadgetText(Fonts(s) \ GadgetName), s) = 0
			MessageRequester("Error", "The font name '" + GetGadgetText(Fonts(s) \ GadgetName) + "' already exists")
			Fonts(s) \ Errors = Fonts(s) \ Errors + 1
		EndIf
		
		If Val(GetGadgetText(Fonts(s) \ GadgetSize)) < 1
			MessageRequester("Error", "The font size '" + GetGadgetText(Fonts(s) \ GadgetSize) + "' is invalid")
			Fonts(s) \ Errors = Fonts(s) \ Errors + 1
		EndIf
	Else
		MessageRequester("Error", "The font name is missing")
		Fonts(s) \ Errors = Fonts(s) \ Errors + 1
	EndIf					
		
	; Form is correct
	If Fonts(s) \ Errors = 0
		
		Dirty(1)
		
		Fonts(s) \ Name = GetGadgetText(Fonts(s) \ GadgetName)
		Fonts(s) \ Family = GetGadgetText(Fonts(s) \ GadgetFamily)
		Fonts(s) \ Size = Val(GetGadgetText(Fonts(s) \ GadgetSize))
		Fonts(s) \ Keywords = GetGadgetText(Fonts(s) \ GadgetKeywords)
		
		If GetGadgetState(Fonts(s) \ GadgetBold) = #PB_Checkbox_Checked
			Fonts(s) \ Bold = 1
		Else
			Fonts(s) \ Bold = 0
		EndIf
		
		If GetGadgetState(Fonts(s) \ GadgetItalic) = #PB_Checkbox_Checked
			Fonts(s) \ Italic = 1
		Else
			Fonts(s) \ Italic = 0
		EndIf
		
		If close = 1
			CloseWindow(Fonts(s) \ GadgetWindow)
			Fonts(s) \ GadgetWindow = 0
		EndIf
		
		RefreshItems()
		
	EndIf
	
EndProcedure

; Display the font form
Procedure FontForm(Name.s)
	
	; Search the font by its name
	For s = 0 To ArraySize(Fonts()) - 1
		If Fonts(s) \ Name = Name
			
			; FORM IS ALREADY OPENED
			If IsWindow(Fonts(s) \ GadgetWindow)
				SetActiveWindow(Fonts(s) \ GadgetWindow)
				ProcedureReturn
			EndIf				
			
			; Form window
			Fonts(s) \ GadgetWindow = OpenWindow(#PB_Any, 0, 0, 310, 300, "Font properties - " + Fonts(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget, WindowID(#MainWindow))
			;StickyWindow(Fonts(s) \ GadgetWindow, 1)
			
			; OK button
			Fonts(s) \ GadgetOK = ButtonGadget(#PB_Any, WindowWidth(Fonts(s) \ GadgetWindow) - 75, WindowHeight(Fonts(s) \ GadgetWindow) - 35, 65, 25, "Done")
			
			; Delete button
			Fonts(s) \ GadgetDelete = ButtonGadget(#PB_Any, 10, WindowHeight(Fonts(s) \ GadgetWindow) - 35, 65, 25, "Delete")			
			
			; Keywords input
			Fonts(s) \ GadgetKeywords = StringGadget(#PB_Any, WindowWidth(Fonts(s) \ GadgetWindow) / 2 - 60, WindowHeight(Fonts(s) \ GadgetWindow) - 35, 120, 25, Fonts(s) \ Keywords)
			
			; Font name
			Fonts(s) \ GadgetName = StringGadget(#PB_Any, 10, 10, 120, 25, Fonts(s) \ Name)
			
			; Family
			TextGadget(#PB_Any, 10, 50, 40, 25, "Family")
			Fonts(s) \ GadgetFamily = StringGadget(#PB_Any, 50, 45, 80, 25, Fonts(s) \ Family)
			
			; Size
			TextGadget(#PB_Any, 10, 85, 40, 25, "Size")
			Fonts(s) \ GadgetSize = StringGadget(#PB_Any, 50, 80, 80, 25, Str(Fonts(s) \ Size), #PB_String_Numeric)
			
			; Bold
			TextGadget(#PB_Any, 10, 115, 40, 25, "Bold")
			Fonts(s) \ GadgetBold = CheckBoxGadget(#PB_Any, 50, 110, 50, 25, "")
			If Fonts(s) \ Bold = 1 : SetGadgetState(Fonts(s) \ GadgetBold, #PB_Checkbox_Checked) : EndIf
			
			; Italic
			TextGadget(#PB_Any, 10, 145, 40, 25, "Italic")
			Fonts(s) \ GadgetItalic = CheckBoxGadget(#PB_Any, 50, 140, 50, 25, "")
			If Fonts(s) \ Italic = 1 : SetGadgetState(Fonts(s) \ GadgetItalic, #PB_Checkbox_Checked) : EndIf
			
			; FONT PREVIEW TEXT
			Fonts(s) \ PreviewCanvas = CanvasGadget(#PB_Any, 10, 175, 290, 80)
			If IsFont(Fonts(s) \ PreviewFont) : FreeFont(Fonts(s) \ PreviewFont) : EndIf
			Fonts(s) \ PreviewFont = LoadFont(#PB_Any, Fonts(s) \ Family, Fonts(s) \ Size, (#PB_Font_Bold * Fonts(s) \ Bold) | (#PB_Font_Italic * Fonts(s) \ Italic) | #PB_Font_HighQuality)
			StartDrawing(CanvasOutput(Fonts(s) \ PreviewCanvas))
			BackColor(RGB(255,255,255))
			Box(0, 0, 290, 80)
		    DrawingFont(FontID(Fonts(s) \ PreviewFont))
		    DrawingMode(#PB_2DDrawing_Transparent)
		    FrontColor(0)
		    DrawText(2, 2, "the brown fox jumps over the lazy dog")
			StopDrawing()
			
			RefreshItems()
			
			Break
			
		EndIf
	Next
	
EndProcedure

; Refresh the object event list
Procedure RefreshEventList(ObjectIndex) 
	
	ClearGadgetItems(Objects(ObjectIndex) \ GadgetEventList)
	
	; CREATION events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "Creation"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconCreation))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next
	
	; DESTROY events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "Destroy"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconDestroy))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next
	
	; STEP events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "Step"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconStep))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next	
	
	; END STEP events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "End step"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconEndStep))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next	
	
	; COLLISION events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "Collision"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconCollision))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next
	
	; ROOM START events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "Room start"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconRoomStart))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next	
	
	; ROOM END events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "Room end"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconRoomEnd))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next	
	
	; ANIMATION END events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "Animation end"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconAnimationEnd))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next
	
	; DRAW events
	For e = 0 To ArraySize(Scripts()) - 1
		If Scripts(e) \ Parent = Objects(ObjectIndex) \ Name And Scripts(e) \ Type = "Draw"
			AddGadgetItem(Objects(ObjectIndex) \ GadgetEventList, -1, Scripts(e) \ Type + Chr(10) + Scripts(e) \ Parameter, ImageID(#IconDraw))
			SetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, CountGadgetItems(Objects(ObjectIndex) \ GadgetEventList) - 1, e)
		EndIf
	Next
	
EndProcedure

; Add a new event
Procedure AddNewEvent(Parent.s, Type.s, Parameter.s)
	
	Index = ArraySize(Scripts())
	ReDim Scripts(Index + 1)
	
	Scripts(Index) \ Type = Type.s
	Scripts(Index) \ Code = ""
	Scripts(Index) \ Parameter = Parameter.s
	Scripts(Index) \ Parent = Parent.s
	Scripts(Index) \ Name = "scr_" + Str(UID())
	
	ProcedureReturn Index
	
EndProcedure

Procedure InitCodeEditor(Gadget)
	
	GOSCI_SetColor(Gadget, #GOSCI_FORECOLOR, sci_color_fore)
	GOSCI_SetColor(Gadget, #GOSCI_SELECTIONBACKCOLOR, sci_color_selection_back)
	GOSCI_SetColor(Gadget, #GOSCI_SELECTIONFORECOLOR, sci_color_selection_fore)
	GOSCI_SetColor(Gadget, #GOSCI_CARETLINEBACKCOLOR, sci_color_caret)
	GOSCI_SetFont(Gadget, sci_font_family, sci_font_size)
	GOSCI_SetTabs(Gadget, 4)
	
	GOSCI_SetMarginWidth(Gadget, #GOSCI_MARGINFOLDINGSYMBOLS, 24)
	
	GOSCI_SetStyleColors(Gadget, #STYLES_COMMANDS, sci_color_command)
	GOSCI_SetStyleFont(Gadget, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
	GOSCI_SetStyleColors(Gadget, #STYLES_COMMENTS, sci_color_comment)	
	GOSCI_SetStyleColors(Gadget, #STYLES_GM_FUNCTION, sci_color_tu_function)
	GOSCI_SetStyleColors(Gadget, #STYLES_GM_VARIABLE, sci_color_tu_variable)
	GOSCI_SetStyleColors(Gadget, #STYLES_GM_CONSTANT, sci_color_tu_constant)
	GOSCI_SetStyleColors(Gadget, #STYLES_ITEM, sci_color_resource)
	GOSCI_SetStyleColors(Gadget, #STYLES_LITERALSTRINGS, sci_color_string)
	GOSCI_SetStyleColors(Gadget, #STYLES_NUMBERS, sci_color_number)
	GOSCI_SetStyleColors(Gadget, #STYLES_FUNCTIONS, sci_color_function)
	
	GOSCI_SetStyleFont(Gadget, #STYLES_ERROR, "", -1, #PB_Font_Bold)
	GOSCI_SetStyleColors(Gadget, #STYLES_ERROR, $FF0000)
	
	GOSCI_AddDelimiter(Gadget, Chr(34), Chr(34), #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
	GOSCI_AddDelimiter(Gadget, "'", "'", #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
	GOSCI_AddDelimiter(Gadget, "(", "", #GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FUNCTIONS)
	GOSCI_AddDelimiter(Gadget, ")", "", 0, #STYLES_FUNCTIONS)
	
	GOSCI_AddKeywords(Gadget, "break case catch continue debugger default delete do else finally for function if in instanceof new return switch this throw try typeof var void while with true false null undefined", #STYLES_COMMANDS, #GOSCI_ADDTOCODECOMPLETION, #True)
	
	GOSCI_AddKeywords(Gadget, "{", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD)
	GOSCI_AddKeywords(Gadget, "}", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD)
	
	; Stylize all sprite names
	For z = 0 To ArraySize(Sprites()) - 1
		GOSCI_AddKeywords(Gadget, Sprites(z) \ Name, #STYLES_ITEM, #GOSCI_ADDTOCODECOMPLETION, #True)
	Next
	
	; Stylize all sound names
	For z = 0 To ArraySize(Sounds()) - 1
		GOSCI_AddKeywords(Gadget, Sounds(z) \ Name, #STYLES_ITEM, #GOSCI_ADDTOCODECOMPLETION, #True)
	Next
	
	; Stylize all music names
	For z = 0 To ArraySize(Musics()) - 1
		GOSCI_AddKeywords(Gadget, Musics(z) \ Name, #STYLES_ITEM, #GOSCI_ADDTOCODECOMPLETION, #True)
	Next
	
	; Stylize all background names
	For z = 0 To ArraySize(Backgrounds()) - 1
		GOSCI_AddKeywords(Gadget, Backgrounds(z) \ Name, #STYLES_ITEM, #GOSCI_ADDTOCODECOMPLETION, #True)
	Next
	
	; Stylize all font names
	For z = 0 To ArraySize(Fonts()) - 1
		GOSCI_AddKeywords(Gadget, Fonts(z) \ Name, #STYLES_ITEM, #GOSCI_ADDTOCODECOMPLETION, #True)
	Next
	
	; Stylize all object names
	For z = 0 To ArraySize(Objects()) - 1
		If Objects(z) \ Proto = 1
			GOSCI_AddKeywords(Gadget, Objects(z) \ Name, #STYLES_ITEM, #GOSCI_ADDTOCODECOMPLETION, #True)
		EndIf
	Next
	
	; Stylize all scene names
	For z = 0 To ArraySize(Scenes()) - 1
		GOSCI_AddKeywords(Gadget, Scenes(z) \ Name, #STYLES_ITEM, #GOSCI_ADDTOCODECOMPLETION, #True)
	Next
	
	; Stylize all function names
	For z = 0 To ArraySize(Functions()) - 1
		GOSCI_AddKeywords(Gadget, Functions(z) \ Name, #STYLES_ITEM, #GOSCI_ADDTOCODECOMPLETION, #True)
	Next	
	
	; Stylize all GM functions, vars, constants
	For z = 0 To ArraySize(Keywords()) - 1
		If Keywords(z) \ Type = "Fn" : GOSCI_AddKeywords(Gadget, Keywords(z) \ Word, #STYLES_GM_FUNCTION, #GOSCI_ADDTOCODECOMPLETION, #True) : EndIf
		If Keywords(z) \ Type = "Var" : GOSCI_AddKeywords(Gadget, Keywords(z) \ Word, #STYLES_GM_VARIABLE, #GOSCI_ADDTOCODECOMPLETION, #True) : EndIf
		If Keywords(z) \ Type = "Cons" : GOSCI_AddKeywords(Gadget, Keywords(z) \ Word, #STYLES_GM_CONSTANT, #GOSCI_ADDTOCODECOMPLETION, #True) : EndIf
	Next	
	
	GOSCI_SetLexerOption(Gadget, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.|&;")
	GOSCI_SetLexerOption(Gadget, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)
	GOSCI_SetLexerState(Gadget, #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING | #GOSCI_LEXERSTATE_ENABLECODEFOLDING | #GOSCI_LEXERSTATE_ENABLECODECOMPLETION | #GOSCI_LEXERSTATE_ENABLEAUTOINDENTATION)
	
	GOSCI_SetLineStylingFunction(Gadget, @MyLineStyler())
	
EndProcedure	

; Resize code editor
Procedure EditScript_Resized(Window, CodeGadget, OKButton, CancelButton, HoverText, HoverDescription)
	ResizeGadget(CodeGadget, #PB_Ignore, #PB_Ignore, WindowWidth(Window) - 20, WindowHeight(Window) - 155)
	ResizeGadget(OKButton, WindowWidth(Window) - 75, WindowHeight(Window) - 35, #PB_Ignore, #PB_Ignore)
	ResizeGadget(CancelButton, #PB_Ignore, WindowHeight(Window) - 35, #PB_Ignore, #PB_Ignore)
	ResizeGadget(HoverText, #PB_Ignore, WindowHeight(Window) - 95, WindowWidth(Window) - 20, 21)
	ResizeGadget(HoverDescription, #PB_Ignore, WindowHeight(Window) - 65, WindowWidth(Window) - 20, 21)
	ScriptEditorWidth = WindowWidth(Window)
	ScriptEditorHeight = WindowHeight(Window)
	ScriptEditorMaximized = -1
	If GetWindowState(Window) = #PB_Window_Maximize
		ScriptEditorMaximized = 1
	EndIf
EndProcedure

Procedure EditCodeStore(s, close)
	ScriptEditorX = WindowX(Objects(s) \ GadgetCodeWindow)
	ScriptEditorY = WindowY(Objects(s) \ GadgetCodeWindow)
	Scripts(Objects(s) \ ScriptIndex) \ Type = GetGadgetText(Objects(s) \ GadgetCodeEvents)
	Scripts(Objects(s) \ ScriptIndex) \ Parameter = GetGadgetText(Objects(s) \ GadgetCodeParameter)
	Scripts(Objects(s) \ ScriptIndex) \ Code = GOSCI_GetText(Objects(s) \ GadgetScintilla)
	If close = 1
		GOSCI_Free(Objects(s) \ GadgetScintilla)
		DisableWindow(Objects(s) \ GadgetWindow, 0)
		CloseWindow(Objects(s) \ GadgetCodeWindow)
		Objects(s) \ GadgetCodeWindow = 0
	EndIf
	RefreshEventList(s)
EndProcedure

; Edit the selected script
Procedure EditCode(s, e)
	
	Objects(s) \ ScriptIndex = e
	
	DisableWindow(Objects(s) \ GadgetWindow, 1)
	Objects(s) \ GadgetCodeWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Code editor - " + Scripts(e) \ Type + " event of " + Scripts(e) \ Parent, #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget, WindowID(Objects(s) \ GadgetWindow))
	;StickyWindow(Objects(s) \ GadgetCodeWindow, 1)
	
	; Cancel button
	Objects(s) \ GadgetCodeCancel = ButtonGadget(#PB_Any, 10, WindowHeight(Objects(s) \ GadgetCodeWindow) - 35, 65, 25, "Cancel")
	
	; OK button
	Objects(s) \ GadgetCodeOK = ButtonGadget(#PB_Any, WindowWidth(Objects(s) \ GadgetCodeWindow) - 75, WindowHeight(Objects(s) \ GadgetCodeWindow) - 35, 65, 25, "OK")
	
	; Selectable events for creating new event script
	TextGadget(#PB_Any, 10, 15, 60, 25, "Event type")
	Objects(s) \ GadgetCodeEvents = ComboBoxGadget(#PB_Any, 70, 10, 100, 25, #PB_ComboBox_Image)
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "Creation", ImageID(#IconCreation))
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "Destroy", ImageID(#IconDestroy))
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "Step", ImageID(#IconStep))
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "End step", ImageID(#IconEndStep))
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "Collision", ImageID(#IconCollision))
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "Room start", ImageID(#IconRoomStart))	
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "Room end", ImageID(#IconRoomEnd))
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "Animation end", ImageID(#IconAnimationEnd))	
	AddGadgetItem(Objects(s) \ GadgetCodeEvents, -1, "Draw", ImageID(#IconDraw))
	SetGadgetText(Objects(s) \ GadgetCodeEvents, Scripts(e) \ Type)
	
	; Parameter
	If Scripts(e) \ Type = "Collision"
		Objects(s) \ GadgetCodeParameterText = TextGadget(#PB_Any, 180, 15, 50, 25, "with")
		Objects(s) \ GadgetCodeParameter = ComboBoxGadget(#PB_Any, 240, 10, 200, 25, #PB_ComboBox_Image)
		AddGadgetItem(Objects(s) \ GadgetCodeParameter, -1, "")
		For w = 0 To ArraySize(Objects()) - 1
			If Objects(w) \ Proto = 1
				
				Image = #MissingSprite
				If IsImage(Objects(w) \ TImage)
					Image = Objects(w) \ TImage
				EndIf
				
				AddGadgetItem(Objects(s) \ GadgetCodeParameter, -1, Objects(w) \ Name, ImageID(Image))
			EndIf
		Next
		SetGadgetText(Objects(s) \ GadgetCodeParameter, Scripts(e) \ Parameter)
	Else
		Objects(s) \ GadgetCodeParameterText = TextGadget(#PB_Any, -1800, 15, 50, 25, "with")
		Objects(s) \ GadgetCodeParameter = StringGadget(#PB_Any, -2400, 10, 200, 25, Scripts(e) \ Parameter)
	EndIf
	
	; Code editor
	Objects(s) \ GadgetScintilla = GOSCI_Create(#PB_Any, 10, 45, 780, 470, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
	InitCodeEditor(Objects(s) \ GadgetScintilla)
	RemoveKeyboardShortcut(Objects(s) \ GadgetCodeWindow, #PB_Shortcut_All)
	GOSCI_SetText(Objects(s) \ GadgetScintilla, Scripts(e) \ Code)
	
	; Hover text
	Objects(s) \ GadgetCodeHoverText = TextGadget(#PB_Any, 10, 520, 780, 25, "")
	Objects(s) \ GadgetCodeHoverDescription = TextGadget(#PB_Any, 10, 550, 780, 25, "")
	SetGadgetFont(Objects(s) \ GadgetCodeHoverText, FontID(#ItemFont))
	
	If ScriptEditorX <> -1 And ScriptEditorY <> -1 And ScriptEditorMaximized = -1
		ResizeWindow(Objects(s) \ GadgetCodeWindow, ScriptEditorX, ScriptEditorY, ScriptEditorWidth, ScriptEditorHeight)
	EndIf
	
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
		If ScriptEditorMaximized > -1
			SetWindowState(Objects(s) \ GadgetCodeWindow, #PB_Window_Maximize)
		EndIf
	CompilerEndIf
	
	AddWindowTimer(Objects(s) \ GadgetCodeWindow, Objects(s) \ Timer, 100)
	
	EditScript_Resized(Objects(s) \ GadgetCodeWindow, Objects(s) \ GadgetScintilla, Objects(s) \ GadgetCodeOK, Objects(s) \ GadgetCodeCancel, Objects(s) \ GadgetCodeHoverText, Objects(s) \ GadgetCodeHoverDescription)
	
EndProcedure

; Edit the selected script
Procedure EditScript(e)
	
	EditWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Code editor - " + Scripts(e) \ Type + " event of " + Scripts(e) \ Parent, #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
	
	; Cancel button
	CancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(EditWindow) - 35, 65, 25, "Cancel")
	
	; OK button
	OKButton = ButtonGadget(#PB_Any, WindowWidth(EditWindow) - 75, WindowHeight(EditWindow) - 35, 65, 25, "OK")
	
	; Selectable events for creating new event script
	TextGadget(#PB_Any, 10, 15, 60, 25, "Event type")
	EventsCombo = ComboBoxGadget(#PB_Any, 70, 10, 100, 25, #PB_ComboBox_Image)
	AddGadgetItem(EventsCombo, -1, "Creation", ImageID(#IconCreation))
	AddGadgetItem(EventsCombo, -1, "Destroy", ImageID(#IconDestroy))
	AddGadgetItem(EventsCombo, -1, "Step", ImageID(#IconStep))
	AddGadgetItem(EventsCombo, -1, "End step", ImageID(#IconEndStep))
	AddGadgetItem(EventsCombo, -1, "Collision", ImageID(#IconCollision))
	AddGadgetItem(EventsCombo, -1, "Room start", ImageID(#IconRoomStart))	
	AddGadgetItem(EventsCombo, -1, "Room end", ImageID(#IconRoomEnd))
	AddGadgetItem(EventsCombo, -1, "Animation end", ImageID(#IconAnimationEnd))	
	AddGadgetItem(EventsCombo, -1, "Draw", ImageID(#IconDraw))
	SetGadgetText(EventsCombo, Scripts(e) \ Type)
	
	; Parameter
	If Scripts(e) \ Type = "Collision"
		ParameterText = TextGadget(#PB_Any, 180, 15, 50, 25, "with")
		ParameterGadget = ComboBoxGadget(#PB_Any, 240, 10, 200, 25, #PB_ComboBox_Image)
		AddGadgetItem(ParameterGadget, -1, "")
		For w = 0 To ArraySize(Objects()) - 1
			If Objects(w) \ Proto = 1
				
				Image = #MissingSprite
				If IsImage(Objects(w) \ TImage)
					Image = Objects(w) \ TImage
				EndIf
				
				AddGadgetItem(ParameterGadget, -1, Objects(w) \ Name, ImageID(Image))
			EndIf
		Next
		SetGadgetText(ParameterGadget, Scripts(e) \ Parameter)
	Else
		ParameterText = TextGadget(#PB_Any, -1800, 15, 50, 25, "with")
		ParameterGadget = StringGadget(#PB_Any, -2400, 10, 200, 25, Scripts(e) \ Parameter)
	EndIf
	
	; Code editor
	GOSCI_Create(#CodeGadget, 10, 45, 780, 510, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
	InitCodeEditor(#CodeGadget)
	RemoveKeyboardShortcut(EditWindow, #PB_Shortcut_All)
	GOSCI_SetText(#CodeGadget, Scripts(e) \ Code)
	
	; Hover text
	HoverText = TextGadget(#PB_Any, 10, 520, 780, 25, "")
	HoverDescription = TextGadget(#PB_Any, 10, 550, 780, 25, "")
	SetGadgetFont(HoverText, FontID(#ItemFont))
	
	If ScriptEditorX <> -1 And ScriptEditorY <> -1 And ScriptEditorMaximized = -1
		ResizeWindow(EditWindow, ScriptEditorX, ScriptEditorY, ScriptEditorWidth, ScriptEditorHeight)
	EndIf
	
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
	 If ScriptEditorMaximized > -1
		 SetWindowState(EditWindow, #PB_Window_Maximize)
	 EndIf
	CompilerEndIf
	
	AddWindowTimer(#SubWindow, 88, 100)
	
	Done = 0
	Repeat
		SetActiveWindow(EditWindow)
		Select WaitWindowEvent()
				
			Case #PB_Event_Timer
				If EventTimer() = 88
					HelpIndex = GetScriptHelpIndex(#CodeGadget)
					If HelpIndex > -1
						If Keywords(HelpIndex) \ Help <> "n/a"
							SetGadgetText(HoverText, Keywords(HelpIndex) \ Help)
						EndIf
						If Keywords(HelpIndex) \ Description <> "n/a"
							SetGadgetText(HoverDescription, Keywords(HelpIndex) \ Description)
						EndIf
					Else
						SetGadgetText(HoverText, "")
						SetGadgetText(HoverDescription, "")
					EndIf
				EndIf
				
			Case #PB_Event_CloseWindow
				Done = 1
				
			Case #PB_Event_MaximizeWindow
				EditScript_Resized(EditWindow, #CodeGadget, OKButton, CancelButton, HoverText, HoverDescription)
				
			Case #PB_Event_MinimizeWindow
				EditScript_Resized(EditWindow, #CodeGadget, OKButton, CancelButton, HoverText, HoverDescription)
				
			Case #PB_Event_SizeWindow
				EditScript_Resized(EditWindow, #CodeGadget, OKButton, CancelButton, HoverText, HoverDescription)
				
			Case #PB_Event_Gadget
				Select EventGadget()
						
					Case EventsCombo
						Select EventType()
							Case #PB_EventType_Change
								ResizeGadget(ParameterGadget, -1800, #PB_Ignore, #PB_Ignore, #PB_Ignore)
								ResizeGadget(ParameterText, -1800, #PB_Ignore, #PB_Ignore, #PB_Ignore)
								If GetGadgetState(EventsCombo) = 4
									ResizeGadget(ParameterGadget, 240, #PB_Ignore, #PB_Ignore, #PB_Ignore)
									ResizeGadget(ParameterText, 180, #PB_Ignore, #PB_Ignore, #PB_Ignore)
								EndIf
						EndSelect
						
					Case CancelButton
						Done = 1
						
					Case OKButton
						Scripts(e) \ Type = GetGadgetText(EventsCombo)
						Scripts(e) \ Parameter = GetGadgetText(ParameterGadget)
						Scripts(e) \ Code = GOSCI_GetText(#CodeGadget)
						GOSCI_Free(#CodeGadget)
						Done = 1
				EndSelect
		EndSelect
	Until Done = 1
	
	ScriptEditorX = WindowX(EditWindow)
	ScriptEditorY = WindowY(EditWindow)
	
	CloseWindow(EditWindow)
	
EndProcedure

; Display the currently selected event code
Procedure RefreshCodePreview(ObjectIndex)
	If GetGadgetText(Objects(ObjectIndex) \ GadgetEventList) <> ""
		SetGadgetText(Objects(ObjectIndex) \ GadgetCodePreview, Scripts(GetGadgetItemData(Objects(ObjectIndex) \ GadgetEventList, GetGadgetState(Objects(ObjectIndex) \ GadgetEventList))) \ Code)
	Else
		SetGadgetText(Objects(ObjectIndex) \ GadgetCodePreview, "")
	EndIf
EndProcedure

; Duplicate the specified object
Procedure DuplicateObject(ObjectName.s)
	
	; CHECK IF THE DUPLICATED NAME EXISTS (CREATING MULTIPLICATION FROM THE SAME OBJECT)
	MultiOk = 1
	For m = 0 To ArraySize(Objects()) - 1
		If Objects(m) \ Name = ObjectName + "_dup"
			MultiOk = 0
		EndIf
	Next
	
	If MultiOk = 1
	
		; Search for the object
		For m = 0 To ArraySize(Objects()) - 1
			If Objects(m) \ Name = ObjectName
				
				Index = ArraySize(Objects())	
				ReDim Objects(Index + 1)
				
				Objects(Index) = Objects(m)
				Objects(Index) \ Name = ObjectName + "_dup"
				
				Break
				
			EndIf
		Next
		
		; Search for the scripts
		For m = 0 To ArraySize(Scripts()) - 1
			If Scripts(m) \ Parent = ObjectName
				
				Index = ArraySize(Scripts())	
				ReDim Scripts(Index + 1)
				
				Scripts(Index) = Scripts(m)
				Scripts(Index) \ Parent = ObjectName + "_dup"
				
				;Break
				
			EndIf
		Next	
	Else
		
		MessageRequester("Message", "The name of the duplicated object (" + ObjectName + "_dup) already exist." + Chr(13) + "Please rename it before creating a new duplication.")
		
	EndIf
	
EndProcedure

Procedure DuplicateScene(SceneName.s)
	
	MultiOk = 1
	For m = 0 To ArraySize(Scenes()) - 1
		If Scenes(m) \ Name = SceneName + "_dup"
			MultiOk = 0
		EndIf
	Next
	
	If MultiOk = 1
	
		; Search for the scene
		For m = 0 To ArraySize(Scenes()) - 1
			If Scenes(m) \ Name = SceneName
				
				Index = ArraySize(Scenes())	
				ReDim Scenes(Index + 1)
				
				Scenes(Index) = Scenes(m)
				Scenes(Index) \ Name = SceneName + "_dup"
				Scenes(Index) \ InnerTimer = UID()
				Break
				
			EndIf
		Next
		
		; Search for the objects
		For m = 0 To ArraySize(Objects()) - 1
			If Objects(m) \ Scene = SceneName
				
				Index = ArraySize(Objects())	
				ReDim Objects(Index + 1)
				
				Objects(Index) = Objects(m)
				Objects(Index) \ Scene = SceneName + "_dup"
				Objects(Index) \ Name = "SceneObject" + Str(UID())
				Objects(Index) \ TImage = GetSpriteImage(Objects(m) \ Sprite)
				Objects(Index) \ TImageModified = GetSpriteImage(Objects(m) \ Sprite)
				If IsImage(Objects(Index) \ TImage)
					Objects(Index) \ TWidth = ImageWidth(Objects(Index) \ TImage)
					Objects(Index) \ THeight = ImageHeight(Objects(Index) \ TImage)
				EndIf
				If IsImage(Objects(Index) \ TImageModified)
					Objects(Index) \ TImageModified = RotateImageFree(Objects(m) \ TImage, Objects(m) \ ImageAngle, #True)
				EndIf
				Objects(Index) \ Timer = UID()
				
			EndIf
		Next	
		
	Else
		
		MessageRequester("Message", "The name of the duplicated scene (" + SceneName + "_dup) already exist." + Chr(13) + "Please rename it before creating a new duplication.")		
		
	EndIf
	
EndProcedure

; Delete the specified object
Procedure DeleteObject(ObjectName.s)
	
	; Search for the object
	Dim TempObjects.Object(0)
	For m = 0 To ArraySize(Objects()) - 1
		If Objects(m) \ Name <> ObjectName And Objects(m) \ TemplateObject <> ObjectName
			
			Index = ArraySize(TempObjects())	
			ReDim TempObjects(Index + 1)
			TempObjects(Index) = Objects(m)
		EndIf
	Next
	
	CopyArray(TempObjects(), Objects())
	
	; Delete scripts using this object
	Dim Temp.Script(0)
	For m = 0 To ArraySize(Scripts()) - 1
		If Scripts(m) \ Parent <> ObjectName
			
			Index = ArraySize(Temp())
			ReDim Temp(Index + 1)
			
			Temp(Index) \ Code = Scripts(m) \ Code
			Temp(Index) \ Name = Scripts(m) \ Name
			Temp(Index) \ Parameter = Scripts(m) \ Parameter
			Temp(Index) \ Parent = Scripts(m) \ Parent
			Temp(Index) \ Type = Scripts(m) \ Type
			
		EndIf
	Next
	
	CopyArray(Temp(), Scripts())
	
EndProcedure

; Refresh the collision lines in the sprite preview
Procedure CreateSpritePreview(Gadget, SpriteIndex, Image)
	WS.f = 1
	HS.f = 1
	If IsImage(Image)
		IW = ImageWidth(Image)
		IH = ImageHeight(Image)
		If IW >= IH
			WS.f = 1
			HS.f = IH / IW
		Else
			WS.f = IW / IH
			HS.f = 1
		EndIf
		;ResizeImage(Image, 100 * WS, 100 * HS)
	EndIf
	PreviewImage = CreateImage(#PB_Any, 100, 100, 32, #PB_Image_Transparent)
	StartDrawing(ImageOutput(PreviewImage))
	DrawingMode(#PB_2DDrawing_AlphaBlend)
	If IsImage(Image) : DrawImage(ImageID(Image), 0, 0, 100 * WS, 100 * HS) : EndIf
	StopDrawing()
	SetGadgetState(Gadget, ImageID(PreviewImage))
EndProcedure

; Refresh the sprite combobox
Procedure RefreshObjectSprite(s)
	If IsWindow(Objects(s) \ GadgetWindow)
		
		; CLEAR ALL AVAILABLE NAMES
		ClearGadgetItems(Objects(s) \ GadgetSprite)

		AddGadgetItem(Objects(s) \ GadgetSprite, -1, "")
		For r = 0 To ArraySize(Sprites()) - 1
			
			Image = #MissingSprite
			For f = 0 To ArraySize(Frames()) - 1
				If Frames(f) \ Sprite = Sprites(r) \ Name
					Image = Frames(f) \ Image
					Break
				EndIf
			Next
			
			AddGadgetItem(Objects(s) \ GadgetSprite, -1, Sprites(r) \ Name, ImageID(Image))
		Next
		SetGadgetText(Objects(s) \ GadgetSprite, Objects(s) \ Sprite)
		
		; Sprite preview
		Image = #NoSprite
		For f = 0 To ArraySize(Frames()) - 1
			If Frames(f) \ Sprite = Objects(s) \ Sprite
				Image = Frames(f) \ Image
				Break
			EndIf
		Next
		
		CreateSpritePreview(Objects(s) \ GadgetSpritePreview, s, Image)
		If Image <> #NoSprite
			SetGadgetText(Objects(s) \ GadgetDimensions, "Size: " + Str(ImageWidth(Image)) + " x " + Str(ImageHeight(Image)) + " px")
		Else
			SetGadgetText(Objects(s) \ GadgetDimensions, "Size: <no sprite>")
		EndIf
		
	EndIf	
EndProcedure

; Refresh the parent combobox
Procedure RefreshObjectParent(s)
	If IsWindow(Objects(s) \ GadgetWindow)
		
		; CLEAR ALL AVAILABLE PARENT NAMES
		ClearGadgetItems(Objects(s) \ GadgetParent)
		AddGadgetItem(Objects(s) \ GadgetParent, -1, "")
		
		; GET OBJECT NAMES AS AVAILABLE PARENTS (EXCEPT SELF)
		For t = 0 To ArraySize(Objects()) - 1
			If Objects(t) \ Name <> Objects(s) \ Name And Objects(t) \ Proto = 1
				
				; PARENT ICON IMAGE
				Image = #MissingSprite
				If IsImage(Objects(t) \ TImage) : Image = Objects(t) \ TImage : EndIf
				
				; ADD THE NAME
				AddGadgetItem(Objects(s) \ GadgetParent, -1, Objects(t) \ Name, ImageID(Image))
			EndIf
		Next
		
		; SELECT THE ACTUAL PARENT
		SetGadgetText(Objects(s) \ GadgetParent, Objects(s) \ Parent)
	EndIf
EndProcedure

; Store OBJECT FORM
Procedure ObjectFormStore(s, close)
					
	Objects(s) \ Errors = 0
	
	; Check object name (Missing or exists)
	If GetGadgetText(Objects(s) \ GadgetName) <> ""
		If ObjectNameIsFree(GetGadgetText(Objects(s) \ GadgetName), s) = 0
			; Wrong name
			MessageRequester("Error", "The object name '" + GetGadgetText(Objects(s) \ GadgetName) + "' already exists")
			Objects(s) \ Errors = Objects(s) \ Errors + 1
		EndIf
	Else
		; Missing name
		MessageRequester("Error", "The object name is missing")
		Objects(s) \ Errors = Objects(s) \ Errors + 1
	EndIf
	
	; Form is correct
	If Objects(s) \ Errors = 0
		
		Dirty(1)
		
		;Refresh scripts using this name
		For r = 0 To ArraySize(Scripts()) - 1
			If Scripts(r) \ Parent = Objects(s) \ Name
				Scripts(r) \ Parent = GetGadgetText(Objects(s) \ GadgetName)
			EndIf
		Next
		
		;Refresh objects using this name as template
		For r = 0 To ArraySize(Objects()) - 1
			If Objects(r) \ TemplateObject = Objects(s) \ Name
				Objects(r) \ TemplateObject = GetGadgetText(Objects(s) \ GadgetName)
			EndIf
		Next
		
		; Refresh objects using this name as parent
		For r = 0 To ArraySize(Objects()) - 1
			If Objects(r) \ Parent = Objects(s) \ Name
				Objects(r) \ Parent = GetGadgetText(Objects(s) \ GadgetName)
			EndIf
		Next
		
		;Refresh scene object depths using this name
		For r = 0 To ArraySize(Objects()) - 1
			If Objects(r) \ TemplateObject = Objects(s) \ Name
				Objects(r) \ Depth = Val(GetGadgetText(Objects(s) \ GadgetDepth))
			EndIf
		Next
		
		;Refresh script parameter using this name
		For r = 0 To ArraySize(Scripts()) - 1
			If Scripts(r) \ Parameter = Objects(s) \ Name
				Scripts(r) \ Parameter = GetGadgetText(Objects(s) \ GadgetName)
			EndIf
		Next
		
		; Set the new name
		Objects(s) \ Name = GetGadgetText(Objects(s) \ GadgetName)
		Objects(s) \ Sprite = GetGadgetText(Objects(s) \ GadgetSprite)
		Objects(s) \ Visible = GetGadgetState(Objects(s) \ GadgetVisible)
		Objects(s) \ Depth = Val(GetGadgetText(Objects(s) \ GadgetDepth))
		Objects(s) \ Collide = GetGadgetState(Objects(s) \ GadgetCollide)
		Objects(s) \ Parent = GetGadgetText(Objects(s) \ GadgetParent)
		Objects(s) \ Keywords = GetGadgetText(Objects(s) \ GadgetKeywords)
		
		; Update scene objects using this sprite
		For w = 0 To ArraySize(Objects()) - 1
			If Objects(w) \ TemplateObject = Objects(s) \ Name
				Objects(w) \ Sprite = Objects(s) \ Sprite
				Objects(w) \ TImage = GetSpriteImage(Objects(w) \ Sprite)
				If Objects(w) \ TImage > -1
					Objects(w) \ TWidth = ImageWidth(Objects(w) \ TImage)
					Objects(w) \ THeight = ImageHeight(Objects(w) \ TImage)
				EndIf
			EndIf
		Next
		
		; Refresh parents on the opened windows
		For r = 0 To ArraySize(Objects()) - 1
			RefreshObjectParent(r)
		Next
		
		; Store temp data for the scene editor
		; Store the image and the image dimensions
		Objects(s) \ TImage = -1
		For f = 0 To ArraySize(Frames()) - 1
			If Frames(f) \ Sprite = Objects(s) \ Sprite
				Objects(s) \ TImage = Frames(f) \ Image
				If Objects(s) \ TImage > -1
					Objects(s) \ TWidth = ImageWidth(Frames(f) \ Image)
					Objects(s) \ THeight = ImageHeight(Frames(f) \ Image)
				EndIf
				Break
			EndIf
		Next
		
		; n/a
		For w = 0 To ArraySize(Objects()) - 1
			If Objects(w) \ TemplateObject = Objects(s) \ Name
				Objects(w) \ TImage = Objects(s) \ TImage
				Objects(w) \ TWidth = Objects(s) \ TWidth
				Objects(w) \ THeight = Objects(s) \ THeight
			EndIf
		Next
		
		; CLOSE WINDOW OR SILENT FORM SAVE
		If close = 1
			CloseWindow(Objects(s) \ GadgetWindow)
			Objects(s) \ GadgetWindow = 0
		EndIf
		RefreshItems()
		
		For a = 0 To ArraySize(Scenes()) - 1
			If IsWindow(Scenes(a) \ GadgetWindow)
				RefreshSceneObjectsList(a)
				RefreshSceneObjectToFollowCombo(a)
			EndIf
		Next
		
	EndIf	
EndProcedure

; Displays the editor form of the specified object
Procedure ObjectForm(Name.s)
	
	; Search the object by its name
	For s = 0 To ArraySize(Objects()) - 1
		If Objects(s) \ Name = Name
			
			; FORM IS ALREADY OPENED
			If IsWindow(Objects(s) \ GadgetWindow)
				SetActiveWindow(Objects(s) \ GadgetWindow)
				ProcedureReturn
			EndIf			
			
			; Form window
			Objects(s) \ GadgetWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Object properties - " + Objects(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget, WindowID(#MainWindow))
			;StickyWindow(Objects(s) \ GadgetWindow, 1)
			
			; OK button
			Objects(s) \ GadgetOK = ButtonGadget(#PB_Any, WindowWidth(Objects(s) \ GadgetWindow) - 75, WindowHeight(Objects(s) \ GadgetWindow) - 35, 65, 25, "Done")
			
			; Delete button
			Objects(s) \ GadgetDelete = ButtonGadget(#PB_Any, 10, WindowHeight(Objects(s) \ GadgetWindow) - 35, 65, 25, "Delete")			
			
			; Keywords input
			Objects(s) \ GadgetKeywords = StringGadget(#PB_Any, WindowWidth(Objects(s) \ GadgetWindow) / 2 - 100, WindowHeight(Objects(s) \ GadgetWindow) - 35, 200, 25, Objects(s) \ Keywords)
			
			; Object name
			Objects(s) \ GadgetName = StringGadget(#PB_Any, 10, 10, 100, 25, Objects(s) \ Name)
			
			; Preview image
			Objects(s) \ GadgetSpritePreview = ImageGadget(#PB_Any, 10, 45, 100, 100, ImageID(#NullImage), #PB_Image_Border)
			
			; Dimensions
			Objects(s) \ GadgetDimensions = TextGadget(#PB_Any, 10, 190, 100, 25, "")
			
			; Sprite combobox
			Objects(s) \ GadgetSprite = ComboBoxGadget(#PB_Any, 10, 155, 100, 25, #PB_ComboBox_Image)
			RefreshObjectSprite(s)
			
			; Visible checkbox
			Objects(s) \ GadgetVisible = CheckBoxGadget(#PB_Any, 10, 215, 100, 25, "Visible")
			SetGadgetState(Objects(s) \ GadgetVisible, Objects(s) \ Visible)
			
			; Depth
			TextGadget(#PB_Any, 10, 255, 55, 25, "Depth")
			Objects(s) \ GadgetDepth = StringGadget(#PB_Any, 60, 250, 50, 25, Str(Objects(s) \ Depth))
			
			; Can collide
			Objects(s) \ GadgetCollide = CheckBoxGadget(#PB_Any, 10, 280, 100, 25, "Collision check")
			SetGadgetState(Objects(s) \ GadgetCollide, Objects(s) \ Collide)
			
			; Parenting
			TextGadget(#PB_Any, 10, 315, 100, 25, "Parent")
			Objects(s) \ GadgetParent = ComboBoxGadget(#PB_Any, 10, 340, 100, 25, #PB_ComboBox_Image)
			RefreshObjectParent(s)
			
			; New event button
			Objects(s) \ GadgetNewEvent = ButtonGadget(#PB_Any, 120, 10, 100, 25, "Add event >>> ")
			
			; Selectable events for creating new event script
			Objects(s) \ GadgetEvents = ComboBoxGadget(#PB_Any, 220, 10, 100, 25, #PB_ComboBox_Image)
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "Creation", ImageID(#IconCreation))
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "Destroy", ImageID(#IconDestroy))			
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "Step", ImageID(#IconStep))
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "End step", ImageID(#IconEndStep))
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "Collision", ImageID(#IconCollision))			
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "Room start", ImageID(#IconRoomStart))			
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "Room end", ImageID(#IconRoomEnd))
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "Animation end", ImageID(#IconAnimationEnd))
			AddGadgetItem(Objects(s) \ GadgetEvents, -1, "Draw", ImageID(#IconDraw))
			SetGadgetText(Objects(s) \ GadgetEvents, "Creation")
			
			; Event list
			Objects(s) \ GadgetEventList = ListIconGadget(#PB_Any, 120, 45, 200, WindowHeight(Objects(s) \ GadgetWindow) - 90 , "Event", 90, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
			AddGadgetColumn(Objects(s) \ GadgetEventList, 1, "Parameter", 80)
			RefreshEventList(s)
			
			; Code preview
			TextGadget(#PB_Any, 480, 15, 200, 25, "Code preview of selected event")
			Objects(s) \ GadgetCodePreview = EditorGadget(#PB_Any, 330, 45, 460, WindowHeight(Objects(s) \ GadgetWindow) - 90, #PB_Editor_ReadOnly)
			SetGadgetFont(Objects(s) \ GadgetCodePreview, FontID(#EditorFont))
			SetGadgetColor(Objects(s) \ GadgetCodePreview, #PB_Gadget_BackColor, RGB(240,240,240))

			RefreshItems()
			Break
			
		EndIf
	Next
	
EndProcedure

; Delete the specified sound
Procedure DeleteSound(SoundName.s)
	
	; Search for the sound
	Dim TempSounds.Sound(0)
	For m = 0 To ArraySize(Sounds()) - 1
		If Sounds(m) \ Name <> SoundName
			
			Index = ArraySize(TempSounds())	
			ReDim TempSounds(Index + 1)
			TempSounds(Index) = Sounds(m)
		EndIf
	Next
	CopyArray(TempSounds(), Sounds())
	
EndProcedure

Procedure SoundFormStore(s, close)
	
	Sounds(s) \ Errors = 0
	
	; Check sound name (Missing or exists)
	If GetGadgetText(Sounds(s) \ GadgetName) <> ""
		If SoundNameIsFree(GetGadgetText(Sounds(s) \ GadgetName), s) = 0
			MessageRequester("Error", "The sound name '" + GetGadgetText(Sounds(s) \ GadgetName) + "' already exists")
			Sounds(s) \ Errors = Sounds(s) \ Errors + 1
		EndIf
	Else
		MessageRequester("Error", "The sound name is missing")
		Sounds(s) \ Errors = Sounds(s) \ Errors + 1
	EndIf
	
	; Form is correct
	If Sounds(s) \ Errors = 0
		
		Dirty(1)
		Sounds(s) \ Name = GetGadgetText(Sounds(s) \ GadgetName)
		Sounds(s) \ File = GetFilePart(Sounds(s) \ SelectedFile)
		Sounds(s) \ File2 = GetFilePart(Sounds(s) \ SelectedFile2)
		Sounds(s) \ File3 = GetFilePart(Sounds(s) \ SelectedFile3)
		
		If FileSize(Sounds(s) \ SelectedFile) > 0
			CopyFile(Sounds(s) \ SelectedFile, TempName + "/" + GetFilePart(Sounds(s) \ SelectedFile))
		EndIf
		If FileSize(Sounds(s) \ SelectedFile2) > 0
			CopyFile(Sounds(s) \ SelectedFile2, TempName + "/" + GetFilePart(Sounds(s) \ SelectedFile2))
		EndIf
		If FileSize(Sounds(s) \ SelectedFile3) > 0
			CopyFile(Sounds(s) \ SelectedFile3, TempName + "/" + GetFilePart(Sounds(s) \ SelectedFile3))
		EndIf
		
		Sounds(s) \ Keywords = GetGadgetText(Sounds(s) \ GadgetKeywords)
		
		If close = 1
			CloseWindow(Sounds(s) \ GadgetWindow)
			Sounds(s) \ GadgetWindow = 0
		EndIf
		
		RefreshItems()
		
	EndIf
	
EndProcedure

; Display the sound form
Procedure SoundForm(Name.s)
	
	; Search the sound by its name
	For s = 0 To ArraySize(Sounds()) - 1
		If Sounds(s) \ Name = Name.s
			
			; FORM IS ALREADY OPENED
			If IsWindow(Sounds(s) \ GadgetWindow)
				SetActiveWindow(Sounds(s) \ GadgetWindow)
				ProcedureReturn
			EndIf
			
			; Preload the sound for playing
			Sounds(s) \ SelectedFile.s = Sounds(s) \ File
			Sounds(s) \ SelectedFile2.s = Sounds(s) \ File2
			Sounds(s) \ SelectedFile3.s = Sounds(s) \ File3
			
			; Form window
			Sounds(s) \ GadgetWindow = OpenWindow(#PB_Any, 0, 0, 480, 220, "Sound properties - " + Sounds(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget, WindowID(#MainWindow))
			;StickyWindow(Sounds(s) \ GadgetWindow, 1)
			
			; OK button
			Sounds(s) \ GadgetOK = ButtonGadget(#PB_Any, WindowWidth(Sounds(s) \ GadgetWindow) - 75, WindowHeight(Sounds(s) \ GadgetWindow) - 35, 65, 25, "Done")
			
			; Delete button
			Sounds(s) \ GadgetDelete = ButtonGadget(#PB_Any, 10, WindowHeight(Sounds(s) \ GadgetWindow) - 35, 65, 25, "Delete")			
			
			; Keywords input
			Sounds(s) \ GadgetKeywords = StringGadget(#PB_Any, WindowWidth(Sounds(s) \ GadgetWindow) / 2 - 100, WindowHeight(Sounds(s) \ GadgetWindow) - 35, 200, 25, Sounds(s) \ Keywords)
			
			; Sound name
			Sounds(s) \ GadgetName = StringGadget(#PB_Any, 10, 10, 230, 25, Sounds(s) \ Name)
			
			CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
				osxUnsetButton = 75
				osxUnsetOffset = 395
			CompilerElse
				osxUnsetButton = 50
				osxUnsetOffset = 420
			CompilerEndIf
			
			; File (WAV)
			Sounds(s) \ GadgetFileSelector = ButtonGadget(#PB_Any, 10, 40, 150, 25, "Set WAV file...")
			Sounds(s) \ GadgetFileName = TextGadget(#PB_Any, 170, 45, 230, 25, "File: " + Sounds(s) \ File)
			Sounds(s) \ GadgetFileRemover = ButtonGadget(#PB_Any, osxUnsetOffset, 40, osxUnsetButton, 25, "<< Unset")
			
			; File2 (MP3)
			Sounds(s) \ GadgetFile2Selector = ButtonGadget(#PB_Any, 10, 70, 150, 25, "Set MP3 file...")
			Sounds(s) \ GadgetFile2Name = TextGadget(#PB_Any, 170, 75, 230, 25, "File: " + Sounds(s) \ File2)
			Sounds(s) \ GadgetFile2Remover = ButtonGadget(#PB_Any, osxUnsetOffset, 70, osxUnsetButton, 25, "<< Unset")
			
			; File (OGG)
			Sounds(s) \ GadgetFile3Selector = ButtonGadget(#PB_Any, 10, 100, 150, 25, "Set OGG file...")
			Sounds(s) \ GadgetFile3Name = TextGadget(#PB_Any, 170, 105, 230, 25, "File: " + Sounds(s) \ File3)
			Sounds(s) \ GadgetFile3Remover = ButtonGadget(#PB_Any, osxUnsetOffset, 100, osxUnsetButton, 25, "<< Unset")
			
			RefreshItems()
			
			Break
			
		EndIf
	Next
	
EndProcedure

; Delete the specified music
Procedure DeleteMusic(MusicName.s)
	
	; Search for the music
	Dim TempMusics.Music(0)
	For m = 0 To ArraySize(Musics()) - 1
		If Musics(m) \ Name <> MusicName
			
			Index = ArraySize(TempMusics())	
			ReDim TempMusics(Index + 1)
			TempMusics(Index) = Musics(m)
		EndIf
	Next
	CopyArray(TempMusics(), Musics())
	
EndProcedure

Procedure MusicFormStore(s, close)
	Musics(s) \ Errors = 0
	
	; Check music name (Missing or exists)
	If GetGadgetText(Musics(s) \ GadgetName) <> ""
		If MusicNameIsFree(GetGadgetText(Musics(s) \ GadgetName), s) = 0
			MessageRequester("Error", "The music name '" + GetGadgetText(Musics(s) \ GadgetName) + "' already exists")
			Musics(s) \ Errors = Musics(s) \ Errors + 1
		EndIf
	Else
		MessageRequester("Error", "The music name is missing")
		Musics(s) \ Errors = Musics(s) \ Errors + 1
	EndIf
	
	; Form is correct
	If Musics(s) \ Errors = 0
		
		Dirty(1)
		Musics(s) \ Name = GetGadgetText(Musics(s) \ GadgetName)
		Musics(s) \ File = GetFilePart(Musics(s) \ SelectedFile)
		Musics(s) \ File2 = GetFilePart(Musics(s) \ SelectedFile2)
		Musics(s) \ File3 = GetFilePart(Musics(s) \ SelectedFile3)
		
		If FileSize(Musics(s) \ SelectedFile) > 0
			CopyFile(Musics(s) \ SelectedFile, TempName + "/" + GetFilePart(Musics(s) \ SelectedFile))
		EndIf
		If FileSize(Musics(s) \ SelectedFile2) > 0
			CopyFile(Musics(s) \ SelectedFile2, TempName + "/" + GetFilePart(Musics(s) \ SelectedFile2))
		EndIf
		If FileSize(Musics(s) \ SelectedFile3) > 0
			CopyFile(Musics(s) \ SelectedFile3, TempName + "/" + GetFilePart(Musics(s) \ SelectedFile3))
		EndIf
		
		Musics(s) \ Keywords = GetGadgetText(Musics(s) \ GadgetKeywords)
		
		If close = 1
			CloseWindow(Musics(s) \ GadgetWindow)
			Musics(s) \ GadgetWindow = 0
		EndIf
	
		RefreshItems()
		
	EndIf
	
EndProcedure

; Display the music form
Procedure MusicForm(Name.s)
	
	; Search the sound by its name
	For s = 0 To ArraySize(Musics()) - 1
		If Musics(s) \ Name = Name.s
			
			; FORM IS ALREADY OPENED
			If IsWindow(Musics(s) \ GadgetWindow)
				SetActiveWindow(Musics(s) \ GadgetWindow)
				ProcedureReturn
			EndIf
			
			; Preload the sound for playing
			Musics(s) \ SelectedFile.s = Musics(s) \ File
			Musics(s) \ SelectedFile2.s = Musics(s) \ File2
			Musics(s) \ SelectedFile3.s = Musics(s) \ File3
			
			; Form window
			Musics(s) \ GadgetWindow = OpenWindow(#PB_Any, 0, 0, 480, 220, "Music properties - " + Musics(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget, WindowID(#MainWindow))
			;StickyWindow(Musics(s) \ GadgetWindow, 1)
			
			; OK button
			Musics(s) \ GadgetOK = ButtonGadget(#PB_Any, WindowWidth(Musics(s) \ GadgetWindow) - 75, WindowHeight(Musics(s) \ GadgetWindow) - 35, 65, 25, "Done")
			
			; Delete button
			Musics(s) \ GadgetDelete = ButtonGadget(#PB_Any, 10, WindowHeight(Musics(s) \ GadgetWindow) - 35, 65, 25, "Delete")			
			
			; Keywords input
			Musics(s) \ GadgetKeywords = StringGadget(#PB_Any, WindowWidth(Musics(s) \ GadgetWindow) / 2 - 100, WindowHeight(Musics(s) \ GadgetWindow) - 35, 200, 25, Musics(s) \ Keywords)
			
			; Music name
			Musics(s) \ GadgetName = StringGadget(#PB_Any, 10, 10, 230, 25, Musics(s) \ Name)
			
			CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
				osxUnsetButton = 75
				osxUnsetOffset = 395
			CompilerElse
				osxUnsetButton = 50
				osxUnsetOffset = 420
			CompilerEndIf
			
			; File (WAV)
			Musics(s) \ GadgetFileSelector = ButtonGadget(#PB_Any, 10, 40, 150, 25, "Set WAV file...")
			Musics(s) \ GadgetFileName = TextGadget(#PB_Any, 170, 45, 230, 25, "File: " + Musics(s) \ File)
			Musics(s) \ GadgetFileRemover = ButtonGadget(#PB_Any, osxUnsetOffset, 40, osxUnsetButton, 25, "<< Unset")
			
			; File2 (MP3)
			Musics(s) \ GadgetFile2Selector = ButtonGadget(#PB_Any, 10, 70, 150, 25, "Set MP3 file...")
			Musics(s) \ GadgetFile2Name = TextGadget(#PB_Any, 170, 75, 230, 25, "File: " + Musics(s) \ File2)
			Musics(s) \ GadgetFile2Remover = ButtonGadget(#PB_Any, osxUnsetOffset, 70, osxUnsetButton, 25, "<< Unset")
			
			; File (OGG)
			Musics(s) \ GadgetFile3Selector = ButtonGadget(#PB_Any, 10, 100, 150, 25, "Set OGG file...")
			Musics(s) \ GadgetFile3Name = TextGadget(#PB_Any, 170, 105, 230, 25, "File: " + Musics(s) \ File3)
			Musics(s) \ GadgetFile3Remover = ButtonGadget(#PB_Any, osxUnsetOffset, 100, osxUnsetButton, 25, "<< Unset")
			
			RefreshItems()
			
			Break
			
		EndIf
	Next
	
EndProcedure

Procedure EditSceneCodeStore(s, close)
	Scenes(s) \ Code = GOSCI_GetText(Scenes(s) \ CodeScintilla)
	Dirty(1)
	If close = 1
		GOSCI_Free(Scenes(s) \ CodeScintilla)
		CloseWindow(Scenes(s) \ CodeEditorWindow)
		DisableWindow(Scenes(s) \ GadgetWindow, 0)
	EndIf
EndProcedure

; Display the scene code editor
Procedure EditSceneCode(s)
	
	Scenes(s) \ CodeEditorWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Scene code editor", #PB_Window_ScreenCentered | #PB_Window_Tool, WindowID(Scenes(s) \ GadgetWindow))
	DisableWindow(Scenes(s) \ GadgetWindow, 1)
	;StickyWindow(Scenes(s) \ CodeEditorWindow, 1)
	
	; Cancel button
	Scenes(s) \ CodeCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(Scenes(s) \ CodeEditorWindow) - 35, 65, 25, "Cancel")
	
	; OK button
	Scenes(s) \ CodeOKButton = ButtonGadget(#PB_Any, WindowWidth(Scenes(s) \ CodeEditorWindow) - 75, WindowHeight(Scenes(s) \ CodeEditorWindow) - 35, 65, 25, "OK")
	
	; Code editor
	Scenes(s) \ CodeScintilla = GOSCI_Create(#PB_Any, 10, 10, 780, 540, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
	InitCodeEditor(Scenes(s) \ CodeScintilla)
	RemoveKeyboardShortcut(Scenes(s) \ CodeEditorWindow, #PB_Shortcut_All)
	GOSCI_SetText(Scenes(s) \ CodeScintilla, Scenes(s) \ Code)
	
EndProcedure

; Resize the canvas gadget in the scene editor
Procedure RefreshSceneGadget(SceneCanvas, ScrollerGadget, WidthGadget, HeightGadget) 
	NewWidth = Val(GetGadgetText(WidthGadget))
	NewHeight = Val(GetGadgetText(HeightGadget))
	ResizeGadget(SceneCanvas, 0, 0, NewWidth, NewHeight)
	SetGadgetAttribute(ScrollerGadget, #PB_ScrollArea_InnerWidth, NewWidth)
	SetGadgetAttribute(ScrollerGadget, #PB_ScrollArea_InnerHeight, NewHeight)
EndProcedure

; Delete the specified layer
Procedure DeleteLayer(LayerName.s)
	
	; Search for the layer
	Dim TempLayers.Layer(0)
	For m = 0 To ArraySize(Layers()) - 1
		If Layers(m) \ Name <> LayerName
			Index = ArraySize(TempLayers())	
			ReDim TempLayers(Index + 1)
			TempLayers(Index) = Layers(m)
		EndIf
	Next
	CopyArray(TempLayers(), Layers())
	
EndProcedure

; Delete the specified tile
Procedure DeleteTile(TileName.s)
	
	; Search for the tile
	Dim TempTiles.Tile(0)
	For m = 0 To ArraySize(Tiles()) - 1
		If Tiles(m) \ Name <> TileName
			
			Index = ArraySize(TempTiles())	
			ReDim TempTiles(Index + 1)
			TempTiles(Index) = Tiles(m)
		Else
			If IsImage(Tiles(m) \ Image)
				FreeImage(Tiles(m) \ Image)
			EndIf
		EndIf
	Next
	CopyArray(TempTiles(), Tiles())
	
EndProcedure

; Delete the specified scene and its objects
Procedure DeleteScene(SceneName.s)
	
	; Search for the scene
	Dim TempScenes.Scene(0)
	For m = 0 To ArraySize(Scenes()) - 1
		If Scenes(m) \ Name <> SceneName
			
			Index = ArraySize(TempScenes())	
			ReDim TempScenes(Index + 1)
			TempScenes(Index) = Scenes(m)
		EndIf
	Next
	CopyArray(TempScenes(), Scenes())
	
	; Collect scene object to delete
	Dim ObjectsToDelete.s(0)
	For w = 0 To ArraySize(Objects()) - 1
		If Objects(w) \ Scene = SceneName
			Index = ArraySize(ObjectsToDelete())
			ReDim ObjectsToDelete(Index + 1)
			ObjectsToDelete(Index) = Objects(w) \ Name
		EndIf
	Next
	; Delete collected object
	For w = 0 To ArraySize(ObjectsToDelete()) - 1
		DeleteObject(ObjectsToDelete(w))
	Next
	
	; Delete layers using this scene
	Dim LayerTrash.s(0)
	For r = 0 To ArraySize(Layers()) - 1
		If Layers(r) \ Scene = SceneName
			Index = ArraySize(LayerTrash())
			ReDim LayerTrash(Index + 1)
			LayerTrash(Index) = Layers(r) \ Name
		EndIf
	Next
	; Delete trash
	For r = 0 To ArraySize(LayerTrash()) - 1
		DeleteLayer(LayerTrash(r))
	Next
	
	; Delete tiles using this scene
	Dim TileTrash.s(0)
	For r = 0 To ArraySize(Tiles()) - 1
		If Tiles(r) \ Scene = SceneName
			Index = ArraySize(TileTrash())
			ReDim TileTrash(Index + 1)
			TileTrash(Index) = Tiles(r) \ Name
		EndIf
	Next
	; Delete trash
	For r = 0 To ArraySize(TileTrash()) - 1
		DeleteTile(TileTrash(r))
	Next
	
EndProcedure

; Move the selected scene to backward one position
Procedure SceneMoveBackward(SceneName.s) 
	
	Changed = 0
	
	Dim Temp.Scene(1)
	For t = 0 To ArraySize(Scenes()) - 1
		If Scenes(t) \ Name = SceneName
			
			; If not already the first element in the array
			If t > 0
				
				; Store the previous scene data
				; CURRENT SCENE -> TEMP
				Temp(0) = Scenes(t - 1)
				
				; Overwrite the previous scene data with the selected scene data
				; CURRENT SCENE -> PREVIOUS SCENE
				Scenes(t - 1) = Scenes(t)
				
				; Overwrite the selected scene data with the temp stored data
				; TEMP -> CURRENT SCENE
				Scenes(t) = Temp(0)
				
				Changed = 1
				
				Break
			EndIf
			
		EndIf
	Next
	
	If Changed = 1
		RefreshItems()
	EndIf
	
EndProcedure

; Move the selected scene to forward one position
Procedure SceneMoveForward(SceneName.s) 
	
	Changed = 0
	
	Dim Temp.Scene(1)
	
	For t = 0 To ArraySize(Scenes()) - 1
		If Scenes(t) \ Name = SceneName
			
			; If not already the first element in the array
			If t < ArraySize(Scenes()) - 1
				
				; Store the previous scene data
				; CURRENT SCENE -> TEMP
				Temp(0) = Scenes(t + 1)
				
				; Overwrite the previous scene data with the selected scene data
				; CURRENT SCENE -> PREVIOUS SCENE
				Scenes(t + 1) = Scenes(t)
				
				; Overwrite the selected scene data with the temp stored data
				; TEMP -> CURRENT SCENE
				Scenes(t) = Temp(0)
				
				Changed = 1
				
				Break
			EndIf
			
		EndIf
	Next
	
	If Changed = 1
		RefreshItems()
	EndIf	
	
EndProcedure

Procedure RefreshTileImage(Gadget, Scroller, BackgroundName.s)
	
	Index = -1
	For b = 0 To ArraySize(Backgrounds()) - 1
		If Backgrounds(b) \ Name = BackgroundName
			Index = b
			Break
		EndIf
	Next
	
	If Index > -1 And Backgrounds(Index) \ File <> ""
		BackgroundImage = LoadImage(#PB_Any, TempName + "/" + Backgrounds(Index) \ File)
		NewWidth = ImageWidth(BackgroundImage)
		NewHeight = ImageHeight(BackgroundImage)
		ResizeGadget(Gadget, 0, 0, NewWidth, NewHeight)
		SetGadgetAttribute(Scroller, #PB_ScrollArea_InnerWidth, NewWidth)
		SetGadgetAttribute(Scroller, #PB_ScrollArea_InnerHeight, NewHeight)
		StartDrawing(CanvasOutput(Gadget))
		If IsImage(#TransGrid) : DrawImage(ImageID(#TransGrid), 0, 0) : EndIf
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(BackgroundImage), 0, 0)
		StopDrawing()
		FreeImage(BackgroundImage)
	Else
		ResizeGadget(Gadget, 0, 0, 0, 0)
		SetGadgetAttribute(Scroller, #PB_ScrollArea_InnerWidth, 0)
		SetGadgetAttribute(Scroller, #PB_ScrollArea_InnerHeight, 0)
	EndIf
EndProcedure

Procedure RefreshLayerCombo(Scene.s, Combo)
	ClearGadgetItems(Combo)
	For d = 0 To ArraySize(Layers()) - 1
		If Layers(d) \ Scene = Scene
			AddGadgetItem(Combo, -1, Str(Layers(d) \ Value))
		EndIf
	Next
	SetGadgetState(Combo, 0)
EndProcedure

Procedure ValidateSee(Scene.s)
	
	ClearList(Sees())
	
	For z = 0 To ArraySize(Objects()) - 1
		If Objects(z) \ Scene = Scene And Objects(z) \ Proto = 0
			*Index.See = AddElement(Sees())
			*Index \ Depth = Objects(z) \ Depth
			*Index \ Object = z
			*Index \ Tile = -1
		EndIf
	Next
	
	For z = 0 To ArraySize(Tiles()) - 1
		If Tiles(z) \ Scene  = Scene
			*Index.See = AddElement(Sees())
			*Index \ Depth = Tiles(z) \ Depth
			*Index \ Object = -1
			*Index \ Tile = z
		EndIf
	Next
	
	SortStructuredList(Sees(), #PB_Sort_Descending, OffsetOf(See\Depth), #PB_Long)
	
EndProcedure

; Custom instance properties
Procedure EditSceneInstance(s, Index)
	
	; Form window
	DisableWindow(Scenes(s) \ GadgetWindow, 1)
	Scenes(s) \ InnerPropWindow = OpenWindow(#PB_Any, 0, 0, 280, 220, "Instance properties - " + Objects(Index) \ Name, #PB_Window_ScreenCentered | #PB_Window_Tool, WindowID(Scenes(s) \ GadgetWindow))
	;StickyWindow(Scenes(s) \ InnerPropWindow, 1)
	
	; X
	TextGadget(#PB_Any, 10, 15, 150, 25, "X")
	Scenes(s) \ InnerPropGadgetX = StringGadget(#PB_Any, 170, 10, 100, 25, Str(Objects(Index) \ X))
	
	; Y
	TextGadget(#PB_Any, 10, 45, 150, 25, "Y")
	Scenes(s) \ InnerPropGadgetY = StringGadget(#PB_Any, 170, 40, 100, 25, Str(Objects(Index) \ Y))
	
	; Direction
	TextGadget(#PB_Any, 10, 75, 150, 25, "Direction")
	Scenes(s) \ InnerPropGadgetDirection = StringGadget(#PB_Any, 170, 70, 100, 25, Str(Objects(Index) \ Direction))
	
	; Image angle
	TextGadget(#PB_Any, 10, 105, 150, 25, "Image angle")
	Scenes(s) \ InnerPropGadgetImageAngle = StringGadget(#PB_Any, 170, 100, 100, 25, Str(Objects(Index) \ ImageAngle))
	
	; OK button
	Scenes(s) \ InnerPropOKButton = ButtonGadget(#PB_Any, WindowWidth(Scenes(s) \ InnerPropWindow) - 75, WindowHeight(Scenes(s) \ InnerPropWindow) - 35, 65, 25, "OK")
	
	; Cancel
	Scenes(s) \ InnerPropCancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(Scenes(s) \ InnerPropWindow) - 35, 65, 25, "Cancel")
	
	; Window handling
	Done = 0
	Repeat
		SetActiveWindow(Scenes(s) \ InnerPropWindow)
		Select WaitWindowEvent()

			Case #PB_Event_Gadget
				Select EventGadget()
						
					; Apply form changes
					Case Scenes(s) \ InnerPropOKButton
						Objects(Index) \ X = Val(GetGadgetText(Scenes(s) \ InnerPropGadgetX))
						Objects(Index) \ Y = Val(GetGadgetText(Scenes(s) \ InnerPropGadgetY))
						Objects(Index) \ Direction = Val(GetGadgetText(Scenes(s) \ InnerPropGadgetDirection))
						Objects(Index) \ ImageAngle = Val(GetGadgetText(Scenes(s) \ InnerPropGadgetImageAngle))
						
						; VALIDATE Image rotation from ImageAngle
						If IsImage(Objects(Index) \ TImageModified) : FreeImage(Objects(Index) \ TImageModified) : EndIf
						If IsImage(Objects(Index) \ TImage)
							If Objects(Index) \ ImageAngle <> 0
								Objects(Index) \ TImageModified = RotateImageFree(Objects(Index) \ TImage, Objects(Index) \ ImageAngle, #True)
							Else
								Objects(Index) \ TImageModified = CopyImage(Objects(Index) \ TImage, #PB_Any)
							EndIf
						EndIf						
						
						Done = 1
						Dirty(1)
						
					Case Scenes(s) \ InnerPropCancelButton
						Done = 1
						
				EndSelect
				
		EndSelect
	Until Done = 1
	
	; Close window
	DisableWindow(Scenes(s) \ GadgetWindow, 0)			
	CloseWindow(Scenes(s) \ InnerPropWindow)
	
	RefreshSceneObjectSelector(s)
	
EndProcedure

Procedure RefreshSceneObjectToFollowCombo(s)
	ClearGadgetItems(Scenes(s) \ InnerObjectToFollowCombo)
	AddGadgetItem(Scenes(s) \ InnerObjectToFollowCombo, -1, "") ; empty option
	
	; Loop on objects
	For a = 0 To ArraySize(Objects()) - 1
		
		; Add objects to Object selector if template
		If Objects(a) \ Proto = 1
			
			Scenes(s) \ InnerImage = Objects(a) \ TImage
			If Not IsImage(Scenes(s) \ InnerImage) 
				Scenes(s) \ InnerImage = #MissingSprite
			EndIf
			
			AddGadgetItem(Scenes(s) \ InnerObjectToFollowCombo, -1, Objects(a) \ Name, ImageID(Scenes(s) \ InnerImage))
		EndIf
		
		; Rotate visual image of level object
		If Objects(a) \ Proto = 0
			If IsImage(Objects(a) \ TImageModified) : FreeImage(Objects(a) \ TImageModified) : EndIf
			If IsImage(Objects(a) \ TImage)
				If Objects(a) \ ImageAngle <> 0
					Objects(a) \ TImageModified = RotateImageFree(Objects(a) \ TImage, Objects(a) \ ImageAngle, #True)
				Else
					Objects(a) \ TImageModified = CopyImage(Objects(a) \ TImage, #PB_Any)
				EndIf
			EndIf
		EndIf
		
	Next
	
	; FOLLOW OBJECT
	SetGadgetText(Scenes(s) \ InnerObjectToFollowCombo, Scenes(s) \ ViewportObject)	
EndProcedure

Procedure RefreshSceneObjectsList(s)
	
	ClearGadgetItems(Scenes(s) \ InnerObjectsList)
	
	For a = 0 To ArraySize(Objects()) - 1
		If Objects(a) \ Proto = 1
			
			Scenes(s) \ InnerImage.i = Objects(a) \ TImage
			If Not IsImage(Scenes(s) \ InnerImage) 
				Scenes(s) \ InnerImage.i = #MissingSprite
			EndIf
			
			AddGadgetItem(Scenes(s) \ InnerObjectsList, -1, Objects(a) \ Name, ImageID(Scenes(s) \ InnerImage))
		EndIf
	Next
	
	SetGadgetState(Scenes(s) \ InnerObjectsList, 0)
	Scenes(s) \ InnerSelectedObjectSpriteImage = GetSpriteImage(GetObjectSprite(GetGadgetText(Scenes(s) \ InnerObjectsList)))
	Scenes(s) \ InnerSelectedObjectSpriteIndex = GetSpriteIndex(GetObjectSprite(GetGadgetText(Scenes(s) \ InnerObjectsList)))
	
	If Scenes(s) \ InnerSelectedObjectSpriteImage <> -1
		Scenes(s) \ InnerIW = ImageWidth(Scenes(s) \ InnerSelectedObjectSpriteImage)
		Scenes(s) \ InnerIH = ImageHeight(Scenes(s) \ InnerSelectedObjectSpriteImage)
		If Scenes(s) \ InnerIW >= Scenes(s) \ InnerIH
			Scenes(s) \ InnerWS = 1
			Scenes(s) \ InnerHS = Scenes(s) \ InnerIH / Scenes(s) \ InnerIW
		Else
			Scenes(s) \ InnerWS = Scenes(s) \ InnerIW / Scenes(s) \ InnerIH
			Scenes(s) \ InnerHS = 1
		EndIf
		If IsImage(Scenes(s) \ InnerPreviewImage) : FreeImage(Scenes(s) \ InnerPreviewImage) : EndIf
		Scenes(s) \ InnerPreviewImage = CreateImage(#PB_Any, 100, 100, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(Scenes(s) \ InnerPreviewImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		DrawImage(ImageID(Scenes(s) \ InnerSelectedObjectSpriteImage), 0, 0, 100 * Scenes(s) \ InnerWS, 100 * Scenes(s) \ InnerHS)
		StopDrawing()
		SetGadgetState(Scenes(s) \ InnerObjectPreview, ImageID(Scenes(s) \ InnerPreviewImage))
	Else
		SetGadgetState(Scenes(s) \ InnerObjectPreview, ImageID(#NullImage))
	EndIf
	
EndProcedure

Procedure RefreshSceneBackgroundsCombo(s)
	ClearGadgetItems(Scenes(s) \ InnerBackgroundImageCombo)
	AddGadgetItem(Scenes(s) \ InnerBackgroundImageCombo, -1, "")
	For b = 0 To ArraySize(Backgrounds()) - 1
		AddGadgetItem(Scenes(s) \ InnerBackgroundImageCombo, -1, Backgrounds(b) \ Name)
	Next
	SetGadgetText(Scenes(s) \ InnerBackgroundImageCombo, Scenes(s) \ Background)
EndProcedure

Procedure RefreshSceneBackgroundImage(s)
	Scenes(s) \ InnerBackgroundImage = -1
	For b = 0 To ArraySize(Backgrounds()) - 1
		If Scenes(s) \ Background = Backgrounds(b) \ Name
			Scenes(s) \ InnerBackgroundImage = LoadImage(#PB_Any, TempName + "/" + Backgrounds(b) \ File)
			Break
		EndIf
	Next
EndProcedure

Procedure RefreshSceneSelectedTile(s)
	RefreshTileImage(Scenes(s) \ InnerTileCanvas, Scenes(s) \ InnerTileScroller, GetGadgetText(Scenes(s) \ InnerTileImageCombo))
	
	If IsImage(Scenes(s) \ InnerTileCursorImage) : FreeImage(Scenes(s) \ InnerTileCursorImage) : EndIf
	Scenes(s) \ InnerTileCursorImage = -1
	
	Scenes(s) \ InnerTileX = 0
	Scenes(s) \ InnerTileY = 0
	Scenes(s) \ InnerTileWidth = 0
	Scenes(s) \ InnerTileHeight = 0
	
	; Create new tile background image
	For b = 0 To ArraySize(Backgrounds()) - 1
		If Backgrounds(b) \ Name = GetGadgetText(Scenes(s) \ InnerTileImageCombo)
			If IsImage(Scenes(s) \ InnerTileBackground)
				FreeImage(Scenes(s) \ InnerTileBackground)
			EndIf
			If Backgrounds(b) \ File <> ""
				Scenes(s) \ InnerTileBackground = LoadImage(#PB_Any, TempName + "/" + Backgrounds(b) \ File)
			EndIf
			Break
		EndIf
	Next
EndProcedure

Procedure RefreshSceneTilesCombo(s)
	ClearGadgetItems(Scenes(s) \ InnerTileImageCombo)
	For b = 0 To ArraySize(Backgrounds()) - 1
		AddGadgetItem(Scenes(s) \ InnerTileImageCombo, -1, Backgrounds(b) \ Name)
	Next
	SetGadgetText(Scenes(s) \ InnerTileImageCombo, Backgrounds(0) \ Name)
EndProcedure

Procedure SceneFormStore(s, close)
	
	Scenes(s) \ InnerErrors = 0
	
	; Check scene name (Missing or exists)
	If GetGadgetText(Scenes(s) \ InnerNameGadget) <> ""
		If SceneNameIsFree(GetGadgetText(Scenes(s) \ InnerNameGadget), s) = 0
			MessageRequester("Error", "The scene name '" + GetGadgetText(Scenes(s) \ InnerNameGadget) + "' already exists")
			Scenes(s) \ InnerErrors = Scenes(s) \ InnerErrors + 1
		EndIf
	Else
		MessageRequester("Error", "The scene name is missing")
		Scenes(s) \ InnerErrors = Scenes(s) \ InnerErrors + 1
	EndIf
	
	; Scene speed
	If GetGadgetText(Scenes(s) \ InnerSceneSpeedGadget) <> ""
		If Val(GetGadgetText(Scenes(s) \ InnerSceneSpeedGadget)) < 1
			MessageRequester("Error", "Invalid scene speed value")
			Scenes(s) \ InnerErrors = Scenes(s) \ InnerErrors + 1
		EndIf
	Else
		MessageRequester("Error", "Invalid scene speed value")
		Scenes(s) \ InnerErrors = Scenes(s) \ InnerErrors + 1
	EndIf
	
	; Form is correct
	If Scenes(s) \ InnerErrors = 0
		
		Dirty(1)
		
		; Update scene data in objects
		For w = 0 To ArraySize(Objects()) - 1
			If Objects(w) \ Scene = Scenes(s) \ Name
				Objects(w) \ Scene = GetGadgetText(Scenes(s) \ InnerNameGadget)
			EndIf
		Next
		
		; Update scene data in layers
		For w = 0 To ArraySize(Layers()) - 1
			If Layers(w) \ Scene = Scenes(s) \ Name
				Layers(w) \ Scene = GetGadgetText(Scenes(s) \ InnerNameGadget)
			EndIf
		Next
		
		; Update scene data in tiles
		For w = 0 To ArraySize(Tiles()) - 1
			If Tiles(w) \ Scene = Scenes(s) \ Name
				Tiles(w) \ Scene = GetGadgetText(Scenes(s) \ InnerNameGadget)
			EndIf
		Next
		
		Scenes(s) \ Name = GetGadgetText(Scenes(s) \ InnerNameGadget)
		Scenes(s) \ Speed = Val(GetGadgetText(Scenes(s) \ InnerSceneSpeedGadget))
		Scenes(s) \ Width = Val(GetGadgetText(Scenes(s) \ InnerWidthGadget))
		Scenes(s) \ Height = Val(GetGadgetText(Scenes(s) \ InnerHeightGadget))
		Scenes(s) \ ViewportWidth = Val(GetGadgetText(Scenes(s) \ InnerViewportWidthGadget))
		Scenes(s) \ ViewportHeight = Val(GetGadgetText(Scenes(s) \ InnerViewportHeightGadget))
		Scenes(s) \ Background = GetGadgetText(Scenes(s) \ InnerBackgroundImageCombo)
		Scenes(s) \ ViewportObject = GetGadgetText(Scenes(s) \ InnerObjectToFollowCombo)
		Scenes(s) \ ViewportXBorder = Val(GetGadgetText(Scenes(s) \ InnerMarginWidthGadget))
		Scenes(s) \ ViewportYBorder = Val(GetGadgetText(Scenes(s) \ InnerMarginHeightGadget))
		Scenes(s) \ Keywords = GetGadgetText(Scenes(s) \ GadgetKeywords)
		
		; Save canvas image as project preview image
		If ProjectName <> ""
			ProjectImage = CreateImage(#PB_Any, 240, 240)
			StartDrawing(ImageOutput(ProjectImage))
			DrawingMode(#PB_2DDrawing_Default)
			Scenes(s) \ InnerIW = Scenes(s) \ Width
			Scenes(s) \ InnerIH = Scenes(s) \ Height
			If Scenes(s) \ InnerIW >= Scenes(s) \ InnerIH
				Scenes(s) \ InnerWS = 1
				Scenes(s) \ InnerHS = Scenes(s) \ InnerIH / Scenes(s) \ InnerIW
			Else
				Scenes(s) \ InnerWS = Scenes(s) \ InnerIW / Scenes(s) \ InnerIH
				Scenes(s) \ InnerHS = 1
			EndIf
			DrawImage(GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_Image), 0, 0, 240 * Scenes(s) \ InnerWS, 240 * Scenes(s) \ InnerHS)
			StopDrawing()
			SaveImage(ProjectImage, "Projects/" + ProjectName + ".png", #PB_ImagePlugin_PNG)
			If IsImage(ProjectImage) : FreeImage(ProjectImage) : EndIf
		EndIf
		
		; Create preview image
		NewSceneImage = CreateImage(#PB_Any, 150, 100, 32, #PB_Image_Transparent)
		StartDrawing(ImageOutput(NewSceneImage))
		DrawingMode(#PB_2DDrawing_AlphaBlend)
		If IsImage(#BoxEmpty) : DrawImage(ImageID(#BoxEmpty), 0, 0) : EndIf
		Scenes(s) \ InnerIW = Scenes(s) \ Width
		Scenes(s) \ InnerIH = Scenes(s) \ Height
		If Scenes(s) \ InnerIW >= Scenes(s) \ InnerIH
			Scenes(s) \ InnerWS.f = 1
			Scenes(s) \ InnerHS.f = Scenes(s) \ InnerIH / Scenes(s) \ InnerIW
		Else
			Scenes(s) \ InnerWS.f = Scenes(s) \ InnerIW / Scenes(s) \ InnerIH
			Scenes(s) \ InnerHS.f = 1
		EndIf
		DrawImage(GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_Image), 35, 10, 80 * Scenes(s) \ InnerWS, 80 * Scenes(s) \ InnerHS)
		StopDrawing()
		Scenes(s) \ Preview = CopyImage(NewSceneImage, #PB_Any)
		If IsImage(NewSceneImage) : FreeImage(NewSceneImage) : EndIf
		
		; Deselect all objects / tiles
		For w = 0 To ArraySize(Objects()) - 1 : Objects(w) \ Selected = 0 : Next
		For w = 0 To ArraySize(Tiles()) - 1 : Tiles(w) \ Selected = 0 : Next
		; Free temp background image
		If IsImage(Scenes(s) \ InnerBackgroundImage) : FreeImage(Scenes(s) \ InnerBackgroundImage) : EndIf
		
		If close = 1
			CloseWindow(Scenes(s) \ GadgetWindow)
			Scenes(s) \ GadgetWindow = 0
		EndIf
		
		RefreshItems()
		
	EndIf
	
EndProcedure

Procedure RefreshSceneObjectSelector(s)
	If IsWindow(Scenes(s) \ GadgetWindow)
		ClearGadgetItems(Scenes(s) \ InnerObjectSelector)
		sn = 0
		For w = 0 To ArraySize(Objects()) - 1
			If Objects(w) \ Scene = Scenes(s) \ Name
				AddGadgetItem(Scenes(s) \ InnerObjectSelector, -1, Objects(w) \ TemplateObject + " (" + Objects(w) \ Sprite+ ") : " + Str(Objects(w) \ X) + ", " + Str(Objects(w) \ Y))
				If Objects(w) \ Selected
					SetGadgetItemState(Scenes(s) \ InnerObjectSelector, sn, 1)
				EndIf
				SetGadgetItemData(Scenes(s) \ InnerObjectSelector, sn, w)
				sn = sn + 1
			EndIf
		Next
	EndIf
EndProcedure

; Display the scene form
Procedure SceneForm(Name.s)
	
	; Search the scene by its name
	For s = 0 To ArraySize(Scenes()) - 1
		If Scenes(s) \ Name = Name
			
			; WINDOW IS ALREADY OPENED
			If IsWindow(Scenes(s) \ GadgetWindow)
				ProcedureReturn
			EndIf
			
			; Image of the selected object
			Scenes(s) \ InnerSelectedObjectSpriteImage = -1
			Scenes(s) \ InnerSelectedObjectSpriteIndex = -1
			
			; Mouse is in the scene area
			Scenes(s) \ InnerMouseInScene = 0
			
			; Tile handling
			Scenes(s) \ InnerTileBackground = -1
			Scenes(s) \ InnerTileX = 0
			Scenes(s) \ InnerTileY = 0
			Scenes(s) \ InnerTileWidth = 0
			Scenes(s) \ InnerTileHeight = 0
			Scenes(s) \ InnerTilePreviewImage = -1
			Scenes(s) \ InnerTileCursorImage = -1
			
			Scenes(s) \ InnerKey = -1
			Scenes(s) \ InnerShift = 0
			Scenes(s) \ InnerAlt = 0
			Scenes(s) \ InnerCtrl = 0
		
			; Multiple object handling
			Scenes(s) \ InnerBlockX = 0
			Scenes(s) \ InnerBlockY = 0
			Scenes(s) \ InnerOldBlockX = 0
			Scenes(s) \ InnerOldBlockY = 0
			
			; Temp background image
			RefreshSceneBackgroundImage(s)
			
			; Form window
			Scenes(s) \ GadgetWindow = OpenWindow(#PB_Any, 0, 0, 1024, 668, "Scene properties - " + Scenes(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_Tool, WindowID(#MainWindow))
			;StickyWindow(Scenes(s) \ GadgetWindow, 1)
			
			CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
				If OSVersion() = #PB_OS_MacOSX_10_7 Or OSVersion() = #PB_OS_MacOSX_10_8 Or OSVersion() = #PB_OS_MacOSX_Future
					EnableFullScreenButton(Scenes(s) \ GadgetWindows)
				EndIf
			CompilerEndIf
			
			; OK button
			Scenes(s) \ InnerOK = ButtonGadget(#PB_Any, 10, 10, 100, 25, "Done")
			
			; Scene name
			Scenes(s) \ InnerNameGadget = StringGadget(#PB_Any, 120, 10, 100, 25, Scenes(s) \ Name)
			
			; Panel
			Scenes(s) \ InnerTabPanel = PanelGadget(#PB_Any, 10, 40, 300, 618)
			AddGadgetItem(Scenes(s) \ InnerTabPanel, 0, "Settings")
			
			; Scene dimensions
			TextGadget(#PB_Any, 10, 15, 100, 25, "Scene size (W/H)")
			Scenes(s) \ InnerWidthGadget = StringGadget(#PB_Any, 10, 40, 45, 25, Str(Scenes(s) \ Width), #PB_String_Numeric)
			Scenes(s) \ InnerHeightGadget = StringGadget(#PB_Any, 85, 40, 45, 25, Str(Scenes(s) \ Height), #PB_String_Numeric)
			
			; Viewport dimensions
			TextGadget(#PB_Any, 10, 75, 105, 25, "Viewport size (W/H)")
			Scenes(s) \ InnerViewportWidthGadget = StringGadget(#PB_Any, 10, 100, 45, 25, Str(Scenes(s) \ ViewportWidth), #PB_String_Numeric)
			Scenes(s) \ InnerViewportHeightGadget = StringGadget(#PB_Any, 85, 100, 45, 25, Str(Scenes(s) \ ViewportHeight), #PB_String_Numeric)
			
			; Object to follow
			TextGadget(#PB_Any, 10, 135, 100, 25, "Object to follow")
			Scenes(s) \ InnerObjectToFollowCombo = ComboBoxGadget(#PB_Any, 10, 160, 120, 25, #PB_ComboBox_Image)
			
			RefreshSceneObjectToFollowCombo(s)
			
			; Follow border
			TextGadget(#PB_Any, 10, 195, 105, 25, "Follow margin (X/Y)")
			Scenes(s) \ InnerMarginWidthGadget = StringGadget(#PB_Any, 10, 220, 45, 25, Str(Scenes(s) \ ViewportXBorder), #PB_String_Numeric)
			Scenes(s) \ InnerMarginHeightGadget = StringGadget(#PB_Any, 85, 220, 45, 25, Str(Scenes(s) \ ViewportYBorder), #PB_String_Numeric)
			
			; Scene FPS Speed
			TextGadget(#PB_Any, 10, 260, 40, 25, "Speed")
			Scenes(s) \ InnerSceneSpeedGadget = StringGadget(#PB_Any, 85, 255, 45, 25, Str(Scenes(s) \ Speed), #PB_String_Numeric)
			
			; Scene script button
			Scenes(s) \ InnerSceneCodeButton = ButtonGadget(#PB_Any, 10, 290, 120, 25, "Scene code...")
			
			; Keywords input
			Scenes(s) \ GadgetKeywords = StringGadget(#PB_Any, 10, 555, 280, 25, Scenes(s) \ Keywords)
			
			AddGadgetItem(Scenes(s) \ InnerTabPanel, 1, "Objects")
			; Object action mode
			TextGadget(#PB_Any, 10, 15, 100, 25, "Action")
			Scenes(s) \ InnerObjectActionMode = ComboBoxGadget(#PB_Any, 10, 35, 120, 25, #PB_ComboBox_Image)
			AddGadgetItem(Scenes(s) \ InnerObjectActionMode, -1, "Place objects", ImageID(#CreateIcon))
			AddGadgetItem(Scenes(s) \ InnerObjectActionMode, -1, "Select objects", ImageID(#SelectIcon))
			AddGadgetItem(Scenes(s) \ InnerObjectActionMode, -1, "Remove objects", ImageID(#DeleteIcon))
			SetGadgetState(Scenes(s) \ InnerObjectActionMode, 0)
			
			; Available objects to place
			TextGadget(#PB_Any, 150, 15, 80, 25, "Object to place")
			
			Scenes(s) \ InnerObjectsList = ComboBoxGadget(#PB_Any, 150, 35, 130, 25, #PB_ComboBox_Image)
			; Object preview
			Scenes(s) \ InnerObjectPreview = ImageGadget(#PB_Any, 150, 70, 100, 100, ImageID(#NullImage), #PB_Image_Border)
			RefreshSceneObjectsList(s)
			
			Scenes(s) \ InnerEditInstance = ButtonGadget(#PB_Any, 10, 190, 275, 25, "Edit selected instance...")
			
			Scenes(s) \ InnerObjectSelector = ListViewGadget(#PB_Any, 10, 230, 275, 300, #PB_ListView_MultiSelect)
			RefreshSceneObjectSelector(s)
			
			AddGadgetItem(Scenes(s) \ InnerTabPanel, 2, "Background")
			
			; Background color
			TextGadget(#PB_Any, 10, 15, 100, 25, "Background color")
			Scenes(s) \ InnerBackgroundColor = StringGadget(#PB_Any, 10, 40, 65, 25, "", #PB_String_ReadOnly | #PB_String_BorderLess)
			SetGadgetColor(Scenes(s) \ InnerBackgroundColor, #PB_Gadget_BackColor, RGB(Scenes(s) \ R, Scenes(s) \ G, Scenes(s) \ B))
			
			Scenes(s) \ InnerosxBGcolorsize = 30
			
			CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
				Scenes(s) \ InnerosxBGcolorsize = 40 
			CompilerEndIf
			
			Scenes(s) \ InnerBackgroundChangeButton = ButtonGadget(#PB_Any, 80, 40, Scenes(s) \ InnerosxBGcolorsize, 25, "...")
			
			; Background image
			TextGadget(#PB_Any, 10, 75, 100, 25, "Background image")
			Scenes(s) \ InnerBackgroundImageCombo = ComboBoxGadget(#PB_Any, 10, 100, 100, 25)
			RefreshSceneBackgroundsCombo(s)
			
			; Tile XY
			Scenes(s) \ InnerTileXCheckbox = CheckBoxGadget(#PB_Any, 10, 130, 100, 25, "Tile horizontally")
			Scenes(s) \ InnerTileYCheckbox = CheckBoxGadget(#PB_Any, 10, 160, 100, 25, "Tile vertically")
			Scenes(s) \ InnerStretchCheckbox = CheckBoxGadget(#PB_Any, 10, 190, 100, 25, "Stretch")
			SetGadgetState(Scenes(s) \ InnerTileXCheckbox, Scenes(s) \ BackgroundTileX)
			SetGadgetState(Scenes(s) \ InnerTileYCheckbox, Scenes(s) \ BackgroundTileY)
			SetGadgetState(Scenes(s) \ InnerStretchCheckbox, Scenes(s) \ BackgroundStretch)
			
			AddGadgetItem(Scenes(s) \ InnerTabPanel, 3, "Tiles")
			
			; Background image
			TextGadget(#PB_Any, 10, 15, 100, 25, "Tile image")
			Scenes(s) \ InnerTileImageCombo = ComboBoxGadget(#PB_Any, 10, 40, 100, 25)
			RefreshSceneTilesCombo(s)
			
			; Tile action mode
			TextGadget(#PB_Any, 130, 15, 100, 25, "Action")
			Scenes(s) \ InnerTileActionMode = ComboBoxGadget(#PB_Any, 130, 40, 100, 25, #PB_ComboBox_Image)
			AddGadgetItem(Scenes(s) \ InnerTileActionMode, -1, "Place tiles", ImageID(#CreateIcon))
			AddGadgetItem(Scenes(s) \ InnerTileActionMode, -1, "Select tiles", ImageID(#SelectIcon))
			AddGadgetItem(Scenes(s) \ InnerTileActionMode, -1, "Remove tiles", ImageID(#DeleteIcon))
			SetGadgetState(Scenes(s) \ InnerTileActionMode, 0)
			
			; Tile background image
			Scenes(s) \ InnerTileScroller = ScrollAreaGadget(#PB_Any, 10, 80, 270, 360, 640, 480, 16, #PB_ScrollArea_BorderLess | #PB_ScrollArea_Flat)
			Scenes(s) \ InnerTileCanvas = CanvasGadget(#PB_Any, 0, 0, 640, 480, #PB_Canvas_ClipMouse | #PB_Canvas_Keyboard)
			RefreshTileImage(Scenes(s) \ InnerTileCanvas, Scenes(s) \ InnerTileScroller, Backgrounds(0) \ Name)
			CloseGadgetList()
			
			; Layer combo
			TextGadget(#PB_Any, 10, 455, 100, 25, "Layer")
			Scenes(s) \ InnerLayerCombo = ComboBoxGadget(#PB_Any, 10, 480, 110, 25)
			RefreshLayerCombo(Scenes(s) \ Name, Scenes(s) \ InnerLayerCombo)
			SetGadgetState(Scenes(s) \ InnerLayerCombo, 0)
			
			; Layer add/delete button
			Scenes(s) \ InnerLayerAddButton = ButtonGadget(#PB_Any, 10, 510, 50, 25, "Add")
			Scenes(s) \ InnerLayerDeleteButton = ButtonGadget(#PB_Any, 60, 510, 60, 25, "Delete")
			; Layer change button
			Scenes(s) \ InnerLayerChangeButton = ButtonGadget(#PB_Any, 10, 540, 110, 25, "Change...")
			
			; Selected tile
			TextGadget(#PB_Any, 130, 455, 120, 25, "Selected tile")
			Scenes(s) \ InnerTilePreview = ImageGadget(#PB_Any, 130, 480, 100, 100, ImageID(#NullImage), #PB_Image_Border)
			CloseGadgetList()
			
			CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
				Scenes(s) \ InnerosxGameButton = 30
			CompilerElse
				Scenes(s) \ InnerosxGameButton = 24
			CompilerEndIf
			
			; New icon
			Scenes(s) \ InnerNewButton = ButtonImageGadget(#PB_Any, 320, 10, Scenes(s) \ InnerosxGameButton, Scenes(s) \ InnerosxGameButton, ImageID(#NewIcon)) : GadgetToolTip(Scenes(s) \ InnerNewButton, "New")
			
			; Shift icon
			Scenes(s) \ InnerShiftButton = ButtonImageGadget(#PB_Any, 355, 10, Scenes(s) \ InnerosxGameButton, Scenes(s) \ InnerosxGameButton, ImageID(#ArrowIcon)) : GadgetToolTip(Scenes(s) \ InnerShiftButton, "Shift objects")
			
			; Show grid
			Scenes(s) \ InnerShowGridButton = ButtonImageGadget(#PB_Any, 390, 10, Scenes(s) \ InnerosxGameButton, Scenes(s) \ InnerosxGameButton, ImageID(#GridIcon), #PB_Button_Toggle) : GadgetToolTip(Scenes(s) \ InnerShowGridButton, "Toggle show / hide the grid")
			SetGadgetState(Scenes(s) \ InnerShowGridButton, Scenes(s) \ InnerShowGrid)
			
			; Snap to grid
			Scenes(s) \ InnerSnapToGridButton = ButtonImageGadget(#PB_Any, 425, 10, Scenes(s) \ InnerosxGameButton, Scenes(s) \ InnerosxGameButton, ImageID(#SnapIcon), #PB_Button_Toggle) : GadgetToolTip(Scenes(s) \ InnerSnapToGridButton, "Toggle snap / don't snap objects to grid")
			SetGadgetState(Scenes(s) \ InnerSnapToGridButton, Scenes(s) \ InnerSnapToGrid)
			
			; Grid size
			TextGadget(#PB_Any, 460, 15, 40, 25, "Size")
			Scenes(s) \ InnerGridSizeGadget = StringGadget(#PB_Any, 490, 10, 40, 25, Str(Scenes(s) \ InnerGridSize), #PB_String_Numeric)
			
			; Show Objects
			Scenes(s) \ InnerShowObjectsCheckbox = CheckBoxGadget(#PB_Any, 540, 10, 90, 25, "Show objects")
			SetGadgetState(Scenes(s) \ InnerShowObjectsCheckbox, Scenes(s) \ InnerShowObjects)
			
			; Show tiles
			Scenes(s) \ InnerShowTilesCheckbox = CheckBoxGadget(#PB_Any, 630, 10, 80, 25, "Show tiles")
			SetGadgetState(Scenes(s) \ InnerShowTilesCheckbox, Scenes(s) \ InnerShowTiles)
			
			; Last selected object info
			Scenes(s) \ InnerSelectedObjectInfo = TextGadget(#PB_Any, 750, 15, 300, 25, "")
			
			; Canvas
			Scenes(s) \ InnerScrollerGadget = ScrollAreaGadget(#PB_Any, 320, 45, WindowWidth(Scenes(s) \ GadgetWindow) - 130, WindowHeight(Scenes(s) \ GadgetWindow) - 60, 1024, 768, 20, #PB_ScrollArea_BorderLess | #PB_ScrollArea_Flat)
			Scenes(s) \ InnerSceneCanvas = CanvasGadget(#PB_Any, 0, 0, Scenes(s) \ Width, Scenes(s) \ Height, #PB_Canvas_ClipMouse | #PB_Canvas_Keyboard)
			CloseGadgetList()
			RefreshSceneGadget(Scenes(s) \ InnerSceneCanvas, Scenes(s) \ InnerScrollerGadget, Scenes(s) \ InnerWidthGadget, Scenes(s) \ InnerHeightGadget)
			
			AddWindowTimer(Scenes(s) \ GadgetWindow, Scenes(s) \ InnerTimer, 50)
			
			RefreshItems()
			
			Break
			
		EndIf
	Next
	
EndProcedure

; Delete the specified script
Procedure DeleteScript(ScriptName.s)
	
	; Search for the script
	Dim TempScripts.Function(0)
	For m = 0 To ArraySize(Functions()) - 1
		If Functions(m) \ Name <> ScriptName
			
			Index = ArraySize(TempScripts())	
			ReDim TempScripts(Index + 1)
			TempScripts(Index) = Functions(m)
		EndIf
	Next
	CopyArray(TempScripts(), Functions())
	
EndProcedure

; Export functions
Procedure ExportFunctions()
	
	If Not ArraySize(Functions())
		MessageRequester("Message", "There is nothing to export.")
		ProcedureReturn #True
	EndIf
	
	DisableWindow(#MainWindow, 1)
	OpenWindow(#SubWindow, 0, 0, 450, 600, "Select functions to export", #PB_Window_ScreenCentered | #PB_Window_Tool)
	
	; OK button
	ButtonGadget(#GeneralOKButton, WindowWidth(#SubWindow) - 105, WindowHeight(#SubWindow) - 35, 95, 25, "Export")
	
	; Cancel button
	CancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(#SubWindow) - 35, 65, 25, "Cancel")			
	
	ReDim FunctionCheckboxes(0)
	
	ScrollAreaGadget(#PB_Any, 10, 10, 230, 540, 210, 10 + ArraySize(Functions()) * 30, 16, #PB_ScrollArea_Single)
	For s = 0 To ArraySize(Functions()) - 1
		Index = ArraySize(FunctionCheckboxes())
		ReDim FunctionCheckboxes(Index + 1)
		FunctionCheckboxes(Index) \ Gadget = CheckBoxGadget(#PB_Any, 10, 10 + s * 30, 300, 25, Functions(s) \ Name)
		SetGadgetState(FunctionCheckboxes(Index) \ Gadget, #PB_Checkbox_Checked)
		FunctionCheckboxes(Index) \ Function = Functions(s) \ Name
	Next
	CloseGadgetList()
	
	TextGadget(#PB_Any, 250, 15, 190, 25, "Author")
	Author = StringGadget(#PB_Any, 250, 40, 190, 25, "")
	TextGadget(#PB_Any, 250, 75, 190, 25, "Description")
	Description = EditorGadget(#PB_Any, 250, 100, 190, 450)
	
	done = 0
	Repeat
		SetActiveWindow(#SubWindow)
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case CancelButton : done = 1
						
					Case #GeneralOKButton

						FileName.s = SaveFileRequester("Exporting functions...", "", "XML files | *.xml", 0)
						If FileName <> ""
							
							FileName = ReplaceString(FileName, ".xml", "")
							
							saveok = 1
							
							; File exists, overwrite?
							If FileSize(FileName + ".xml") > 0
								If MessageRequester("Message", "File exists. Overwrite?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
									saveok = 1
									DeleteFile(FileName + ".xml")
								Else
									saveok = 0
								EndIf
							EndIf
							
							; Save functions as XML
							If saveok = 1
								
								xml = CreateXML(#PB_Any, #PB_UTF8)
								tululoo_functions_node = CreateXMLNode(RootXMLNode(xml))
								SetXMLNodeName(tululoo_functions_node, "tululoo_functions")
								SetXMLAttribute(tululoo_functions_node, "version", Str(Version))
								SetXMLAttribute(tululoo_functions_node, "author", GetGadgetText(Author))
								SetXMLAttribute(tululoo_functions_node, "description", GetGadgetText(Description))
								
								functions_node = CreateXMLNode(tululoo_functions_node)
								SetXMLNodeName(functions_node, "fns")
								SetXMLAttribute(functions_node, "count", Str(ArraySize(Functions())))
								
								; Function details
								For w = 0 To ArraySize(Functions()) - 1
									
									; Function set as exportable
									For c = 0 To ArraySize(FunctionCheckboxes()) - 1
										If GetGadgetState(FunctionCheckboxes(c) \ Gadget) = #PB_Checkbox_Checked And FunctionCheckboxes(c) \ Function = Functions(w) \ Name
											function_node = CreateXMLNode(functions_node)
											SetXMLNodeName(function_node, "fn")
											SetXMLAttribute(function_node, "name", Functions(w) \ Name)
											SetXMLAttribute(function_node, "params", Functions(w) \ Params)
											SetXMLAttribute(function_node, "description", Functions(w) \ Description)
											SetXMLNodeText(function_node, Functions(w) \ Code)
										EndIf
									Next
									
								Next	
								
								FormatXML(xml, #PB_XML_ReIndent, 4)
								SaveXML(xml, FileName + ".xml")
								FreeXML(xml)
								
								done = 1
							EndIf
						EndIf
				EndSelect
		EndSelect
	Until done = 1
	DisableWindow(#MainWindow, 0)
	CloseWindow(#SubWindow)	
EndProcedure

; Import functions from XML
Procedure ImportFunctions()
	FileName.s = OpenFileRequester("Select functions to import", "", "XML files|*.xml", 0)
	If FileName <> ""
		xml = LoadXML(#PB_Any, FileName)
		tululoo_functions_node = MainXMLNode(xml)
		xml_version = Val(GetXMLAttribute(tululoo_functions_node, "version"))
		author.s = GetXMLAttribute(tululoo_functions_node, "author")
		description.s = GetXMLAttribute(tululoo_functions_node, "description")
		fns_node = ChildXMLNode(tululoo_functions_node, 1)
		
		Num = Val(GetXMLAttribute(fns_node, "count"))
		For w = 0 To Num - 1
			
			Index = ArraySize(Functions())
			ReDim Functions(Index + 1)
			
			function_node = ChildXMLNode(fns_node, w + 1)
			
			TempName.s = GetXMLAttribute(function_node, "name")
			
			; Check existing name
			For c = 0 To ArraySize(Functions()) - 1
				If TempName = Functions(c) \ Name
					TempName = TempName + "_2"
				EndIf
			Next
			
			Functions(Index) \ Name = TempName
			Functions(Index) \ Params = GetXMLAttribute(function_node, "params")
			Functions(Index) \ Description = GetXMLAttribute(function_node, "description")
			Functions(Index) \ Code = GetXMLNodeText(function_node)
		Next
		RefreshItems()
	EndIf
EndProcedure

Procedure FunctionFormStore(s, close)
	
	Functions(s) \ Errors = 0
	
	; Check function name (Missing or exists)
	If GetGadgetText(Functions(s) \ GadgetName) <> ""
		If ScriptNameIsFree(GetGadgetText(Functions(s) \ GadgetName), s) = 0
			MessageRequester("Error", "The function name '" + GetGadgetText(Functions(s) \ GadgetName) + "' already exists")
			Functions(s) \ Errors = Functions(s) \ Errors + 1
		EndIf
	Else
		MessageRequester("Error", "The function name is missing")
		Functions(s) \ Errors = Functions(s) \ Errors + 1
	EndIf
		
	; Form is correct
	If Functions(s) \ Errors = 0
		
		Dirty(1)
		
		Functions(s) \ Name = GetGadgetText(Functions(s) \ GadgetName)
		Functions(s) \ Params = GetGadgetText(Functions(s) \ GadgetParams)
		Functions(s) \ Code = GOSCI_GetText(Functions(s) \ GadgetCode)
		Functions(s) \ Keywords = GetGadgetText(Functions(s) \ GadgetKeywords)
		
		If close = 1
			GOSCI_Free(Functions(s) \ GadgetCode)
			CloseWindow(Functions(s) \ GadgetWindow)
			Functions(s) \ GadgetWindow = 0
		EndIf
		
		RefreshItems()
		
	EndIf
	
EndProcedure

; Display the function form
Procedure FunctionForm(Name.s)
	
	; Search the function by its name
	For s = 0 To ArraySize(Functions()) - 1
		If Functions(s) \ Name = Name
			
			; FORM IS ALREADY OPENED
			If IsWindow(Functions(s) \ GadgetWindow)
				SetActiveWindow(Functions(s) \ GadgetWindow)
				ProcedureReturn
			EndIf
			
			; Form window
			Functions(s) \ GadgetWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Function properties - " + Functions(s) \ Name, #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget, WindowID(#MainWindow))
			;StickyWindow(Functions(s) \ GadgetWindow, 1)
			
			; OK button
			Functions(s) \ GadgetOK = ButtonGadget(#PB_Any, WindowWidth(Functions(s) \ GadgetWindow) - 75, WindowHeight(Functions(s) \ GadgetWindow) - 35, 65, 25, "Done")
			
			; Delete button
			Functions(s) \ GadgetDelete = ButtonGadget(#PB_Any, 10, WindowHeight(Functions(s) \ GadgetWindow) - 35, 65, 25, "Delete")			
			
			; Keywords input
			Functions(s) \ GadgetKeywords = StringGadget(#PB_Any, WindowWidth(Functions(s) \ GadgetWindow) / 2 - 100, WindowHeight(Functions(s) \ GadgetWindow) - 35, 200, 25, Functions(s) \ Keywords)
			
			; Function name
			Functions(s) \ GadgetName = StringGadget(#PB_Any, 10, 10, 120, 25, Functions(s) \ Name)
			
			; Function params
			TextGadget(#PB_Any, 140, 15, 60, 25, "Parameters")
			Functions(s) \ GadgetParams = StringGadget(#PB_Any, 215, 10, 300, 25, Functions(s) \ Params)
			
			; Code editor
			Functions(s) \ GadgetCode = GOSCI_Create(#PB_Any, 10, 45, 780, 510, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
			InitCodeEditor(Functions(s) \ GadgetCode)
			RemoveKeyboardShortcut(Functions(s) \ GadgetWindow, #PB_Shortcut_All)
			GOSCI_SetText(Functions(s) \ GadgetCode, Functions(s) \ Code)			
			
			RefreshItems()
			
			Break
			
		EndIf
	Next
	
EndProcedure

Procedure EditGlobalsStore(close)
	Games(0) \ Globals = GOSCI_GetText(Games(0) \ GadgetGlobalsScintilla)
	Dirty(1)
	If close = 1
		GOSCI_Free(Games(0) \ GadgetGlobalsScintilla)
		CloseWindow(Games(0) \ GadgetGlobalsWindow)
		Games(0) \ GadgetGlobalsWindow = 0
	EndIf
EndProcedure

; Globals editor form
Procedure EditGlobals()
	
	; WINDOW IS ALREADY OPEN
	If IsWindow(Games(0) \ GadgetGlobalsWindow)
		ProcedureReturn
	EndIf
	
	Games(0) \ GadgetGlobalsWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Global variables", #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget, WindowID(#MainWindow))
	;StickyWindow(Games(0) \ GadgetGlobalsWindow, 1)
	
	; Cancel button
	Games(0) \ GadgetGlobalsCancel = ButtonGadget(#PB_Any, 10, WindowHeight(Games(0) \ GadgetGlobalsWindow) - 35, 65, 25, "Cancel")
	
	; OK button
	Games(0) \ GadgetGlobalsOK = ButtonGadget(#PB_Any, WindowWidth(Games(0) \ GadgetGlobalsWindow) - 75, WindowHeight(Games(0) \ GadgetGlobalsWindow) - 35, 65, 25, "OK")
	
	Temp = TextGadget(#PB_Any, 10, 15, 200, 25, "Global variables")
	SetGadgetFont(Temp, FontID(#ItemFont))
	
	; Code editor
	Games(0) \ GadgetGlobalsScintilla = GOSCI_Create(#PB_Any, 10, 45, 780, 540, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
	InitCodeEditor(Games(0) \ GadgetGlobalsScintilla)
	RemoveKeyboardShortcut(Games(0) \ GadgetGlobalsWindow, #PB_Shortcut_All)
	GOSCI_SetText(Games(0) \ GadgetGlobalsScintilla, Games(0) \ Globals)
	
	; Hover text
	Games(0) \ GadgetGlobalsHoverText = TextGadget(#PB_Any, 10, 520, 780, 25, "")
	Games(0) \ GadgetGlobalsHoverDescription = TextGadget(#PB_Any, 10, 550, 780, 25, "")
	SetGadgetFont(Games(0) \ GadgetGlobalsHoverText, FontID(#ItemFont))

	If ScriptEditorX <> -1 And ScriptEditorY <> -1 And ScriptEditorMaximized = -1
		ResizeWindow(Games(0) \ GadgetGlobalsWindow, ScriptEditorX, ScriptEditorY, ScriptEditorWidth, ScriptEditorHeight)
	EndIf
	If ScriptEditorMaximized > -1
		SetWindowState(Games(0) \ GadgetGlobalsWindow, #PB_Window_Maximize)
	EndIf
	
	AddWindowTimer(Games(0) \ GadgetGlobalsWindow, Games(0) \ GlobalsTimer, 100)
	
	EditScript_Resized(Games(0) \ GadgetGlobalsWindow, Games(0) \ GadgetGlobalsScintilla, Games(0) \ GadgetGlobalsOK, Games(0) \ GadgetGlobalsCancel, Games(0) \ GadgetGlobalsHoverText, Games(0) \ GadgetGlobalsHoverDescription)
	
EndProcedure

Procedure EditFunctionsStore(close)
	Dirty(1)
	Games(0) \ Functions = GOSCI_GetText(Games(0) \ GadgetFunctionsScintilla)
	If close = 1
		GOSCI_Free(Games(0) \ GadgetFunctionsScintilla)
		CloseWindow(Games(0) \ GadgetFunctionsWindow)
		Games(0) \ GadgetFunctionsWindow = 0
	EndIf
EndProcedure

; Functions editor form
Procedure EditFunctions()
	
	; WINDOW IS ALREADY OPEN
	If IsWindow(Games(0) \ GadgetFunctionsWindow)
		ProcedureReturn
	EndIf
	
	Games(0) \ GadgetFunctionsWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Not listed custom functions", #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget, WindowID(#MainWindow))
	;StickyWindow(Games(0) \ GadgetFunctionsWindow, 1)
	
	; Cancel button
	Games(0) \ GadgetFunctionsCancel = ButtonGadget(#PB_Any, 10, WindowHeight(Games(0) \ GadgetFunctionsWindow) - 35, 65, 25, "Cancel")
	
	; OK button
	Games(0) \ GadgetFunctionsOK = ButtonGadget(#PB_Any, WindowWidth(Games(0) \ GadgetFunctionsWindow) - 75, WindowHeight(Games(0) \ GadgetFunctionsWindow) - 35, 65, 25, "OK")
	
	Temp = TextGadget(#PB_Any, 10, 15, 200, 25, "Not listed custom functions")
	SetGadgetFont(Temp, FontID(#ItemFont))
	
	; Code editor
	Games(0) \ GadgetFunctionsScintilla = GOSCI_Create(#PB_Any, 10, 45, 780, 540, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
	InitCodeEditor(Games(0) \ GadgetFunctionsScintilla)
	RemoveKeyboardShortcut(Games(0) \ GadgetFunctionsWindow, #PB_Shortcut_All)
	GOSCI_SetText(Games(0) \ GadgetFunctionsScintilla, Games(0) \ Functions)
	
	; Hover text
	Games(0) \ GadgetFunctionsHoverText = TextGadget(#PB_Any, 10, 520, 780, 25, "")
	Games(0) \ GadgetFunctionsHoverDescription = TextGadget(#PB_Any, 10, 550, 780, 25, "")
	SetGadgetFont(Games(0) \ GadgetFunctionsHoverText, FontID(#ItemFont))

	If ScriptEditorX <> -1 And ScriptEditorY <> -1 And ScriptEditorMaximized = -1
		ResizeWindow(Games(0) \ GadgetFunctionsWindow, ScriptEditorX, ScriptEditorY, ScriptEditorWidth, ScriptEditorHeight)
	EndIf
	If ScriptEditorMaximized > -1
		SetWindowState(Games(0) \ GadgetFunctionsWindow, #PB_Window_Maximize)
	EndIf
	
	AddWindowTimer(Games(0) \ GadgetFunctionsWindow, Games(0) \ FunctionsTimer, 100)
	
	EditScript_Resized(Games(0) \ GadgetFunctionsWindow, Games(0) \ GadgetFunctionsScintilla, Games(0) \ GadgetFunctionsOK, Games(0) \ GadgetFunctionsCancel, Games(0) \ GadgetFunctionsHoverText, Games(0) \ GadgetFunctionsHoverDescription)
	
EndProcedure

; Check if a box item has an opened window
Procedure HasWindow(k)
	
	Window = 0
	
	Select Items(k) \ tab
		Case "Sprites"
			For s = 0 To ArraySize(Sprites()) - 1
				If Sprites(s) \ Name = Items(k) \ Name
					If IsWindow(Sprites(s) \ GadgetWindow) : Window = 1 : EndIf
					Break
				EndIf
			Next
			
		Case "Sounds"
			For s = 0 To ArraySize(Sounds()) - 1
				If Sounds(s) \ Name = Items(k) \ Name
					If IsWindow(Sounds(s) \ GadgetWindow) : Window = 1 : EndIf
					Break
				EndIf
			Next

			
		Case "Musics"
			For s = 0 To ArraySize(Musics()) - 1
				If Musics(s) \ Name = Items(k) \ Name
					If IsWindow(Musics(s) \ GadgetWindow) : Window = 1 : EndIf
					Break
				EndIf
			Next
			
		Case "Backgrounds"
			For s = 0 To ArraySize(Backgrounds()) - 1
				If Backgrounds(s) \ Name = Items(k) \ Name
					If IsWindow(Backgrounds(s) \ GadgetWindow) : Window = 1 : EndIf
					Break
				EndIf
			Next
			
		Case "Fonts"
			For s = 0 To ArraySize(Fonts()) - 1
				If Fonts(s) \ Name = Items(k) \ Name
					If IsWindow(Fonts(s) \ GadgetWindow) : Window = 1 : EndIf
					Break
				EndIf
			Next
			
		Case "Objects"
			For s = 0 To ArraySize(Objects()) - 1
				If Objects(s) \ Name = Items(k) \ Name
					If IsWindow(Objects(s) \ GadgetWindow) : Window = 1 : EndIf
					Break
				EndIf
			Next
			
		Case "Scenes"
			For s = 0 To ArraySize(Scenes()) - 1
				If Scenes(s) \ Name = Items(k) \ Name
					If IsWindow(Scenes(s) \ GadgetWindow) : Window = 1 : EndIf
					Break
				EndIf
			Next

			
		Case "Functions"
			For s = 0 To ArraySize(Functions()) - 1
				If Functions(s) \ Name = Items(k) \ Name
					If IsWindow(Functions(s) \ GadgetWindow) : Window = 1 : EndIf
					Break
				EndIf
			Next

	EndSelect
	
	ProcedureReturn Window
	
EndProcedure

; Display the popup menu for the selected item
Procedure ShowMenu(Gadget)
	For k = 0 To ArraySize(Items()) - 1
		Items(k) \ Selected = 0
		If Items(k) \ Gadget = Gadget And Items(k) \ Menu > -1
			Items(k) \ Selected = 1
			If HasWindow(k) = 0
				DisplayPopupMenu(Items(k) \ Menu, WindowID(#MainWindow))
			EndIf
			;Items(k) \ Selected = 1
		EndIf
	Next
EndProcedure

; Return the double clicked gadget
Procedure.s DBClickItem(Gadget)
	
	; Deselect all items
	For k = 0 To ArraySize(Items()) - 1 : Items(k) \ Selected = 0 : Next		
	
	; Find the clicked gagdet
	For k = 0 To ArraySize(Items()) - 1
		If Items(k) \ Gadget = Gadget And Items(k) \ Menu > -1
			
			Items(k) \ Selected = 1			

			Select(Items(k) \ Tab)
					
				Case "Sprites"
					SpriteForm(Items(k) \ Name)
					Break
					
				Case "Sounds"
					SoundForm(Items(k) \ Name)
					Break
					
				Case "Musics"
					MusicForm(Items(k) \ Name)
					Break
					
				Case "Backgrounds"
					BackgroundForm(Items(k) \ Name)
					Break
					
				Case "Fonts"
					FontForm(Items(k) \ Name)
					Break
					
				Case "Objects"
					ObjectForm(Items(k) \ Name)
					Break
					
				Case "Scenes"
					SceneForm(Items(k) \ Name)					
					Break
					
				Case "Functions"
					FunctionForm(Items(k) \ Name)					
					Break
					
			EndSelect
			
		EndIf
	Next
	
EndProcedure

Procedure StoreResources()
	
	For s = 0 To ArraySize(Sprites()) - 1
		If IsWindow(Sprites(s) \ GadgetWindow) : SpriteFormStore(s, 0) : EndIf
	Next
	
	For s = 0 To ArraySize(Sounds()) - 1
		If IsWindow(Sounds(s) \ GadgetWindow) : SoundFormStore(s, 0) : EndIf
	Next
	
	For s = 0 To ArraySize(Musics()) - 1
		If IsWindow(Musics(s) \ GadgetWindow) : MusicFormStore(s, 0) : EndIf
	Next
	
	For s = 0 To ArraySize(Fonts()) - 1
		If IsWindow(Fonts(s) \ GadgetWindow) : FontFormStore(s, 0) : EndIf
	Next
	
	For s = 0 To ArraySize(Backgrounds()) - 1
		If IsWindow(Backgrounds(s) \ GadgetWindow) : BackgroundFormStore(s, 0) : EndIf
	Next
	
	For s = 0 To ArraySize(Functions()) - 1
		If IsWindow(Functions(s) \ GadgetWindow) : FunctionFormStore(s, 0) : EndIf
	Next
	
	For s = 0 To ArraySize(Objects()) - 1
		If IsWindow(Objects(s) \ GadgetWindow) : ObjectFormStore(s, 0) : EndIf
		If IsWindow(Objects(s) \ GadgetCodeWindow) : EditCodeStore(s, 0) : EndIf
	Next
	
	For s = 0 To ArraySize(Scenes()) - 1
		If IsWindow(Scenes(s) \ GadgetWindow) : SceneFormStore(s, 0) : EndIf
		If IsWindow(Scenes(s) \ CodeEditorWindow) : EditSceneCodeStore(s, 0) : EndIf
	Next
	
	If IsWindow(Games(0)  \ GadgetGlobalsWindow) : EditGlobalsStore(0) : EndIf
	If IsWindow(Games(0)  \ GadgetFunctionsWindow) : EditFunctionsStore(0) : EndIf
	If IsWindow(Games(0)  \ GadgetCommentsWindow) : EditGameCommentStore(0) : EndIf
	If IsWindow(Games(0)  \ ExtensionWindow) : ManageExtensionsStore(0) : EndIf
	
EndProcedure

Procedure RunGame()
	
	If ProjectName <> ""
		
		StoreResources()
		Save()
		Export()
		
		FileProtocol.s = ""
		If AddFileProtocol = 1
			FileProtocol.s = "file://"
		EndIf
		
		If FileSize(GetCurrentDirectory() + "Projects/" + ProjectName + "/index.html") > 0
		
			CompilerIf #PB_Compiler_OS = #PB_OS_Windows
				RunProgram(FileProtocol + GetCurrentDirectory() + "Projects/" + ProjectName + "/index.html")
			CompilerEndIf						
			
			CompilerIf #PB_Compiler_OS = #PB_OS_Linux
				RunProgram("x-www-browser", FileProtocol + GetCurrentDirectory() + "Projects/" + ProjectName + "/index.html", "")
			CompilerEndIf
			
			CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
			  RunProgram("open", Chr(34) + FileProtocol + GetCurrentDirectory() + "Projects/" + ProjectName + "/index.html" + Chr(34), "")
			CompilerEndIf
			
		Else
			MessageRequester("Message", "The INDEX.HTML file is missing. You can allow Tululoo to create it (enable it in the Preferences) or you can copy your file in the project folder.")
		EndIf
		
	Else
		MessageRequester("Message", "Please save your game.")
	EndIf
EndProcedure

; *************************************************************************************************************************************************
; SCINTILLA KEYWORDS
; *************************************************************************************************************************************************

LoadKeywords()

; KEYBOARD CONSTANTS

AddKeyword("vk_0", "Cons", "", "")
AddKeyword("vk_1", "Cons", "", "")
AddKeyword("vk_2", "Cons", "", "")
AddKeyword("vk_3", "Cons", "", "")
AddKeyword("vk_4", "Cons", "", "")
AddKeyword("vk_5", "Cons", "", "")
AddKeyword("vk_6", "Cons", "", "")
AddKeyword("vk_7", "Cons", "", "")
AddKeyword("vk_8", "Cons", "", "")
AddKeyword("vk_9", "Cons", "", "")
AddKeyword("vk_a", "Cons", "", "")
AddKeyword("vk_add", "Cons", "", "")
AddKeyword("vk_alt", "Cons", "", "")
AddKeyword("vk_b", "Cons", "", "")
AddKeyword("vk_backspace", "Cons", "", "")
AddKeyword("vk_c", "Cons", "", "")
AddKeyword("vk_ctrl", "Cons", "", "")
AddKeyword("vk_d", "Cons", "", "")
AddKeyword("vk_decimal", "Cons", "", "")
AddKeyword("vk_delete", "Cons", "", "")
AddKeyword("vk_divide", "Cons", "", "")
AddKeyword("vk_down", "Cons", "", "")
AddKeyword("vk_e", "Cons", "", "")
AddKeyword("vk_end", "Cons", "", "")
AddKeyword("vk_enter", "Cons", "", "")
AddKeyword("vk_escape", "Cons", "", "")
AddKeyword("vk_f", "Cons", "", "")
AddKeyword("vk_f1", "Cons", "", "")
AddKeyword("vk_f10", "Cons", "", "")
AddKeyword("vk_f11", "Cons", "", "")
AddKeyword("vk_f12", "Cons", "", "")
AddKeyword("vk_f2", "Cons", "", "")
AddKeyword("vk_f3", "Cons", "", "")
AddKeyword("vk_f4", "Cons", "", "")
AddKeyword("vk_f5", "Cons", "", "")
AddKeyword("vk_f6", "Cons", "", "")
AddKeyword("vk_f7", "Cons", "", "")
AddKeyword("vk_f8", "Cons", "", "")
AddKeyword("vk_f9", "Cons", "", "")
AddKeyword("vk_g", "Cons", "", "")
AddKeyword("vk_h", "Cons", "", "")
AddKeyword("vk_home", "Cons", "", "")
AddKeyword("vk_i", "Cons", "", "")
AddKeyword("vk_insert", "Cons", "", "")
AddKeyword("vk_j", "Cons", "", "")
AddKeyword("vk_k", "Cons", "", "")
AddKeyword("vk_l", "Cons", "", "")
AddKeyword("vk_left", "Cons", "", "")
AddKeyword("vk_m", "Cons", "", "")
AddKeyword("vk_multiply", "Cons", "", "")
AddKeyword("vk_n", "Cons", "", "")
AddKeyword("vk_num0", "Cons", "", "")
AddKeyword("vk_num1", "Cons", "", "")
AddKeyword("vk_num2", "Cons", "", "")
AddKeyword("vk_num3", "Cons", "", "")
AddKeyword("vk_num4", "Cons", "", "")
AddKeyword("vk_num5", "Cons", "", "")
AddKeyword("vk_num6", "Cons", "", "")
AddKeyword("vk_num7", "Cons", "", "")
AddKeyword("vk_num8", "Cons", "", "")
AddKeyword("vk_num9", "Cons", "", "")
AddKeyword("vk_o", "Cons", "", "")
AddKeyword("vk_p", "Cons", "", "")
AddKeyword("vk_pagedown", "Cons", "", "")
AddKeyword("vk_pageup", "Cons", "", "")
AddKeyword("vk_pause", "Cons", "", "")
AddKeyword("vk_q", "Cons", "", "")
AddKeyword("vk_r", "Cons", "", "")
AddKeyword("vk_right", "Cons", "", "")
AddKeyword("vk_s", "Cons", "", "")
AddKeyword("vk_shift", "Cons", "", "")
AddKeyword("vk_space", "Cons", "", "")
AddKeyword("vk_subtract", "Cons", "", "")
AddKeyword("vk_t", "Cons", "", "")
AddKeyword("vk_tab", "Cons", "", "")
AddKeyword("vk_u", "Cons", "", "")
AddKeyword("vk_up", "Cons", "", "")
AddKeyword("vk_v", "Cons", "", "")
AddKeyword("vk_w", "Cons", "", "")
AddKeyword("vk_x", "Cons", "", "")
AddKeyword("vk_y", "Cons", "", "")
AddKeyword("vk_z", "Cons", "", "")

; *************************************************************************************************************************************************
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  SetGadgetFont(#PB_Default, LoadFont(2, "Arial", 11))
CompilerEndIf

LoadFont(#EditorFont, "Consolas", 10)
LoadFont(#TabFont, "Arial", 11)
LoadFont(#ItemFont, "Arial", 11, #PB_Font_Bold | #PB_Font_HighQuality)
LoadFont(#ProjectListFont, "Arial", 16, #PB_Font_Bold | #PB_Font_HighQuality)

CatchImage(#BoxEmpty, ?BoxEmpty)
CatchImage(#BoxInvalid, ?BoxInvalid)
CatchImage(#BoxSound, ?BoxSound)
CatchImage(#BoxMusic, ?BoxMusic)
CatchImage(#BoxFont, ?BoxFont)
CatchImage(#BoxFunction, ?BoxFunction)
CatchImage(#BoxNew, ?BoxNew)
CatchImage(#TransGrid, ?TransGrid)
CatchImage(#NoSprite, ?NoSprite)
CatchImage(#GlobalsButton, ?GlobalsButton)
CatchImage(#CustomFunctions, ?CustomFunctions)
CatchImage(#GameComments, ?GameComments)
CatchImage(#ManageExtensions, ?ManageExtensions)
CatchImage(#AboutScreen, ?AboutScreen)
CreateImage(#NullImage, 100, 100)
CatchImage(#TabHeaderSprites, ?TabHeaderSprites)
CatchImage(#TabHeaderSounds, ?TabHeaderSounds)
CatchImage(#TabHeaderMusics, ?TabHeaderMusics)
CatchImage(#TabHeaderBackgrounds, ?TabHeaderBackgrounds)
CatchImage(#TabHeaderFonts, ?TabHeaderFonts)
CatchImage(#TabHeaderObjects, ?TabHeaderObjects)
CatchImage(#TabHeaderScenes, ?TabHeaderScenes)
CatchImage(#TabHeaderFunctions, ?TabHeaderFunctions)
CatchImage(#IconCreation, ?IconCreation)
CatchImage(#IconCollision, ?IconCollision)
CatchImage(#IconStep, ?IconStep)
CatchImage(#IconDraw, ?IconDraw)
CatchImage(#IconEndStep, ?IconEndStep)
CatchImage(#IconAnimationEnd, ?IconAnimationEnd)
CatchImage(#IconDestroy, ?IconDestroy)
CatchImage(#IconRoomStart, ?IconRoomStart)
CatchImage(#IconRoomEnd, ?IconRoomEnd)
CatchImage(#Processing, ?Processing)
CatchImage(#CollectingExt, ?CollectingExt)
CatchImage(#NewIcon, ?NewIcon)
CatchImage(#ArrowIcon, ?ArrowIcon)
CatchImage(#OpenIcon, ?OpenIcon)
CatchImage(#MergeIcon, ?MergeIcon)
CatchImage(#EraseIcon, ?EraseIcon)
CatchImage(#ZoomInIcon, ?ZoomInIcon)
CatchImage(#ZoomOutIcon, ?ZoomOutIcon)
CatchImage(#ZoomResetIcon, ?ZoomResetIcon)
CatchImage(#PickerIcon, ?PickerIcon)
CatchImage(#LineIcon, ?LineIcon)
CatchImage(#BoxIcon, ?BoxIcon)
CatchImage(#CircleIcon, ?CircleIcon)
CatchImage(#FillIcon, ?FillIcon)
CatchImage(#SaveIcon, ?SaveIcon)
CatchImage(#PlayIcon, ?PlayIcon)
CatchImage(#SpriteIcon, ?SpriteIcon)
CatchImage(#SoundIcon, ?SoundIcon)
CatchImage(#MusicIcon, ?MusicIcon)
CatchImage(#FontIcon, ?FontIcon)
CatchImage(#BackgroundIcon, ?BackgroundIcon)
CatchImage(#ObjectIcon, ?ObjectIcon)
CatchImage(#SceneIcon, ?SceneIcon)
CatchImage(#FunctionIcon, ?FunctionIcon)
CatchImage(#GridIcon, ?GridIcon)
CatchImage(#SnapIcon, ?SnapIcon)
CatchImage(#SaveAsIcon, ?SaveAsIcon)
CatchImage(#PreferencesIcon, ?PreferencesIcon)
CatchImage(#ExitIcon, ?ExitIcon)
CatchImage(#HelpIcon, ?HelpIcon)
CatchImage(#AboutIcon, ?AboutIcon)
CatchImage(#VersionIcon, ?VersionIcon)
CatchImage(#MissingSprite, ?MissingSprite)
CatchImage(#CreateIcon, ?CreateIcon)
CatchImage(#SelectIcon, ?SelectIcon)
CatchImage(#EditIcon, ?EditIcon)
CatchImage(#DeleteIcon, ?DeleteIcon)
CatchImage(#AddIcon, ?AddIcon)
CatchImage(#DuplicateIcon, ?DuplicateIcon)
CatchImage(#MoveLeftIcon, ?MoveLeftIcon)
CatchImage(#MoveRightIcon, ?MoveRightIcon)
CatchImage(#ShiftIcon, ?ShiftIcon)
CatchImage(#MirrorIcon, ?MirrorIcon)
CatchImage(#RotateIcon, ?RotateIcon)
CatchImage(#ScaleIcon, ?ScaleIcon)
CatchImage(#ResizeIcon, ?ResizeIcon)
CatchImage(#StretchIcon, ?StretchIcon)
CatchImage(#GrayscaleIcon, ?GrayScaleIcon)
CatchImage(#SwapRGBIcon, ?SwapRGBIcon)
CatchImage(#ColorizeIcon, ?ColorizeIcon)
CatchImage(#InvertIcon, ?InvertIcon)
CatchImage(#Selector, ?Selector)
CatchImage(#ColorBalanceIcon, ?ColorBalanceIcon)
CatchImage(#EraseColorIcon, ?EraseColorIcon)
CatchImage(#OpacityIcon, ?OpacityIcon)
CatchImage(#BrightnessIcon, ?BrightnessIcon)
CatchImage(#PosterizeIcon, ?PosterizeIcon)
CatchImage(#NoiseIcon, ?NoiseIcon)
CatchImage(#MakeOpaqueIcon, ?MakeOpaqueIcon)
CatchImage(#HueBar, ?HueBar)
CatchImage(#NoProjectImage, ?NoProjectImage)
CatchImage(#SortResetImage, ?SortReset)
CatchImage(#SortAscImage, ?SortAsc)
CatchImage(#SortDescImage, ?SortDesc)
CatchImage(#ColorMatrix, ?ColorMatrix)
CatchImage(#ColorRainbow, ?ColorRainbow)

StartWindow = OpenWindow(#PB_Any, 0, 0, 800, 600, "Please wait...", #PB_Window_ScreenCentered | #PB_Window_BorderLess)
StartDrawing(WindowOutput(StartWindow))
DrawImage(ImageID(#Processing), 0, 0, 800, 600)
StopDrawing()
DefaultJS = DecodeJSEngine()
CloseWindow(StartWindow)
Delay(1000)

OpenWindow(#MainWindow, 0, 0, 800, 600, "Tululoo Game Maker", #PB_Window_ScreenCentered | #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)
SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "Arial Narrow", 10, #PB_Font_HighQuality)))

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
	osxGameButton = 30
CompilerElse
	osxGameButton = 25
CompilerEndIf
  
NewGameButton = ButtonImageGadget(#PB_Any, 10, 10, osxGameButton, osxGameButton, ImageID(#NewIcon)) : GadgetToolTip(NewGameButton, "New game")
OpenGameButton = ButtonImageGadget(#PB_Any, 40, 10, osxGameButton, osxGameButton, ImageID(#OpenIcon)) : GadgetToolTip(OpenGameButton, "Open game")
MergeGameButton = ButtonImageGadget(#PB_Any, 70, 10, osxGameButton, osxGameButton, ImageID(#MergeIcon)) : GadgetToolTip(MergeGameButton, "Merge with an existing game...")
SaveGameButton = ButtonImageGadget(#PB_Any, 100, 10, osxGameButton, osxGameButton, ImageID(#SaveIcon)) : GadgetToolTip(SaveGameButton, "Save game")
RunGameButton = ButtonImageGadget(#PB_Any, 130, 10, 50, osxGameButton, ImageID(#PlayIcon)) : GadgetToolTip(RunGameButton, "Run game")

NewSpriteButton = ButtonImageGadget(#PB_Any, 200, 10, osxGameButton, osxGameButton, ImageID(#SpriteIcon)) : GadgetToolTip(NewSpriteButton, "Add a new sprite")
NewSoundButton = ButtonImageGadget(#PB_Any, 230, 10, osxGameButton, osxGameButton, ImageID(#SoundIcon)) : GadgetToolTip(NewSoundButton, "Add a new sound")
NewMusicButton = ButtonImageGadget(#PB_Any, 260, 10, osxGameButton, osxGameButton, ImageID(#MusicIcon)) : GadgetToolTip(NewMusicButton, "Add a new music")
NewBackgroundButton = ButtonImageGadget(#PB_Any, 290, 10, osxGameButton, osxGameButton, ImageID(#BackgroundIcon)) : GadgetToolTip(NewBackgroundButton, "Add a new background")
NewFontButton = ButtonImageGadget(#PB_Any, 320, 10, osxGameButton, osxGameButton, ImageID(#FontIcon)) : GadgetToolTip(NewFontButton, "Add a new font")
NewObjectButton = ButtonImageGadget(#PB_Any, 350, 10, osxGameButton, osxGameButton, ImageID(#ObjectIcon)) : GadgetToolTip(NewObjectButton, "Add a new object")
NewSceneButton = ButtonImageGadget(#PB_Any, 380, 10, osxGameButton, osxGameButton, ImageID(#SceneIcon)) : GadgetToolTip(NewSceneButton, "Add a new scene")
NewFunctionButton = ButtonImageGadget(#PB_Any, 410, 10, osxGameButton, osxGameButton, ImageID(#FunctionIcon)) : GadgetToolTip(NewFunctionButton, "Add a new function")

ButtonGadget(#MainWindowInfoText, 450, 10, 200, osxGameButton, "STATUS: READY.")
SetGadgetFont(#MainWindowInfoText, FontID(#TabFont))

; ************************
; Main window menu
; ************************

CreateImageMenu(#MainWindowMenu, WindowID(#MainWindow))
MenuTitle("File")
MenuItem(#MainWindowMenuNew, "New" + Chr(9) + "Ctrl + N", ImageID(#NewIcon))
MenuBar()
MenuItem(#MainWindowMenuOpen, "Open..." + Chr(9) + "Ctrl + O", ImageID(#OpenIcon))
MenuBar()
MenuItem(#MainWindowMenuMerge, "Merge with an existing game..." + Chr(9) + "Ctrl + M", ImageID(#MergeIcon))
MenuBar()
MenuItem(#MainWindowMenuSave, "Save" + Chr(9) + "Ctrl + S", ImageID(#SaveIcon))
MenuItem(#MainWindowMenuSaveAs, "Save as...", ImageID(#SaveAsIcon))
MenuBar()
MenuItem(#MainWindowMenuRun, "Run game" + Chr(9) + "F5", ImageID(#PlayIcon))

CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
 MenuBar()
 MenuItem(#MainWindowMenuPreferences, "Preferences...", ImageID(#PreferencesIcon))
 MenuBar()
 MenuItem(#MainWindowMenuExit, "Exit" + Chr(9) + "Ctrl + X", ImageID(#ExitIcon))
CompilerEndIf

MenuTitle("Resources")
MenuItem(#MainWindowMenuAddSprite, "Add new sprite" + Chr(9) + "Ctrl + 1", ImageID(#SpriteIcon))
MenuItem(#MainWindowMenuAddSound, "Add new sound" + Chr(9) + "Ctrl + 2", ImageID(#SoundIcon))
MenuItem(#MainWindowMenuAddMusic, "Add new music" + Chr(9) + "Ctrl + 3", ImageID(#MusicIcon))
MenuItem(#MainWindowMenuAddBackground, "Add new background" + Chr(9) + "Ctrl + 4", ImageID(#BackgroundIcon))
MenuItem(#MainWindowMenuAddFont, "Add new font" + Chr(9) + "Ctrl + 5", ImageID(#FontIcon))
MenuItem(#MainWindowMenuAddObject, "Add new object" + Chr(9) + "Ctrl + 6", ImageID(#ObjectIcon))
MenuItem(#MainWindowMenuAddScene, "Add new scene" + Chr(9) + "Ctrl + 7", ImageID(#SceneIcon))
MenuItem(#MainWindowMenuAddFunction, "Add new function" + Chr(9) + "Ctrl + 8", ImageID(#FunctionIcon))

MenuTitle("Help")
MenuItem(#MainWindowMenuHelp, "Help" + Chr(9) + "F1", ImageID(#HelpIcon))

CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux
 MenuItem(#MainWindowMenuAbout, "About", ImageID(#AboutIcon))
CompilerEndIf  

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
 MenuItem(#PB_Menu_About,"About Tululoo")
 MenuItem(#PB_Menu_Preferences, "")
 MenuItem(#PB_Menu_Quit,"Quit"+Chr(9)+"Cmd+Q")
CompilerEndIf
MenuBar()
MenuItem(#MainWindowMenuVersionCheck, "Check program version...", ImageID(#VersionIcon))

; ************************
; Popup Menus
; ************************

CreatePopupMenu(#PopupMenuGlobals)
MenuItem(#PopupMenuGlobalsEdit, "Edit")

CreatePopupMenu(#PopupMenuFunctions)
MenuItem(#PopupMenuFunctionsEdit, "Edit")

CreatePopupMenu(#PopupMenuSpriteItem)
MenuItem(#PopupMenuSpriteItemEdit, "Edit")
MenuBar()
MenuItem(#PopupMenuSpriteItemDelete, "Delete")

CreatePopupMenu(#PopupMenuBackgroundItem)
MenuItem(#PopupMenuBackgroundItemEdit, "Edit")
MenuBar()
MenuItem(#PopupMenuBackgroundItemDelete, "Delete")

CreatePopupMenu(#PopupMenuFontItem)
MenuItem(#PopupMenuFontItemEdit, "Edit")
MenuBar()
MenuItem(#PopupMenuFontItemDelete, "Delete")

CreatePopupMenu(#PopupMenuObjectItem)
MenuItem(#PopupMenuObjectItemEdit, "Edit")
MenuBar()
MenuItem(#PopupMenuObjectItemDuplicate, "Duplicate")
MenuBar()
MenuItem(#PopupMenuObjectItemDelete, "Delete")

CreatePopupMenu(#PopupMenuSoundItem)
MenuItem(#PopupMenuSoundItemEdit, "Edit")
MenuBar()
MenuItem(#PopupMenuSoundItemDelete, "Delete")

CreatePopupMenu(#PopupMenuMusicItem)
MenuItem(#PopupMenuMusicItemEdit, "Edit")
MenuBar()
MenuItem(#PopupMenuMusicItemDelete, "Delete")

CreatePopupMenu(#PopupMenuSceneItem)
MenuItem(#PopupMenuSceneItemEdit, "Edit")
MenuBar()
MenuItem(#PopupMenuSceneDuplicate, "Duplicate")
MenuBar()
MenuItem(#PopupMenuSceneItemDelete, "Delete")
MenuBar()
MenuItem(#PopupMenuSceneItemMoveBackward, "Move backward")
MenuItem(#PopupMenuSceneItemMoveForward, "Move forward")

CreatePopupMenu(#PopupMenuFunctionItem)
MenuItem(#PopupMenuFunctionItemEdit, "Edit")
MenuBar()
MenuItem(#PopupMenuFunctionItemDelete, "Delete")

CreatePopupMenu(#PopupEventItem)
MenuItem(#PopupEventItemEdit, "Edit")
MenuBar()
MenuItem(#PopupEventItemDelete, "Delete")

CreatePopupMenu(#PopupMenuFrame)
MenuItem(#PopupMenuFrameReplace, "Replace...")
MenuBar()
MenuItem(#PopupMenuFrameDelete, "Delete")

; Add tabs
PanelGadget(#MainPanel, 5, 45, 790, WindowHeight(#MainWindow) - MenuHeight() - 10)
SetGadgetFont(#MainPanel, FontID(#TabFont))

AddGadgetItem(#MainPanel, 0, " Sprites ", ImageID(#SpriteIcon))
ScrollAreaGadget(#SpriteScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
SetGadgetColor(#SpriteScroller, #PB_Gadget_BackColor, RGB(200, 200, 200))
CloseGadgetList()

AddGadgetItem(#MainPanel, 1, " Sounds ", ImageID(#SoundIcon))
ScrollAreaGadget(#SoundScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
SetGadgetColor(#SoundScroller, #PB_Gadget_BackColor, RGB(200, 200, 200))
CloseGadgetList()

AddGadgetItem(#MainPanel, 2, " Musics ", ImageID(#MusicIcon))
ScrollAreaGadget(#MusicScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
SetGadgetColor(#MusicScroller, #PB_Gadget_BackColor, RGB(200, 200, 200))
CloseGadgetList()

AddGadgetItem(#MainPanel, 3, " Backgrounds ", ImageID(#BackgroundIcon))
ScrollAreaGadget(#BackgroundScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
SetGadgetColor(#BackgroundScroller, #PB_Gadget_BackColor, RGB(200, 200, 200))
CloseGadgetList()

AddGadgetItem(#MainPanel, 4, " Fonts ", ImageID(#FontIcon))
ScrollAreaGadget(#FontScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
SetGadgetColor(#FontScroller, #PB_Gadget_BackColor, RGB(200, 200, 200))
CloseGadgetList()

AddGadgetItem(#MainPanel, 5, " Objects ", ImageID(#ObjectIcon))
ScrollAreaGadget(#ObjectScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
SetGadgetColor(#ObjectScroller, #PB_Gadget_BackColor, RGB(200, 200, 200))
CloseGadgetList()

AddGadgetItem(#MainPanel, 6, " Scenes ", ImageID(#SceneIcon))
ScrollAreaGadget(#SceneScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
SetGadgetColor(#SceneScroller, #PB_Gadget_BackColor, RGB(200, 200, 200))
CloseGadgetList()

AddGadgetItem(#MainPanel, 7, " Functions ", ImageID(#FunctionIcon))
ScrollAreaGadget(#FunctionScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
SetGadgetColor(#FunctionScroller, #PB_Gadget_BackColor, RGB(200, 200, 200))
CloseGadgetList()

AddGadgetItem(#MainPanel, 8, " Game ")
ScrollAreaGadget(#GameScroller, 0, 0, GetGadgetAttribute(#MainPanel, #PB_Panel_ItemWidth), GetGadgetAttribute(#MainPanel, #PB_Panel_ItemHeight), 640, 480, 16, #PB_ScrollArea_BorderLess)
ImageGadget(#GlobalsButtonGadget, 10, 10, 275, 38, ImageID(#GlobalsButton))
ImageGadget(#FunctionsButtonGadget, 10, 70, 275, 38, ImageID(#CustomFunctions))
ImageGadget(#GameCommentsButtonGadget, 10, 130, 275, 38, ImageID(#GameComments))
ImageGadget(#ManageExtensionsButtonGadget, 10, 190, 275, 38, ImageID(#ManageExtensions))
CheckBoxGadget(#ScriptModeCheckbox, 20, 250, 200, 30, "Advanced scripting mode")
SetGadgetFont(#ScriptModeCheckbox, FontID(#ItemFont))
SetGadgetState(#ScriptModeCheckbox, Games(0)\ScriptMode)
CloseGadgetList()

CloseGadgetList()

SetWindowState(#MainWindow, #PB_Window_Maximize)

New()

CheckVersionSilent()
GetProjects()
SetCaption()

; WINDOW SHORTCUTS
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_N, #MainWindowMenuNew)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_O, #MainWindowMenuOpen)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_M, #MainWindowMenuMerge)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_S, #MainWindowMenuSave)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_X, #MainWindowMenuExit)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_1, #MainWindowMenuAddSprite)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_2, #MainWindowMenuAddSound)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_3, #MainWindowMenuAddMusic)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_4, #MainWindowMenuAddBackground)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_5, #MainWindowMenuAddFont)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_6, #MainWindowMenuAddObject)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_7, #MainWindowMenuAddScene)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_Control | #PB_Shortcut_8, #MainWindowMenuAddFunction)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_F1, #MainWindowMenuHelp)
AddKeyboardShortcut(#MainWindow, #PB_Shortcut_F5, #MainWindowMenuRun)

Repeat
	Select WaitWindowEvent()
			
		Case #PB_Event_Timer
			Gosub HandleSpritePreviewAnimations
			Gosub HandleShapeEditorCanvas
			Gosub HandleBackgroundTileSettings
			Gosub HandleCodeEditorTimer
			Gosub HandleGlobalsEditorTimer
			Gosub HandleFunctionsEditorTimer
			Gosub HandleSceneTimer

		Case #PB_Event_CloseWindow
			
			WhichWindow = EventWindow()
			; MAIN WINDOW CLOSE
			If WhichWindow = #MainWindow : Exit() : EndIf
			Gosub HandleResourcesCloseWindow
			
		Case #PB_Event_MaximizeWindow
			WhichWindow = EventWindow()
			If WhichWindow = #MainWindow : WindowResized() : EndIf
			Gosub HandleCodeEditorResize
			Gosub HandleGlobalsEditorResize
			Gosub HandleFunctionsEditorResize
			Gosub HandleSceneResize
				
		Case #PB_Event_SizeWindow
			WhichWindow = EventWindow()
			If WhichWindow = #MainWindow : WindowResized() : EndIf
			Gosub HandleCodeEditorResize
			Gosub HandleGlobalsEditorResize
			Gosub HandleFunctionsEditorResize
			Gosub HandleSceneResize
				
		Case #PB_Event_MinimizeWindow
			WhichWindow = EventWindow()
			If WhichWindow = #MainWindow : WindowResized() : EndIf
			Gosub HandleCodeEditorResize
			Gosub HandleGlobalsEditorResize
			Gosub HandleFunctionsEditorResize
			Gosub HandleSceneResize
			
		;Case #PB_Event_SizeWindow
		;	WhichWindow = EventWindow()
		;	If WhichWindow = #MainWindow : WindowResized() : EndIf
		;	Gosub HandleCodeEditorResize
		;	Gosub HandleGlobalsEditorResize
		;	Gosub HandleFunctionsEditorResize
		;	Gosub HandleSceneResize
			
		Case #PB_Event_Gadget
			
			EventGadget = EventGadget()
			
			Select EventGadget
					
				Case #SpriteSearchField, #SoundSearchField, #MusicSearchField, #FontSearchField, #BackgroundSearchField, #ObjectSearchField, #SceneSearchField, #FunctionSearchField
					Select EventType()
						Case #PB_EventType_Change, #PB_EventType_LostFocus
							RefreshItems()
					EndSelect
					
				Case #SpriteSearchCombo
					Select EventType()
						Case #PB_EventType_Change
							SetGadgetText(#SpriteSearchField, GetGadgetText(#SpriteSearchCombo))
							RefreshItems()
					EndSelect
					
				Case #SpriteSortReset
					SortStructuredArray(Sprites(), #PB_Sort_Ascending, OffsetOf(Sprite\UID), #PB_Integer, 0, ArraySize(Sprites()) - 1)
					RefreshItems()
					
				Case #SpriteSortAsc
					SortStructuredArray(Sprites(), #PB_Sort_Ascending, OffsetOf(Sprite\Name), #PB_String, 0, ArraySize(Sprites()) - 1)
					RefreshItems()
					
				Case #SpriteSortDesc
					SortStructuredArray(Sprites(), #PB_Sort_Descending, OffsetOf(Sprite\Name), #PB_String, 0, ArraySize(Sprites()) - 1)
					RefreshItems()
					
				Case #SoundSearchCombo
					Select EventType()
						Case #PB_EventType_Change
							SetGadgetText(#SoundSearchField, GetGadgetText(#SoundSearchCombo))
							RefreshItems()
					EndSelect
					
				Case #SoundSortReset
					SortStructuredArray(Sounds(), #PB_Sort_Ascending, OffsetOf(Sound\UID), #PB_Integer, 0, ArraySize(Sounds()) - 1)
					RefreshItems()
					
				Case #SoundSortAsc
					SortStructuredArray(Sounds(), #PB_Sort_Ascending, OffsetOf(Sound\Name), #PB_String, 0, ArraySize(Sounds()) - 1)
					RefreshItems()
					
				Case #SoundSortDesc
					SortStructuredArray(Sounds(), #PB_Sort_Descending, OffsetOf(Sound\Name), #PB_String, 0, ArraySize(Sounds()) - 1)
					RefreshItems()
					
				Case #MusicSearchCombo
					Select EventType()
						Case #PB_EventType_Change
							SetGadgetText(#MusicSearchField, GetGadgetText(#MusicSearchCombo))
							RefreshItems()
					EndSelect
					
				Case #MusicSortReset
					SortStructuredArray(Musics(), #PB_Sort_Ascending, OffsetOf(Music\UID), #PB_Integer, 0, ArraySize(Musics()) - 1)
					RefreshItems()
					
				Case #MusicSortAsc
					SortStructuredArray(Musics(), #PB_Sort_Ascending, OffsetOf(Music\Name), #PB_String, 0, ArraySize(Musics()) - 1)
					RefreshItems()
					
				Case #MusicSortDesc
					SortStructuredArray(Musics(), #PB_Sort_Descending, OffsetOf(Music\Name), #PB_String, 0, ArraySize(Musics()) - 1)
					RefreshItems()
					
				Case #FontSearchCombo
					Select EventType()
						Case #PB_EventType_Change
							SetGadgetText(#FontSearchField, GetGadgetText(#FontSearchCombo))
							RefreshItems()
					EndSelect
					
				Case #FontSortReset
					SortStructuredArray(Fonts(), #PB_Sort_Ascending, OffsetOf(Font\UID), #PB_Integer, 0, ArraySize(Fonts()) - 1)
					RefreshItems()
					
				Case #FontSortAsc
					SortStructuredArray(Fonts(), #PB_Sort_Ascending, OffsetOf(Font\Name), #PB_String, 0, ArraySize(Fonts()) - 1)
					RefreshItems()
					
				Case #FontSortDesc
					SortStructuredArray(Fonts(), #PB_Sort_Descending, OffsetOf(Font\Name), #PB_String, 0, ArraySize(Fonts()) - 1)
					RefreshItems()
					
				Case #BackgroundSearchCombo
					Select EventType()
						Case #PB_EventType_Change
							SetGadgetText(#BackgroundSearchField, GetGadgetText(#BackgroundSearchCombo))
							RefreshItems()
					EndSelect
					
				Case #BackgroundSortReset
					SortStructuredArray(Backgrounds(), #PB_Sort_Ascending, OffsetOf(Background\UID), #PB_Integer, 0, ArraySize(Backgrounds()) - 1)
					RefreshItems()
					
				Case #BackgroundSortAsc
					SortStructuredArray(Backgrounds(), #PB_Sort_Ascending, OffsetOf(Background\Name), #PB_String, 0, ArraySize(Backgrounds()) - 1)
					RefreshItems()
					
				Case #BackgroundSortDesc
					SortStructuredArray(Backgrounds(), #PB_Sort_Descending, OffsetOf(Background\Name), #PB_String, 0, ArraySize(Backgrounds()) - 1)
					RefreshItems()
					
				Case #ObjectSearchCombo
					Select EventType()
						Case #PB_EventType_Change
							SetGadgetText(#ObjectSearchField, GetGadgetText(#ObjectSearchCombo))
							RefreshItems()
					EndSelect
					
				Case #ObjectSortReset
					SortStructuredArray(Objects(), #PB_Sort_Ascending, OffsetOf(Object\UID), #PB_Integer, 0, ArraySize(Objects()) - 1)
					RefreshItems()
					ObjectsOrder = ""
					
				Case #ObjectSortAsc
					SortStructuredArray(Objects(), #PB_Sort_Ascending, OffsetOf(Object\Name), #PB_String, 0, ArraySize(Objects()) - 1)
					RefreshItems()
					ObjectsOrder = "ASC"
					
				Case #ObjectSortDesc
					SortStructuredArray(Objects(), #PB_Sort_Descending, OffsetOf(Object\Name), #PB_String, 0, ArraySize(Objects()) - 1)
					RefreshItems()
					ObjectsOrder = "DESC"
					
				Case #SceneSearchCombo
					Select EventType()
						Case #PB_EventType_Change
							SetGadgetText(#SceneSearchField, GetGadgetText(#SceneSearchCombo))
							RefreshItems()
					EndSelect
					
				Case #SceneSortReset
					SortStructuredArray(Scenes(), #PB_Sort_Ascending, OffsetOf(Scene\UID), #PB_Integer, 0, ArraySize(Scenes()) - 1)
					RefreshItems()
					
				Case #SceneSortAsc
					SortStructuredArray(Scenes(), #PB_Sort_Ascending, OffsetOf(Scene\Name), #PB_String, 0, ArraySize(Scenes()) - 1)
					RefreshItems()
					
				Case #SceneSortDesc
					SortStructuredArray(Scenes(), #PB_Sort_Descending, OffsetOf(Scene\Name), #PB_String, 0, ArraySize(Scenes()) - 1)
					RefreshItems()
					
				Case #FunctionSearchCombo
					Select EventType()
						Case #PB_EventType_Change
							SetGadgetText(#FunctionSearchField, GetGadgetText(#FunctionSearchCombo))
							RefreshItems()
					EndSelect
					
				Case #FunctionSortReset
					SortStructuredArray(Functions(), #PB_Sort_Ascending, OffsetOf(Function\UID), #PB_Integer, 0, ArraySize(Functions()) - 1)
					RefreshItems()
					
				Case #FunctionSortAsc
					SortStructuredArray(Functions(), #PB_Sort_Ascending, OffsetOf(Function\Name), #PB_String, 0, ArraySize(Functions()) - 1)
					RefreshItems()
					
				Case #FunctionSortDesc
					SortStructuredArray(Functions(), #PB_Sort_Descending, OffsetOf(Function\Name), #PB_String, 0, ArraySize(Functions()) - 1)
					RefreshItems()
					
				Case NewGameButton
					New()
					RefreshItems()
					
				Case OpenGameButton
					Open(0)
					RefreshItems()
					If Games(0) \ GameComment <> ""
						ShowGameComment()
					EndIf
					
				Case MergeGameButton
					Open(1)
					RefreshItems()
					DisplayConflictInfo()
					
				Case SaveGameButton
					Save()
					If ProjectName <> ""
						Export()
					EndIf					
					
				Case #GlobalsButtonGadget
					EditGlobals()
					
				Case #FunctionsButtonGadget
					EditFunctions()
					
				Case #ScriptModeCheckbox
					Games(0)\ScriptMode = GetGadgetState(#ScriptModeCheckbox)
					
				Case #GameCommentsButtonGadget
					EditGameComment()
					
				Case #ManageExtensionsButtonGadget
					ManageExtensions()
					
				Case NewSpriteButton
					SpriteForm(CreateNewSprite())
					
				Case NewSoundButton
					New.s = CreateNewSound()
					If New <> ""
						SoundForm(New)
					EndIf
					
				Case NewMusicButton
					New.s = CreateNewMusic()
					If New <> ""
						MusicForm(New)
					EndIf
					
				Case NewBackgroundButton
					BackgroundForm(CreateNewBackground())
					
				Case NewFontButton
					FontForm(CreateNewFont())
					
				Case NewObjectButton
					ObjectForm(CreateNewObject())
					
				Case NewSceneButton
					SceneForm(CreateNewScene())					
					
				Case NewFunctionButton
					FunctionForm(CreateNewFunction())
					
				Case #ExportFunctionButton
					ExportFunctions()
					
				Case #ImportFunctionButton
					ImportFunctions()
					
				Case #NewSpriteButton
					SpriteForm(CreateNewSprite())
					
				Case #NewSoundButton
					New.s = CreateNewSound()
					If New <> ""
						SoundForm(New)
					EndIf
					
				Case #NewMusicButton
					New.s = CreateNewMusic()
					If New <> ""
						MusicForm(New)
					EndIf
					
				Case #NewBackgroundButton
					BackgroundForm(CreateNewBackground())
					
				Case #NewFontButton
					FontForm(CreateNewFont())
					
				Case #NewObjectButton
					ObjectForm(CreateNewObject())
					
				Case #NewSceneButton
					SceneForm(CreateNewScene())
					
				Case #NewFunctionButton
					FunctionForm(CreateNewFunction())
					
				Case RunGameButton
					RunGame()
					
				Case Games(0) \ GadgetCommentsOK
					EditGameCommentStore(1)
					
			EndSelect
			
			; HANDLE ALL OPENED SPRITE FORMS
			Gosub SpriteFormHandler
			
			; HANDLE ALL OPENED SOUND FORMS
			Gosub SoundFormHandler
			
			; HANDLE ALL OPENED MUSIC FORMS
			Gosub MusicFormHandler
			
			; HANDLE ALL OPENED BACKGROUND FORMS
			Gosub BackgroundFormHandler
			
			; HANDLE ALL OPENED FONT FORMS
			Gosub FontFormHandler
			
			; HANDLE ALL OPENED FUNCTION FORMS
			Gosub FunctionFormHandler
			
			; HANDLE ALL OPENED OBJECT FORMS
			Gosub ObjectFormHandler
			
			; HANDLE ALL OPENED CODE EDITORS
			Gosub HandleCodeEditors
			
			; HANDLE GLOBALS CODE EDITOR
			Gosub HandleGlobalsEditor
			
			; HANDLE EXTENSION EDITOR
			Gosub HandleExtensionEditor
			
			; HANDLE CUSTOMFUNCTIONS CODE EDITOR
			Gosub HandleFunctionsEditor
			
			; HANDLE ALL OPENED SCENE FORMS
			Gosub SceneFormHandler
			
			Select EventType()
					
				Case #PB_EventType_RightClick
					ShowMenu(EventGadget)
					
				Case #PB_EventType_LeftDoubleClick
					DBClickItem(EventGadget)
					
			EndSelect
			
		Case #PB_Event_Menu
			Select EventMenu()
					
				Case #PopupEventItemEdit
					For s = 0 To ArraySize(Objects()) - 1
						If IsWindow(Objects(s) \ GadgetWindow) And EventWindow() = Objects(s) \ GadgetWindow
							EditCode(s, GetGadgetItemData(Objects(s) \ GadgetEventList, GetGadgetState(Objects(s) \ GadgetEventList)))
							RefreshEventList(s)
						EndIf
					Next
					
				Case #PopupEventItemDelete
					For s = 0 To ArraySize(Objects()) - 1
						If IsWindow(Objects(s) \ GadgetWindow) And EventWindow() = Objects(s) \ GadgetWindow
					
							If Confirm("Confirm", "Delete this event?") = 1
								del = GetGadgetItemData(Objects(s) \ GadgetEventList, GetGadgetState(Objects(s) \ GadgetEventList))
								Dim Temp.Script(ArraySize(Scripts()))
								sn = 0
								For m = 0 To ArraySize(Scripts()) - 1
									If m <> del
										Temp(sn) \ Code = Scripts(m) \ Code
										Temp(sn) \ Name = Scripts(m) \ Name
										Temp(sn) \ Parameter = Scripts(m) \ Parameter
										Temp(sn) \ Parent = Scripts(m) \ Parent
										Temp(sn) \ Type = Scripts(m) \ Type
										sn = sn + 1
									EndIf
								Next
								
								ReDim Scripts(sn)
								CopyArray(Temp(), Scripts())
								
								RefreshEventList(s)
								RefreshCodePreview(s)
								
							EndIf
					
						EndIf
					Next
					
				Case #MainWindowMenuNew
					New()
					RefreshItems()
					
				Case #MainWindowMenuOpen
					Open(0)
					RefreshItems()
					If Games(0) \ GameComment <> ""
						ShowGameComment()
					EndIf
					
				Case #MainWindowMenuMerge
					Open(1)
					RefreshItems()
					DisplayConflictInfo()
					
				Case #MainWindowMenuSave
					Save()
					If ProjectName <> ""
						Export()
					EndIf
					
				Case #MainWindowMenuSaveAs
					SaveAs()
					If ProjectName <> ""
						Export()
					EndIf
					
			CompilerIf #PB_Compiler_OS = #PB_OS_Windows Or #PB_Compiler_OS = #PB_OS_Linux	
				  
				Case #MainWindowMenuPreferences
				  PreferencesForm()
				  
				Case #MainWindowMenuExit
				  Exit()
				  
				Case #MainWindowMenuAbout
				  About()
				  
				Case #MainWindowMenuHelp
				  OpenHelp("tululoo.chm", "")
			CompilerEndIf		
					
			CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
				Case #PB_Menu_Preferences
				  PreferencesForm()
				  
				Case #PB_Menu_Quit
				  Exit()
				  
				Case #PB_Menu_About
				  About()
				  
				Case #MainWindowMenuHelp
					RunProgram("open", Chr(34) + GetCurrentDirectory() + "Tululoo Help.app" + Chr(34), "")
					
			CompilerEndIf
					
				Case #MainWindowMenuRun
					RunGame()
					
				Case #MainWindowMenuAddSprite
					SpriteForm(CreateNewSprite())
					
				Case #MainWindowMenuAddSound
					New.s = CreateNewSound()
					If New <> ""
						SoundForm(New)
					EndIf
					
				Case #MainWindowMenuAddMusic
					New.s = CreateNewMusic()
					If New <> ""
						MusicForm(New)
					EndIf
					
				Case #MainWindowMenuAddBackground
					BackgroundForm(CreateNewBackground())
					
				Case #MainWindowMenuAddFont
					FontForm(CreateNewFont())
					
				Case #MainWindowMenuAddObject
					ObjectForm(CreateNewObject())
					
				Case #MainWindowMenuAddScene
					SceneForm(CreateNewScene())					
					
				Case #MainWindowMenuAddFunction
					FunctionForm(CreateNewFunction())
					
				Case #MainWindowMenuVersionCheck
					CheckVersion()
					
				Case #PopupMenuGlobalsEdit
					EditGlobals()
					
				Case #PopupMenuFunctionsEdit
					EditFunctions()
					
				Case #PopupMenuSpriteItemEdit
					SpriteForm(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuSpriteItemDelete
					If Confirm("Confirm", "Do you really want to delete this sprite?") = 1
						DeleteSprite(Items(SelectedItem()) \ Name)
						RefreshItems()
					EndIf
					
				Case #PopupMenuBackgroundItemEdit
					BackgroundForm(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuBackgroundItemDelete
					If Confirm("Confirm", "Do you really want to delete this background?") = 1
						DeleteBackground(Items(SelectedItem()) \ Name)
						RefreshItems()
					EndIf
					
				Case #PopupMenuFontItemEdit
					FontForm(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuFontItemDelete
					If Confirm("Confirm", "Do you really want to delete this font?") = 1
						DeleteFont(Items(SelectedItem()) \ Name)
						RefreshItems()
					EndIf
					
				Case #PopupMenuObjectItemEdit
					ObjectForm(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuObjectItemDuplicate
					DuplicateObject(Items(SelectedItem()) \ Name)
					RefreshItems()
					
				Case #PopupMenuObjectItemDelete
					If Confirm("Confirm", "Do you really want to delete this object?") = 1
						DeleteObject(Items(SelectedItem()) \ Name)
						RefreshItems()
					EndIf
					
				Case #PopupMenuSoundItemEdit
					SoundForm(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuSoundItemDelete
					If Confirm("Confirm", "Do you really want to delete this sound?") = 1
						DeleteSound(Items(SelectedItem()) \ Name)
						RefreshItems()
					EndIf
					
				Case #PopupMenuMusicItemEdit
					MusicForm(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuMusicItemDelete
					If Confirm("Confirm", "Do you really want to delete this music?") = 1
						DeleteMusic(Items(SelectedItem()) \ Name)
						RefreshItems()
					EndIf
					
				Case #PopupMenuSceneItemEdit
					SceneForm(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuSceneItemDelete
					If Confirm("Confirm", "Do you really want to delete this scene?") = 1
						DeleteScene(Items(SelectedItem()) \ Name)
						RefreshItems()
					EndIf
					
				Case #PopupMenuSceneItemMoveBackward
					SceneMoveBackward(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuSceneItemMoveForward
					SceneMoveForward(Items(SelectedItem()) \ Name)
					
				Case #PopupMenuSceneDuplicate
					DuplicateScene(Items(SelectedItem()) \ Name)
					RefreshItems()
					
				Case #PopupMenuFunctionItemEdit
					FunctionForm(Items(SelectedItem()) \ Name)					
					
				Case #PopupMenuFunctionItemDelete
					If Confirm("Confirm", "Do you really want to delete this function?") = 1
						DeleteScript(Items(SelectedItem()) \ Name)
						RefreshItems()
					EndIf					
					
			EndSelect			
			
	EndSelect
ForEver

DataSection
	BoxEmpty: : IncludeBinary "box_empty.png"
	BoxInvalid: : IncludeBinary "box_invalid.png"
	BoxSound: : IncludeBinary "box_sound.png"
	BoxMusic: : IncludeBinary "box_music.png"
	BoxFont: : IncludeBinary "box_font.png"
	BoxFunction: : IncludeBinary "box_function.png"
	BoxNew: : IncludeBinary "box_new.png"	
	TransGrid: : IncludeBinary "transgrid.png"
	NoSprite: : IncludeBinary "no_sprite.png"
	GlobalsButton: : IncludeBinary "globals_button.png"
	CustomFunctions: : IncludeBinary "custom_functions.png"
	GameComments: : IncludeBinary "game_comments.png"
	ManageExtensions: : IncludeBinary "manage_extensions.png"
	AboutScreen: : IncludeBinary "aboutscreen.png"
	TabHeaderSprites: : IncludeBinary "tab_header_sprites.png"
	TabHeaderSounds: : IncludeBinary "tab_header_sounds.png"
	TabHeaderMusics: : IncludeBinary "tab_header_musics.png"
	TabHeaderBackgrounds: : IncludeBinary "tab_header_backgrounds.png"
	TabHeaderFonts: : IncludeBinary "tab_header_fonts.png"
	TabHeaderObjects: : IncludeBinary "tab_header_objects.png"
	TabHeaderScenes: : IncludeBinary "tab_header_scenes.png"
	TabHeaderFunctions: : IncludeBinary "tab_header_functions.png"
	IconCreation: : IncludeBinary "icon_creation.png"
	IconCollision: : IncludeBinary "icon_collision.png"
	IconStep: : IncludeBinary "icon_step.png"
	IconDraw: : IncludeBinary "icon_draw.png"
	IconEndStep: : IncludeBinary "icon_end_step.png"
	IconAnimationEnd: : IncludeBinary "icon_animationend.png"
	IconDestroy: : IncludeBinary "icon_destroy.png"
	IconRoomStart: : IncludeBinary "icon_roomstart.png"
	IconRoomEnd: : IncludeBinary "icon_roomend.png"
	Processing: : IncludeBinary "processing.png"
	CollectingExt: : IncludeBinary "collecting_extensions.png"
	NewIcon: : IncludeBinary "new_icon.png"
	ArrowIcon: : IncludeBinary "arrow_icon.png"
	OpenIcon: : IncludeBinary "open_icon.png"
	MergeIcon: : IncludeBinary "merge_icon.png"
	EraseIcon: : IncludeBinary "eraser_icon.png"
	PickerIcon: : IncludeBinary "picker_icon.png"
	LineIcon: : IncludeBinary "line_icon.png"
	BoxIcon: : IncludeBinary "box_icon.png"
	CircleIcon: : IncludeBinary "circle_icon.png"
	FillIcon: : IncludeBinary "fill_icon.png"
	ZoomInIcon: : IncludeBinary "zoom_in.png"
	ZoomOutIcon: : IncludeBinary "zoom_out.png"
	ZoomResetIcon: : IncludeBinary "zoom_reset.png"
	SaveIcon: : IncludeBinary "save_icon.png"
	PlayIcon: : IncludeBinary "play_icon.png"
	SpriteIcon: : IncludeBinary "sprite_icon.png"
	SoundIcon: : IncludeBinary "sound_icon.png"
	MusicIcon: : IncludeBinary "music_icon.png"
	FontIcon: : IncludeBinary "font_icon.png"
	BackgroundIcon: : IncludeBinary "background_icon.png"
	ObjectIcon: : IncludeBinary "object_icon.png"
	SceneIcon: : IncludeBinary "scene_icon.png"
	FunctionIcon: : IncludeBinary "script_icon.png"
	GridIcon: : IncludeBinary "grid_icon.png"
	SnapIcon: : IncludeBinary "snap_icon.png"
	SaveAsIcon: : IncludeBinary "saveas_icon.png"
	PreferencesIcon: : IncludeBinary "preferences_icon.png"
	ExitIcon: : IncludeBinary "exit_icon.png"
	HelpIcon: : IncludeBinary "help_icon.png"
	AboutIcon: : IncludeBinary "about_icon.png"
	VersionIcon: : IncludeBinary "version_icon.png"
	MissingSprite: : IncludeBinary "missing_sprite.png"
	CreateIcon: : IncludeBinary "create_icon.png"
	SelectIcon: : IncludeBinary "select_icon.png"
	EditIcon: : IncludeBinary "edit_icon.png"
	DeleteIcon: : IncludeBinary "delete_icon.png"
	AddIcon: : IncludeBinary "add_icon.png"
	DuplicateIcon: : IncludeBinary "duplicate_icon.png"
	MoveLeftIcon: : IncludeBinary "left_icon.png"
	MoveRightIcon: : IncludeBinary "right_icon.png"
	ShiftIcon: : IncludeBinary "shift_icon.png"
	MirrorIcon: : IncludeBinary "mirror_icon.png"
	RotateIcon: : IncludeBinary "rotate_icon.png"
	ScaleIcon: : IncludeBinary "scale_icon.png"
	ResizeIcon: : IncludeBinary "resize_icon.png"
	StretchIcon: : IncludeBinary "stretch_icon.png"
	GrayScaleIcon: : IncludeBinary "grayscale_icon.png"
	SwapRGBIcon: : IncludeBinary "swaprgb_icon.png"
	ColorizeIcon: : IncludeBinary "colorize_icon.png"
	InvertIcon: : IncludeBinary "invert_icon.png"
	Selector: : IncludeBinary "selector.png"
	ColorBalanceIcon: : IncludeBinary "colorbalance_icon.png"
	EraseColorIcon: : IncludeBinary "erasecolor_icon.png"
	OpacityIcon: : IncludeBinary "opacity_icon.png"
	BrightnessIcon: : IncludeBinary "brightness_icon.png"
	PosterizeIcon: : IncludeBinary "posterize_icon.png"
	NoiseIcon: : IncludeBinary "noise_icon.png"
	MakeOpaqueIcon: : IncludeBinary "makeopaque_icon.png"
	HueBar: : IncludeBinary "hue.png"
	NoProjectImage: : IncludeBinary "projectnoimage.png"
	SortReset: : IncludeBinary "sortreset.png"
	SortAsc: : IncludeBinary "sortasc.png"
	SortDesc: : IncludeBinary "sortdesc.png"
	ColorMatrix: : IncludeBinary "colorpicker1.png"
	ColorRainbow: : IncludeBinary "colorpicker2.png"
EndDataSection

SpriteFormHandler:

	For s = 0 To ArraySize(Sprites()) - 1
		If IsWindow(Sprites(s) \ GadgetWindow)
			
			Select EventGadget
					
				; SAVE AS PNG
				Case Sprites(s) \ GadgetSaveStrip
					FrameSavePNG(Sprites(s) \ GadgetWindow, Sprites(s) \ Name, 0)
					
				; EDIT FRAMES
				Case Sprites(s) \ GadgetEditStrip
					EditFrames(Sprites(s) \ Name)
					
				; SHOW COLLISION SHAPE CHECKBOX
				Case Sprites(s) \ GadgetShowCollisionShape
					Sprites(s) \ ShowCollisionShape = GetGadgetState(Sprites(s) \ GadgetShowCollisionShape)
					
				; PREVIEW ZOOM
				Case Sprites(s) \ GadgetZoomTrackbar
					Sprites(s) \ Zoom = GetGadgetState(Sprites(s) \ GadgetZoomTrackbar)
					
				; Center X
				Case Sprites(s) \ GadgetCenterX
					Select EventType()
						Case #PB_EventType_Change
							If Val(GetGadgetText(Sprites(s) \ GadgetCenterX)) <= Sprites(s) \ ThisWidth
								Sprites(s) \ CenterX = Val(GetGadgetText(Sprites(s) \ GadgetCenterX))
							EndIf
					EndSelect
					
				; Center Y
				Case Sprites(s) \ GadgetCenterY
					Select EventType()
						Case #PB_EventType_Change
							If Val(GetGadgetText(Sprites(s) \ GadgetCenterY)) <= Sprites(s) \ ThisHeight
								Sprites(s) \ CenterY = Val(GetGadgetText(Sprites(s) \ GadgetCenterY))
							EndIf
					EndSelect
					
				; Center button
				Case Sprites(s) \ GadgetCenter
					If Sprites(s) \ ThisWidth > 0 And Sprites(s) \ ThisHeight > 0
						SetGadgetText(Sprites(s) \ GadgetCenterX, Str(Round(Sprites(s) \ ThisWidth / 2, #PB_Round_Down)))
						SetGadgetText(Sprites(s) \ GadgetCenterY, Str(Round(Sprites(s) \ ThisHeight / 2, #PB_Round_Down)))
						Sprites(s) \ CenterX = Val(GetGadgetText(Sprites(s) \ GadgetCenterX))
						Sprites(s) \ CenterY = Val(GetGadgetText(Sprites(s) \ GadgetCenterY))
					EndIf
					
				; Collision shape
				Case Sprites(s) \ GadgetCollisionShape
					Select EventType()
						Case #PB_EventType_Change
							Sprites(s) \ CollisionShape = GetGadgetText(Sprites(s) \ GadgetCollisionShape)
					EndSelect
					
				; Collision radius
				Case Sprites(s) \ GadgetCollisionRadius
					Select EventType()
						Case #PB_EventType_Change
							Sprites(s) \ CollisionRadius = Val(GetGadgetText(Sprites(s) \ GadgetCollisionRadius))
					EndSelect
					
				; Collision left
				Case Sprites(s) \ GadgetCollisionLeft
					Select EventType()
						Case #PB_EventType_Change
							Sprites(s) \ CollisionLeft = Val(GetGadgetText(Sprites(s) \ GadgetCollisionLeft))
					EndSelect
					
				; Collision right
				Case Sprites(s) \ GadgetCollisionRight
					Select EventType()
						Case #PB_EventType_Change
							Sprites(s) \ CollisionRight = Val(GetGadgetText(Sprites(s) \ GadgetCollisionRight))
					EndSelect
					
				; Collision top
				Case Sprites(s) \ GadgetCollisionTop
					Select EventType()
						Case #PB_EventType_Change
							Sprites(s) \ CollisionTop = Val(GetGadgetText(Sprites(s) \ GadgetCollisionTop))
					EndSelect
					
				; Collision bottom
				Case Sprites(s) \ GadgetCollisionBottom
					Select EventType()
						Case #PB_EventType_Change
							Sprites(s) \ CollisionBottom = Val(GetGadgetText(Sprites(s) \ GadgetCollisionBottom))
					EndSelect
					
				; Anim Speed input
				Case Sprites(s) \ GadgetAnimSpeed
					Select EventType()
						Case #PB_EventType_Change
							If Val(GetGadgetText(Sprites(s) \ GadgetAnimSpeed)) > 0
								RemoveWindowTimer(Sprites(s) \ GadgetWindow, Sprites(s) \ Timer)
								Sprites(s) \ AnimSpeed = Val(GetGadgetText(Sprites(s) \ GadgetAnimSpeed))
								Sprites(s) \ Timer = UID()
								AddWindowTimer(Sprites(s) \ GadgetWindow, Sprites(s) \ Timer, Round(1000 / Sprites(s) \ AnimSpeed , #PB_Round_Down))
							EndIf
					EndSelect
					
				; Get center by clicking on the canvas
				Case Sprites(s) \ GadgetSpritePreview
					Select EventType()
						Case #PB_EventType_LeftButtonDown
							Sprites(s) \ ShapeEditorCanvasDown = 1
							Sprites(s) \ CenterX = GetGadgetAttribute(Sprites(s) \ GadgetSpritePreview, #PB_Canvas_MouseX) / Sprites(s) \ Zoom
							Sprites(s) \ CenterY = GetGadgetAttribute(Sprites(s) \ GadgetSpritePreview, #PB_Canvas_MouseY) / Sprites(s) \ Zoom
							SetGadgetText(Sprites(s) \ GadgetCenterX, Str(Sprites(s) \ CenterX))
							SetGadgetText(Sprites(s) \ GadgetCenterY, Str(Sprites(s) \ CenterY))
							
						Case #PB_EventType_MouseMove
							If Sprites(s) \ ShapeEditorCanvasDown = 1
								Sprites(s) \ CenterX = GetGadgetAttribute(Sprites(s) \ GadgetSpritePreview, #PB_Canvas_MouseX) / Sprites(s) \ Zoom
								Sprites(s) \ CenterY = GetGadgetAttribute(Sprites(s) \ GadgetSpritePreview, #PB_Canvas_MouseY) / Sprites(s) \ Zoom
								SetGadgetText(Sprites(s) \ GadgetCenterX, Str(Sprites(s) \ CenterX))
								SetGadgetText(Sprites(s) \ GadgetCenterY, Str(Sprites(s) \ CenterY))
							EndIf
						Case #PB_EventType_LeftButtonUp
							Sprites(s) \ ShapeEditorCanvasDown = 0
					EndSelect
				
					
				; Delete sprite
				Case Sprites(s) \ GadgetDelete
					If Confirm("Confirm", "Do you really want to delete this sprite?") = 1
						Dirty(1)
						CloseWindow(Sprites(s) \ GadgetWindow)
						Sprites(s) \ GadgetWindow = 0
						DeleteSprite(Sprites(s) \ Name)
						RefreshItems()
						
						; UPDATE OBJECT SPRITE PREVIEW
						For r = 0 To ArraySize(Objects()) - 1
							RefreshObjectSprite(r)
						Next
						
					EndIf
					
				; Apply form changes
				Case Sprites(s) \ GadgetOK
					SpriteFormStore(s, 1)
					
				Case Sprites(s) \ GadgetImportStrip
					ImportSpriteStrip(s)
					SetGadgetText(Sprites(s) \ GadgetCollisionRadius, Str(Sprites(s) \ CollisionRadius))
					SetGadgetText(Sprites(s) \ GadgetCollisionLeft, Str(Sprites(s) \ CollisionLeft))
					SetGadgetText(Sprites(s) \ GadgetCollisionRight, Str(Sprites(s) \ CollisionRight))
					SetGadgetText(Sprites(s) \ GadgetCollisionTop, Str(Sprites(s) \ CollisionTop))
					SetGadgetText(Sprites(s) \ GadgetCollisionBottom, Str(Sprites(s) \ CollisionBottom))
					
				; Edit collision shape
				Case Sprites(s) \ GadgetCollectionShapeEdit
					If IsImage(Sprites(s) \ Preview)
						EditCollisionShape(s)
					Else
						MessageRequester("Message", "Please add a sprite image.")
					EndIf
					
				; Close shape editor
				Case Sprites(s) \ GadgetShapeOK
					CloseWindow(Sprites(s) \ GadgetShapeWindow)
					DisableWindow(Sprites(s) \ GadgetWindow, 0)
					
				; Frame next
				Case Sprites(s) \ GadgetShapeNextFrame
					Sprites(s) \ ShapeEditorCurrentFrame = Sprites(s) \ ShapeEditorCurrentFrame + 1
					If Sprites(s) \ ShapeEditorCurrentFrame > Sprites(s) \ MaxFrames - 1
						Sprites(s) \ ShapeEditorCurrentFrame = Sprites(s) \ MaxFrames - 1
					EndIf
					
				; Frame previous
				Case Sprites(s) \ GadgetShapePrevFrame
					Sprites(s) \ ShapeEditorCurrentFrame = Sprites(s) \ ShapeEditorCurrentFrame - 1
					If Sprites(s) \ ShapeEditorCurrentFrame < 0
						Sprites(s) \ ShapeEditorCurrentFrame = 0
					EndIf
					
				; Shape editor zoom
				Case Sprites(s) \ GadgetShapeZoom
					Sprites(s) \ ShapeEditorZoom = GetGadgetState(Sprites(s) \ GadgetShapeZoom)
					
				; Shape editor snap to grid width/height
				Case Sprites(s) \ GadgetShapeGridWidth, Sprites(s) \ GadgetShapeGridHeight
					Select EventType()
						Case #PB_EventType_Change, #PB_EventType_LostFocus
							Sprites(s) \ ShapeEditorGridWidth = Val(GetGadgetText(Sprites(s) \ GadgetShapeGridWidth))
							Sprites(s) \ ShapeEditorGridHeight = Val(GetGadgetText(Sprites(s) \ GadgetShapeGridHeight))
					EndSelect
					
				; Shape editor snap to grid / show grid
				Case Sprites(s) \ GadgetShapeSnapToGrid
					Sprites(s) \ ShapeEditorSnapToGrid = GetGadgetState(Sprites(s) \ GadgetShapeSnapToGrid)
					
				; Shape editor point list
				Case Sprites(s) \ GadgetShapePointList
					If GetGadgetText(Sprites(s) \ GadgetShapePointList) <> ""
						Sprites(s) \ ShapeEditorPickedPointLocal = GetGadgetState(Sprites(s) \ GadgetShapePointList)
						sn = 0
						For p = 0 To ArraySize(CollisionPoints()) - 1
							If CollisionPoints(p) \ Sprite = Sprites(s) \ Name
								If sn = GetGadgetState(Sprites(s) \ GadgetShapePointList)
									Sprites(s)  \ ShapeEditorPickedPointGlobal = p
								EndIf
								sn = sn + 1
							EndIf
						Next
					EndIf
					
				; Shape editor delete point
				Case Sprites(s) \ GadgetShapePointDelete
					If GetGadgetState(Sprites(s) \ GadgetShapePointList) > -1
						sn = 0
						For p = 0 To ArraySize(CollisionPoints()) - 1
							If CollisionPoints(p) \ Sprite = Sprites(s) \ Name
								If sn = GetGadgetState(Sprites(s) \ GadgetShapePointList)
									Sprites(s)  \ ShapeEditorPickedPointGlobal = p
								EndIf
								sn = sn + 1
							EndIf
						Next
						If Sprites(s)  \ ShapeEditorPickedPointGlobal > -1
							Dim TempCollisionPoints.CollisionPoint(ArraySize(CollisionPoints()))
							For p = 0 To ArraySize(CollisionPoints()) - 1
								If p <> Sprites(s)  \ ShapeEditorPickedPointGlobal
									index = ArraySize(TempCollisionPoints())
									TempCollisionPoints(index) = CollisionPoints(p)
									ReDim TempCollisionPoints(index + 1)
								EndIf
							Next
							CopyArray(TempCollisionPoints(), CollisionPoints())
							FreeArray(TempCollisionPoints())
						EndIf
						; Refresh the point list
						ClearGadgetItems(Sprites(s) \ GadgetShapePointList)
						For p = 0 To ArraySize(CollisionPoints()) - 1
							If CollisionPoints(p) \ Sprite = Sprites(s) \ Name
								AddGadgetItem(Sprites(s) \ GadgetShapePointList, -1, "(" + Str(CollisionPoints(p) \ X) + "," + Str(CollisionPoints(p) \ Y) + ")")
							EndIf
							Sprites(s) \ ShapeEditorPickedPointLocal = -1
							Sprites(s)  \ ShapeEditorPickedPointGlobal = -1
						Next
						
					EndIf
					
				; Shape editor canvas click
				Case Sprites(s) \ GadgetShapeCanvas
				
					Mouse_X = GetGadgetAttribute(Sprites(s) \ GadgetShapeCanvas, #PB_Canvas_MouseX)
					Mouse_Y = GetGadgetAttribute(Sprites(s) \ GadgetShapeCanvas, #PB_Canvas_MouseY)
					
					MX = Mouse_X
					MY = Mouse_Y
					If Sprites(s) \ ShapeEditorSnapToGrid = 1
						MX = Sprites(s) \ ShapeEditorGridWidth * Round(Mouse_X / Sprites(s) \ ShapeEditorGridWidth, #PB_Round_Down) 
						MY = Sprites(s) \ ShapeEditorGridHeight * Round(Mouse_Y / Sprites(s) \ ShapeEditorGridHeight, #PB_Round_Down) 
					EndIf
					
					Select EventType()
							
						Case #PB_EventType_LeftButtonDown
							
							Sprites(s) \ ShapeEditorCanvasDown = 1
							
							; Detect empty or point
							Sprites(s) \ ShapeEditorPickedPointLocal = -1
							Sprites(s) \ ShapeEditorPickedPointGlobal = -1
							
							plc = 0 ; point list item counter
							For p = 0 To ArraySize(CollisionPoints()) - 1
								If CollisionPoints(p) \ Sprite = Sprites(s) \ Name
									CX1 = Sprites(s) \ ShapeEditorZoom * CollisionPoints(p) \ X - 6
									CY1 = Sprites(s) \ ShapeEditorZoom * CollisionPoints(p) \ Y - 6
									CX2 = Sprites(s) \ ShapeEditorZoom * CollisionPoints(p) \ X + 6
									CY2 = Sprites(s) \ ShapeEditorZoom * CollisionPoints(p) \ Y + 6
									If Mouse_X > CX1 And Mouse_X < CX2 And Mouse_Y > CY1 And Mouse_Y < CY2
										Sprites(s) \ ShapeEditorPickedPointLocal = plc
										Sprites(s) \ ShapeEditorPickedPointGlobal = p
										SetGadgetState(Sprites(s) \ GadgetShapePointList, plc)
									EndIf
									plc = plc + 1
								EndIf
							Next

							; No points picked, create
							If Sprites(s) \ ShapeEditorPickedPointGlobal = -1
								Index = ArraySize(CollisionPoints())
								CollisionPoints(Index) \ Sprite = Sprites(s) \ Name
								CollisionPoints(Index) \ X = MX / Sprites(s) \ ShapeEditorZoom
								CollisionPoints(Index) \ Y = MY / Sprites(s) \ ShapeEditorZoom
								Sprites(s) \ ShapeEditorPickedPointGlobal = Index
								ReDim CollisionPoints(Index + 1)
							EndIf
							
						Case #PB_EventType_MouseMove
							If Sprites(s) \ ShapeEditorCanvasDown = 1
								If Sprites(s) \ ShapeEditorPickedPointGlobal > -1
									; Move the picked point
									CollisionPoints(Sprites(s) \ ShapeEditorPickedPointGlobal) \ X = MX / Sprites(s) \ ShapeEditorZoom
									CollisionPoints(Sprites(s) \ ShapeEditorPickedPointGlobal) \ Y = MY / Sprites(s) \ ShapeEditorZoom
								EndIf
							EndIf
							
						Case #PB_EventType_LeftButtonUp
							Sprites(s) \ ShapeEditorCanvasDown = 0
							
							; Refresh the point list
							ClearGadgetItems(Sprites(s) \ GadgetShapePointList)
							For p = 0 To ArraySize(CollisionPoints()) - 1
								If CollisionPoints(p) \ Sprite = Sprites(s) \ Name
									AddGadgetItem(Sprites(s) \ GadgetShapePointList, -1, "(" + Str(CollisionPoints(p) \ X) + "," + Str(CollisionPoints(p) \ Y) + ")")
								EndIf
							Next
							SetGadgetState(Sprites(s) \ GadgetShapePointList, Sprites(s) \ ShapeEditorPickedPointLocal)
							
							
					EndSelect
					
					
			EndSelect
		EndIf
	Next
			
Return

HandleShapeEditorCanvas:
	For s = 0 To ArraySize(Sprites()) - 1
		If IsWindow(Sprites(s) \ GadgetShapeWindow) And EventTimer() = Sprites(s) \ Timer2
			
			If Sprites(s) \ Preview > -1
				
				; RE-CREATE THE SEQUENCE FOR THE CURRENT SPRITE FROM FRAME IMAGES
				Sprites(s) \ MaxFrames = 0
				For q = 0 To ArraySize(Sequences()) - 1
					If IsImage(Sequences(q) \ Image) : FreeImage(Sequences(q) \ Image) : EndIf
				Next
				ReDim Sequences(0)
				For m = 0 To ArraySize(Frames()) - 1
					If Frames(m) \ Sprite = Sprites(s) \ Name
						
						Sprites(s) \ ThisWidth = ImageWidth(Frames(m) \ Image)
						Sprites(s) \ ThisHeight = ImageHeight(Frames(m) \ Image)
						
						index = ArraySize(Sequences())
						ReDim Sequences(index + 1)
						Sequences(index) \ Image = CopyImage(Frames(m) \ Image, #PB_Any)
						ResizeImage(Sequences(index) \ Image, Sprites(s) \ ThisWidth * Sprites(s) \ ShapeEditorZoom, Sprites(s) \ ThisHeight * Sprites(s) \ ShapeEditorZoom, #PB_Image_Raw)
						ResizeGadget(Sprites(s) \ GadgetShapeCanvas, 0, 0, Sprites(s) \ ThisWidth * Sprites(s) \ ShapeEditorZoom, Sprites(s) \ ThisHeight * Sprites(s) \ ShapeEditorZoom)
						SetGadgetAttribute(Sprites(s) \ GadgetShapeCanvasScoller, #PB_ScrollArea_InnerWidth, Sprites(s) \ ThisWidth * Sprites(s) \ ShapeEditorZoom)
						SetGadgetAttribute(Sprites(s) \ GadgetShapeCanvasScoller, #PB_ScrollArea_InnerHeight, Sprites(s) \ ThisHeight * Sprites(s) \ ShapeEditorZoom)
						Sprites(s) \ MaxFrames = Sprites(s) \ MaxFrames + 1
					EndIf
				Next
				
				; START DRAW ACTUAL FRAME
				StartDrawing(CanvasOutput(Sprites(s) \ GadgetShapeCanvas))
				
				; DRAW TRANSPARENT GRID BACKGROUND
				DrawingMode(#PB_2DDrawing_Default)
				If IsImage(#TransGrid)
					DrawImage(ImageID(#TransGrid), 0, 0)
				EndIf
				
				; DRAW FRAME IMAGE
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				If IsImage(Sequences(Sprites(s) \ CurrentFrame) \ Image)
					DrawImage(ImageID(Sequences(Sprites(s) \ ShapeEditorCurrentFrame) \ Image), 0, 0)
				EndIf
				
				; DRAW GRID
				If Sprites(s) \ ShapeEditorSnapToGrid = 1 And Sprites(s) \ ShapeEditorGridWidth > 0 And Sprites(s) \ ShapeEditorGridHeight > 0
					DrawingMode(#PB_2DDrawing_XOr)
					For gs = 0 To (Sprites(s) \ ShapeEditorZoom * Sprites(s) \ ThisWidth) / Sprites(s) \ ShapeEditorGridWidth : Line(gs * Sprites(s) \ ShapeEditorGridWidth * Sprites(s) \ ShapeEditorZoom, 0, 1, Sprites(s) \ ThisHeight * Sprites(s) \ ShapeEditorZoom) : Next
					For gs = 0 To (Sprites(s) \ ShapeEditorZoom * Sprites(s) \ ThisHeight) / Sprites(s) \ ShapeEditorGridHeight : Line(0, gs * Sprites(s) \ ShapeEditorGridHeight * Sprites(s) \ ShapeEditorZoom, Sprites(s) \ ThisWidth * Sprites(s) \ ShapeEditorZoom, 1) : Next							
					DrawingMode(#PB_2DDrawing_Default)
				EndIf
				
				; DRAW POINTS
				DrawingMode(#PB_2DDrawing_Default)
				Dim Points.i(0)
				For p = 0 To ArraySize(CollisionPoints()) - 1
					If CollisionPoints(p) \ Sprite = Sprites(s) \ Name
						index = ArraySize(Points())
						Points(index) = p
						ReDim Points(index + 1)
						If p = Sprites(s) \ ShapeEditorPickedPointGlobal
							Sprites(s) \ ShapeEditorPickedPointLocal = index
						EndIf
					EndIf
				Next
				For p = 0 To ArraySize(Points()) - 1
					
					CX0 = CollisionPoints(Points(0)) \ X * Sprites(s) \ ShapeEditorZoom
					CY0 = CollisionPoints(Points(0)) \ Y * Sprites(s) \ ShapeEditorZoom
					CX = CollisionPoints(Points(p)) \ X * Sprites(s) \ ShapeEditorZoom
					CY = CollisionPoints(Points(p)) \ Y * Sprites(s) \ ShapeEditorZoom
					CX2 = CollisionPoints(Points(p + 1)) \ X * Sprites(s) \ ShapeEditorZoom
					CY2 = CollisionPoints(Points(p + 1)) \ Y * Sprites(s) \ ShapeEditorZoom
					
					; Line between points
					If p < ArraySize(Points()) - 1
						LineXY(CX - 1, CY, CX2 - 1, CY2, RGB(0, 0, 0))
						LineXY(CX + 1, CY, CX2 + 1, CY2, RGB(0, 0, 0))
						LineXY(CX, CY - 1, CX2, CY2 - 1, RGB(0, 0, 0))
						LineXY(CX, CY + 1, CX2, CY2 + 1, RGB(0, 0, 0))
						LineXY(CX, CY, CX2, CY2, RGB(255,255,0))
					EndIf
					If p = ArraySize(Points()) - 2
						LineXY(CX2 - 1, CY2, CX0 - 1, CY0, RGB(0, 0, 0))
						LineXY(CX2 + 1, CY2, CX0 + 1, CY0, RGB(0, 0, 0))
						LineXY(CX2, CY2 - 1, CX0, CY0 - 1, RGB(0, 0, 0))
						LineXY(CX2, CY2 + 1, CX0, CY0 + 1, RGB(0, 0, 0))
						LineXY(CX2, CY2, CX0, CY0, RGB(255,255,0))
					EndIf
					
					; Dot
					If p = 0
						Box(CX-4, CY-4, 9, 9, RGB(0, 100, 0))
					EndIf
					Circle(CX, CY, 3, RGB(0, 0, 0))
					color = RGB(255, 255, 255) : If p = Sprites(s) \ ShapeEditorPickedPointLocal : color = RGB(255, 10, 10) : EndIf
					Circle(CX, CY, 2, color)
				Next
				
				; END DRAWING
				StopDrawing()
				FreeArray(Points())
				
			EndIf			
			
		EndIf
	Next
Return

HandleSpritePreviewAnimations:

	For s = 0 To ArraySize(Sprites()) - 1
	
		; WINDOW EXISTS AND TIMER TICKED
		If IsWindow(Sprites(s) \ GadgetWindow) And EventTimer() = Sprites(s) \ Timer
			If Sprites(s) \ Preview > -1
				
				; RE-CREATE THE SEQUENCE FOR THE CURRENT SPRITE FROM FRAME IMAGES
				Sprites(s) \ MaxFrames = 0
				For q = 0 To ArraySize(Sequences()) - 1
					If IsImage(Sequences(q) \ Image) : FreeImage(Sequences(q) \ Image) : EndIf
				Next
				ReDim Sequences(0)
				For m = 0 To ArraySize(Frames()) - 1
					If Frames(m) \ Sprite = Sprites(s) \ Name
						
						Sprites(s) \ ThisWidth = ImageWidth(Frames(m) \ Image)
						Sprites(s) \ ThisHeight = ImageHeight(Frames(m) \ Image)
						SetGadgetText(Sprites(s) \ GadgetSize, "Size: " + Str(Sprites(s) \ ThisWidth) + " x " + Str(Sprites(s) \ ThisHeight))
						
						index = ArraySize(Sequences())
						ReDim Sequences(index + 1)
						Sequences(index) \ Image = CopyImage(Frames(m) \ Image, #PB_Any)
						ResizeImage(Sequences(index) \ Image, Sprites(s) \ ThisWidth * Sprites(s) \ Zoom, Sprites(s) \ ThisHeight * Sprites(s) \ Zoom, #PB_Image_Raw)
						ResizeGadget(Sprites(s) \ GadgetSpritePreview, 0, 0, Sprites(s) \ ThisWidth * Sprites(s) \ Zoom, Sprites(s) \ ThisHeight * Sprites(s) \ Zoom)
						SetGadgetAttribute(Sprites(s) \ GadgetPreviewScroller, #PB_ScrollArea_InnerWidth, Sprites(s) \ ThisWidth * Sprites(s) \ Zoom)
						SetGadgetAttribute(Sprites(s) \ GadgetPreviewScroller, #PB_ScrollArea_InnerHeight, Sprites(s) \ ThisHeight * Sprites(s) \ Zoom)
						Sprites(s) \ MaxFrames = Sprites(s) \ MaxFrames + 1
					EndIf
				Next
				
				; START DRAW ACTUAL FRAME
				StartDrawing(CanvasOutput(Sprites(s) \ GadgetSpritePreview))
				
				; DRAW TRANSPARENT GRID BACKGROUND
				DrawingMode(#PB_2DDrawing_Default)
				If IsImage(#TransGrid)
					DrawImage(ImageID(#TransGrid), 0, 0)
				EndIf
				
				; DRAW FRAME IMAGE
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				If IsImage(Sequences(Sprites(s) \ CurrentFrame) \ Image)
					DrawImage(ImageID(Sequences(Sprites(s) \ CurrentFrame) \ Image), 0, 0)
				EndIf
				
				; DRAW CENTER LINES
				DrawingMode(#PB_2DDrawing_XOr)
				Line(Sprites(s) \ CenterX * Sprites(s) \ Zoom, 0, 1, Sprites(s) \ ThisHeight * Sprites(s) \ Zoom)
				Line(0, Sprites(s) \ CenterY * Sprites(s) \ Zoom, Sprites(s) \ ThisWidth * Sprites(s) \ Zoom, 1)
				
				; DRAW COLLISION SHAPE
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				If Sprites(s) \ ShowCollisionShape = 1
					
					If GetGadgetText(Sprites(s) \ GadgetCollisionShape) = "Box"
						DrawingMode(#PB_2DDrawing_Outlined)
						Box(Sprites(s) \ CollisionLeft * Sprites(s) \ Zoom, Sprites(s) \ CollisionTop * Sprites(s) \ Zoom, (Sprites(s) \ CollisionRight - Sprites(s) \ CollisionLeft) * Sprites(s) \ Zoom, (Sprites(s) \ CollisionBottom - Sprites(s) \ Collisiontop) * Sprites(s) \ Zoom, RGBA(0,255,0,90))
						DrawingMode(#PB_2DDrawing_AlphaBlend)
						Box(Sprites(s) \ CollisionLeft * Sprites(s) \ Zoom, Sprites(s) \ CollisionTop * Sprites(s) \ Zoom, (Sprites(s) \ CollisionRight - Sprites(s) \ CollisionLeft) * Sprites(s) \ Zoom, (Sprites(s) \ CollisionBottom - Sprites(s) \ Collisiontop) * Sprites(s) \ Zoom, RGBA(0,255,0,90))
					EndIf
					
					If GetGadgetText(Sprites(s) \ GadgetCollisionShape) = "Circle"
						DrawingMode(#PB_2DDrawing_Outlined)
						Circle(Sprites(s) \ ThisWidth / 2 * Sprites(s) \ Zoom, Sprites(s) \ ThisHeight / 2 * Sprites(s) \ Zoom, Sprites(s) \ CollisionRadius * Sprites(s) \ Zoom, RGBA(0,255,0,90))
						DrawingMode(#PB_2DDrawing_AlphaBlend)
						Circle(Sprites(s) \ ThisWidth / 2 * Sprites(s) \ Zoom, Sprites(s) \ ThisHeight / 2 * Sprites(s) \ Zoom, Sprites(s) \ CollisionRadius * Sprites(s) \ Zoom, RGBA(0,255,0,90))
					EndIf
					
					If GetGadgetText(Sprites(s) \ GadgetCollisionShape) = "Shape"
						
						; CENTER XY FOR FILLING
						FILLX.f = 0
						FILLY.f = 0
						
						; DRAW POINTS
						DrawingMode(#PB_2DDrawing_Default)
						Dim Points.i(0)
						For p = 0 To ArraySize(CollisionPoints()) - 1
							If CollisionPoints(p) \ Sprite = Sprites(s) \ Name
								index = ArraySize(Points())
								Points(index) = p
								ReDim Points(index + 1)
							EndIf
						Next
						For p = 0 To ArraySize(Points()) - 1
							
							CX0 = CollisionPoints(Points(0)) \ X * Sprites(s) \ Zoom
							CY0 = CollisionPoints(Points(0)) \ Y * Sprites(s) \ Zoom
							CX = CollisionPoints(Points(p)) \ X * Sprites(s) \ Zoom
							CY = CollisionPoints(Points(p)) \ Y * Sprites(s) \ Zoom
							CX2 = CollisionPoints(Points(p + 1)) \ X * Sprites(s) \ Zoom
							CY2 = CollisionPoints(Points(p + 1)) \ Y * Sprites(s) \ Zoom
							
							; FIND CENTER
							FILLX = FILLX + CX
							FILLY = FILLY + CY
							
							; Line between points
							If p < ArraySize(Points()) - 1
								LineXY(CX, CY, CX2, CY2, RGBA(0,255,0, 90))
							EndIf
							If p = ArraySize(Points()) - 2
								LineXY(CX2, CY2, CX0, CY0, RGBA(0,255,0, 90))
							EndIf
							
						Next
						
						If ArraySize(Points()) > 0
							DrawingMode(#PB_2DDrawing_AlphaBlend)
							FillArea(FILLX / (ArraySize(Points()) - 1), FILLY / (ArraySize(Points()) - 1), RGBA(0,255,0, 90), RGBA(0,255,0,90))
						EndIf
						
					EndIf
				EndIf
				
				; END DRAWING
				StopDrawing()
				
				; HANDLE ANIMATION
				Sprites(s) \ CurrentFrame = Sprites(s) \ CurrentFrame + 1
				If Sprites(s) \ CurrentFrame > Sprites(s) \ MaxFrames - 1 : Sprites(s) \ CurrentFrame = 0 : EndIf
				
			EndIf
		EndIf
	Next
Return
	
SoundFormHandler:

	For s = 0 To ArraySize(Sounds()) - 1
		If IsWindow(Sounds(s) \ GadgetWindow)
			
			Select EventGadget
					
				; Change file button (WAV)
				Case Sounds(s) \ GadgetFileSelector
				
					; Select a new sound file from the HD
					FileName.s = OpenFileRequester("Select a sound", "", "WAV files(*.wav)|*.wav", 0)
					
					; Load the new sound for playing
					If Filename <> ""
						Sounds(s) \ SelectedFile = FileName
						SetGadgetText(Sounds(s) \ GadgetFileName, "File: " + GetFilePart(FileName))
					EndIf
					
				; Change file button (MP3)
				Case Sounds(s) \ GadgetFile2Selector
				
					; Select a new sound file from the HD
					FileName.s = OpenFileRequester("Select a sound", "", "MP3 files(*.mp3)|*.mp3", 0)
					
					; Load the new sound for playing
					If Filename <> ""
						Sounds(s) \ SelectedFile2 = FileName
						SetGadgetText(Sounds(s) \ GadgetFile2Name, "File: " + GetFilePart(FileName))
					EndIf
					
				; Change file button (OGG)
				Case Sounds(s) \ GadgetFile3Selector
				
					; Select a new sound file from the HD
					FileName.s = OpenFileRequester("Select a sound", "", "OGG files(*.ogg)|*.ogg", 0)
					
					; Load the new sound for playing
					If Filename <> ""
						Sounds(s) \ SelectedFile3 = Filename
						SetGadgetText(Sounds(s) \ GadgetFile3Name, "File: " + GetFilePart(FileName))
					EndIf
					
				; Remove WAV source
				Case Sounds(s) \ GadgetFileRemover
					If Confirm("Confirm", "Remove WAV source?") = 1
						Sounds(s) \ SelectedFile = ""
						SetGadgetText(Sounds(s) \ GadgetFileName, "File: ")
					EndIf
					
				; Remove MP3 source
				Case Sounds(s) \ GadgetFile2Remover
					If Confirm("Confirm", "Remove MP3 source?") = 1
						Sounds(s) \ SelectedFile2 = ""
						SetGadgetText(Sounds(s) \ GadgetFile2Name, "File: ")
					EndIf
					
				; Remove OGG source
				Case Sounds(s) \ GadgetFile3Remover
					If Confirm("Confirm", "Remove OGG source?") = 1
						Sounds(s) \ SelectedFile3 = ""
						SetGadgetText(Sounds(s) \ GadgetFile3Name, "File: ")
					EndIf
					
				Case Sounds(s) \ GadgetDelete
					If Confirm("Confirm", "Do you really want to delete this sound?") = 1
						CloseWindow(Sounds(s) \ GadgetWindow)
						Sounds(s) \ GadgetWindow = 0
						DeleteSound(Sounds(s) \ Name)
						RefreshItems()
					EndIf							
				
				; Apply form changes
				Case Sounds(s) \ GadgetOK
					SoundFormStore(s, 1)
					
			EndSelect
		EndIf
	Next

	Return
	
MusicFormHandler:

	For s = 0 To ArraySize(Musics()) - 1
		If IsWindow(Musics(s) \ GadgetWindow)
			
			Select EventGadget
					
				; Change file button (WAV)
				Case Musics(s) \ GadgetFileSelector
				
					; Select a new music file from the HD
					FileName.s = OpenFileRequester("Select a music", "", "WAV files(*.wav)|*.wav", 0)
					
					; Load the new sound for playing
					If Filename <> ""
						Musics(s) \ SelectedFile = FileName
						SetGadgetText(Musics(s) \ GadgetFileName, "File: " + GetFilePart(FileName))
					EndIf
					
				; Change file button (MP3)
				Case Musics(s) \ GadgetFile2Selector
				
					; Select a new sound file from the HD
					FileName.s = OpenFileRequester("Select a music", "", "MP3 files(*.mp3)|*.mp3", 0)
					
					; Load the new sound for playing
					If Filename <> ""
						Musics(s) \ SelectedFile2 = FileName
						SetGadgetText(Musics(s) \ GadgetFile2Name, "File: " + GetFilePart(FileName))
					EndIf
					
				; Change file button (OGG)
				Case Musics(s) \ GadgetFile3Selector
				
					; Select a new sound file from the HD
					FileName.s = OpenFileRequester("Select a music", "", "OGG files(*.ogg)|*.ogg", 0)
					
					; Load the new sound for playing
					If Filename <> ""
						Musics(s) \ SelectedFile3 = Filename
						SetGadgetText(Musics(s) \ GadgetFile3Name, "File: " + GetFilePart(FileName))
					EndIf
					
				; Remove WAV source
				Case Musics(s) \ GadgetFileRemover
					If Confirm("Confirm", "Remove WAV source?") = 1
						Musics(s) \ SelectedFile = ""
						SetGadgetText(Musics(s) \ GadgetFileName, "File: ")
					EndIf
					
				; Remove MP3 source
				Case Musics(s) \ GadgetFile2Remover
					If Confirm("Confirm", "Remove MP3 source?") = 1
						Musics(s) \ SelectedFile2 = ""
						SetGadgetText(Musics(s) \ GadgetFile2Name, "File: ")
					EndIf
					
				; Remove OGG source
				Case Musics(s) \ GadgetFile3Remover
					If Confirm("Confirm", "Remove OGG source?") = 1
						Musics(s) \ SelectedFile3 = ""
						SetGadgetText(Musics(s) \ GadgetFile3Name, "File: ")
					EndIf
					
				Case Musics(s) \ GadgetDelete
					If Confirm("Confirm", "Do you really want to delete this music?") = 1
						CloseWindow(Musics(s) \ GadgetWindow)
						Musics(s) \ GadgetWindow = 0
						DeleteMusic(Musics(s) \ Name)
						RefreshItems()
					EndIf							
				
				; Apply form changes
				Case Musics(s) \ GadgetOK
					MusicFormStore(s, 1)
					
			EndSelect
		EndIf
	Next

Return
	
BackgroundFormHandler:

	For s = 0 To ArraySize(Backgrounds()) - 1
		If IsWindow(Backgrounds(s) \ GadgetWindow)
			
			Select EventGadget
					
				Case Backgrounds(s) \ GadgetTileCheckbox
					If GetGadgetState(Backgrounds(s) \ GadgetTileCheckbox) = 1
						Backgrounds(s) \ TileContainerX = 10
					Else
						Backgrounds(s) \ TileContainerX = 10000
					EndIf
					ResizeGadget(Backgrounds(s) \ GadgetTileContainer, Backgrounds(s) \ TileContainerX, #PB_Ignore, #PB_Ignore, #PB_Ignore)
					
				; Change file button
				Case Backgrounds(s) \ GadgetFileSelector
				
					; Select a new image
					FileName.s = OpenFileRequester("Select an image", "", "Image files (jpg, bmp, png)|*.jpg;*.bmp;*.png|JPG files(*.jpg)|*.jpg|BMP files(*.bmp)|*.bmp|PNG files(*.png)|*.png", 0)
					
					If Filename <> ""
						
						; Loads a new preview image
						Backgrounds(s) \ SelectedFile = FileName;
						SetGadgetText(Backgrounds(s) \ GadgetFileName, GetFilePart(FileName))
						If IsImage(Backgrounds(s) \ BackgroundImage) : FreeImage(Backgrounds(s) \ BackgroundImage) : EndIf
						Backgrounds(s) \ BackgroundImage = LoadImage(#PB_Any, FileName)
						RefreshBackgroundImage(Backgrounds(s) \ GadgetScroller, Backgrounds(s) \ GadgetBackgroundCanvas, Backgrounds(s) \ BackgroundImage)
						
						; Create a new box image
						NewBackgroundImage = CreateImage(#PB_Any, 150, 100, 32, #PB_Image_Transparent)
						StartDrawing(ImageOutput(NewBackgroundImage))
						DrawingMode(#PB_2DDrawing_AlphaBlend)
						If IsImage(#BoxEmpty) : DrawImage(ImageID(#BoxEmpty), 0, 0) : EndIf
						If IsImage(Backgrounds(s) \ BackgroundImage)
							IW = ImageWidth(Backgrounds(s) \ BackgroundImage)
							IH = ImageHeight(Backgrounds(s) \ BackgroundImage)
							If IW >= IH
								WS.f = 1
								HS.f = IH / IW
							Else
								WS.f = IW / IH
								HS.f = 1
							EndIf
							DrawImage(ImageID(Backgrounds(s) \ BackgroundImage), 45, 20, 60 * WS, 60 * HS)
						EndIf
						StopDrawing()
						Backgrounds(s) \ Preview = CopyImage(NewBackgroundImage, #PB_Any)
						If IsImage(NewBackgroundImage) : FreeImage(NewBackgroundImage) : EndIf
						
						; DELETE TILES LEFT/TOP OUTSIDE OF THIS IMAGE WIDTH/HEIGHT
						Dim TileTrash.s(0)
						For t = 0 To ArraySize(Tiles())
							If Tiles(t) \ Background = Backgrounds(s) \ Name And (Tiles(t) \ Left > ImageWidth(Backgrounds(s) \ BackgroundImage) Or Tiles(t) \ Top > ImageHeight(Backgrounds(s) \ BackgroundImage))
								Index = ArraySize(TileTrash())
								ReDim TileTrash(Index + 1)
								TileTrash(Index) = Tiles(t) \ Name
							EndIf
						Next
						; Delete tiles from trash
						For t = 0 To ArraySize(TileTrash()) - 1
							DeleteTile(TileTrash(t))
						Next
						
						; Recreate tiles using this background
						For t = 0 To ArraySize(Tiles()) - 1
							If Tiles(t) \ Background = Backgrounds(s) \ Name And IsImage(Tiles(t) \ Image) And IsImage(Backgrounds(s) \ BackgroundImage)
								StartDrawing(ImageOutput(Tiles(t) \ Image))
								DrawingMode(#PB_2DDrawing_AlphaChannel)
								Box(0, 0, ImageWidth(Tiles(t) \ Image), ImageHeight(Tiles(t) \ Image), RGBA(0, 0, 0, 0))
								DrawingMode(#PB_2DDrawing_AlphaBlend)
								DrawImage(ImageID(Backgrounds(s) \ BackgroundImage), -Tiles(t) \ Left, -Tiles(t) \ Top)
								StopDrawing()
							EndIf
						Next
						
					EndIf
					
				Case Backgrounds(s) \ GadgetDelete
					If Confirm("Confirm", "Do you really want to delete this background?") = 1
						Dirty(1)
						CloseWindow(Backgrounds(s) \ GadgetWindow)
						Backgrounds(s) \ GadgetWindow = 0
						DeleteBackground(Backgrounds(s) \ Name)
						RefreshItems()
					EndIf
					
				; Apply form changes
				Case Backgrounds(s) \ GadgetOK
					BackgroundFormStore(s, 1)
					
			EndSelect
		EndIf
		
	Next

Return
	
HandleBackgroundTileSettings:

	For s = 0 To ArraySize(Backgrounds()) - 1
	
		; WINDOW EXISTS AND TIMER TICKED
		If IsWindow(Backgrounds(s) \ GadgetWindow) And EventTimer() = Backgrounds(s) \ Timer
			
			; Not tile
			If GetGadgetState(Backgrounds(s) \ GadgetTileCheckbox) = 0 And IsImage(Backgrounds(s) \ BackgroundImage)
				StartDrawing(CanvasOutput(Backgrounds(s) \ GadgetBackgroundCanvas))
				If IsImage(#TransGrid) : DrawImage(ImageID(#TransGrid), 0, 0) : EndIf
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(Backgrounds(s) \ BackgroundImage), 0, 0)
				StopDrawing()
			EndIf
			
			; Tile
			If GetGadgetState(Backgrounds(s) \ GadgetTileCheckbox) = 1 And IsImage(Backgrounds(s) \ BackgroundImage)
				
				tw = Val(GetGadgetText(Backgrounds(s) \ GadgetTileWidth))
				th = Val(GetGadgetText(Backgrounds(s) \ GadgetTileHeight))
				txo = Val(GetGadgetText(Backgrounds(s) \ GadgetTileXoffset))
				tyo = Val(GetGadgetText(Backgrounds(s) \ GadgetTileYoffset))
				txs = Val(GetGadgetText(Backgrounds(s) \ GadgetTileXSpace))
				tys = Val(GetGadgetText(Backgrounds(s) \ GadgetTileYSpace))
				
				xstep = 0
				If tw > 0
					xstep = ImageWidth(Backgrounds(s) \ BackgroundImage) / tw
				EndIf
				
				ystep = 0
				If th > 0
					ystep = ImageHeight(Backgrounds(s) \ BackgroundImage) / th
				EndIf
				
				StartDrawing(CanvasOutput(Backgrounds(s) \ GadgetBackgroundCanvas))
				If IsImage(#TransGrid) : DrawImage(ImageID(#TransGrid), 0, 0) : EndIf
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(Backgrounds(s) \ BackgroundImage), 0, 0)
				DrawingMode(#PB_2DDrawing_XOr)
				For xv = 0 To xstep
					For yv = 0 To ystep
						
						bx = txo + txs * xv + xv * tw
						by = tyo + tys * yv + yv * th
						
						Line(bx, by, tw, 1)
						Line(bx, by, 1, th)
						Line(bx, by + th - 1, tw, 1)
						Line(bx + tw - 1, 1 + by, 1, th)
					Next
				Next
				StopDrawing()
				
			EndIf			
			
		EndIf
		
	Next

Return

FontFormHandler:

	For s = 0 To ArraySize(Fonts()) - 1
		If IsWindow(Fonts(s) \ GadgetWindow)
			
			Select EventGadget
					
				Case Fonts(s) \ GadgetFamily, Fonts(s) \ GadgetSize
					Select EventType()
						Case #PB_EventType_Change
							If IsFont(Fonts(s) \ PreviewFont) : FreeFont(Fonts(s) \ PreviewFont) : EndIf
							Fonts(s) \ PreviewFont = LoadFont(#PB_Any, GetGadgetText(Fonts(s) \ GadgetFamily), Val(GetGadgetText(Fonts(s) \ GadgetSize)), (#PB_Font_Bold * GetGadgetState(Fonts(s) \ GadgetBold)) | (#PB_Font_Italic * GetGadgetState(Fonts(s) \ GadgetItalic)) | #PB_Font_HighQuality)
							StartDrawing(CanvasOutput(Fonts(s) \ PreviewCanvas))
							BackColor(RGB(255,255,255))
							Box(0, 0, 290, 80)
						    DrawingFont(FontID(Fonts(s) \ PreviewFont))
						    DrawingMode(#PB_2DDrawing_Transparent)
						    FrontColor(0)
						    DrawText(2, 2, "the brown fox jumps over the lazy dog")
							StopDrawing()
					EndSelect
					
				Case Fonts(s) \ GadgetBold, Fonts(s) \ GadgetItalic
					If IsFont(Fonts(s) \ PreviewFont) : FreeFont(Fonts(s) \ PreviewFont) : EndIf
					Fonts(s) \ PreviewFont = LoadFont(#PB_Any, GetGadgetText(Fonts(s) \ GadgetFamily), Val(GetGadgetText(Fonts(s) \ GadgetSize)), (#PB_Font_Bold * GetGadgetState(Fonts(s) \ GadgetBold)) | (#PB_Font_Italic * GetGadgetState(Fonts(s) \ GadgetItalic)) | #PB_Font_HighQuality)
					StartDrawing(CanvasOutput(Fonts(s) \ PreviewCanvas))
					BackColor(RGB(255,255,255))
					Box(0, 0, 290, 80)
				    DrawingFont(FontID(Fonts(s) \ PreviewFont))
				    DrawingMode(#PB_2DDrawing_Transparent)
				    FrontColor(0)
				    DrawText(2, 2, "the brown fox jumps over the lazy dog")
					StopDrawing()
					
				Case Fonts(s) \ GadgetDelete
					If Confirm("Confirm", "Do you really want to delete this font?") = 1
						Dirty(1)
						CloseWindow(Fonts(s) \ GadgetWindow)
						Fonts(s) \ GadgetWindow = 0
						DeleteFont(Fonts(s) \ Name)
						RefreshItems()
					EndIf
					
				; Apply form changes
				Case Fonts(s) \ GadgetOK
					FontFormStore(s, 1)
					
			EndSelect
			
		EndIf
	Next
	
Return
	
FunctionFormHandler:

	For s = 0 To ArraySize(Functions()) - 1
		If IsWindow(Functions(s) \ GadgetWindow)
			
			Select EventGadget
					
				Case Functions(s) \ GadgetDelete
					If Confirm("Confirm", "Do you really want to delete this function?") = 1
						Dirty(1)
						CloseWindow(Functions(s) \ GadgetWindow)
						Functions(s) \ GadgetWindow = 0
						DeleteScript(Functions(s) \ Name)
						RefreshItems()
					EndIf
					
				; Apply form changes
				Case Functions(s) \ GadgetOK
					FunctionFormStore(s, 1)
					
			EndSelect
			
		EndIf
		
	Next

Return
	
ObjectFormHandler:

	For s = 0 To ArraySize(Objects()) - 1
		If IsWindow(Objects(s) \ GadgetWindow)
			
			Select EventGadget
					
				; Change sprite
				Case Objects(s) \ GadgetSprite
					Select EventType()
							
						Case #PB_EventType_Change
							; Generate sprite preview image
							If IsImage(Objects(s) \ PreviewImage) : FreeImage(Objects(s) \ PreviewImage) : EndIf
							Image = #NoSprite
							For f = 0 To ArraySize(Frames()) - 1
								If Frames(f) \ Sprite = GetGadgetText(Objects(s) \ GadgetSprite)
									Image = Frames(f) \ Image
									Break
								EndIf
							Next
							
							CreateSpritePreview(Objects(s) \ GadgetSpritePreview, s, Image)
							
							If Image <> #NoSprite
								SetGadgetText(Objects(s) \ GadgetDimensions, "Size: " + Str(ImageWidth(Image)) + " x " + Str(ImageHeight(Image)) + " px")
							Else
								SetGadgetText(Objects(s) \ GadgetDimensions, "Size: <no sprite>")
							EndIf

							
					EndSelect
					
				; Add new event button
				Case Objects(s) \ GadgetNewEvent
					EditCode(s, AddNewEvent(Objects(s) \ Name, GetGadgetText(Objects(s) \ GadgetEvents), ""))
					RefreshEventList(s)
					
				; Eventlist
				Case Objects(s) \ GadgetEventList
					Select EventType()
							
						Case #PB_EventType_LeftClick: RefreshCodePreview(s)
							
						Case #PB_EventType_LeftDoubleClick
							If GetGadgetText(Objects(s) \ GadgetEventList) <> ""
								EditCode(s, GetGadgetItemData(Objects(s) \ GadgetEventList, GetGadgetState(Objects(s) \ GadgetEventList)))
								RefreshEventList(s)
								SetGadgetText(Objects(s) \ GadgetCodePreview, Scripts(GetGadgetItemData(Objects(s) \ GadgetEventList, GetGadgetState(Objects(s) \ GadgetEventList))) \ Code)
								RefreshCodePreview(s)
							EndIf
							
						Case #PB_EventType_RightClick
							If GetGadgetText(Objects(s) \ GadgetEventList) <> ""
								DisplayPopupMenu(#PopupEventItem, WindowID(Objects(s) \ GadgetWindow))
							EndIf
							
					EndSelect
				
					
				Case Objects(s) \ GadgetDelete
					If Confirm("Confirm", "Do you really want to delete this object?") = 1
						Dirty(1)
						CloseWindow(Objects(s) \ GadgetWindow)
						Objects(s) \ GadgetWindow = 0
						DeleteObject(Objects(s) \ Name)
						RefreshItems()
					EndIf
					
				; Apply form changes
				Case Objects(s) \ GadgetOK
					ObjectFormStore(s, 1)
					
			EndSelect
			
		EndIf
	Next

Return

HandleCodeEditors:

	For s = 0 To ArraySize(Objects()) - 1
		If IsWindow(Objects(s) \ GadgetCodeWindow)
			
			Select EventGadget
					
				Case Objects(s) \ GadgetCodeEvents
					Select EventType()
						Case #PB_EventType_Change
							ResizeGadget(Objects(s) \ GadgetCodeParameter, -1800, #PB_Ignore, #PB_Ignore, #PB_Ignore)
							ResizeGadget(Objects(s) \ GadgetCodeParameterText, -1800, #PB_Ignore, #PB_Ignore, #PB_Ignore)
							If GetGadgetState(Objects(s) \ GadgetCodeEvents) = 4
								ResizeGadget(Objects(s) \ GadgetCodeParameter, 240, #PB_Ignore, #PB_Ignore, #PB_Ignore)
								ResizeGadget(Objects(s) \ GadgetCodeParameterText, 180, #PB_Ignore, #PB_Ignore, #PB_Ignore)
							EndIf
					EndSelect
					
				Case Objects(s) \ GadgetCodeCancel
					ScriptEditorX = WindowX(Objects(s) \ GadgetCodeWindow)
					ScriptEditorY = WindowY(Objects(s) \ GadgetCodeWindow)
					DisableWindow(Objects(s) \ GadgetWindow, 0)
					CloseWindow(Objects(s) \ GadgetCodeWindow)
					Objects(s) \ GadgetCodeWindow = 0
					
				Case Objects(s) \ GadgetCodeOK
					EditCodeStore(s, 1)
			EndSelect
			
		EndIf
		
	Next

Return

HandleCodeEditorTimer:

	For s = 0 To ArraySize(Objects()) - 1
	
		; WINDOW EXISTS AND TIMER TICKED
		If IsWindow(Objects(s) \ GadgetCodeWindow) And EventTimer() = Objects(s) \ Timer
			HelpIndex = GetScriptHelpIndex(Objects(s) \ GadgetScintilla)
			If HelpIndex > -1
				If Keywords(HelpIndex) \ Help <> "n/a"
					SetGadgetText(Objects(s) \ GadgetCodeHoverText, Keywords(HelpIndex) \ Help)
				EndIf
				If Keywords(HelpIndex) \ Description <> "n/a"
					SetGadgetText(Objects(s) \ GadgetCodeHoverDescription, Keywords(HelpIndex) \ Description)
				EndIf
			Else
				SetGadgetText(Objects(s) \ GadgetCodeHoverText, "")
				SetGadgetText(Objects(s) \ GadgetCodeHoverDescription, "")
			EndIf
		EndIf
	Next

Return
	
HandleCodeEditorResize:
	For s = 0 To ArraySize(Objects()) - 1
		If IsWindow(Objects(s) \ GadgetCodeWindow)
			If WhichWindow = Objects(s) \ GadgetCodeWindow
				EditScript_Resized(Objects(s) \ GadgetCodeWindow, Objects(s) \ GadgetScintilla, Objects(s) \ GadgetCodeOK, Objects(s) \ GadgetCodeCancel, Objects(s) \ GadgetCodeHoverText, Objects(s) \ GadgetCodeHoverDescription)
			EndIf
		EndIf
	Next
Return
	
HandleGlobalsEditorTimer:

	If EventTimer() = Games(0) \ GlobalsTimer And IsWindow(Games(0) \ GadgetGlobalsWindow)
		HelpIndex = GetScriptHelpIndex(Games(0) \ GadgetGlobalsScintilla)
		If HelpIndex > -1
			SetGadgetText(Games(0) \ GadgetGlobalsHoverText, Keywords(HelpIndex) \ Help)
			SetGadgetText(Games(0) \ GadgetGlobalsHoverDescription, Keywords(HelpIndex) \ Description)
		Else
			SetGadgetText(Games(0) \ GadgetGlobalsHoverText, "")
			SetGadgetText(Games(0) \ GadgetGlobalsHoverDescription, "")
		EndIf
	EndIf

Return
	
HandleGlobalsEditorResize:
	If IsWindow(Games(0) \ GadgetGlobalsWindow)
		If WhichWindow = Games(0) \ GadgetGlobalsWindow
			EditScript_Resized(Games(0) \ GadgetGlobalsWindow, Games(0) \ GadgetGlobalsScintilla, Games(0) \ GadgetGlobalsOK, Games(0) \ GadgetGlobalsCancel, Games(0) \ GadgetGlobalsHoverText, Games(0) \ GadgetGlobalsHoverDescription)
		EndIf
	EndIf
Return
	
HandleGlobalsEditor:

	If IsWindow(Games(0) \ GadgetGlobalsWindow)
		
		Select EventGadget

			Case Games(0) \ GadgetGlobalsCancel
				GOSCI_Free(Games(0) \ GadgetGlobalsScintilla)
				CloseWindow(Games(0) \ GadgetGlobalsWindow)
				Games(0) \ GadgetGlobalsWindow = 0
					
			Case Games(0) \ GadgetGlobalsOK
				EditGlobalsStore(1)
				
		EndSelect
	EndIf

Return

HandleExtensionEditor:
	If IsWindow(Games(0) \ ExtensionWindow)
		
		Select EventGadget
				
			Case Games(0) \ ExtExtensionList
				If GetGadgetText(Games(0) \ ExtExtensionList) <> ""
					item.i = GetGadgetItemData(Games(0) \ ExtExtensionList, GetGadgetState(Games(0) \ ExtExtensionList))
					If item >= 0
						SetGadgetText(Games(0) \ ExtInfoGadget, "NAME:" + Extensions(item) \ Name + Chr(13) + "AUTHOR: " + Extensions(item)\Author + Chr(13) + Chr(13) + "DESCRIPTION: " + Extensions(item)\Description + "HELP:" + Extensions(item)\Help)
					EndIf
				EndIf
				
			; Open
			Case Games(0) \ ExtOpenButton
				ManageExtensionsStore(1)
				
			Case Games(0) \ ExtCancelButton
				CloseWindow(Games(0) \ ExtensionWindow)
				Games(0) \ ExtensionWindow = 0					
				
		EndSelect
	EndIf
Return

HandleFunctionsEditorTimer:

	If EventTimer() = Games(0) \ FunctionsTimer And IsWindow(Games(0) \ GadgetFunctionsWindow)
		HelpIndex = GetScriptHelpIndex(Games(0) \ GadgetFunctionsScintilla)
		If HelpIndex > -1
			SetGadgetText(Games(0) \ GadgetFunctionsHoverText, Keywords(HelpIndex) \ Help)
			SetGadgetText(Games(0) \ GadgetFunctionsHoverDescription, Keywords(HelpIndex) \ Description)
		Else
			SetGadgetText(Games(0) \ GadgetFunctionsHoverText, "")
			SetGadgetText(Games(0) \ GadgetFunctionsHoverDescription, "")
		EndIf
	EndIf

Return
	
HandleFunctionsEditorResize:
	If IsWindow(Games(0) \ GadgetFunctionsWindow)
		If WhichWindow = Games(0) \ GadgetFunctionsWindow
			EditScript_Resized(Games(0) \ GadgetFunctionsWindow, Games(0) \ GadgetFunctionsScintilla, Games(0) \ GadgetFunctionsOK, Games(0) \ GadgetFunctionsCancel, Games(0) \ GadgetFunctionsHoverText, Games(0) \ GadgetFunctionsHoverDescription)
		EndIf
	EndIf
Return
	
HandleFunctionsEditor:

		If IsWindow(Games(0) \ GadgetFunctionsWindow)
			
			Select EventGadget

				Case Games(0) \ GadgetFunctionsCancel
					GOSCI_Free(Games(0) \ GadgetFunctionsScintilla)
					CloseWindow(Games(0) \ GadgetFunctionsWindow)
					Games(0) \ GadgetFunctionsWindow = 0
						
				Case Games(0) \ GadgetFunctionsOK
					EditFunctionsStore(1)
					
			EndSelect
		EndIf

Return

SceneFormHandler:

	For s = 0 To ArraySize(Scenes()) - 1
		If IsWindow(Scenes(s) \ GadgetWindow)
			
			Select EventGadget
					
				; SCENE CODE EDITOR
				Case Scenes(s) \ CodeCancelButton
					CloseWindow(Scenes(s) \ CodeEditorWindow)
					DisableWindow(Scenes(s) \ GadgetWindow, 0)
					
				Case Scenes(s) \ CodeOKButton
					EditSceneCodeStore(s, 1)
					
				; Background tile mode
				Case Scenes(s) \ InnerTileXCheckbox : Scenes(s) \ BackgroundTileX = GetGadgetState(Scenes(s) \ InnerTileXCheckbox)
				Case Scenes(s) \ InnerTileYCheckbox : Scenes(s) \ BackgroundTileY = GetGadgetState(Scenes(s) \ InnerTileYCheckbox)
				Case Scenes(s) \ InnerStretchCheckbox : Scenes(s) \ BackgroundStretch = GetGadgetState(Scenes(s) \ InnerStretchCheckbox)
				Case Scenes(s) \ InnerShowObjectsCheckbox : Scenes(s) \ InnerShowObjects = GetGadgetState(Scenes(s) \ InnerShowObjectsCheckbox)
				Case Scenes(s) \ InnerShowTilesCheckbox : Scenes(s) \ InnerShowTiles = GetGadgetState(Scenes(s) \ InnerShowTilesCheckbox)
					
				Case Scenes(s) \ InnerNewButton
					
					; DELETE ALL OBJECT IF TAB 1 IS SELECTED
					If GetGadgetState(Scenes(s) \ InnerTabPanel) = 1
						If Confirm("Confirm", "Delete all objects in this scene?") = 1
							Dim ObjectTrash.s(0)
							For t = 0 To ArraySize(Objects()) - 1
								If Objects(t) \ Scene = Scenes(s) \ Name
									Index = ArraySize(ObjectTrash())
									ReDim ObjectTrash(Index + 1)
									ObjectTrash(Index) = Objects(t) \ Name
								EndIf
							Next
							For t = 0 To ArraySize(ObjectTrash()) - 1
								DeleteObject(ObjectTrash(t))
							Next
							RefreshSceneObjectSelector(s)
						EndIf
					EndIf
					
					; DELETE ALL TILES IF TAB 3 IS SELECTED
					If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3
						If Confirm("Confirm", "Delete all tiles in this scene?") = 1
							Dim TileTrash.s(0)
							For t = 0 To ArraySize(Tiles()) - 1
								If Tiles(t) \ Scene = Scenes(s) \ Name
									Index = ArraySize(TileTrash())
									ReDim TileTrash(Index + 1)
									TileTrash(Index) = Tiles(t) \ Name
								EndIf
							Next
							For t = 0 To ArraySize(TileTrash()) - 1
								DeleteTile(TileTrash(t))
							Next

						EndIf
					EndIf
					
				Case Scenes(s) \ InnerShiftButton
					
					; SHIFT THE OBJECTS IF TAB 1 IS SELECTED
					If GetGadgetState(Scenes(s) \ InnerTabPanel) = 1
						ShiftWindow = OpenWindow(#PB_Any, 0, 0, 200, 160, "Shift objects", #PB_Window_ScreenCentered | #PB_Window_Tool)
						StickyWindow(ShiftWindow, 1)
						DisableWindow(Scenes(s) \ GadgetWindow, 1)
						TextGadget(#PB_Any, 10, 15, 80, 25, "Horizontal")
						ShiftXInput = StringGadget(#PB_Any, 100, 10, 90, 25, Str(Scenes(s) \ InnerGridSize))
						TextGadget(#PB_Any, 10, 45, 80, 25, "Vertical")
						ShiftYInput = StringGadget(#PB_Any, 100, 40, 90, 25, Str(Scenes(s) \ InnerGridSize))
						OKButton = ButtonGadget(#PB_Any, WindowWidth(ShiftWindow) - 74, WindowHeight(ShiftWindow) - 35, 64, 25, "OK")
						CancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ShiftWindow) - 35, 64, 25, "Cancel")
						ShiftDone = 0
						Repeat
							SetActiveWindow(ShiftWindow)
							Select WaitWindowEvent()
								Case #PB_Event_Gadget
									Select EventGadget()
										Case CancelButton
											ShiftDone = 1
										Case OKButton
											For t = 0 To ArraySize(Objects()) - 1
												If Objects(t) \ Scene = Scenes(s) \ Name
													Objects(t) \ X = Objects(t) \ X + Val(GetGadgetText(ShiftXInput))
													Objects(t) \ Y = Objects(t) \ Y + Val(GetGadgetText(ShiftYInput))
												EndIf
											Next
											ShiftDone = 1
									EndSelect
							EndSelect
						Until ShiftDone = 1
						StickyWindow(ShiftWindow, 0)
						CloseWindow(ShiftWindow)
						DisableWindow(Scenes(s) \ GadgetWindow, 0)
						SetActiveWindow(#MainWindow)
						SetActiveWindow(Scenes(s) \ GadgetWindow)
						RefreshSceneObjectSelector(s)
					EndIf
					
					; SHIFT THE TILES IF TAB 3 IS SELECTED
					If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3
						ShiftWindow = OpenWindow(#PB_Any, 0, 0, 200, 160, "Shift tiles", #PB_Window_ScreenCentered | #PB_Window_Tool)
						StickyWindow(ShiftWindow, 1)
						DisableWindow(Scenes(s) \ GadgetWindow, 1)
						TextGadget(#PB_Any, 10, 15, 80, 25, "Horizontal")
						ShiftXInput = StringGadget(#PB_Any, 100, 10, 90, 25, Str(Scenes(s) \ InnerGridSize))
						TextGadget(#PB_Any, 10, 45, 80, 25, "Vertical")
						ShiftYInput = StringGadget(#PB_Any, 100, 40, 90, 25, Str(Scenes(s) \ InnerGridSize))
						AllLayerCheckbox = CheckBoxGadget(#PB_Any, 10, 75, 100, 25, "In all layer")
						OKButton = ButtonGadget(#PB_Any, WindowWidth(ShiftWindow) - 74, WindowHeight(ShiftWindow) - 35, 64, 25, "OK")
						CancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(ShiftWindow) - 35, 64, 25, "Cancel")
						ShiftDone = 0
						Repeat
							SetActiveWindow(ShiftWindow)
							Select WaitWindowEvent()
								Case #PB_Event_Gadget
									Select EventGadget()
										Case CancelButton
											ShiftDone = 1
										Case OKButton
											For t = 0 To ArraySize(Tiles()) - 1
												If GetGadgetState(AllLayerCheckbox) = 0
													If Tiles(t) \ Scene = Scenes(s) \ Name And Tiles(t) \ Depth = Val(GetGadgetText(LayerCombo))
														Tiles(t) \ X = Tiles(t) \ X + Val(GetGadgetText(ShiftXInput))
														Tiles(t) \ Y = Tiles(t) \ Y + Val(GetGadgetText(ShiftYInput))
													EndIf
												Else
													If Tiles(t) \ Scene = Scenes(s) \ Name
														Tiles(t) \ X = Tiles(t) \ X + Val(GetGadgetText(ShiftXInput))
														Tiles(t) \ Y = Tiles(t) \ Y + Val(GetGadgetText(ShiftYInput))
													EndIf
												EndIf
											Next
											ShiftDone = 1
									EndSelect
							EndSelect
						Until ShiftDone = 1
						StickyWindow(ShiftWindow, 0)
						CloseWindow(ShiftWindow)
						DisableWindow(Scenes(s) \ GadgetWindow, 0)
						SetActiveWindow(#MainWindow)
						SetActiveWindow(Scenes(s) \ GadgetWindow)									
					EndIf								
					
				; Add new layer
				Case Scenes(s) \ InnerLayerAddButton
				
					; ADD A NEW LAYER
					LayerWindow = OpenWindow(#PB_Any, 0, 0, 230, 100, "Add a new tile layer", #PB_Window_ScreenCentered | #PB_Window_Tool)
					StickyWindow(LayerWindow, 1)
					DisableWindow(Scenes(s) \ GadgetWindow, 1)
					TextGadget(#PB_Any, 10, 15, 100, 25, "Depth")
					DepthGadget = StringGadget(#PB_Any, 120, 10, 100, 25, GetGadgetText(Scenes(s) \ InnerLayerCombo))
					OKButton = ButtonGadget(#PB_Any, WindowWidth(LayerWindow) - 74, WindowHeight(LayerWindow) - 35, 64, 25, "OK")
					CancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(LayerWindow) - 35, 64, 25, "Cancel")
					LayerDone = 0
					Repeat
						SetActiveWindow(LayerWindow)
						Select WaitWindowEvent()
							Case #PB_Event_Gadget
								Select EventGadget()
										
									Case OKButton
										
										; Check for existing depth number
										LayerExists = 0
										For c = 0 To ArraySize(Layers()) - 1
											If Layers(c) \ Scene = Scenes(s) \ Name And Layers(c) \ Value = Val(GetGadgetText(DepthGadget))
												LayerExists = 1
												Break
											EndIf
										Next
										
										If LayerExists = 0
											; new layer
											Index = ArraySize(Layers())
											Layers(Index) \ Name = "layer_" + Str(UID())
											Layers(Index) \ Scene = Scenes(s) \ Name
											Layers(Index) \ Value = Val(GetGadgetText(DepthGadget))
											LayerDone = 1
											ReDim Layers(Index + 1)
										Else
											MessageRequester("Error", "Depth already exists")
										EndIf
										
									Case CancelButton
										LayerDone = 1
										
								EndSelect
						EndSelect
					Until LayerDone = 1
					TempVal.s = GetGadgetText(DepthGadget)
					CloseWindow(LayerWindow)
					DisableWindow(Scenes(s) \ GadgetWindow, 0)
					SetActiveWindow(#MainWindow)
					SetActiveWindow(Scenes(s) \ GadgetWindow)
					RefreshLayerCombo(Scenes(s) \ Name, Scenes(s) \ InnerLayerCombo)
					SetGadgetText(Scenes(s) \ InnerLayerCombo, TempVal)
					
				; Delete layer
				Case Scenes(s) \ InnerLayerDeleteButton
				
					; DELETE THE SELECTED LAYER
					If Confirm("Confirm", "Delete this layer and all tiles on this layer?") = 1
						
						; Find and delete layer by depth (and delete tiles on this layer)
						For d = 0 To ArraySize(Layers()) - 1
							
							; Found layer
							If Layers(d) \ Scene = Scenes(s) \ Name And Layers(d) \ Value = Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
								
								DeleteLayer(Layers(d) \ Name)
								
								; Delete tiles on this depth
								Dim TileTrash.s(0)
								For r = 0 To ArraySize(Tiles()) - 1
									If Tiles(r) \ Scene = Scenes(s) \ Name And Tiles(r) \ Depth = Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
										Index = ArraySize(TileTrash())
										ReDim TileTrash(Index + 1)
										TileTrash(Index) = Tiles(r) \ Name
									EndIf
								Next
								; Delete trash
								For r = 0 To ArraySize(TileTrash()) - 1
									DeleteTile(TileTrash(r))
								Next
								
							EndIf
						Next
						
						; Create the default layer if deleted all layers
						Lnum = 0
						For n = 0 To ArraySize(Layers()) - 1
							If Layers(n) \ Scene = Scenes(s) \ Name
								Lnum = Lnum + 1
							EndIf
						Next
						
						; There is no layer in this scene, add the default layer
						If Lnum = 0
							CreateNewLayer(Scenes(s) \ Name)
						EndIf
						
						RefreshLayerCombo(Scenes(s) \ Name, Scenes(s) \ InnerLayerCombo)
						
					EndIf
					
				; Change layer
				Case Scenes(s) \ InnerLayerChangeButton
				
					; Which layer is changed (get the index)
					For c = 0 To ArraySize(Layers()) - 1
						If Layers(c) \ Scene = Scenes(s) \ Name And Layers(c) \ Value = Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
							LayerIndex = c
							OldDepth = Layers(c) \ Value
							Break
						EndIf
					Next
				
					LayerWindow = OpenWindow(#PB_Any, 0, 0, 230, 100, "Change the depth of a tile layer", #PB_Window_ScreenCentered | #PB_Window_Tool)
					StickyWindow(LayerWindow, 1)
					DisableWindow(Scenes(s) \ GadgetWindow, 1)
					TextGadget(#PB_Any, 10, 15, 100, 25, "Depth")
					DepthGadget = StringGadget(#PB_Any, 120, 10, 100, 25, GetGadgetText(Scenes(s) \ InnerLayerCombo))
					OKButton = ButtonGadget(#PB_Any, WindowWidth(LayerWindow) - 74, WindowHeight(LayerWindow) - 35, 64, 25, "OK")
					CancelButton = ButtonGadget(#PB_Any, 10, WindowHeight(LayerWindow) - 35, 64, 25, "Cancel")
					LayerDone = 0
					Repeat
						SetActiveWindow(LayerWindow)
						Select WaitWindowEvent()
							Case #PB_Event_Gadget
								Select EventGadget()
										
									Case OKButton
										
										; Change the layer depth value
										Layers(LayerIndex) \ Value = Val(GetGadgetText(DepthGadget))
										
										; Change the depth of the tiles using the old depth
										For t = 0 To ArraySize(Tiles()) - 1
											If Tiles(t) \ Scene = Scenes(s) \ Name And Tiles(t) \ Depth = OldDepth
												Tiles(t) \ Depth = Val(GetGadgetText(DepthGadget))
											EndIf
										Next
										
										; Delete changed layer if depth exists
										Exists = -1
										Enum = 0
										For c = 0 To ArraySize(Layers()) - 1
											If Layers(c) \ Scene = Scenes(s) \ Name And Layers(c) \ Value = Val(GetGadgetText(DepthGadget))
												Exists = c
												Enum = Enum + 1
											EndIf
										Next
										If Exists > -1 And Enum > 1
											DeleteLayer(Layers(Exists) \ Name)
										EndIf
										
										LayerDone = 1
										
									Case CancelButton
										LayerDone = 1
										
								EndSelect
						EndSelect
					Until LayerDone = 1
					TempVal.s = GetGadgetText(DepthGadget)
					CloseWindow(LayerWindow)
					DisableWindow(Scenes(s) \ GadgetWindow, 0)
					SetActiveWindow(#MainWindow)
					SetActiveWindow(Scenes(s) \ GadgetWindow)
					RefreshLayerCombo(Scenes(s) \ Name, Scenes(s) \ InnerLayerCombo)
					SetGadgetText(Scenes(s) \ InnerLayerCombo, TempVal)
					
				; Change background image
				Case Scenes(s) \ InnerBackgroundImageCombo
					Select EventType()
						Case #PB_EventType_Change
							Scenes(s) \ Background = GetGadgetText(Scenes(s) \ InnerBackgroundImageCombo)
							; Free temp background image
							If IsImage(Scenes(s) \ InnerBackgroundImage) : FreeImage(Scenes(s) \ InnerBackgroundImage) : EndIf
							; Create new temp background image
							Scenes(s) \ InnerBackgroundImage = -1
							If Scenes(s) \ Background <> ""
								For b = 0 To ArraySize(Backgrounds()) - 1
									If Backgrounds(b) \ Name = Scenes(s) \ Background
										If Backgrounds(b) \ File <> ""
											Scenes(s) \ InnerBackgroundImage = LoadImage(#PB_Any, TempName + "/" + Backgrounds(b) \ File)
											Break
										EndIf
									EndIf
								Next
							EndIf
					EndSelect
					
				; Scene code button
				Case Scenes(s) \ InnerSceneCodeButton: EditSceneCode(s)
					
				; Show / Hide grid
				Case Scenes(s) \ InnerShowGridButton : Scenes(s) \ InnerShowGrid = GetGadgetState(Scenes(s) \ InnerShowGridButton)
				
				; Snap to grid
				Case Scenes(s) \ InnerSnapToGridButton : Scenes(s) \ InnerSnapToGrid = GetGadgetState(Scenes(s) \ InnerSnapToGridButton)
					
				; Set Grid size
				Case Scenes(s) \ InnerGridSizeGadget
					Select EventType()
						Case #PB_EventType_Change, #PB_EventType_LostFocus
							If Val(GetGadgetText(Scenes(s) \ InnerGridSizeGadget)) > 4
								Scenes(s) \ InnerGridSize = Val(GetGadgetText(Scenes(s) \ InnerGridSizeGadget))
							EndIf
					EndSelect
					
				; Background color button
				Case Scenes(s) \ InnerBackgroundChangeButton
					Color = ColorRequester(RGB(Scenes(s) \ R, Scenes(s) \ G, Scenes(s) \ B) )
					If Color <> -1
						Scenes(s) \ R = Red(Color)
						Scenes(s) \ G = Green(Color)
						Scenes(s) \ B = Blue(Color)
					EndIf
					SetGadgetColor(Scenes(s) \ InnerBackgroundColor, #PB_Gadget_BackColor, RGB(Scenes(s) \ R, Scenes(s) \ G, Scenes(s) \ B))
					
				; Scene size width
				Case Scenes(s) \ InnerWidthGadget
					Select EventType()
						Case #PB_EventType_LostFocus, #PB_EventType_Change
							RefreshSceneGadget(Scenes(s) \ InnerSceneCanvas, Scenes(s) \ InnerScrollerGadget, Scenes(s) \ InnerWidthGadget, Scenes(s) \ InnerHeightGadget)
							Scenes(s) \ Width = Val(GetGadgetText(Scenes(s) \ InnerWidthGadget))
							Scenes(s) \ Height = Val(GetGadgetText(Scenes(s) \ InnerHeightGadget))
					EndSelect
					
				; Scene size height
				Case Scenes(s) \ InnerHeightGadget
					Select EventType()
						Case #PB_EventType_LostFocus, #PB_EventType_Change
							RefreshSceneGadget(Scenes(s) \ InnerSceneCanvas, Scenes(s) \ InnerScrollerGadget, Scenes(s) \ InnerWidthGadget, Scenes(s) \ InnerHeightGadget)
							Scenes(s) \ Width = Val(GetGadgetText(Scenes(s) \ InnerWidthGadget))
							Scenes(s) \ Height = Val(GetGadgetText(Scenes(s) \ InnerHeightGadget))
					EndSelect
					
				; Canvas events
				Case Scenes(s) \ InnerSceneCanvas
				
					SceneCanvasEventType = EventType()
					
					; Creating/deleting multiple objects or tiles when holding SHIFT
					If SceneCanvasEventType = #PB_EventType_LeftButtonDown Or (SceneCanvasEventType = #PB_EventType_MouseMove And GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton) Or SceneCanvasEventType = #PB_EventType_RightButtonDown
						
						Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseX)
						Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseY)
						
						; SHIFT IS pressed
						If GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_Modifiers) = #PB_Canvas_Shift
							
							; Delete object with mouse click
							If GetGadgetState(Scenes(s) \ InnerObjectActionMode) = 2
								
								; find object under the cursor
								Dim ObjectTrash.s(0)
								For b = 0 To ArraySize(Objects()) - 1
									Obj_X = Objects(b) \ X
									Obj_Y = Objects(b) \ Y
									If Objects(b) \ Sprite <> ""
										OffsetX = 0
										OffsetY = 0
										SprIndex = GetSpriteIndex(Objects(b) \ Sprite)
										If SprIndex > -1
											OffsetX = Sprites(SprIndex) \ CenterX
											OffsetY = Sprites(SprIndex) \ CenterY
										EndIf
									Else
										OffsetX = 7
										OffsetY = 7
									EndIf
									
									If Objects(b) \ Scene = Scenes(s) \ Name
										
										; get image dimensions
										If IsImage(Objects(b) \ TImage)
											For f = 0 To ArraySize(Frames()) - 1
												If Frames(f) \ Sprite = Objects(b) \ Sprite
													ThisImage = Frames(f) \ Image
													Img_W = ImageWidth(ThisImage)
													Img_H = ImageHeight(ThisImage)
													
													R1X = Obj_X - OffsetX
													R1Y = Obj_Y - OffsetY
													R3X = Obj_X - OffsetX + Img_W
													R3Y = Obj_Y - OffsetY + Img_H
													
													If Mouse_X >= R1X And Mouse_X <= R3X And Mouse_Y >= R1Y And Mouse_Y <= R3Y
														Index = ArraySize(ObjectTrash())
														ReDim ObjectTrash(Index + 1)
														ObjectTrash(Index) = Objects(b) \ Name
													EndIf
													
												EndIf
											Next
										Else
											; OBJECT HAS NO SPRITE
											Img_W = 15
											Img_H = 15
											
											R1X = Obj_X - OffsetX
											R1Y = Obj_Y - OffsetY
											R3X = Obj_X - OffsetX + Img_W
											R3Y = Obj_Y - OffsetY + Img_H
											
											If Mouse_X >= R1X And Mouse_X <= R3X And Mouse_Y >= R1Y And Mouse_Y <= R3Y
												Index = ArraySize(ObjectTrash())
												ReDim ObjectTrash(Index + 1)
												ObjectTrash(Index) = Objects(b) \ Name
											EndIf
											
										EndIf
										
									EndIf
								Next
								
								; Delete objects from trash
								For k = 0 To ArraySize(ObjectTrash()) - 1
									DeleteObject(ObjectTrash(k))
								Next
								
							EndIf										
							
							; Remove tiles
							If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3 And GetGadgetState(Scenes(s) \ InnerTileActionMode) = 2
								
								Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseX)
								Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseY)
								
								Dim TileTrash.s(0)
								For t = 0 To ArraySize(Tiles()) - 1
									
									TX1 = Tiles(t) \ X
									TY1 = Tiles(t) \ Y
									TX2 = Tiles(t) \ X + Tiles(t) \ Width
									TY2 = Tiles(t) \ Y + Tiles(t) \ Height
									
									If Tiles(t) \ Scene = Scenes(s) \ Name And Tiles(t) \ Depth = Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
										If Mouse_X > TX1 And Mouse_X < TX2 And Mouse_Y > TY1 And Mouse_Y < TY2
											Index = ArraySize(TileTrash())
											ReDim TileTrash(Index + 1)
											TileTrash(Index) = Tiles(t) \ Name
										EndIf
									EndIf
								Next
								; Delete from trash
								For t = 0 To ArraySize(TileTrash()) - 1
									DeleteTile(TileTrash(t))
								Next

							EndIf
							
							; Detect mouse movements between different blocks
							Scenes(s) \ InnerBlockX = Round(Mouse_X / Scenes(s) \ InnerGridSize, #PB_Round_Down)
							Scenes(s) \ InnerBlockY = Round(Mouse_Y / Scenes(s) \ InnerGridSize, #PB_Round_Down)
							
							; Mouse moved to a new grid block
							If Scenes(s) \ InnerBlockX <> Scenes(s) \ InnerOldBlockX Or Scenes(s) \ InnerBlockY <> Scenes(s) \ InnerOldBlockY
								
								; Object creation
								If GetGadgetState(Scenes(s) \ InnerTabPanel) = 1 And GetGadgetState(Scenes(s) \ InnerObjectActionMode) = 0 And GetGadgetText(Scenes(s) \ InnerObjectsList) <> ""
										
									; New object
									Index = ArraySize(Objects())
									ReDim Objects(Index + 1)
									
									MX = Mouse_X
									MY = Mouse_Y
									If Scenes(s) \ InnerSnapToGrid = 1
										MX = Scenes(s) \ InnerGridSize * Round(Mouse_X / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
										MY = Scenes(s) \ InnerGridSize * Round(Mouse_Y / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
									EndIf
									
									Objects(Index) \ Name = "SceneObject" + Str(UID())
									Objects(Index) \ Proto = 0
									Objects(Index) \ TemplateObject = GetGadgetText(Scenes(s) \ InnerObjectsList)
									Objects(Index) \ Scene = Scenes(s) \ Name
									Objects(Index) \ Selected = 0
									Objects(Index) \ Sprite = GetObjectSprite(GetGadgetText(Scenes(s) \ InnerObjectsList))												
									If IsImage(Scenes(s) \ InnerSelectedObjectSpriteImage)
										Objects(Index) \ TImage = GetSpriteImage(Objects(Index) \ Sprite)
										Objects(Index) \ TWidth = ImageWidth(Objects(Index) \ TImage)
										Objects(Index) \ THeight = ImageHeight(Objects(Index) \ TImage)
									Else
										Objects(Index) \ TImage = -1
										Objects(Index) \ TWidth = 15
										Objects(Index) \ THeight = 15
									EndIf
									Objects(Index) \ X = MX
									Objects(Index) \ Y = MY
									Objects(Index) \ Depth = GetObjectDepth(GetGadgetText(Scenes(s) \ InnerObjectsList))
								EndIf
								
								; Placing tiles
								If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3 And IsImage(Scenes(s) \ InnerTileCursorImage) And GetGadgetState(Scenes(s) \ InnerTileActionMode) = 0
									
									Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseX)
									Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseY)
									
									MX = Mouse_X
									MY = Mouse_Y
									If Scenes(s) \ InnerSnapToGrid = 1
										MX = Scenes(s) \ InnerGridSize * Round(Mouse_X / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
										MY = Scenes(s) \ InnerGridSize * Round(Mouse_Y / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
									EndIf
									
									; Add new tile
									Index = ArraySize(Tiles())
									Tiles(Index) \ Background = GetGadgetText(Scenes(s) \ InnerTileImageCombo)
									Tiles(Index) \ Depth = Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
									Tiles(Index) \ Height = Scenes(s) \ InnerTileHeight
									Tiles(Index) \ Image = CopyImage(Scenes(s) \ InnerTileCursorImage, #PB_Any)
									Tiles(Index) \ Left = Scenes(s) \ InnerTileX
									Tiles(Index) \ Name = "tile_" + Str(UID())
									Tiles(Index) \ Scene = Scenes(s) \ Name
									Tiles(Index) \ Top = Scenes(s) \ InnerTileY
									Tiles(Index) \ Width = Scenes(s) \ InnerTileWidth
									Tiles(Index) \ X = MX
									Tiles(Index) \ Y = MY
									Tiles(Index) \ Selected = 0
									ReDim Tiles(Index + 1)
									
								EndIf											
								
							EndIf
						EndIf
						
						; Store current mouseblock xy
						Scenes(s) \ InnerOldBlockX = Scenes(s) \ InnerBlockX
						Scenes(s) \ InnerOldBlockY = Scenes(s) \ InnerBlockY
						
						RefreshSceneObjectSelector(s)
						
					EndIf
					
					Select SceneCanvasEventType
							
						; Cursor press
						Case #PB_EventType_KeyDown
							
							Scenes(s) \ InnerKey = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_Key)
							Scenes(s) \ InnerMoveSpeed = Scenes(s) \ InnerGridSize
							
							If Scenes(s) \ InnerSnapToGrid = 0 : Scenes(s) \ InnerMoveSpeed = 1 : EndIf
							
							; Move objects
							If GetGadgetState(Scenes(s) \ InnerTabPanel) = 1
								
								; Deselect objects
								If Scenes(s) \ InnerKey = 32 Or Scenes(s) \ InnerKey = 27
									For w = 0 To ArraySize(Objects()) - 1
										Objects(w) \ Selected = 0
									Next
								EndIf
								
								; Move selected objects to right
								If Scenes(s) \ InnerKey = 39
									For w = 0 To ArraySize(Objects()) - 1
										If Objects(w) \ Scene = Scenes(s) \ Name And Objects(w) \ Selected = 1
											Objects(w) \ X = Objects(w) \ X + Scenes(s) \ InnerMoveSpeed
										EndIf
									Next
								EndIf
								
								; Move selected objects to left
								If Scenes(s) \ InnerKey = 37
									For w = 0 To ArraySize(Objects()) - 1
										If Objects(w) \ Scene = Scenes(s) \ Name And Objects(w) \ Selected = 1
											Objects(w) \ X = Objects(w) \ X - Scenes(s) \ InnerMoveSpeed
										EndIf
									Next
								EndIf
								
								; Move selected objects to up
								If Scenes(s) \ InnerKey = 38
									For w = 0 To ArraySize(Objects()) - 1
										If Objects(w) \ Scene = Scenes(s) \ Name And Objects(w) \ Selected = 1
											Objects(w) \ Y = Objects(w) \ Y - Scenes(s) \ InnerMoveSpeed
										EndIf
									Next
								EndIf
								
								; Move selected objects to down
								If Scenes(s) \ InnerKey = 40
									For w = 0 To ArraySize(Objects()) - 1
										If Objects(w) \ Scene = Scenes(s) \ Name And Objects(w) \ Selected = 1
											Objects(w) \ Y = Objects(w) \ Y + Scenes(s) \ InnerMoveSpeed
										EndIf
									Next
								EndIf
								
								; Delete selected objects
								If Scenes(s) \ InnerKey = 46
									
									; Collect scene object to delete
									Dim ObjectsToDelete.s(0)
									
									For w = 0 To ArraySize(Objects()) - 1
										If Objects(w) \ Scene = Scenes(s) \ Name And Objects(w) \ Selected = 1
											Index = ArraySize(ObjectsToDelete())
											ReDim ObjectsToDelete(Index + 1)
											ObjectsToDelete(Index) = Objects(w) \ Name
										EndIf
									Next
									
									; Delete collected object
									If ArraySize(ObjectsToDelete()) > 0
										If Confirm("Confirm", "Delete " + Str(ArraySize(ObjectsToDelete())) + " objects?") = 1
											For w = 0 To ArraySize(ObjectsToDelete()) - 1 : DeleteObject(ObjectsToDelete(w)) : Next													
										EndIf
									EndIf
									
								EndIf
								
								RefreshSceneObjectSelector(s)
								
							EndIf
							
							; Move tiles
							If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3
								
								; Deselect all tiles
								If Scenes(s) \ InnerKey = 32 Or Scenes(s) \ InnerKey = 27
									For w = 0 To ArraySize(Tiles()) - 1
										Tiles(w) \ Selected = 0
									Next
								EndIf
								
								; Move selected tiles to right
								If Scenes(s) \ InnerKey = 39
									For w = 0 To ArraySize(Tiles()) - 1
										If Tiles(w) \ Scene = Scenes(s) \ Name And Tiles(w) \ Selected = 1
											Tiles(w) \ X = Tiles(w) \ X + Scenes(s) \ InnerMoveSpeed
										EndIf
									Next
								EndIf
								
								; Move selected tiles to left
								If Scenes(s) \ InnerKey = 37
									For w = 0 To ArraySize(Tiles()) - 1
										If Tiles(w) \ Scene = Scenes(s) \ Name And Tiles(w) \ Selected = 1
											Tiles(w) \ X = Tiles(w) \ X - Scenes(s) \ InnerMoveSpeed
										EndIf
									Next
								EndIf
								
								; Move selected tiles to up
								If Scenes(s) \ InnerKey = 38
									For w = 0 To ArraySize(Tiles()) - 1
										If Tiles(w) \ Scene = Scenes(s) \ Name And Tiles(w) \ Selected = 1
											Tiles(w) \ Y = Tiles(w) \ Y - Scenes(s) \ InnerMoveSpeed
										EndIf
									Next
								EndIf
								
								; Move selected tiles to down
								If Scenes(s) \ InnerKey = 40
									For w = 0 To ArraySize(Tiles()) - 1
										If Tiles(w) \ Scene = Scenes(s) \ Name And Tiles(w) \ Selected = 1
											Tiles(w) \ Y = Tiles(w) \ Y + Scenes(s) \ InnerMoveSpeed
										EndIf
									Next
								EndIf
								
								; Delete selected tiles
								If Scenes(s) \ InnerKey = 46
									
									; Collect scene tiles to delete
									Dim TrashTiles.s(0)
									
									For w = 0 To ArraySize(Tiles()) - 1
										If Tiles(w) \ Scene = Scenes(s) \ Name And Tiles(w) \ Selected = 1
											Index = ArraySize(TrashTiles())
											ReDim TrashTiles(Index + 1)
											TrashTiles(Index) = Tiles(w) \ Name
										EndIf
									Next
									
									; Delete collected tiles
									If ArraySize(TrashTiles()) > 0
										If Confirm("Confirm", "Delete " + Str(ArraySize(TrashTiles())) + " tiles?") = 1
											For w = 0 To ArraySize(TrashTiles()) - 1 : DeleteTile(TrashTiles(w)) : Next													
										EndIf
									EndIf
									
								EndIf
							EndIf										
							
							
						Case #PB_EventType_MouseEnter: Scenes(s) \ InnerMouseInScene = 1
						Case #PB_EventType_MouseLeave: Scenes(s) \ InnerMouseInScene = 0
							
						Case #PB_EventType_MouseMove
							Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseX)
							Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseY)
							
						Case #PB_EventType_LeftClick
							
							; Object editing
							If GetGadgetState(Scenes(s) \ InnerTabPanel) = 1
								
								Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseX)
								Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseY)
							
								; Create a new object at mouse position
								If GetGadgetState(Scenes(s) \ InnerObjectActionMode) = 0 And GetGadgetText(Scenes(s) \ InnerObjectsList) <> "" And GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_Modifiers) <> #PB_Canvas_Shift
									
									; new index
									Index = ArraySize(Objects())
									ReDim Objects(Index + 1)
									
									MX = Mouse_X
									MY = Mouse_Y
									If Scenes(s) \ InnerSnapToGrid = 1
										MX = Scenes(s) \ InnerGridSize * Round(Mouse_X / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
										MY = Scenes(s) \ InnerGridSize * Round(Mouse_Y / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
									EndIf
									
									Objects(Index) \ Name = "SceneObject" + Str(UID())
									Objects(Index) \ Proto = 0
									Objects(Index) \ TemplateObject = GetGadgetText(Scenes(s) \ InnerObjectsList)
									Objects(Index) \ Scene = Scenes(s) \ Name
									Objects(Index) \ Selected = 0
									Objects(Index) \ Sprite = GetObjectSprite(GetGadgetText(Scenes(s) \ InnerObjectsList))												
									If IsImage(Scenes(s) \ InnerSelectedObjectSpriteImage)
										Objects(Index) \ TImage = GetSpriteImage(Objects(Index) \ Sprite)
										Objects(Index) \ TWidth = ImageWidth(Objects(Index) \ TImage)
										Objects(Index) \ THeight = ImageHeight(Objects(Index) \ TImage)
										Objects(Index) \ TImageModified = CopyImage(Objects(Index) \ TImage, #PB_Any)
									Else
										Objects(Index) \ TImage = -1
										Objects(Index) \ TImageModified = -1
										Objects(Index) \ TWidth = 15
										Objects(Index) \ THeight = 15
									EndIf
									Objects(Index) \ X = MX
									Objects(Index) \ Y = MY
									Objects(Index) \ Depth = GetObjectDepth(GetGadgetText(Scenes(s) \ InnerObjectsList))
									
								EndIf
								
								; Select with mouse click
								If GetGadgetState(Scenes(s) \ InnerObjectActionMode) = 1
									
									; Find object under the cursor
									For b = 0 To ArraySize(Objects()) - 1
										
										Obj_X = Objects(b) \ X
										Obj_Y = Objects(b) \ Y
										If Objects(b) \ Sprite <> ""
											OffsetX = 0
											OffsetY = 0
											SprIndex = GetSpriteIndex(Objects(b) \ Sprite)
											If SprIndex > -1
												OffsetX = Sprites(SprIndex) \ CenterX
												OffsetY = Sprites(SprIndex) \ CenterY
											EndIf
										Else
											OffsetX = 7
											OffsetY = 7
										EndIf
										
										If Objects(b) \ Scene = Scenes(s) \ Name
											
											; Get image dimensions
											If IsImage(Objects(b) \ TImage)
											
												For f = 0 To ArraySize(Frames()) - 1
													
													; Select using its sprite																
													If Frames(f) \ Sprite = Objects(b) \ Sprite
														ThisImage = Frames(f) \ Image
														Img_W = ImageWidth(ThisImage)
														Img_H = ImageHeight(ThisImage)
														
														R1X = Obj_X - OffsetX
														R1Y = Obj_Y - OffsetY
														R3X = Obj_X - OffsetX + Img_W
														R3Y = Obj_Y - OffsetY + Img_H
														
														If Mouse_X >= R1X And Mouse_X <= R3X And Mouse_Y >= R1Y And Mouse_Y <= R3Y
															Objects(b) \ Selected = 1 - Objects(b) \ Selected
															Break
														EndIf
														
													EndIf
													
												Next
											
											; Select without having a sprite
											Else
											
												Img_W = 15
												Img_H = 15
												
												R1X = Obj_X - OffsetX
												R1Y = Obj_Y - OffsetY
												R3X = Obj_X - OffsetX + Img_W
												R3Y = Obj_Y - OffsetY + Img_H
												
												If Mouse_X >= R1X And Mouse_X <= R3X And Mouse_Y >= R1Y And Mouse_Y <= R3Y
													Objects(b) \ Selected = 1 - Objects(b) \ Selected
													Break
												EndIf
												
											EndIf
											
										EndIf
									Next
								EndIf
								
								; Delete object with mouse click
								If GetGadgetState(Scenes(s) \ InnerObjectActionMode) = 2
									
									; find object under the cursor
									Dim ObjectTrash.s(0)
									For b = 0 To ArraySize(Objects()) - 1
										Obj_X = Objects(b) \ X
										Obj_Y = Objects(b) \ Y
										If Objects(b) \ Sprite <> ""
											OffsetX = 0
											OffsetY = 0
											SprIndex = GetSpriteIndex(Objects(b) \ Sprite)
											If SprIndex > -1
												OffsetX = Sprites(SprIndex) \ CenterX
												OffsetY = Sprites(SprIndex) \ CenterY
											EndIf
										Else
											OffsetX = 7
											OffsetY = 7
										EndIf
										
										If Objects(b) \ Scene = Scenes(s) \ Name
											
											; get image dimensions
											If IsImage(Objects(b) \ TImage)
												For f = 0 To ArraySize(Frames()) - 1
													If Frames(f) \ Sprite = Objects(b) \ Sprite
														ThisImage = Frames(f) \ Image
														Img_W = ImageWidth(ThisImage)
														Img_H = ImageHeight(ThisImage)
														
														R1X = Obj_X - OffsetX
														R1Y = Obj_Y - OffsetY
														R3X = Obj_X - OffsetX + Img_W
														R3Y = Obj_Y - OffsetY + Img_H
														
														If Mouse_X >= R1X And Mouse_X <= R3X And Mouse_Y >= R1Y And Mouse_Y <= R3Y
															Index = ArraySize(ObjectTrash())
															ReDim ObjectTrash(Index + 1)
															ObjectTrash(Index) = Objects(b) \ Name
														EndIf
														
													EndIf
												Next
											Else
												Img_W = 15
												Img_H = 15
												
												R1X = Obj_X - OffsetX
												R1Y = Obj_Y - OffsetY
												R3X = Obj_X - OffsetX + Img_W
												R3Y = Obj_Y - OffsetY + Img_H
												
												If Mouse_X >= R1X And Mouse_X <= R3X And Mouse_Y >= R1Y And Mouse_Y <= R3Y
													Index = ArraySize(ObjectTrash())
													ReDim ObjectTrash(Index + 1)
													ObjectTrash(Index) = Objects(b) \ Name
												EndIf
												
											EndIf
											
										EndIf
									Next
									
									; Delete objects from trash
									For k = 0 To ArraySize(ObjectTrash()) - 1
										DeleteObject(ObjectTrash(k))
									Next
									
								EndIf
								
								RefreshSceneObjectSelector(s)
								
							EndIf
							
							; Placing tiles
							If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3 And IsImage(Scenes(s) \ InnerTileCursorImage) And GetGadgetState(Scenes(s) \ InnerTileActionMode) = 0 And GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_Modifiers) <> #PB_Canvas_Shift
								
								Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseX)
								Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseY)
								
								MX = Mouse_X
								MY = Mouse_Y
								If Scenes(s) \ InnerSnapToGrid = 1
									MX = Scenes(s) \ InnerGridSize * Round(Mouse_X / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
									MY = Scenes(s) \ InnerGridSize * Round(Mouse_Y / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
								EndIf
								
								; Add new tile
								Index = ArraySize(Tiles())
								Tiles(Index) \ Background = GetGadgetText(Scenes(s) \ InnerTileImageCombo)
								Tiles(Index) \ Depth = Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
								Tiles(Index) \ Height = Scenes(s) \ InnerTileHeight
								Tiles(Index) \ Image = CopyImage(Scenes(s) \ InnerTileCursorImage, #PB_Any)
								Tiles(Index) \ Left = Scenes(s) \ InnerTileX
								Tiles(Index) \ Name = "tile_" + Str(UID())
								Tiles(Index) \ Scene = Scenes(s) \ Name
								Tiles(Index) \ Top = Scenes(s) \ InnerTileY
								Tiles(Index) \ Width = Scenes(s) \ InnerTileWidth
								Tiles(Index) \ X = MX
								Tiles(Index) \ Y = MY
								Tiles(Index) \ Selected = 0
								ReDim Tiles(Index + 1)
								
							EndIf
							
							; Select tiles
							If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3 And GetGadgetState(Scenes(s) \ InnerTileActionMode) = 1
								
								Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseX)
								Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseY)
								
								For t = 0 To ArraySize(Tiles()) - 1
									
									TX1 = Tiles(t) \ X
									TY1 = Tiles(t) \ Y
									TX2 = Tiles(t) \ X + Tiles(t) \ Width
									TY2 = Tiles(t) \ Y + Tiles(t) \ Height
									
									If Tiles(t) \ Scene = Scenes(s) \ Name And Tiles(t) \ Depth = Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
										If Mouse_X > TX1 And Mouse_X < TX2 And Mouse_Y > TY1 And Mouse_Y < TY2
											Tiles(t) \ Selected = 1 - Tiles(t) \ Selected
										EndIf
									EndIf
								Next
									
							EndIf
							
							; Remove tiles
							If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3 And GetGadgetState(Scenes(s) \ InnerTileActionMode) = 2
								
								Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseX)
								Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerSceneCanvas, #PB_Canvas_MouseY)
								
								Dim TileTrash.s(0)
								For t = 0 To ArraySize(Tiles()) - 1
									
									TX1 = Tiles(t) \ X
									TY1 = Tiles(t) \ Y
									TX2 = Tiles(t) \ X + Tiles(t) \ Width
									TY2 = Tiles(t) \ Y + Tiles(t) \ Height
									
									If Tiles(t) \ Scene = Scenes(s) \ Name And Tiles(t) \ Depth = Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
										If Mouse_X > TX1 And Mouse_X < TX2 And Mouse_Y > TY1 And Mouse_Y < TY2
											Index = ArraySize(TileTrash())
											ReDim TileTrash(Index + 1)
											TileTrash(Index) = Tiles(t) \ Name
										EndIf
									EndIf
								Next
								
								; Delete from trash
								For t = 0 To ArraySize(TileTrash()) - 1
									DeleteTile(TileTrash(t))
								Next

							EndIf
							
							
					EndSelect
					
				; Object selector
				Case Scenes(s) \ InnerObjectsList
					Select EventType()
						Case #PB_EventType_Change
							
							; 'Place objects' is selected
							SetGadgetState(Scenes(s) \ InnerObjectActionMode, 0)
							
							Scenes(s) \ InnerSelectedObjectSpriteImage = GetSpriteImage(GetObjectSprite(GetGadgetText(Scenes(s) \ InnerObjectsList)))
							Scenes(s) \ InnerSelectedObjectSpriteIndex = GetSpriteIndex(GetObjectSprite(GetGadgetText(Scenes(s) \ InnerObjectsList)))
							
							If IsImage(Scenes(s) \ InnerSelectedObjectSpriteImage)
								Scenes(s) \ InnerIW = ImageWidth(Scenes(s) \ InnerSelectedObjectSpriteImage)
								Scenes(s) \ InnerIH = ImageHeight(Scenes(s) \ InnerSelectedObjectSpriteImage)
								If Scenes(s) \ InnerIW >= Scenes(s) \ InnerIH
									Scenes(s) \ InnerWS = 1
									Scenes(s) \ InnerHS = Scenes(s) \ InnerIH / Scenes(s) \ InnerIW
								Else
									Scenes(s) \ InnerWS = Scenes(s) \ InnerIW / Scenes(s) \ InnerIH
									Scenes(s) \ InnerHS = 1
								EndIf
								If IsImage(Scenes(s) \ InnerPreviewImage) : FreeImage(Scenes(s) \ InnerPreviewImage) : EndIf
								Scenes(s) \ InnerPreviewImage = CreateImage(#PB_Any, 100, 100, 32, #PB_Image_Transparent)
								StartDrawing(ImageOutput(Scenes(s) \ InnerPreviewImage))
								DrawingMode(#PB_2DDrawing_AlphaBlend)
								DrawImage(ImageID(Scenes(s) \ InnerSelectedObjectSpriteImage), 0, 0, 100 * Scenes(s) \ InnerWS, 100 * Scenes(s) \ InnerHS)
								StopDrawing()
								SetGadgetState(Scenes(s) \ InnerObjectPreview, ImageID(Scenes(s) \ InnerPreviewImage))
							Else
								SetGadgetState(Scenes(s) \ InnerObjectPreview, ImageID(#NullImage))
							EndIf
							
					EndSelect
					
				; Tile selector
				Case Scenes(s) \ InnerTileImageCombo
					Select EventType()
						Case #PB_EventType_Change
							RefreshSceneSelectedTile(s)
					EndSelect								
					
				; Select tile from background image
				Case Scenes(s) \ InnerTileCanvas
					
					; Left mouse button pushed
					If GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_Buttons) = #PB_Canvas_LeftButton And GetGadgetText(Scenes(s) \ InnerTileImageCombo) <> ""
						
						; First click
						If Scenes(s) \ InnerTileLoaded = -1
							
							Scenes(s) \ InnerMouseStartX = GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_MouseX)
							Scenes(s) \ InnerMouseStartY = GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_MouseY)
							Scenes(s) \ InnerTileLoaded = 1
							
							Scenes(s) \ InnerTileWidth = 0
							Scenes(s) \ InnerTileHeight = 0
							
							For b = 0 To ArraySize(Backgrounds()) - 1
								If Backgrounds(b) \ Name = GetGadgetText(Scenes(s) \ InnerTileImageCombo)
									; Load the tile image
									If IsImage(Scenes(s) \ InnerTileBackground) : FreeImage(Scenes(s) \ InnerTileBackground) : EndIf
									If Backgrounds(b) \ File <> "" : Scenes(s) \ InnerTileBackground = LoadImage(#PB_Any, TempName + "/" + Backgrounds(b) \ File) : EndIf
									Break
								EndIf
							Next
							
						EndIf
						
						; Define the selected tile 
						Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_MouseX)
						Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_MouseY)
						
						; Select tile without modifier
						If GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_Modifiers) <> #PB_Canvas_Alt And GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_Modifiers) <> #PB_Canvas_Control
							If Backgrounds(b) \ Tile = 1
								
								If Mouse_X > Backgrounds(b) \ TileXOffset And Mouse_Y > Backgrounds(b) \ TileYOffset
									M_X = Scenes(s) \ InnerMouseStartX - Backgrounds(b) \ TileXOffset
									M_Y = Scenes(s) \ InnerMouseStartY - Backgrounds(b) \ TileYOffset
									
									; Define left, top, width, height
									GSX = Backgrounds(b) \ TileWidth + Backgrounds(b) \ TileXSpace
									GSY = Backgrounds(b) \ TileHeight + Backgrounds(b) \ TileYSpace
									
									Scenes(s) \ InnerTileX = Backgrounds(b) \ TileXOffset + GSX * Round(M_X / GSX, #PB_Round_Down)
									Scenes(s) \ InnerTileY = Backgrounds(b) \ TileYOffset + GSY * Round(M_Y / GSY, #PB_Round_Down)
									
									Scenes(s) \ InnerTileX2 = Backgrounds(b) \ TileXOffset + GSX * Round((Mouse_X - Backgrounds(b) \ TileXOffset) / GSX, #PB_Round_Down)
									Scenes(s) \ InnerTileY2 = Backgrounds(b) \ TileYOffset + GSY * Round((Mouse_Y - Backgrounds(b) \ TileYOffset) / GSY, #PB_Round_Down)
									
									If Scenes(s) \ InnerTileX2 + Backgrounds(b) \ TileWidth > Scenes(s) \ InnerTileX And Scenes(s) \ InnerTileY2 + Backgrounds(b) \ TileHeight > Scenes(s) \ InnerTileY
										Scenes(s) \ InnerTileWidth = Scenes(s) \ InnerTileX2 - Scenes(s) \ InnerTileX + Backgrounds(b) \ TileWidth
										Scenes(s) \ InnerTileHeight = Scenes(s) \ InnerTileY2 - Scenes(s) \ InnerTileY + Backgrounds(b) \ TileHeight
									EndIf
								Else
									Scenes(s) \ InnerTileX = 0
									Scenes(s) \ InnerTileY = 0
									Scenes(s) \ InnerTileWidth = 0
									Scenes(s) \ InnerTileHeight = 0
									Scenes(s) \ InnerTileLoaded = -1
									If IsImage(Scenes(s) \ InnerTileCursorImage) : FreeImage(Scenes(s) \ InnerTileCursorImage) : EndIf
									Scenes(s) \ InnerTileCursorImage = -1
									Scenes(s) \ InnerTileBackground = -1
								EndIf
								
							Else
								Scenes(s) \ InnerTileCursorImage = -1
								Scenes(s) \ InnerTileX = 0
								Scenes(s) \ InnerTileY = 0
								If IsImage(Scenes(s) \ InnerTileBackground)
									Scenes(s) \ InnerTileWidth = ImageWidth(Scenes(s) \ InnerTileBackground)
									Scenes(s) \ InnerTileHeight = ImageHeight(Scenes(s) \ InnerTileBackground)
								Else
									Scenes(s) \ InnerTileWidth = 0
									Scenes(s) \ InnerTileHeight = 0
								EndIf
							EndIf
						EndIf
						
						; Select tile with ALT modifier
						If GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_Modifiers) = #PB_Canvas_Alt
							
							Mouse_X = GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_MouseX)
							Mouse_Y = GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_MouseY)
							
							Scenes(s) \ InnerTileX = Scenes(s) \ InnerMouseStartX
							Scenes(s) \ InnerTileY = Scenes(s) \ InnerMouseStartY
							
							If Mouse_X > Scenes(s) \ InnerMouseStartX And Mouse_Y > Scenes(s) \ InnerMouseStartY
								Scenes(s) \ InnerTileWidth = Mouse_X - Scenes(s) \ InnerMouseStartX
								Scenes(s) \ InnerTileHeight = Mouse_Y - Scenes(s) \ InnerMouseStartY
							EndIf
							
						EndIf									
						
						; Select tile with CONTROL modifier
						If GetGadgetAttribute(Scenes(s) \ InnerTileCanvas, #PB_Canvas_Modifiers) = #PB_Canvas_Control
							M_X = Scenes(s) \ InnerMouseStartX
							M_Y = Scenes(s) \ InnerMouseStartY
							
							; Define left, top, width, height
							Scenes(s) \ InnerTileX = Scenes(s) \ InnerGridSize * Round(M_X / Scenes(s) \ InnerGridSize, #PB_Round_Down)
							Scenes(s) \ InnerTileY = Scenes(s) \ InnerGridSize * Round(M_Y / Scenes(s) \ InnerGridSize, #PB_Round_Down)
							
							Scenes(s) \ InnerTileX2 = Scenes(s) \ InnerGridSize * Round((Mouse_X - Backgrounds(b) \ TileXOffset) / Scenes(s) \ InnerGridSize, #PB_Round_Down)
							Scenes(s) \ InnerTileY2 = Scenes(s) \ InnerGridSize * Round((Mouse_Y - Backgrounds(b) \ TileYOffset) / Scenes(s) \ InnerGridSize, #PB_Round_Down)
							
							If Scenes(s) \ InnerTileX2 + Scenes(s) \ InnerGridSize > Scenes(s) \ InnerTileX And Scenes(s) \ InnerTileY2 + Scenes(s) \ InnerGridSize > Scenes(s) \ InnerTileY
								Scenes(s) \ InnerTileWidth = Scenes(s) \ InnerTileX2 - Scenes(s) \ InnerTileX + Scenes(s) \ InnerGridSize
								Scenes(s) \ InnerTileHeight = Scenes(s) \ InnerTileY2 - Scenes(s) \ InnerTileY + Scenes(s) \ InnerGridSize
							EndIf
							
						EndIf									
						
						; Tile action = Place
						SetGadgetState(Scenes(s) \ InnerTileActionMode, 0)
						
						If Scenes(s) \ InnerTileWidth <= 0 Or Scenes(s) \ InnerTileHeight <= 0
							Scenes(s) \ InnerTileWidth = 1
							Scenes(s) \ InnerTileHeight = 1
						EndIf
						
						; Display selected tile
						If IsImage(Scenes(s) \ InnerTilePreviewImage) : FreeImage(Scenes(s) \ InnerTilePreviewImage) : EndIf
						Scenes(s) \ InnerTilePreviewImage = CreateImage(#PB_Any, Scenes(s) \ InnerTileWidth, Scenes(s) \ InnerTileHeight, 32, #PB_Image_Transparent)
						
						StartDrawing(ImageOutput(Scenes(s) \ InnerTilePreviewImage))
						If IsImage(#TransGrid) : DrawImage(ImageID(#TransGrid), 0, 0) : EndIf
						DrawingMode(#PB_2DDrawing_AlphaBlend)
						If IsImage(Scenes(s) \ InnerTileBackground)
							DrawImage(ImageID(Scenes(s) \ InnerTileBackground), -Scenes(s) \ InnerTileX, -Scenes(s) \ InnerTileY)
						Else
							Scenes(s) \ InnerTileCursorImage = -1
							Box(0, 0, 100, 100, RGB(0, 0, 0))
						EndIf
						StopDrawing()
						
						If IsImage(Scenes(s) \ InnerTileCursorImage)
							FreeImage(Scenes(s) \ InnerTileCursorImage)
						EndIf
						
						Scenes(s) \ InnerTileCursorImage = CopyImage(Scenes(s) \ InnerTilePreviewImage, #PB_Any)
						
						ResizeImage(Scenes(s) \ InnerTilePreviewImage, 100, 100, #PB_Image_Raw)
						SetGadgetState(Scenes(s) \ InnerTilePreview, ImageID(Scenes(s) \ InnerTilePreviewImage))
						
					Else
						
						; Left button released
						Scenes(s) \ InnerMouseStartX = -1
						Scenes(s) \ InnerMouseStartY = -1
						Scenes(s) \ InnerTileLoaded = -1
						
					EndIf
					
				Case Scenes(s) \ InnerEditInstance
					For w = 0 To ArraySize(Objects()) - 1
						If Objects(w) \ Scene = Scenes(s) \ Name And Objects(w) \ Selected = 1
							EditSceneInstance(s, w)
							Break
						EndIf
					Next
					
				Case Scenes(s) \ InnerObjectSelector
					For w = 0 To ArraySize(Objects()) - 1
						If Objects(w) \ Scene = Scenes(s) \ Name : Objects(w) \ Selected = 0 : EndIf
					Next
					For w = 0 To CountGadgetItems(Scenes(s) \ InnerObjectSelector) - 1
						If GetGadgetItemState(Scenes(s) \ InnerObjectSelector, w)
							Objects(GetGadgetItemData(Scenes(s) \ InnerObjectSelector, w)) \ Selected = 1
						EndIf
					Next
					
				; Apply form changes
				Case Scenes(s) \ InnerOK
					SceneFormStore(s, 1)

					
			EndSelect
		EndIf
		
	Next

Return

HandleSceneTimer:
	For s = 0 To ArraySize(Scenes()) - 1
	
		; WINDOW EXISTS AND TIMER TICKED
		If IsWindow(Scenes(s) \ GadgetWindow) And EventTimer() = scenes(s) \ InnerTimer
			
			If GetGadgetState(Scenes(s) \ InnerTabPanel) = 1 Or GetGadgetState(Scenes(s) \ InnerTabPanel) = 3
				ResizeGadget(Scenes(s) \ InnerNewButton, 320, #PB_Ignore, #PB_Ignore, #PB_Ignore)
				ResizeGadget(Scenes(s) \ InnerShiftButton, 355, #PB_Ignore, #PB_Ignore, #PB_Ignore)
			Else
				ResizeGadget(Scenes(s) \ InnerNewButton, -5000, #PB_Ignore, #PB_Ignore, #PB_Ignore)
				ResizeGadget(Scenes(s) \ InnerShiftButton, -5000, #PB_Ignore, #PB_Ignore, #PB_Ignore)
			EndIf
			
			; Refresh scene graphics
			StartDrawing(CanvasOutput(Scenes(s) \ InnerSceneCanvas))
			
			; Clear
			DrawingMode(#PB_2DDrawing_Default )
			Box(0, 0, Scenes(s) \ Width, Scenes(s) \ Height, RGB(Scenes(s) \ R, Scenes(s) \ G, Scenes(s) \ B))
			
			; Draw background image
			If Scenes(s) \ Background <> ""
				If IsImage(Scenes(s) \ InnerBackgroundImage)
					
					TX = Scenes(s) \ BackgroundTileX
					TY = Scenes(s) \ BackgroundTileY
					TS = Scenes(s) \ BackgroundStretch
					
					; NO background tile
					If TX = 0 And TY = 0 And TS = 0
						DrawImage(ImageID(Scenes(s) \ InnerBackgroundImage), 0, 0)
					EndIf
					
					; STRETCHED background tile
					If TS = 1
						DrawImage(ImageID(Scenes(s) \ InnerBackgroundImage), 0, 0, Scenes(s) \ Width, Scenes(s) \ Height)
						
					Else
						
						; HORIZONTAL background tile
						If TX = 1 And TY = 0
							For ht = 0 To Scenes(s) \ Width
								DrawImage(ImageID(Scenes(s) \ InnerBackgroundImage), ht, 0)
								ht = ht + ImageWidth(Scenes(s) \ InnerBackgroundImage)
							Next
						EndIf
						
						; VERTICAL background tile
						If TX = 0 And TY = 1
							For vt = 0 To Scenes(s) \ Height
								DrawImage(ImageID(Scenes(s) \ InnerBackgroundImage), 0, vt)
								vt = vt + ImageHeight(Scenes(s) \ InnerBackgroundImage)
							Next
						EndIf
						
						; HORIZONTAL AND VERTICAL tile
						If TX = 1 And TY = 1
							For ht = 0 To Scenes(s) \ Width
								For vt = 0 To Scenes(s) \ Height
									DrawImage(ImageID(Scenes(s) \ InnerBackgroundImage), ht, vt)
									vt = vt + ImageHeight(Scenes(s) \ InnerBackgroundImage)
								Next
								ht = ht + ImageWidth(Scenes(s) \ InnerBackgroundImage)
							Next
						EndIf
						
					EndIf
					
				EndIf
			EndIf
			
			; Draw Graphics elements
			ValidateSee(Scenes(s) \ Name)
			InfoText.s = ""
			ForEach Sees()
				
				; Draw object
				If Sees() \ Object > -1 And (GetGadgetState(Scenes(s) \ InnerShowObjectsCheckbox) = 1 Or GetGadgetState(Scenes(s) \ InnerTabPanel) = 1)
					t = Sees() \ Object
					
					If IsImage(Objects(t) \ TImage)
						DrawingMode(#PB_2DDrawing_AlphaBlend)
						OffsetX = 0
						OffsetY = 0
						SprIndex = GetSpriteIndex(Objects(t) \ Sprite)
						If SprIndex > -1
							OffsetX = Sprites(SprIndex) \ CenterX
							OffsetY = Sprites(SprIndex) \ CenterY
						EndIf
						;If IsImage(Objects(t) \ TImage) : DrawImage(ImageID(Objects(t) \ TImage), Objects(t) \ X - OffsetX, Objects(t) \ Y - OffsetY) : EndIf
						
						ShiftRotationX = (ImageWidth(Objects(t) \ TImageModified) - ImageWidth(Objects(t) \ TImage)) / 2
						ShiftRotationY = (ImageHeight(Objects(t) \ TImageModified) - ImageHeight(Objects(t) \ TImage)) / 2
						
						If IsImage(Objects(t) \ TImageModified) : DrawImage(ImageID(Objects(t) \ TImageModified), Objects(t) \ X - OffsetX - ShiftRotationX, Objects(t) \ Y - OffsetY - ShiftRotationY) : EndIf
						; Selected ?
						If Objects(t) \ Selected = 1
							DrawingMode(#PB_2DDrawing_XOr)
							Box(Objects(t) \ X - OffsetX, Objects(t) \ Y - OffsetY, Objects(t) \ TWidth, Objects(t) \ THeight, RGBA(200, 64, 64, 150))
							DrawingMode(#PB_2DDrawing_AlphaBlend)
							InfoText = "[" + Objects(t) \ TemplateObject + "] x:" + Str(Objects(t) \ X) + " y:" + Str(Objects(t) \ Y)
						EndIf
						
					Else
						; No sprite set
						
						DrawingMode(#PB_2DDrawing_AlphaBlend)
						OffsetX = 7
						OffsetY = 7
						DrawImage(ImageID(#MissingSprite), Objects(t) \ X - OffsetX, Objects(t) \ Y - OffsetY)
						; Selected ?
						If Objects(t) \ Selected = 1
							DrawingMode(#PB_2DDrawing_XOr)
							Box(Objects(t) \ X - OffsetX, Objects(t) \ Y - OffsetY, 15, 15, RGBA(200, 64, 64, 150))
							DrawingMode(#PB_2DDrawing_AlphaBlend)
							InfoText = "[" + Objects(t) \ TemplateObject + "] x:" + Str(Objects(t) \ X) + " y:" + Str(Objects(t) \ Y)
						EndIf
						
					EndIf
				EndIf
				
				; Draw tile
				If Sees() \ Tile > -1 And (GetGadgetState(Scenes(s) \ InnerShowTilesCheckbox) = 1 Or GetGadgetState(Scenes(s) \ InnerTabPanel) = 3)
					t = Sees() \ Tile
					DrawingMode(#PB_2DDrawing_AlphaBlend)
					If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3 And GetGadgetState(Scenes(s) \ InnerTileActionMode) > 0
						Alpha = 255
						If Tiles(t) \ Depth <> Val(GetGadgetText(Scenes(s) \ InnerLayerCombo))
							Alpha = 100
						EndIf
						DrawAlphaImage(ImageID(Tiles(t)\Image), Tiles(t) \ X, Tiles(t) \ Y, Alpha)
					Else
						DrawImage(ImageID(Tiles(t)\Image), Tiles(t) \ X, Tiles(t) \ Y)
					EndIf
					; Selected
					If Tiles(t) \ Selected = 1
						DrawingMode(#PB_2DDrawing_XOr)
						Box(Tiles(t) \ X, Tiles(t) \ Y, Tiles(t) \ Width, Tiles(t) \ Height, RGBA(200, 64, 64, 150))
						DrawingMode(#PB_2DDrawing_AlphaBlend)
					EndIf
				EndIf
				
			Next
			
			; Info about the selected object
			SetGadgetText(Scenes(s) \ InnerSelectedObjectInfo, InfoText)
			
			; Show grid
			If Scenes(s) \ InnerShowGrid = 1
				DrawingMode(#PB_2DDrawing_XOr)
				For gs = 0 To Scenes(s) \ Width / Scenes(s) \ InnerGridSize : Line(gs * Scenes(s) \ InnerGridSize, 0, 1, Scenes(s) \ Height) : Next
				For gs = 0 To Scenes(s) \ Height / Scenes(s) \ InnerGridSize : Line(0, gs * Scenes(s) \ InnerGridSize, Scenes(s) \ Width, 1) : Next							
				DrawingMode(#PB_2DDrawing_Default)
			EndIf
			
			; Currently selected object at mouse position
			If GetGadgetState(Scenes(s) \ InnerTabPanel) = 1 And GetGadgetState(Scenes(s) \ InnerObjectActionMode) = 0 And GetGadgetText(Scenes(s) \ InnerObjectsList) <> ""
				If Scenes(s) \ InnerMouseInScene = 1 And Mouse_X > 0 And Mouse_X < Scenes(s) \ Width And Mouse_Y > 0 And Mouse_Y < Scenes(s) \ Height
					
					DrawingMode(#PB_2DDrawing_AlphaBlend)
					MX = Mouse_X
					MY = Mouse_Y
					If Scenes(s) \ InnerSnapToGrid = 1
						MX = Scenes(s) \ InnerGridSize * Round(Mouse_X / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
						MY = Scenes(s) \ InnerGridSize * Round(Mouse_Y / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
					EndIf
					If IsImage(Scenes(s) \ InnerSelectedObjectSpriteImage) 
						DrawAlphaImage(ImageID(Scenes(s) \ InnerSelectedObjectSpriteImage), MX - Sprites(Scenes(s) \ InnerSelectedObjectSpriteIndex) \ CenterX, MY - Sprites(Scenes(s) \ InnerSelectedObjectSpriteIndex) \ CenterY, 150)
					Else
						DrawAlphaImage(ImageID(#MissingSprite), MX - 7, MY - 7, 150)
					EndIf
				EndIf
			EndIf
			
			; Currently selected tile at mouse position
			If GetGadgetState(Scenes(s) \ InnerTabPanel) = 3 And GetGadgetState(Scenes(s) \ InnerTileActionMode) = 0
				If Scenes(s) \ InnerMouseInScene = 1 And IsImage(Scenes(s) \ InnerTileCursorImage) And Mouse_X > 0 And Mouse_X < Scenes(s) \ Width And Mouse_Y > 0 And Mouse_Y < Scenes(s) \ Height
					DrawingMode(#PB_2DDrawing_AlphaBlend)
					MX = Mouse_X
					MY = Mouse_Y
					If Scenes(s) \ InnerSnapToGrid = 1
						MX = Scenes(s) \ InnerGridSize * Round(Mouse_X / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
						MY = Scenes(s) \ InnerGridSize * Round(Mouse_Y / Scenes(s) \ InnerGridSize, #PB_Round_Down) 
					EndIf
					DrawAlphaImage(ImageID(Scenes(s) \ InnerTileCursorImage), MX, MY, 200)
				EndIf
			EndIf						
			
			; Stop the canvas refresh
			StopDrawing()
			
			; Tile selected rectangle on the background image
			If Scenes(s) \ InnerTileWidth > 0 And Scenes(s) \ InnerTileHeight > 0 And IsImage(Scenes(s) \ InnerTileBackground)
				StartDrawing(CanvasOutput(Scenes(s) \ InnerTileCanvas))
				If IsImage(#TransGrid) : DrawImage(ImageID(#TransGrid), 0, 0) : EndIf
				DrawingMode(#PB_2DDrawing_AlphaBlend)
				DrawImage(ImageID(Scenes(s) \ InnerTileBackground), 0, 0)
				DrawingMode(#PB_2DDrawing_XOr)
				
				Line(Scenes(s) \ InnerTileX, Scenes(s) \ InnerTileY, Scenes(s) \ InnerTileWidth, 1)
				Line(Scenes(s) \ InnerTileX, Scenes(s) \ InnerTileY, 1, Scenes(s) \ InnerTileHeight)
				Line(Scenes(s) \ InnerTileX, Scenes(s) \ InnerTileY + Scenes(s) \ InnerTileHeight, Scenes(s) \ InnerTileWidth, 1)
				Line(Scenes(s) \ InnerTileX + Scenes(s) \ InnerTileWidth, Scenes(s) \ InnerTileY, 1, Scenes(s) \ InnerTileHeight)
				StopDrawing()
			EndIf

			
		EndIf
	Next
Return

HandleSceneResize:
	For s = 0 To ArraySize(Scenes()) - 1
		If IsWindow(Scenes(s) \ GadgetWindow)
			If WhichWindow = Scenes(s) \ GadgetWindow
				ResizeGadget(Scenes(s) \ InnerTabPanel, #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(Scenes(s) \ GadgetWindow) - 50)
				ResizeGadget(Scenes(s) \ InnerScrollerGadget, #PB_Ignore, #PB_Ignore, WindowWidth(Scenes(s) \ GadgetWindow) - 330, WindowHeight(Scenes(s) \ GadgetWindow) - 60)
				ResizeGadget(Scenes(s) \ InnerObjectSelector, #PB_Ignore, #PB_Ignore, #PB_Ignore, WindowHeight(Scenes(s) \ GadgetWindow) - 320)
			EndIf
		EndIf
	Next
Return

HandleResourcesCloseWindow:

	For s = 0 To ArraySize(Sprites()) - 1
		If IsWindow(Sprites(s) \ GadgetWindow) And WhichWindow = Sprites(s) \ GadgetWindow : CloseWindow(Sprites(s) \ GadgetWindow) : Sprites(s) \ GadgetWindow = 0 : EndIf
		If IsWindow(Sprites(s) \ GadgetShapeWindow) And WhichWindow = Sprites(s) \ GadgetShapeWindow : CloseWindow(Sprites(s) \ GadgetShapeWindow) : Sprites(s) \ GadgetShapeWindow = 0: EndIf
	Next
	
	For s = 0 To ArraySize(Sounds()) - 1
		If IsWindow(Sounds(s) \ GadgetWindow) And WhichWindow = Sounds(s) \ GadgetWindow : CloseWindow(Sounds(s) \ GadgetWindow) : Sounds(s) \ GadgetWindow = 0 : EndIf
	Next
	
	For s = 0 To ArraySize(Musics()) - 1
		If IsWindow(Musics(s) \ GadgetWindow) And WhichWindow = Musics(s) \ GadgetWindow : CloseWindow(Musics(s) \ GadgetWindow) : Musics(s) \ GadgetWindow = 0 : EndIf
	Next
	
	For s = 0 To ArraySize(Fonts()) - 1
		If IsWindow(Fonts(s) \ GadgetWindow) And WhichWindow = Fonts(s) \ GadgetWindow : CloseWindow(Fonts(s) \ GadgetWindow) : Fonts(s) \ GadgetWindow = 0 : EndIf
	Next
	
	For s = 0 To ArraySize(Backgrounds()) - 1
		If IsWindow(Backgrounds(s) \ GadgetWindow) And WhichWindow = Backgrounds(s) \ GadgetWindow : CloseWindow(Backgrounds(s) \ GadgetWindow) : Backgrounds(s) \ GadgetWindow = 0 : EndIf
	Next
	
	For s = 0 To ArraySize(Functions()) - 1
		If IsWindow(Functions(s) \ GadgetWindow) And WhichWindow = Functions(s) \ GadgetWindow : CloseWindow(Functions(s) \ GadgetWindow) : Functions(s) \ GadgetWindow = 0 : EndIf
	Next
	
	For s = 0 To ArraySize(Objects()) - 1
		If IsWindow(Objects(s) \ GadgetWindow) And WhichWindow = Objects(s) \ GadgetWindow : CloseWindow(Objects(s) \ GadgetWindow) : Objects(s) \ GadgetWindow = 0 : EndIf
		If IsWindow(Objects(s) \ GadgetCodeWindow) And WhichWindow = Objects(s) \ GadgetCodeWindow
			ScriptEditorX = WindowX(Objects(s) \ GadgetCodeWindow)
			ScriptEditorY = WindowY(Objects(s) \ GadgetCodeWindow)
			GOSCI_Free(Objects(s) \ GadgetScintilla)
			DisableWindow(Objects(s) \ GadgetWindow, 0)
			CloseWindow(Objects(s) \ GadgetCodeWindow)
			Objects(s) \ GadgetCodeWindow = 0
		EndIf
	Next
	
	For s = 0 To ArraySize(Scenes()) - 1
		If IsWindow(Scenes(s) \ GadgetWindow) And WhichWindow = Scenes(s) \ GadgetWindow : CloseWindow(Scenes(s) \ GadgetWindow) : Scenes(s) \ GadgetWindow = 0 : EndIf
		If IsWindow(Scenes(s) \ CodeEditorWindow) And WhichWindow = Scenes(s) \ CodeEditorWindow : CloseWindow(Scenes(s) \ CodeEditorWindow) : Scenes(s) \ CodeEditorWindow = 0 : EndIf
	Next
	
	; CLOSE GLOBALS CODE EDITOR WITHOUT SAVE
	If IsWindow(Games(0) \ GadgetGlobalsWindow)
		If WhichWindow = Games(0) \ GadgetGlobalsWindow
			ScriptEditorX = WindowX(Games(0) \ GadgetGlobalsWindow)
			ScriptEditorY = WindowY(Games(0) \ GadgetGlobalsWindow)
			GOSCI_Free(Games(0) \ GadgetGlobalsScintilla)
			CloseWindow(Games(0) \ GadgetGlobalsWindow)
			Games(0) \ GadgetGlobalsWindow = 0
		EndIf
	EndIf
	
	; CLOSE CUSTOMFUNCTIONS CODE EDITOR WITHOUT SAVE
	If IsWindow(Games(0) \ GadgetFunctionsWindow)
		If WhichWindow = Games(0) \ GadgetFunctionsWindow
			ScriptEditorX = WindowX(Games(0) \ GadgetFunctionsWindow)
			ScriptEditorY = WindowY(Games(0) \ GadgetFunctionsWindow)
			GOSCI_Free(Games(0) \ GadgetFunctionsScintilla)
			CloseWindow(Games(0) \ GadgetFunctionsWindow)
			Games(0) \ GadgetFunctionsWindow = 0
		EndIf
	EndIf
	
	; CLOSE GAME COMMENT
	If IsWindow(Games(0) \ GadgetCommentsWindow)
		If WhichWindow = Games(0) \ GadgetCommentsWindow
			ScriptEditorX = WindowX(Games(0) \ GadgetCommentsWindow)
			ScriptEditorY = WindowY(Games(0) \ GadgetCommentsWindow)
			CloseWindow(Games(0) \ GadgetCommentsWindow)
			Games(0) \ GadgetCommentsWindow = 0
		EndIf
	EndIf	
	
	; CLOSE EXTENTIONMANAGER
	If IsWindow(Games(0) \ ExtensionWindow)
		If WhichWindow = Games(0) \ ExtensionWindow
			ScriptEditorX = WindowX(Games(0) \ ExtensionWindow)
			ScriptEditorY = WindowY(Games(0) \ ExtensionWindow)
			CloseWindow(Games(0) \ ExtensionWindow)
			Games(0) \ ExtensionWindow = 0
		EndIf
	EndIf
	
Return
