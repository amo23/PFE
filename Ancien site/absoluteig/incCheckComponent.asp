<%
Function IsInstalled(strClassString)
	On Error Resume Next
	IsInstalled = False
	Err = 0
	Dim xTestObj
	Set xTestObj = Server.CreateObject(strClassString)
	If 0 = Err Then IsInstalled = True
	Set xTestObj = Nothing
	Err = 0
End Function
%>
