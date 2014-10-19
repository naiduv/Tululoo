Declare.i myLineStyler(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
Declare.i myStylerUtility_StyleCommentPart(id, *utf8Buffer.ASCII, numUtf8Bytes, *ptrCommented.INTEGER)

;The following is our user-defined line-styling function, called whenever GoScintilla is called upon to style lines.
Procedure.i myLineStyler(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
	
	Protected result = #GOSCI_STYLELINESASREQUIRED, blnIsEndOfPreviousLineCommented, numBytesToStyle, numBytesStyled, *ptrAscii.ASCII
	Protected blnLastSymbolAValidStarter = #True
	
	;Is the end of the previous line commented? (We store a flag to indicate this in the line data.)
	If currentLine > 0
		blnIsEndOfPreviousLineCommented = GOSCI_GetLineData(id, currentLine-1)
	EndIf
	
	;Need to loop through the UTF-8 buffer, alternating between styling comments and invoking GoScintilla's styling lexer as appropriate.
	While numUtf8Bytes
		
		If blnIsEndOfPreviousLineCommented
			numBytesStyled = myStylerUtility_StyleCommentPart(id, *utf8Buffer, numUtf8Bytes, @blnIsEndOfPreviousLineCommented)
			numUtf8Bytes - numBytesStyled
			*utf8Buffer + numBytesStyled
		EndIf
		
		blnLastSymbolAValidStarter = #True
		If numUtf8Bytes > 0
			
			;We are now outside of a comment block. We now search for an opening /* comment marker on a symbol by symbol basis.
			;All other symbols will be passed back to GoScintilla for styling.
			While numUtf8Bytes > 0
				
				numBytesStyled = 0
				*ptrAscii = *utf8Buffer
				If *ptrAscii\a = '/' And numUtf8Bytes > 1
					*ptrAscii + 1
					
					If blnLastSymbolAValidStarter And *ptrAscii\a = '/' ;We have a single line comment and so we style the remainder of this line (excluding EOL characters) appropriately.
						
						numBytesStyled = numUtf8Bytes
						
						;Do not apply the comment style to EOL characters as this can cause problems.
						*ptrAscii + numUtf8Bytes - 1
						While *ptrAscii\a = #LF Or *ptrAscii\a = #CR
							*ptrAscii - 1
							numBytesStyled - 1
						Wend
						
						ScintillaSendMessage(id, #SCI_SETSTYLING, numBytesStyled, #STYLES_COMMENTS)
						
					ElseIf *ptrAscii\a = '*' ;Open comment found.
						
						;Apply the comment style to the /* symbol so as not to confuse our comment styler utility function below.
						ScintillaSendMessage(id, #SCI_SETSTYLING, 2, #STYLES_COMMENTS)
						
						numUtf8Bytes - 2
						*utf8Buffer + 2
						blnIsEndOfPreviousLineCommented = #True ;Mark that, at this point, the end of the current line will be commented.
						
						Break
						
					EndIf
				EndIf
				
				If numBytesStyled = 0
					
					If *ptrAscii\a = 9 Or *ptrAscii\a = 32 Or *ptrAscii\a = ';'
						blnLastSymbolAValidStarter = #True
					Else
						blnLastSymbolAValidStarter = #False
					EndIf
					
					numBytesStyled = GOSCI_StyleNextSymbol(id, *utf8Buffer, numUtf8Bytes)    
				EndIf
				
				numUtf8Bytes - numBytesStyled
				*utf8Buffer + numBytesStyled
				
			Wend
		EndIf
	Wend
	
	;Mark the current line as appropriate, depending upon whether it is an open ended comment.
	If GOSCI_GetLineData(id, currentLine) <> blnIsEndOfPreviousLineCommented
		GOSCI_SetLineData(id, currentLine, blnIsEndOfPreviousLineCommented)
		result = #GOSCI_STYLENEXTLINEREGARDLESS
	EndIf
	
	ProcedureReturn result
	
EndProcedure

;A utility function called by our main line styler above to apply the comment style to any part of a line which is commented.
;Returns the number of bytes styled.
Procedure.i myStylerUtility_StyleCommentPart(id, *utf8Buffer.ASCII, numUtf8Bytes, *ptrCommented.INTEGER)
	
	Protected numBytesToStyle, *ptrAscii.ASCII
	*ptrAscii = *utf8Buffer
	
	While numBytesToStyle < numUtf8Bytes
		
		numBytesToStyle + 1
		
		If *ptrAscii\a = '*' And numBytesToStyle < numUtf8Bytes
			*ptrAscii + 1
			
			If *ptrAscii\a = '/'
				numBytesToStyle + 1
				*ptrCommented\i = #False 
				Break
			EndIf
			
		Else
			*ptrAscii + 1      
		EndIf
		
	Wend
	
	If numBytesToStyle
		
		;Do not apply the comment style to EOL characters. This will cause Scintilla to force us to restyle the entire document.
		;Instead we will leave myLineStyler() to invoke the GOSCI_StyleNextSymbol() function in order to apply the default style.
		*ptrAscii-1
		While *ptrAscii\a = #LF Or *ptrAscii\a = #CR
			
			numBytesToStyle - 1
			*ptrAscii-1
			If numBytesToStyle = 0
				Break
			EndIf
			
		Wend
		
		If numBytesToStyle
			ScintillaSendMessage(id, #SCI_SETSTYLING, numBytesToStyle, #STYLES_COMMENTS)
		EndIf
		
	EndIf
	
	ProcedureReturn numBytesToStyle
	
EndProcedure

; ***********************************************************************************************************
Structure T_RGBA
	B.a
	G.a
	R.a
	A.a
EndStructure

Macro RGB_B(color)
	((color & $FF0000) >> 16)
EndMacro

Macro RGB_G(color)
	((color & $FF00) >> 8)
EndMacro

Macro RGB_R(color)
	(color & $FF)
EndMacro

Macro RGB_Mix (r, g, b)
	((((b) << 8 + (g)) << 8) + (r))
EndMacro

Macro CopyPixel32 (iXs, iYs, iXd, iYd, iBufferPitchSrc, iBufferPitchDest, ptRGBAs, ptRGBAd, pMemSrc, pMemDest)
	ptRGBAs = pMemSrc  + (iYs) * iBufferPitchSrc + (iXs) << 2
	ptRGBAd = pMemDest + (iYd) * iBufferPitchDest + (iXd) << 2
	ptRGBAd\R = ptRGBAs\R
	ptRGBAd\G = ptRGBAs\G
	ptRGBAd\B = ptRGBAs\B
	ptRGBAd\A = ptRGBAs\A
EndMacro

Macro CopyPixel24 (iXs, iYs, iXd, iYd, iBufferPitchSrc, iBufferPitchDest, ptRGBAs, ptRGBAd, pMemSrc, pMemDest)
	ptRGBAs = pMemSrc  + (iYs) * iBufferPitchSrc + (iXs) * 3
	ptRGBAd = pMemDest + (iYd) * iBufferPitchDest + (iXd) * 3
	ptRGBAd\R = ptRGBAs\R
	ptRGBAd\G = ptRGBAs\G
	ptRGBAd\B = ptRGBAs\B   
EndMacro

Macro ReadPixel32 (iX, iY, iBufferPitchSrc, ptRGBA, pMemSrc)
	ptRGBA = pMemSrc + (iY) * iBufferPitchSrc + (iX) << 2
EndMacro

Macro ReadPixel24 (iX, iY, iBufferPitchSrc, ptRGBA, pMemSrc)
	ptRGBA = pMemSrc + (iY) * iBufferPitchSrc + (iX) * 3
EndMacro

Macro WritePixel32 (tPixel, iX, iY, iBufferPitchDest, ptRGBA, pMemDest)
	ptRGBA = pMemDest + (iY) * iBufferPitchDest + (iX) << 2
	ptRGBA\R = tPixel\R
	ptRGBA\G = tPixel\G
	ptRGBA\B = tPixel\B
	ptRGBA\A = tPixel\A
EndMacro

Macro WritePixel24 (tPixel, iX, iY, iBufferPitchDest, ptRGBA, pMemDest)
	ptRGBA = pMemDest + (iY) * iBufferPitchDest + (iX) * 3
	ptRGBA\R = tPixel\R
	ptRGBA\G = tPixel\G
	ptRGBA\B = tPixel\B
EndMacro

Macro JMP_IF_ZERO (var, label)
	If var = 0: Goto label : EndIf
EndMacro

Procedure.i AllocateImageData (nImage, *iBufferPitch.Integer, iFillColor = -1)

	Protected *ImageMem, *AllocMem, iBufferPitch

	StartDrawing(ImageOutput(nImage))

	*ImageMem = DrawingBuffer()
	iBufferPitch = DrawingBufferPitch()

	If iFillColor <> -1
		Select ImageDepth(nImage)
			Case 24
			Box(0, 0, ImageWidth(nImage), ImageHeight(nImage), iFillColor)
			Case 32
			DrawingMode(#PB_2DDrawing_AlphaChannel)   
			Box(0, 0, ImageWidth(nImage), ImageHeight(nImage), $00) ; full transparent
		EndSelect
	EndIf

	*AllocMem = AllocateMemory(iBufferPitch * ImageHeight(nImage))

	If *AllocMem
		CopyMemory(*ImageMem, *AllocMem, MemorySize(*AllocMem))
		*iBufferPitch\i = iBufferPitch
	Else
		*iBufferPitch\i = 0
	EndIf

	StopDrawing()

	ProcedureReturn *AllocMem
	
EndProcedure

Procedure CopyImageData (nImage, *DestMem)
	StartDrawing(ImageOutput(nImage))
	CopyMemory(*DestMem, DrawingBuffer(), MemorySize(*DestMem))
	StopDrawing()
EndProcedure

Procedure.i RotateImage (nSrcImage, iDegRot)

	Protected *tRGBAs.T_RGBA, *tRGBAd.T_RGBA, tPixel.T_RGBA, iType
	Protected *SrcMem, *DestMem, iBufferPitchSrc, iBufferPitchDest
	Protected iSrcWidth, iSrcHeight, iDestWidth, iDestHeight, nDestImage
	Protected iX, iY, iXs, iYs
	Protected iBitPlanes

	; sanity checks
	If IsImage(nSrcImage) = 0
		ProcedureReturn 0
	EndIf

	iBitPlanes = ImageDepth(nSrcImage)

	If iBitPlanes <> 24 And iBitPlanes <> 32
		ProcedureReturn 0
	EndIf

	; sanity checks
	If iDegRot % 90
		ProcedureReturn 0
	EndIf

	iDegRot % 360

	If iDegRot = 0
		ProcedureReturn CopyImage(nSrcImage, #PB_Any)
	EndIf

	CompilerIf (#PB_Compiler_OS = #PB_OS_Linux)
		iDegRot = -iDegRot
	CompilerEndIf

	iSrcWidth = ImageWidth(nSrcImage)
	iSrcHeight = ImageHeight(nSrcImage)

	Select iDegRot           
		Case 90, -270
			iDestWidth = iSrcHeight
			iDestHeight = iSrcWidth
			iType = 1
		Case 180, -180
			iType = 2
			iDestWidth = iSrcWidth
			iDestHeight = iSrcHeight
		Case 270, -90
			iType = 3
			iDestWidth = iSrcHeight
			iDestHeight = iSrcWidth
	EndSelect

	; create 24/32 bit destination image
	nDestImage = CreateImage(#PB_Any, iDestWidth, iDestHeight, iBitPlanes)
	JMP_IF_ZERO (nDestImage, lbl_RotateImage_ERR)

	; copy src image to allocated memory
	*SrcMem = AllocateImageData(nSrcImage, @iBufferPitchSrc)
	JMP_IF_ZERO (*SrcMem, lbl_RotateImage_Alloc_ERR)

	; copy dest image to allocated memory
	*DestMem = AllocateImageData(nDestImage, @iBufferPitchDest)
	JMP_IF_ZERO (*DestMem, lbl_RotateImage_Alloc_ERR)

	Select iBitPlanes
		Case 24
			For iY = 0 To iDestHeight - 1
				For iX = 0 To iDestWidth - 1

					Select iType
						Case 1
							iYs = iSrcHeight - iX - 1
							iXs = iY
						Case 2
							iYs = iSrcHeight - iY - 1
							iXs = iSrcWidth - iX - 1   
						Case 3
							iYs = iX
							iXs = iSrcWidth - iY - 1
					EndSelect

					CopyPixel24 (iXs, iYs, iX, iY, iBufferPitchSrc, iBufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)

				Next
			Next   
		Case 32
			For iY = 0 To iDestHeight - 1
				For iX = 0 To iDestWidth - 1

					Select iType
						Case 1
							iYs = iSrcHeight - iX - 1
							iXs = iY
						Case 2
							iYs = iSrcHeight - iY - 1
							iXs = iSrcWidth - iX - 1   
						Case 3
							iYs = iX
							iXs = iSrcWidth - iY - 1
					EndSelect

					CopyPixel32 (iXs, iYs, iX, iY, iBufferPitchSrc, iBufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)                   

				Next
			Next   
	EndSelect

	CopyImageData(nDestImage, *DestMem)

	FreeMemory(*SrcMem)
	FreeMemory(*DestMem)

	ProcedureReturn nDestImage

	lbl_RotateImage_Alloc_ERR:
	; check if one was successfull and free it
	If *SrcMem <> 0 : FreeMemory(*SrcMem) : EndIf
	If *DestMem <> 0 : FreeMemory(*DestMem) : EndIf

	; image was already created, free it
	FreeImage(nDestImage)

	lbl_RotateImage_ERR:
	ProcedureReturn 0

EndProcedure

Procedure.i RotateImageFree (nSrcImage, fDegRot.f, flgAntiAliasing, iFillColor = $ffffff)

	Protected *tRGBAs.T_RGBA, *tRGBAd.T_RGBA, tPixel.T_RGBA
	Protected *SrcMem, *DestMem, iBufferPitchSrc, iBufferPitchDest
	Protected fzCos.f, fzSin.f
	Protected iSrcWidth, iSrcHeight, iDestWidth, iDestHeight, nDestImage
	Protected iX, iY, iXs, iYs, iXc1, iYc1, iXc2, iYc2, iColor
	Protected iBitPlanes
	Protected XRoundFix, YRoundFix

	; sanity checks
	If IsImage(nSrcImage) = 0
		ProcedureReturn 0
	EndIf

	iBitPlanes = ImageDepth(nSrcImage)

	If iBitPlanes <> 24 And iBitPlanes <> 32
		ProcedureReturn 0
	EndIf

	If fDegRot >= 360.0 ; wrap it
		fDegRot = 360.0 * (fDegRot / 360.0 - Int(fDegRot / 360.0))
	EndIf

	If fDegRot = 0.0 Or fDegRot = 90.0 Or fDegRot = 180.0 Or fDegRot = 270.0
		ProcedureReturn RotateImage(nSrcImage, fDegRot)
	EndIf

	If fDegRot > 270.0
		XRoundFix = -1
		YRoundFix = 0
	ElseIf fDegRot > 180.0
		XRoundFix = -1
		YRoundFix = -1
	ElseIf fDegRot > 90.0
		XRoundFix = 0
		YRoundFix = -1
	EndIf

	CompilerIf (#PB_Compiler_OS = #PB_OS_Linux)
		fDegRot = -fDegRot
	CompilerEndIf

	fzCos = Cos(Radian(fDegRot))
	fzSin = Sin(Radian(fDegRot))

	iSrcWidth = ImageWidth(nSrcImage)
	iSrcHeight = ImageHeight(nSrcImage)

	iDestWidth = Int(iSrcWidth * Abs(fzCos) + iSrcHeight * Abs(fzSin) + 0.9)
	iDestHeight = Int(iSrcHeight * Abs(fzCos) + iSrcWidth * Abs(fzSin) + 0.9)

	iXc1 = iSrcWidth / 2
	iYc1 = iSrcHeight / 2
	iXc2 = iDestWidth / 2
	iYc2 = iDestHeight / 2

	; create 24/32 bit destination image
	nDestImage = CreateImage(#PB_Any, iDestWidth, iDestHeight, iBitPlanes)
	JMP_IF_ZERO (nDestImage, lbl_RotateImageFree_ERR)

	; copy src image to allocated memory
	*SrcMem = AllocateImageData (nSrcImage, @iBufferPitchSrc)
	JMP_IF_ZERO (*SrcMem, lbl_RotateImageFree_Alloc_ERR)

	; copy dest image to allocated memory and fill with backcolor
	*DestMem = AllocateImageData(nDestImage, @iBufferPitchDest, iFillColor)
	JMP_IF_ZERO (*DestMem, lbl_RotateImageFree_Alloc_ERR)

	Select flgAntiAliasing

		Case #False   

			Select iBitPlanes
				Case 24

					For iY = 0 To iDestHeight - 1
						For iX = 0 To iDestWidth - 1

							; For each nDestImage point find rotated nSrcImage source point
							iXs = iXc1 + (iX - iXc2) * fzCos + (iY - iYc2) * fzSin + XRoundFix
							iYs = iYc1 + (iY - iYc2) * fzCos - (iX - iXc2) * fzSin + YRoundFix

							If iXs >= 0 And iXs < iSrcWidth  And iYs >= 0 And iYs < iSrcHeight
								; Move valid rotated nSrcImage source points to nDestImage                   
								CopyPixel24 (iXs, iYs, iX, iY, iBufferPitchSrc, iBufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)
							EndIf

						Next
					Next   

				Case 32

					For iY = 0 To iDestHeight - 1
						For iX = 0 To iDestWidth - 1
							; For each nDestImage point find rotated nSrcImage source point
							iXs = iXc1 + (iX - iXc2) * fzCos + (iY - iYc2) * fzSin + XRoundFix
							iYs = iYc1 + (iY - iYc2) * fzCos - (iX - iXc2) * fzSin + YRoundFix

							If iXs >= 0 And iXs < iSrcWidth  And iYs >= 0 And iYs < iSrcHeight
								; Move valid rotated nSrcImage source points to nDestImage                   
								CopyPixel32 (iXs, iYs, iX, iY, iBufferPitchSrc, iBufferPitchDest, *tRGBAs, *tRGBAd, *SrcMem, *DestMem)
							EndIf

						Next
					Next   

			EndSelect

		Case #True
		
			Protected iXs0, iYs0, icr, icg, icb, icr0, icg0, icb0, icr1, icg1, icb1
			Protected fXs.f, fYs.f, fXfs1.f, fYfs1.f
			Protected fXfs1less.f, fYfs1less.f

			Select iBitPlanes

				Case 24

					For iY = 0 To iDestHeight - 1
						For iX = 0 To iDestWidth - 1

							; For each nDestImage point find rotated nSrcImage source point
							fXs = iXc1 + (iX - iXc2) * fzCos + (iY - iYc2) * fzSin + XRoundFix
							fYs = iYc1 + (iY - iYc2) * fzCos - (iX - iXc2) * fzSin + YRoundFix

							; Bottom left coords of bounding floating point rectangle on nSrcImage
							iXs0 = Int(fXs)
							iYs0 = Int(fYs)

							If iXs0 >= 0 And iXs0 <= iSrcWidth -1 And iYs0 >= 0 And iYs0 <= iSrcHeight - 1                       
								fXfs1 = fXs - Int(fXs)
								fYfs1 = fYs - Int(fYs)

								fXfs1less = 1 - fXfs1 - 0.000005 : If fXfs1less < 0 : fXfs1less = 0 : EndIf
								fYfs1less = 1 - fYfs1 - 0.000005 : If fYfs1less < 0 : fYfs1less = 0 : EndIf

								ReadPixel24 (iXs0, iYs0, iBufferPitchSrc, *tRGBAs, *SrcMem)                                                                                                                               
								icr = *tRGBAs\R * fXfs1less
								icg = *tRGBAs\G * fXfs1less
								icb = *tRGBAs\B * fXfs1less

								ReadPixel24 (iXs0 + 1, iYs0, iBufferPitchSrc, *tRGBAs, *SrcMem)
								icr0 = *tRGBAs\R * fXfs1 + icr
								icg0 = *tRGBAs\G * fXfs1 + icg
								icb0 = *tRGBAs\B * fXfs1 + icb

								ReadPixel24 (iXs0, iYs0 + 1, iBufferPitchSrc, *tRGBAs, *SrcMem)
								icr = *tRGBAs\R * fXfs1less
								icg = *tRGBAs\G * fXfs1less
								icb = *tRGBAs\B * fXfs1less

								ReadPixel24 (iXs0 + 1, iYs0 + 1, iBufferPitchSrc, *tRGBAs, *SrcMem)
								icr1 = *tRGBAs\R * fXfs1 + icr
								icg1 = *tRGBAs\G * fXfs1 + icg
								icb1 = *tRGBAs\B * fXfs1 + icb

								; Weight along axis Y
								tPixel\R = fYfs1less * icr0 + fYfs1 * icr1
								tPixel\G = fYfs1less * icg0 + fYfs1 * icg1
								tPixel\B = fYfs1less * icb0 + fYfs1 * icb1                           

								WritePixel24 (tPixel, iX, iY, iBufferPitchDest, *tRGBAd, *DestMem)
							EndIf
						Next
					Next

				Case 32

					Protected ica, ica0, ica1

					For iY = 0 To iDestHeight - 1
						For iX = 0 To iDestWidth - 1

							; For each nDestImage point find rotated nSrcImage source point
							fXs = iXc1 + (iX - iXc2) * fzCos + (iY - iYc2) * fzSin + XRoundFix
							fYs = iYc1 + (iY - iYc2) * fzCos - (iX - iXc2) * fzSin + YRoundFix

							; Bottom left coords of bounding floating point rectangle on nSrcImage
							iXs0 = Int(fXs)   
							iYs0 = Int(fYs)

							If iXs0 >= 0 And iXs0 <= iSrcWidth - 1 And iYs0 >= 0 And iYs0 < iSrcHeight - 1

								fXfs1 = fXs - Int(fXs)
								fYfs1 = fYs - Int(fYs)

								fXfs1less = 1 - fXfs1 - 0.000005 : If fXfs1less < 0 : fXfs1less = 0 : EndIf
								fYfs1less = 1 - fYfs1 - 0.000005 : If fYfs1less < 0 : fYfs1less = 0 : EndIf

								ReadPixel32 (iXs0, iYs0, iBufferPitchSrc, *tRGBAs, *SrcMem)                                                                                                                                                       
								icr = *tRGBAs\R * fXfs1less
								icg = *tRGBAs\G * fXfs1less
								icb = *tRGBAs\B * fXfs1less
								ica = *tRGBAs\A * fXfs1less

								ReadPixel32 (iXs0 + 1, iYs0, iBufferPitchSrc, *tRGBAs, *SrcMem)
								icr0 = *tRGBAs\R * fXfs1 + icr
								icg0 = *tRGBAs\G * fXfs1 + icg
								icb0 = *tRGBAs\B * fXfs1 + icb
								ica0 = *tRGBAs\A * fXfs1 + ica

								ReadPixel32 (iXs0, iYs0 + 1, iBufferPitchSrc, *tRGBAs, *SrcMem)
								icr = *tRGBAs\R * fXfs1less
								icg = *tRGBAs\G * fXfs1less
								icb = *tRGBAs\B * fXfs1less
								ica = *tRGBAs\A * fXfs1less

								ReadPixel32 (iXs0 + 1, iYs0 + 1, iBufferPitchSrc, *tRGBAs, *SrcMem)
								icr1 = *tRGBAs\R * fXfs1 + icr
								icg1 = *tRGBAs\G * fXfs1 + icg
								icb1 = *tRGBAs\B * fXfs1 + icb
								ica1 = *tRGBAs\A * fXfs1 + ica

								; Weight along axis Y
								tPixel\R = fYfs1less * icr0 + fYfs1 * icr1
								tPixel\G = fYfs1less * icg0 + fYfs1 * icg1
								tPixel\B = fYfs1less * icb0 + fYfs1 * icb1
								tPixel\A = fYfs1less * ica0 + fYfs1 * ica1                           

								WritePixel32 (tPixel, iX, iY, iBufferPitchDest, *tRGBAd, *DestMem)
							EndIf           
						Next
					Next           

			EndSelect
	EndSelect

	CopyImageData (nDestImage, *DestMem)

	FreeMemory(*SrcMem)
	FreeMemory(*DestMem)

	ProcedureReturn nDestImage

	lbl_RotateImageFree_Alloc_ERR:
	; check if one was successfull and free it
	If *SrcMem <> 0 : FreeMemory(*SrcMem) : EndIf
	If *DestMem <> 0 : FreeMemory(*DestMem) : EndIf

	; image was already created, free it
	FreeImage(nDestImage)

	lbl_RotateImageFree_ERR:
	ProcedureReturn 0

EndProcedure
; ***********************************************************************************************************

;Return the word currently under the cursor.
Procedure GetScriptHelpIndex(id)
	
	Protected text.s
	
	If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
		
		curPos = ScintillaSendMessage(id, #SCI_GETCURRENTPOS)
		linePos = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, curPos)
		colPos = ScintillaSendMessage(id, #SCI_GETCOLUMN, curPos)
   
		text.s = GOSCI_GetLineText(id, linePos)
		word.s = ""
		
		;get the start of the word
		colPos = colPos + 1
		stPos.i = 1
		nonalpha.i = 0
		
		For a.i = colPos To 1 Step - 1
			m.c = Asc(Mid(text.s, a.i, 1))
			
			Select m.c
					
				Case 'a' To 'z', 'A' To 'Z', '_'
					If nonalpha.i = 0
						stPos.i = a.i
					EndIf
					
				Default
					nonalpha.i = 1
					
			EndSelect
		Next
		
		;get word
		For a.i = stPos.i To Len(text.s)
			m.c = Asc(Mid(text.s, a.i, 1))
			Select m.c
					
				Case 'a' To 'z', 'A' To 'Z', '_'
					word.s = word.s + Chr(m.c)
					
				Default
					If Trim(word.s) <> ""
        		
						found.i = -1
						For k = 0 To ArraySize(Keywords()) - 1
							If Keywords(k) \ Word = word.s And Keywords(k) \ Help <> ""
								found = k
								Break
							EndIf
						Next
        		
						ProcedureReturn found
					EndIf
					
			EndSelect
		Next
	EndIf
	
	found.i = -1
	For k = 0 To ArraySize(Keywords()) - 1
		If Keywords(k) \ Word = word.s And Keywords(k) \ Help <> ""
			found = k
			Break
		EndIf
	Next
	
	ProcedureReturn found
	
EndProcedure
