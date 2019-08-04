#Persistent
#NoTrayIcon
#SingleInstance, force 
;#include %A_ScriptDir%\lib\ai.ahk
;----------------------------------- SETTINGS -------------------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------------- GUI SETTINGS -------------------------------------------------------------------------------------------------------------
CoordMode, Mouse, Client 
Gui, Font, s30, Arial
;----------------------------------- GlOBAL VARS -------------------------------------------------------------------------------------------------------------
global board := [["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""]]
global map := [[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0]]
global turn := "X"
;----------------------------------- AUTO-EXECUTION SECTION -------------------------------------------------------------------------------------------------------------
;GUI CONSTRUCTORS
BuildButtonGrid(0,0,100,100,10,10)
Gui, Add, Text, x50 y1010 w1000 h40 vPlayerTurn, Player X turn 
Gui, Show, w1000 h1050, Connect 5

;PLAYER TURN - will determine who goes first
sleep 500
Random, player_turn, 1, 2
if (player_turn = 1)
	player := "X"
else
{ 
	player := "O"
	;AIturn()
}
;MsgBox % player
return 
;----------------------------------- EVENTS -------------------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------------- GUI CLOSE -------------------------------------------------------------------------------------------------------------
Esc::
GuiClose: 
ExitApp 

2GuiClose:
Gui 2: Destroy 
return 
;----------------------------------- CLICK EVENTS -------------------------------------------------------------------------------------------------------------
bclick: ;executes setclick function whenever user clicks in a space
{
	;if(turn = player)
		SetClick()
	return 
}
;----------------------------------- FUNCTIONS -------------------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------------- Click Functions -------------------------------------------------------------------------------------------------------------
SetClick() { ;finds where user clicks --> checks if legal move --> makes the move --> checks for win condition --> changes turn 
	MouseGetPos, UnderX, UnderY, WinUnderHwnd, ControlUnder ;gets mouse position to determine which button was clicked
	;MsgBox %ControlUnder%
	xpos := FindCoord(UnderX) ;converts x position of mouse to grid position 
	ypos := FindCoord(UnderY) ;converts y position of mouse to grid position
	;MsgBox (%xpos%,%ypos%)
	if (board[ypos][xpos] != "")
		return 
	MakeMove(ypos, xpos, ControlUnder)
	CheckWinCondition(ypos, xpos)
	ChangeTurn() 
	;AIturn()
}
FindCoord(ByRef x) { ;translates mouse click in window to corresponding board position 
	xprime := x/100
	xcoord := Round(xprime)
	xsum := xprime - xcoord
	if (xsum > 0)
		xcoord := xcoord +1
	return xcoord
}
ChangeTurn() { ;changes turn and updates turn indicator 
	if(turn = "X")
	{
		turn := "O"
		GuiControl,, PlayerTurn, Player O turn 
		return 
	}
	if(turn = "O")
	{
		turn := "X"
		GuiControl,, PlayerTurn, Player X turn 
		return 
	}
}
MakeMove(ypos, xpos, con) {
	GuiControl ,, %con%, %turn% 
	board[ypos][xpos] := turn	
}
;----------------------------------- CHECK FOR WIN CONDITION -------------------------------------------------------------------------------------------------------------
CheckWinCondition(ypos, xpos) {
	if(LateralCheck(ypos, xpos) = 1) or (VerticalCheck(ypos, xpos) = 1) or (UpperLeftDiagCheck(ypos, xpos) = 1) or (LowerLeftDiagCheck(ypos, xpos) = 1)
	{
		MsgBox %turn% wins!
		reload 
	}
	else if(EmptySpaces() = 0)
	{
		MsgBox Stale Mate!
		reload 
	}
}
LateralCheck(ypos, xpos) {
	if(board[ypos][xpos-1] = turn) or (board[ypos][xpos+1] = turn)
	{
		wincount := 1
		
		Loop
		{
			if(wincount = 5)
				return true
			else if(board[ypos][xpos-A_Index] = turn)
				wincount := wincount + 1
			else 
				break 
		}
		
		Loop 
		{
			if(wincount = 5)
				return true 
			else if(board[ypos][xpos+A_Index] = turn)
				wincount := wincount + 1
			else 
				break 
		}
	}
}
VerticalCheck(ypos, xpos) {
	if(board[ypos-1][xpos] = turn) or (board[ypos+1][xpos] = turn)
	{
		wincount := 1

		Loop 
		{
			if(wincount  = 5)
				return true 
			else if(board[ypos-A_Index][xpos] = turn)
				wincount := wincount + 1
			else 
				break 
		}

		Loop 
		{
			if(wincount = 5)
				return true 
			else if(board[ypos+A_Index][xpos] = turn)
				wincount := wincount + 1
			else 
				break 
		} 
	}
}
UpperLeftDiagCheck(ypos, xpos) {
	if(board[ypos-1][xpos-1] = turn) or (board[ypos+1][xpos+1] = turn)
	{
		wincount := 1

		Loop 
		{
			if(wincount  = 5)
				return true 
			else if(board[ypos-A_Index][xpos-A_Index] = turn)
				wincount := wincount + 1
			else 
				break 
		}

		Loop 
		{
			if(wincount = 5)
				return true 
			else if(board[ypos+A_Index][xpos+A_Index] = turn)
				wincount := wincount + 1
			else 
				break 
		} 
	}	
}
LowerLeftDiagCheck(ypos, xpos) {
	if(board[ypos+1][xpos-1] = turn) or (board[ypos-1][xpos+1] = turn)
	{
		wincount := 1

		Loop 
		{
			if(wincount  = 5)
				return true 
			else if(board[ypos+A_Index][xpos-A_Index] = turn)
				wincount := wincount + 1
			else 
				break 
		}

		Loop 
		{
			if(wincount = 5)
				return true 
			else if(board[ypos-A_Index][xpos+A_Index] = turn)
				wincount := wincount + 1
			else 
				break 
		} 
	}
}
EmptySpaces() {
	empty_spaces := 0
	for index, array in board 
	{
		for index, elem in array 
		{	
			if(elem = "")
				 empty_spaces := empty_spaces + 1
		}
	}
	return empty_spaces 
}
;----------------------------------- BUILD BUTTON GRID -------------------------------------------------------------------------------------------------------------
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
;----------------------------------- DEBUG -------------------------------------------------------------------------------------------------------------
^r:: ;reload script 
{
	Reload 
	return
} 
^+t:: ;display values in boardarray
{
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
}
^+e:: ;display values in map 
{
	Gui 2: Destroy 
	BuildEditGrid(0,0,100,100,10,10)
	Gui 2: Show, w1000 h1000
	return 
}
;----------------------------------- EDIT GRID FOR DEBUG -------------------------------------------------------------------------------------------------------------
BuildEditGrid(ByRef x, ByRef y, ByRef w, ByRef h, ByRef num_columns, ByRef num_rows) {
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
			Gui 2: Add, Edit, %xywh% %bname% ReadOnly -VScroll, % map[rpos][cpos] ;, %bname%
			y0 := (y0 + h0)
			;MsgBox % xywh 
		}
		x0 := (x0 + w0)
		if(y1 < y0)
			y0 := y1
		;MsgBox % xywh
	}
}
;----------------------------------- AI -------------------------------------------------------------------------------------------------------------
AIturn() {
	AIrandomMove()
	CheckWinCondition(col, row)
	ChangeTurn()
}
AIbestMove() {

}
AIrandomMove() {
	Random, rand, 1, EmptySpaces()
	;MsgBox % rand 
	iter := 0
	for index, array in board
	{
		if (iter = rand)
			break 
		row := A_Index 
		for index, elem in array 
		{
			if (iter = rand)
				break 
			col := A_Index 
			if (elem = "")
				iter := iter + 1
		}
	}
	;MsgBox c:%col% r:%row%
	AImove(col, row)
}
AImove(ypos, xpos) {
	ny := BuildCoord(ypos), nx := BuildCoord(xpos), con := ControlsAtPos("Connect 5", nx, ny)
	;MsgBox % con 
	MakeMove(ypos, xpos, con)
}
BuildCoord(ByRef x) {
	xnew := (x*100)-50
	return xnew
}
ControlsAtPos(WinTitle, fx, fy) {
	WinGet, list, ControlListHwnd, %WinTitle%
	loop, parse, list, `n
	{
		ControlGetPos, x, y, w, h, , ahk_id %A_LoopField%
		if (x <= fx && fx <= x+w) && (y <= fy && fy <= y+h)
			ret .= "`n" A_LoopField  
		; controls can overlap, so a single position could theoretically
		;   have more than one control
	}
	return SubStr(ret, 2)
}