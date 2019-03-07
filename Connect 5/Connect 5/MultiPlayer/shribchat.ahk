wb := ComObjCreate("InternetExplorer.Application")
wb.Visible := true 
wb.Navigate("https://shrib.com/jFuNbAhbDfYwhLR")
InputBox, name , name
q=0
Gui, Add, Edit, x1 y1 w220 h20 vsubmit
Gui, Show, x131 y91 h172 w210, CHAT
Gui, Add, Button, default gsubmit, Submit
Gui, Add, Edit, x1 w210 h120 vTOTALCHAT
Gui, Submit, nohide
goto LOOP
return
 
SUBMIT:
q=1
Gui, Submit, nohide
GuiControl,, submit, 
sleep 1000
CHATT := name
CHATT .= " says:"
CHATT .= submit
CHATT .= "`n"
CHATT .= wb.document.getelementbyid("igob").value
wb.document.getelementbyid("igob").value := CHATT
GuiControl,, TOTALCHAT, %CHATT%
sleep 3000
q=0
return

LOOP:
loop
{
sleep 2000
if q = 0
{
ding := wb.document.getelementbyid("igob").value
if CHAT != %ding%
{
CHAT := wb.document.getelementbyid("igob").value
GuiControl,, TOTALCHAT, %CHAT%
}
wb.Navigate("https://shrib.com/jFuNbAhbDfYwhLR")
sleep 1000
}
}
 
GuiClose:
wb.Quit
ExitApp
return