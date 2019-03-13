#Persistent
#NoTrayIcon 
#SingleInstance, force 
#include %A_ScriptDir%\lib\GUILibrary.ahk 
#include %A_ScriptDir%\lib\shriblib.ahk

;----------------------------------- COORD SETTINGS -------------------------------------------------------------------------------------------------------------
CoordMode, Mouse, Client
DetectHiddenWindows, On
DetectHiddenText, On 
;----------------------------------- INTERNET CONNECTION -------------------------------------------------------------------------------------------------------------
;SHRIB link: https://shrib.com/#N6WHkXcPNHvbrnL1UDhC

sbin := new shrib()
;sbin.postShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC", "derp")

;sleep 2000
;MsgBox % sbin.getShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC")

;pbin := new pastebin()
;pbin.editPaste("8gX2u7Ra", 1, "NEWGAME")
;----------------------------------- INITIAL START UP -------------------------------------------------------------------------------------------------------------
board := [["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""],["","","","","","","","","",""]]

;define turn var, playerpiece var, opponentpiece var 
;turn := "player"
;playerpiece := "X"
;opponentpiece := "O"



;startread variable determines player type 
startread := sbin.getShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC")

if (startread="NEWGAME")
{
	turn := "player"
	playerpiece := "X"
	opponentpiece := "O"
	MsgBox, You are X's
}

else 
{
	sbin.postShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC", "NEWGAME")
	playermove := "NEWGAME"
	turn := "opponent"
	playerpiece := "O"
	opponentpiece := "X"
	MsgBox, You are O's

		;Gui, +resize 
	Gui, Font, s30, Arial
	BuildButtonGrid(0,0,100,100,10,10)
	Gui, Add, Text, x50 y1010 w1000 h40 vPlayerTurn, Player X turn 
	Gui, Show, w1000 h1050, Connect 5

	Loop ;check to see if opponent has moved 
	{
		opponentmove := sbin.getShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC")
		if (playermove = opponentmove)
			continue
		else if (opponentmove = "GAMEOVER")
		{
			MsgBox, %opponentpiece% wins!
			return 
		}
		else if (playermove != opponentmove)
			break 
		sleep 2000
	}

	Loop, Parse, opponentmove, . ;interprets opponent move 
	{
		if A_Index=1
		{
			fy := A_LoopField 
			;MsgBox % fy
		}
		if A_Index=2
		{
			fx := A_LoopField 
			;MsgBox % fx 
		}
	}
	;MsgBox, y:%fy% x:%fx%

	board[fy][fx] := opponentpiece ;places opponent move on board 

	fyprime := BuildCoord(fy) ;converts opponent move to button location
	fxprime := BuildCoord(fx)

	con := ControlsAtPos("Connect 5", fxprime, fyprime) ;finds button at location 
	GuiControl,,%con%, %opponentpiece%  ;places opponent's piece at button location 

	sleep 100
	GuiControl,,Playerturn, Player %playerpiece% turn 
	turn := "player"

	return 

}

;----------------------------------- GUI SETTINGS -------------------------------------------------------------------------------------------------------------
;Gui, +resize 
Gui, Font, s30, Arial
BuildButtonGrid(0,0,100,100,10,10)
Gui, Add, Text, x50 y1010 w1000 h40 vPlayerTurn, Player X turn 
Gui, Show, w1000 h1050, Connect 5



return 

;----------------------------------- GUI CLOSE -------------------------------------------------------------------------------------------------------------
GuiClose:
Process, Close, iexplore.exe 
Process, Close, ielowutil.exe
ExitApp
return 

Esc::
Process, Close, iexplore.exe 
Process, Close, ielowutil.exe
ExitApp 
return  

^q::
InputBox, output, 
sbin.postShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC", output)
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
	turn := "opponent"
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
				sbin.postShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC", "GAMEOVER")
			 	return  
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
			 	return 
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
				sbin.postShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC", "GAMEOVER")
			 	return  
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
			 	return  
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
				sbin.postShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC", "GAMEOVER")
			 	return 
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
			 	return  
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
				sbin.postShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC", "GAMEOVER")
			 	return 
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
			 	return  
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
	  
	sbin.postShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC", playermove)
	GuiControl,,PlayerTurn, Player %opponentpiece% turn
	

;----------------------------------- Opponent Check -------------------------------------------------------------------------------------------------------------
	sleep 5000

	Loop ;check to see if opponent has moved 
	{
		opponentmove := sbin.getShribData("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC")
		if (playermove = opponentmove)
			continue
		else if (opponentmove = "GAMEOVER")
		{
			MsgBox, %opponentpiece% wins!
			reload 
		}
		else if (playermove != opponentmove)
			break 
		sleep 2000
	}

	Loop, Parse, opponentmove, . ;interprets opponent move 
	{
		if A_Index=1
		{
			fy := A_LoopField 
			;MsgBox % fy
		}
		if A_Index=2
		{
			fx := A_LoopField 
			;MsgBox % fx 
		}
	}
	;MsgBox, y:%fy% x:%fx%

	board[fy][fx] := opponentpiece ;places opponent move on board 

	fyprime := BuildCoord(fy) ;converts opponent move to button location
	fxprime := BuildCoord(fx)

	con := ControlsAtPos("Connect 5", fxprime, fyprime) ;finds button at location 
	GuiControl,,%con%, %opponentpiece%  ;places opponent's piece at button location 

	sleep 100
	GuiControl,,Playerturn, Player %playerpiece% turn 
	turn := "player"
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

BuildCoord(ByRef x) {
	xnew := (x*100)-50
	return xnew
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



