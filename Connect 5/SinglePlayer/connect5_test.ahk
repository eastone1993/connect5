#Persistent
#NoTrayIcon 
#SingleInstance, force 
#include %A_ScriptDir%\lib\GUILibrary.ahk 

;----------------------------------- COORD SETTINGS -------------------------------------------------------------------------------------------------------------
CoordMode, Mouse, Client

;----------------------------------- GLOBAL VARS -------------------------------------------------------------------------------------------------------------
turn := "x"
board := [["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""]]

;----------------------------------- GUI SETTINGS -------------------------------------------------------------------------------------------------------------
;Gui, +resize 
Gui, Font, s30, Arial
BuildButtonGrid(0,0,100,100,10,10)
Gui, Add, Text, x50 y1010 w1000 h40 vPlayerTurn, Player X turn 
Gui, Show, w1000 h1050, Connect 5

return 

;----------------------------------- GUI CLOSE -------------------------------------------------------------------------------------------------------------
GuiClose:
ExitApp 
;----------------------------------- RELOAD -------------------------------------------------------------------------------------------------------------
^r::
Reload 
return 
;----------------------------------- DEBUG -------------------------------------------------------------------------------------------------------------
Esc::
For index, array in board 
{
	by := A_Index

	for index, element in array 
	{
		bx := A_Index 
		contents := board[by][bx]
		key := by . "." . bx 

		IniWrite, %contents%, board.ini, board, %key% 
	}
}
Run, C:\Windows\Notepad.exe "%A_ScriptDir%\board.ini"
return 

;----------------------------------- CLICK EVENTS -------------------------------------------------------------------------------------------------------------
bclick:
MouseGetPos, UnderX, UnderY, WinUnderHwnd, ControlUnder ;gets mouse position to determine which button was clicked
;MsgBox %ControlUnder%
xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
;MsgBox (%xpos%,%ypos%)

;----------------------------------- X TURN -------------------------------------------------------------------------------------------------------------
if (turn = "X") ; X player's turn 
{
/*
	if (board[ypos][xpos] = "X") ;checks to see if space is already taken 
		return 
	if (board[ypos][xpos] = "O") ;checks to see if space is already taken 
		return
*/
	ControlSetText, %ControlUnder%, X 
	;MsgBox, %ypos% : %xpos%
	board[ypos][xpos] := "X"

	;left right check 
	if (board[ypos][xpos] = board[ypos][xpos-1]) or (board[ypos][xpos] = board[ypos][xpos+1])
	{
		wincount := 1
		;MsgBox % wincount 
		winval := board[ypos][xpos]
		Loop
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos][xpos-1])
			{
				xpos := xpos-1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
		xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
		ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
		Loop 
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos][xpos+1])
			{
				xpos := xpos+1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
	}

	;up down check 
	if (board[ypos][xpos] = board[ypos-1][xpos]) or (board[ypos][xpos] = board[ypos+1][xpos])
	{
		wincount := 1
		;MsgBox % wincount 
		winval := board[ypos][xpos]
		Loop
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos-1][xpos])
			{
				ypos := ypos-1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
		xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
		ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
		Loop 
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos+1][xpos])
			{
				ypos := ypos+1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
	}

	;upper left to bottom right diagnal check
	if (board[ypos][xpos] = board[ypos-1][xpos-1]) or (board[ypos][xpos] = board[ypos+1][xpos+1])
	{
		wincount := 1
		;MsgBox % wincount 
		winval := board[ypos][xpos]
		Loop
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos-1][xpos-1])
			{
				ypos := ypos-1
				xpos := xpos-1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
		xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
		ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
		Loop 
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos+1][xpos+1])
			{
				ypos := ypos+1
				xpos := xpos+1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
	}

	;bottom left to upper right diagonal check 
	if (board[ypos][xpos] = board[ypos+1][xpos-1]) or (board[ypos][xpos] = board[ypos-1][xpos+1])
	{
		wincount := 1
		;MsgBox % wincount 
		winval := board[ypos][xpos]
		Loop
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos+1][xpos-1])
			{
				ypos := ypos+1
				xpos := xpos-1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
		xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
		ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
		Loop 
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos-1][xpos+1])
			{
				ypos := ypos-1
				xpos := xpos+1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
	}
	GuiControl,,PlayerTurn, Player O turn
	turn := "O"
}

