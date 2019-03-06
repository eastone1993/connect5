#Persistent
#NoTrayIcon 
#SingleInstance, force 
#include %A_ScriptDir%\lib\GUILibrary.ahk 
#include %A_ScriptDir%\lib\pastebin.ahk 

;----------------------------------- COORD SETTINGS -------------------------------------------------------------------------------------------------------------
CoordMode, Mouse, Client

;----------------------------------- INTERNET CONNECTION -------------------------------------------------------------------------------------------------------------
pbin := new pastebin()
;msgbox % Clipboard := pbin.pasteAsGuest("Evan's first paste with AHK", "paste_name", "autohotkey")
;pbin.editPaste("8gX2u7Ra", 1, "3rd paste!")
;sleep 3000
;msgbox % Clipboard := pbin.paste("This is my second paste!", "First Paste")
;msgbox % Clipboard := pbin.getPasteData("https://pastebin.com/8gX2u7Ra")

/*
ie := ComObjCreate("InternetExplorer.Application")
ie.Visible := true 
ie.Navigate("https://shrib.com/1_55nDiq5sKG6glD_NSk")
;ie.document.getelementbyid("igob").value 
*/

;----------------------------------- GLOBAL VARS -------------------------------------------------------------------------------------------------------------
turn := "player"
playerpiece := "X"
opponentpiece := "O"
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
pbin.Quit
ExitApp
return 

Esc::
pbin.Quit
ExitApp 
return  

^q::
MsgBox % Con := ControlsAtPos("Connect 5", 51, 51)
GuiControl,,%con%, "Derp "
return 
;----------------------------------- RELOAD -------------------------------------------------------------------------------------------------------------
^r::
Reload 
return 

;----------------------------------- DEBUG -------------------------------------------------------------------------------------------------------------
^+t::
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
if (turn = "player") ; X player's turn 
{
	/*
	if (board[ypos][xpos] = "X") ;checks to see if space is already taken 
		return 
	if (board[ypos][xpos] = "O") ;checks to see if space is already taken 
		return
	*/
	ControlSetText, %ControlUnder%, %playerpiece% 
	;MsgBox, %ypos% : %xpos%
	board[ypos][xpos] := playerpiece
	playermove := ypos . "." . xpos 
	

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
	pbin.editPaste("8gX2u7Ra", 1, playermove)
	GuiControl,,PlayerTurn, Player %opponentpiece% turn
	turn := "Opponent"

;----------------------------------- Opponent Check -------------------------------------------------------------------------------------------------------------
	sleep 5000

	Loop 
	{
		sleep 2000
		opponentmove := pbin.getPasteData("https://pastebin.com/8gX2u7Ra")
		if (playermove = opponentmove)
			continue
		else if (playermove != opponentmove)
			break 
	}

	;MsgBox % opponentmove 
	movearray := StrSplit(%opponentmove%,.)
	fx := movearray[2]
	fy := movearray[1]
	MsgBox, y:%fy% x:%fx%

}

	
;----------------------------------- O TURN  -------------------------------------------------------------------------------------------------------------
/*
else if (turn = "Opponent")
{
	
;	if (board[ypos][xpos] = "X")
;		return 
;	if (board[ypos][xpos] = "O")
;		return
	
	;MsgBox, %ypos% : %xpos%
	board[ypos][xpos] := "O"
	playermove := ypos . "." . xpos 

	;left right check 
	

	GuiControl,,PlayerTurn, Player %playerpiece% turn
	turn := "Player"

}	
*/	
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



