#SingleInstance, force 
#Persistent 

DetectHiddenWindows, On
DetectHiddenText, On 

ie := ComObjCreate("InternetExplorer.Application")
ie.visible := 0
ie.navigate("https://shrib.com/#N6WHkXcPNHvbrnL1UDhC")
while ie.busy
	sleep 10
sleep 1000
;ControlSend, Internet Explorer_Server1, help me dagag, ahk_class IEFrame
;sleep 1000
;ControlGetText, output, Internet Explorer_Server1, ahk_class IEFrame
;MsgBox  % output
;WinGetText, output, ahk_class IEFrame 
sleep 500
;MsgBox % output 
ie.execWB(17,0)
ie.execWB(12,0)
MsgBox % Clipboard 
ie.visible := 1
return 

Esc::
Process, Close, iexplore.exe 
Process, Close, ielowutil.exe
ExitApp 