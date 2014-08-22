<!-- #include file="incSystem.asp" -->
<%
lvl=validate(1)
set conn=server.createobject("ADODB.Connection")
conn.open connection
reload=request("reload")
kill=request("kill")
if kill<>"" and lvl=2 then
	psql="delete from plugins where pluginid="&kill
	conn.execute(psql)
	reload=1
end if
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">
<%if reload=1 then response.write "parent.topmenu.location.href='topmenu.asp';"%>
function deleteplugin(pluginid){
	if (confirm('Remove this plugin reference?\nThe Plugin files still need to be removed manually')){
		self.location='plugins.asp?kill=' + pluginid;
	}
}


function notallowed(term){
	alert('You\'re not allowed to ' + term + ' this plugin');
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="90%" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr valign="top"> 
    <td colspan="5" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/imgPlugins.gif" width="19" height="20" align="absmiddle"> 
            Plugin Manager</b></font></td>
          <td align="right"> 
            <%if lvl=2 then%><a href="editplugin.asp"><img src="images/btnRegisterPlugin.gif" width="114" height="18" alt="Register Plug-In" border="0"></a><%end if%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr valign="top" bgcolor="#666666"> 
    <td colspan="5" align="left"></td>
  </tr>
  <tr valign="top"> 
    <td width="8%" align="left" bgcolor="#003399" valign="middle"> 
      <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">#</font></b></div>
    </td>
    <td width="68%" align="left" bgcolor="#003399" valign="middle"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Plugin 
      Name / Description</font></b></td>
    <td width="8%" align="left" bgcolor="#003399" valign="middle"> 
      <div align="center"><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF"><b>Run</b></font></div>
    </td>
    <td width="8%" align="left" bgcolor="#003399" valign="middle"> 
      <div align="center"><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b> 
        Edit</b></font></div>
    </td>
    <td width="8%" align="left" bgcolor="#003399" valign="middle"> 
      <div align="center"><b><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif">Delete</font></b></div>
    </td>
  </tr>
  <%
	psql="select * from plugins order by pplname asc;"
	set rs=conn.execute(psql)
	if not(rs.eof) then
   do until rs.eof
   cc=cc+1
   pluginid=rs("pluginid")
   pplname=rs("pplname")
   pplfile=rs("pplfile")
   ppldescription=rs("ppldescription")
   if lvl<2 then
   		img="0"
		editable="javascript:notallowed('edit');"
		deleteable="javascript:notallowed('delete');"
	else
		img=""
		editable="editplugin.asp?pluginid=" & pluginid
		deleteable="javascript:deleteplugin("&pluginid&")"
	end if
  	

%>
  <tr valign="top" bgcolor="#F3F3F3"> 
    <td width="8%" align="left"> 
      <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif"><%=cc%>.</font></b></div>
    </td>
    <td width="68%" align="left"><a href="<%=pplfile%>"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=pplname%></b></font></a><font face="Arial, Helvetica, sans-serif"><br>
      <font size="1">- Description : <%=replace(""&ppldescription,vbcrlf,"<br>")%></font></font></td>
    <td width="8%" align="center" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><a href="<%=pplfile%>"><img src="images/btnLoad.gif" width="27" height="27" border="0" alt="Run Plug-In"></a> 
      </font> </td>
    <td width="8%" align="center" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><a href="<%=editable%>"><img src="images/btnEdit<%=img%>.gif" width="27" height="27" alt="Edit Plug-In" border="0"></a> 
      <br>
      </font></td>
    <td width="8%" align="center" valign="top"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="<%=deleteable%>"><img src="images/btnKill<%=img%>.gif" width="27" height="27" alt="Delete plug-in" border="0"></a></font></td>
    <%rs.movenext
  loop
  else%>
  <tr valign="top"> 
    <td colspan="5" align="left"> 
      <div align="center"> 
        <p>&nbsp;</p>
        <p><font size="2" color="#FF0000" face="Arial, Helvetica, sans-serif"><b><br>
          There are no plugins registered<br>
          </b></font></p>
        <p><font size="2" color="#FF0000" face="Arial, Helvetica, sans-serif"><b><br>
          <%if lvl=2 then%>
          <a href="editplugin.asp"><img src="images/btnRegisterPlugin.gif" width="114" height="18" alt="Register Plug-In" border="0"></a> 
          <%end if%>
          </b></font></p>
        <p>&nbsp;</p>
      </div>
    </td>
  </tr>
  <%end if%>
</table>
</body>
</html>
<%
rs.close
set rs=nothing
conn.close
set conn=nothing
%>


