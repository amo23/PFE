<!--#include file="incSystem.asp" -->
<%
lvl=validate(2)
response.flush
on error resume next
Function CompactDB(dbPath)
	Dim fso, Engine, strDBPath
	strDBPath = left(dbPath,instrrev(DBPath,"\"))
	Set fso = CreateObject("Scripting.FileSystemObject")
	If fso.FileExists(dbPath) Then
		Set Engine = CreateObject("JRO.JetEngine")
		Engine.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbpath, "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDBPath & "temp.mdb"
		fso.CopyFile strDBPath & "temp.mdb",dbpath
		fso.DeleteFile(strDBPath & "temp.mdb")
		Set fso = nothing
		Set Engine = nothing
	End If
End Function
%>
<html>
<head>
<title>Compact Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<body bgcolor="#999999" text="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="10" marginheight="10">
<table width="96%" border="0" cellspacing="0" cellpadding="0" height="100%" align="center">
  <tr>
    <td width="100%" height="100%" align="center" valign="middle"> 
      <p align="center"><font color="#FFFFFF" face="Tahoma, Arial, Verdana" size="2"><b>Compacting 
        Database...</b></font> <br>
        <%
if database<>""  then
	if instr(database,":")=0 then database=server.mappath(database)
	call compactdb(database)
end if
if err.number<>0 then message=err.description else message="Done!"
%>
</p>
      <p align="center"><font face="Tahoma, Arial, Verdana" size="2" color="#FFFF33"><b><%=message%></b></font></p>
      <p align="center"><font face="Tahoma, Arial, Verdana" size="2" color="#FFFFFF"><b><br>
        <input type="submit" name="Submit" value="Close Window" onClick="javascript:self.close()">
        </b></font></p>
</td>
  </tr>
</table>
</body>
</html>
