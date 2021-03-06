#NoEnv
SendMode Input
if reroll()
Position := Array[3]

	;Pixel is always relative to the middle of the Diablo III window
  If (Position == 1)
  	Array[1] := Round(Array[1]*DiabloHeight/1440+(DiabloWidth-3440*DiabloHeight/1440)/2, 0)

  ;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
  If Else (Position == 2 || Position == 4)
		Array[1] := Round(Array[1]*(DiabloHeight/1440), 0)

	;Pixel is always relative to the right side of the Diablo III window
	If Else (Position == 3)
		Array[1] := Round(DiabloWidth-(3440-Array[1])*DiabloHeight/1440, 0)

	Array[2] := Round(Array[2]*(DiabloHeight/1440), 0)
}
Reroll()
{
	WinGetPos, , , DiabloWidth, DiabloHeight, Diablo III
	If (D3ScreenResolution != DiabloWidth*DiabloHeight)
	{
		;all needed coordinates to use the Reroll, all coordinates are based on a resolution of 3440x1440 and calculated later to the used resolution
		global Fill := [957, 1121, 2]
		, Transmute := [315, 1106, 2]
		, TopLeftInv := [2753, 748, 3]
		, InvSize := [668, 394, 4]
		, SwitchPages := [180, 180, 4]
		, SwitchPagesLeft
		, SwitchPagesRight
		, Columns := 10
		, Rows := 6
		, SlotX
		, SlotY

		;convert coordinates for the used resolution of Diablo III
		ScreenMode := isWindowFullScreen("Diablo III")
		ConvertCoordinates(Fill)
		ConvertCoordinates(Transmute)
		ConvertCoordinates(TopLeftInv)
		ConvertCoordinates(InvSize)
		ConvertCoordinates(SwitchPages)

		;calculate all other needed coordinates of the base coordinates that where converted into the used Diablo III resolution
		SlotX := Round(InvSize[1]/Columns)
		SlotY := Round(InvSize[2]/Rows)
		TopLeftInv[1] := TopLeftInv[1]+SlotX/2
		TopLeftInv[2] := TopLeftInv[2]+SlotY/2
		SwitchPagesLeft := [Fill[1]-SwitchPages[1], Fill[2]]
		SwitchPagesRight := [Fill[1]+SwitchPages[1], Fill[2]]
	}
	
	If (ColumnCount == 9) && (RowCount >= 6)
	{
		ColumnCount := 0
		RowCount := 0
		Cycles := 0
	}
	If (ColumnCount >= 10) && (RowCount == 4)
	{
		ColumnCount := 0
		RowCount := 0
		Cycles := 0
	}
		{
			RowCount++
			If (RowCount > 5) && (ColumnCount < 9)
			{
				RowCount := 0
				ColumnCount := ColumnCount + ItemSize
			}
		}
		Sleep, 50
		MouseClick, left, Fill[1], Fill[2]
		Sleep, 50
		MouseClick, left, Transmute[1], Transmute[2]
		Sleep, 175
		MouseClick, left, SwitchPagesRight[1], SwitchPagesRight[2]
		Sleep, 50
		MouseClick, left, SwitchPagesLeft[1], SwitchPagesLeft[2]
		Sleep, 50
	}	Until Cycles>=Columns*Rows/ItemSize or GetKeyState("U","P")
}


ConvertCoordinates(ByRef Array)
{
	WinGetPos, , , DiabloWidth, DiabloHeight, Diablo III
	D3ScreenResolution := DiabloWidth*DiabloHeight

 	If (ScreenMode == false)
 	{
		DiabloWidth := DiabloWidth-16
		DiabloHeight := DiabloHeight-39
	}

	Position := Array[3]

	;Pixel is always relative to the middle of the Diablo III window
  If (Position == 1)
  	Array[1] := Round(Array[1]*DiabloHeight/1440+(DiabloWidth-3440*DiabloHeight/1440)/2, 0)

  ;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
  If Else (Position == 2 || Position == 4)
		Array[1] := Round(Array[1]*(DiabloHeight/1440), 0)

	;Pixel is always relative to the right side of the Diablo III window
	If Else (Position == 3)
		Array[1] := Round(DiabloWidth-(3440-Array[1])*DiabloHeight/1440, 0)

	Array[2] := Round(Array[2]*(DiabloHeight/1440), 0)
}

isWindowFullScreen(WinID)
{
   ;checks if the specified window is full screen

	winID := WinExist( winTitle )
	If ( !winID )
		Return false

	WinGet style, Style, ahk_id %WinID%
	WinGetPos ,,,winW,winH, %winTitle%
	; 0x800000 is WS_BORDER.
	; 0x20000000 is WS_MINIMIZE.
	; no border and not minimized
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}