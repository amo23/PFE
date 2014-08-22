<!-- #include file="incSystem.asp" -->
<%
lvl=validate(2)
pluginid=request("pluginid")
if pluginid="" or not(isnumeric(pluginid)) then pluginid=0

set conn=server.createobject("ADODB.Connection")
conn.open connection

'/// Register Plug-In
if request("button")<>"" then
	pplname=request("pplname")
	pplfile=request("pplfile")
	ppldescription=request("ppldescription")
	
	if pplname="" then errormsg="You Must Provide a Name for the Plug-In<br>"
	if pplfile="" then errormsg=errormsg & "No Plug-In File Provided<br>"
	
	if errormsg="" then
		psql="select * from plugins where pluginid="&pluginid
		Set rs = Server.CreateObject("ADODB.Recordset") 
		rs.open psql,conn,1,2
		if rs.eof then rs.addnew
		rs("pplname")=pplname
		rs("pplfile")=pplfile
		rs("ppldescription")=ppldescription
		rs.update
		rs.close
		set rs=nothing
		conn.close
		set conn=nothing
		response.redirect "plugins.asp?reload=1"
	end if
end if

'/// Retrieve Plug-In Info
if pluginid>0 and button="" then
	psql="select * from plugins where pluginid="&pluginid
	set rs=conn.execute(psql)
		pplname=rs("pplname")
		pplfile=rs("pplfile")
		ppldescription=rs("ppldescription")
	rs.close
	set rs=nothing
end if

conn.close
set conn=nothing
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <table width="90%" border="0" cellspacing="2" cellpadding="2" align="center">
    <tr> 
      <td width="27%"><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/imgPlugins.gif" width="19" height="20" align="absmiddle"> 
        Register Plugin</b></font></td>
      <td width="73%">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <%if errormsg<>"" then%>
    <tr> 
      <td colspan="2" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"><b><font color="#FF0000">Error 
        : The Plugin could not be registered <br>
        </font></b><%=errormsg%></font></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <%end if%>
    <tr align="left" valign="top"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Plugin 
        Name :</font></b></td>
      <td width="73%" bgcolor="#F3F3F3"> 
        <input type="text" name="pplname" size="50" value="<%=pplname%>">
        <br>
        <font face="Arial, Helvetica, sans-serif" size="1">Enter a name to identify 
        this Plugin</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Plugin 
        File :</font></b></td>
      <td width="73%" bgcolor="#F3F3F3"> 
        <input type="text" name="pplfile" size="50" value="<%=pplfile%>">
        <br>
        <font face="Arial, Helvetica, sans-serif" size="1">Enter the file to run 
        in order to start the Plugin (.ASP, .HTML)</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Description 
        :</font></b></td>
      <td width="73%" bgcolor="#F3F3F3"> 
        <textarea name="ppldescription" cols="40"><%=ppldescription%></textarea>
        <br>
        <font face="Arial, Helvetica, sans-serif" size="1">Enter an Optional Description 
        for the Plugin</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" bgcolor="#CCCCCC">&nbsp;</td>
      <td width="73%" bgcolor="#F3F3F3"> 
        <input type="submit" name="button" value="Register Plugin">
      </td>
    </tr>
  </table>
</form>
</body>
</html>
