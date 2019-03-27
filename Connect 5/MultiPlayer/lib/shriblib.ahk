/* Example: 
pbin := new shrib()
MsgBox % getShribData("link")
*/

;https://shrib.com/#N6WHkXcPNHvbrnL1UDhC

DetectHiddenWindows, On
DetectHiddenText, On 
Class shrib 
{
	__New() {
		this.ie := ComObjCreate("InternetExplorer.Application")
		this.ie.visible := 1
	}

	getShribData(link) {
		if !IsObject(this.ie)
		{
			this.ie := ComObjCreate("InternetExplorer.Application")
			this.ie.visible := 1
		}
		this.ie.navigate(link)
		while this.ie.busy 
			sleep 100
		;return this.ie.document.getElementByID("mainForm").innerhtml
		sleep 1000
		this.ie.execWB(17,0)
		this.ie.execWB(12,0)
		this.output := Clipboard
		;this.ie.refresh
		;this.ie.quit
		;this.ie := ""
		;VarSetCapacity(this.ie, 0)
		;this.closeWin()
		return this.output 
	}
	
	postShribData(link, message) {
		if !IsObject(this.ie)
		{
			this.ie := ComObjCreate("InternetExplorer.Application")
			this.ie.visible := 1
		}
		this.ie.navigate(link)
		while this.ie.busy 
			sleep 100
		sleep 1000
		this.ie.execWB(17,0)
		sleep 500
		clipboard :=
		clipboard := message
		this.ie.execWB(13,0)
		;sleep 500
		;ControlSend, Internet Explorer_Server1, %message%, ahk_class IEFrame
		;this.ie.refresh
		;this.ie.quit
		;this.ie := ""
		;VarSetCapacity(this.ie, 0)
		;this.closeWin()
	}

	closeWin() {
		WinWait, ahk_class #32770, &Leave this page, 5
		if ErrorLevel 
		{
			return 
		}
		else 
		{
			;MsgBox, window found!
			;WinClose, ahk_class #32770
			ControlSend,, {enter}, ahk_class #32770, &Leave this page
		}
		return 
	}
}