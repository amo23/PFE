<!--#include file="incSystem.asp" -->
<%
lvl=validate(0)
articleid=request("articleid")

set conn=server.createobject("ADODB.Connection")
conn.open connection

%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">
function passfile(what){
	parent.selectImage(what);
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" rightmargin="0" bottommargin=0>
<table width="98%" border="0" cellspacing="1" cellpadding="1" align="center">
  <%
	psql="select * from articlefiles where articleid="&articleid&" and filetype='Inline' order by filetitle"
	set rs=conn.execute(psql)
	if not(rs.eof) then
do until rs.eof
		filetitle=rs("filetitle")
		urlfile=rs("urlfile")
		filename=rs("filename")
		if urlfile=0 then filename="./articlefiles/"&articleid&"-"&rs("filename")
		%>
  <tr align="left" valign="top"> 
    <td width="1%" align="center"><font face="Tahoma, Verdana, Arial" size="1">&#149;</font></td>
    <td width="97%"><a href="javascript:passfile('<%=filename%>');"><font face="Tahoma, Verdana, Arial" size="1"><%=filetitle%></font></a></td>
  </tr>
  <%
	rs.movenext
	loop
	else%>
  <tr> 
    <td align="center" valign="middle" colspan="2"> 
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p><font face="Tahoma, Verdana, Arial" size="1"><b><font color="#FF0000">No 
        Inline Files Available</font></b><br>
        To Upload Inline files<br>
        Click the &quot;Images and Files&quot; Button on the &quot;Article Properties&quot; 
        screen. </font></p>
    </td>
  </tr>
  <%end if
rs.close
set rs=nothing%>
</table>
</body>
</html>

