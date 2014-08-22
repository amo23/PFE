<!--#include file="configdata.asp"-->
<%
'/// Add Files To My Box
imageid=request("imageid")
mybox=request.cookies("xlaAIG_box")("mybox")&""
if imageid<>"" and enablemybox<>"" then
	if instr(","&mybox&",",","&imageid&",")<>0 then
		mybox=replace(","&mybox&",",","&imageid&",",",")
		mybox=mid(mybox,2,len(mybox)-2)
		boximage="images/btnMyBoxOff.gif"
	else
		if mybox="" then mybox="0"
		mybox=mybox & ","&imageid
		boximage="images/btnMyBoxOn.gif"
	end if
	response.cookies("xlaAIG_box")("mybox")=mybox
	response.cookies("xlaAIG_box").expires=date+365
	response.redirect boximage
end if
%>