;----------------------------------- O TURN  -------------------------------------------------------------------------------------------------------------
else if (turn = "O")
{
	
	/*if (board[ypos][xpos] = "X")
		return 
	if (board[ypos][xpos] = "O")
		return
	*/
	ControlSetText, %ControlUnder%, O
	;MsgBox, %ypos% : %xpos%
	board[ypos][xpos] := "O"

	;left right check 
	if (board[ypos][xpos] = board[ypos][xpos-1]) or (board[ypos][xpos] = board[ypos][xpos+1])
	{
		wincount := 1
		;MsgBox % wincount 
		winval := board[ypos][xpos]
		Loop
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos][xpos-1])
			{
				xpos := xpos-1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
		xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
		ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
		Loop 
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos][xpos+1])
			{
				xpos := xpos+1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
	}

	;up down check 
	if (board[ypos][xpos] = board[ypos-1][xpos]) or (board[ypos][xpos] = board[ypos+1][xpos])
	{
		wincount := 1
		;MsgBox % wincount 
		winval := board[ypos][xpos]
		Loop
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos-1][xpos])
			{
				ypos := ypos-1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
		xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
		ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
		Loop 
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos+1][xpos])
			{
				ypos := ypos+1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
	}

	;upper left to bottom right diagnal check
	if (board[ypos][xpos] = board[ypos-1][xpos-1]) or (board[ypos][xpos] = board[ypos+1][xpos+1])
	{
		wincount := 1
		;MsgBox % wincount 
		winval := board[ypos][xpos]
		Loop
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos-1][xpos-1])
			{
				ypos := ypos-1
				xpos := xpos-1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
		xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
		ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
		Loop 
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos+1][xpos+1])
			{
				ypos := ypos+1
				xpos := xpos+1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
	}

	;bottom left to upper right diagonal check 
	if (board[ypos][xpos] = board[ypos+1][xpos-1]) or (board[ypos][xpos] = board[ypos-1][xpos+1])
	{
		wincount := 1
		;MsgBox % wincount 
		winval := board[ypos][xpos]
		Loop
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos+1][xpos-1])
			{
				ypos := ypos+1
				xpos := xpos-1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
		xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
		ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
		Loop 
		{
			if (wincount = 5)
			{
				MsgBox, %turn% Wins!
			 	reload 
			}
			if (board[ypos][xpos] = board[ypos-1][xpos+1])
			{
				ypos := ypos-1
				xpos := xpos+1
				wincount := wincount+1
				;MsgBox % wincount
			}
			Else
			{
				;wincount := 0
				break 
			}
		}
	}

	GuiControl,,PlayerTurn, Player X turn
	turn := "X"

}	
	
return 

;----------------------------------- FUNCTIONS -------------------------------------------------------------------------------------------------------------
FindCoord(ByRef x) {
	xprime := x/100
	xcoord := Round(xprime)
	xsum := xprime - xcoord
	if (xsum > 0)
		xcoord := xcoord +1
	return xcoord
}

BuildButtonGrid(ByRef x, ByRef y, ByRef w, ByRef h, ByRef num_columns, ByRef num_rows) {
	global 
	local x0, y0, h0, w0, y1 
		
	x0 := x ;x variable for button 
	y0 := y ;starting y variable
	w0 := w ;width of buttons 
	h0 := h ;height of buttons 
	y1 := y 

	
	ncol := num_columns
	nrows := num_rows

	Loop %ncol%
	{
		rpos := A_Index
		;MsgBox, rpos: %rpos%
		Loop %nrows%
		{
			local bname 
			cpos := A_Index 
			;MsgBox, cpos: %cpos%
			bname := "v" . cpos . rpos 
			xywh := "x" . x0 . " y" . y0 . " w" . w0 . " h" . h0
			Gui, Add, Button, %xywh% %bname% gbclick ;, %bname%
			y0 := (y0 + h0)
			;MsgBox % xywh 
		}
		x0 := (x0 + w0)
		if(y1 < y0)
			y0 := y1
		;MsgBox % xywh
	}
}





