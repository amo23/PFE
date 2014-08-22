<!-- #include file="incSystem.asp" -->
<%
lvl=validate(0)
'/// Load Plugins
psql="select * from plugins "
if lvl>0 then 
psql="select * from plugins order by pplname asc;"
set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
do until rs.eof
	plugins=plugins & "<option value='"&rs("pplfile")&"'>"&rs("pplname")&"</option>"
	rs.movenext
loop
rs.close
set rs=nothing
conn.close
if plugins<>"" then plugins="<option value=''> - Select - </option>"&plugins
end if
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" link="#FFFFFF" vlink="#FFFFFF">
<form name="form1" method="post" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td bgcolor="#515151">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" height="50">
          <tr> 
            <td width="39%"><a href="http://www.xigla.com/absolutenm" target="_blank"><img src="images/imgLogo2.gif" width="213" height="31" hspace="40" border="0" alt="Absolute News Manager V1.0 - By Xigla Software"></a></td>
            <td width="61%" align="center"><a href="search.asp" target="main"><img src="images/btnSearch.gif" width="41" height="53" border="0" hspace="1" vspace="1" alt="Search /  View Articles"></a><a href="editarticle1.asp" target="main"><img src="images/btnNewArticle.gif" width="41" height="53" border="0" hspace="1" vspace="1" alt="Create a  New Article"></a><a href="zones.asp" target="main"><img src="images/btnZones.gif" width="41" height="53" border="0" vspace="1" alt="View / Edit  Zones" hspace="1"></a><%if lvl>0 or (lvl=0 and pblusers="") then%><a href="publishers.asp" target="main"><img src="images/btnPublishers.gif" width="41" height="53" alt="View / Edit Publishers" border="0" hspace="1" vspace="1"></a><%end if%><%if lvl>0 then%><a href="plugins.asp" target="main"><img src="images/btnPlugins.gif" width="41" height="53" border="0" alt="Plugins Manager" vspace="1" hspace="1"></a><%if lvl=2 then%><a href="options.asp" target="main"><img src="images/btnOptions.gif" width="41" height="53" border="0" vspace="1" alt="Configuration Settings" hspace="1"></a><%end if%><%end if%><a href="logout.asp" target="main"><img src="images/btnLogout.gif" width="41" height="53" border="0" vspace="1" alt="Log Out" hspace="1"></a></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="1" bgcolor="#FF0000"></td>
    </tr>
    <tr> 

      <td bgcolor="#CC0000" height="12">
<%if plugins<>"" and lvl>0 then%> 
      <table width="61%" border="0" cellspacing="0" cellpadding="0" align="right">
          <tr> 
            <td align="center"> <font size="1" face="Arial, Helvetica, sans-serif"> 
              <script language="JavaScript">
function loadplugin(){
	var plugin=form1.plugins.value;
	if (plugin!='') parent.main.location.href=plugin;
}
</script>
              <font color="#FFFFFF">Installed Plug-Ins : 
              <select name="plugins" style="font-family:arial; font-size:9px" onchange="javascript:loadplugin();">
                <%=plugins%> 
              </select>
              </font></font> </td>
        </tr>
      </table><%end if%>
      </td>
    </tr>
    <tr>
      <td bgcolor="#930000" height="2" align="left"></td>
    </tr>
  </table>
  </form>
</body>
</html>

