/* Example: 
pbin := new shrib()
MsgBox % getShribData("link")
*/
DetectHiddenWindows, On
DetectHiddenText, On 
Class shrib 
{
	__New() {
		this.ie := ComObjCreate("InternetExplorer.Application")
		this.ie.visible := 0
	}

	getShribData(link) {
		if !IsObject(this.ie)
		{
			this.ie := ComObjCreate("InternetExplorer.Application")
			this.ie.visible := 0
		}
		this.ie.navigate(link)
		while this.ie.busy 
			sleep 100
		;return this.ie.document.getElementByID("mainForm").innerhtml
		sleep 1000
		this.ie.execWB(17,0)
		this.ie.execWB(12,0)
		this.output := Clipboard
		return this.output 
	}
	
	postShribData(link, message) {
		if !IsObject(this.ie)
		{
			this.ie := ComObjCreate("InternetExplorer.Application")
			this.ie.visible := 0
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
	}
}