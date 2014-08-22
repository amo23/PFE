<!-- #include file="incSystem.asp" -->
<%
lvl=validate(0)
redim codeline(1),whatcode(1)
whichcode=request("whichcode")
if whichcode="" or not(isnumeric(whichcode)) then whichcode=0
whatcode(0)="Javascript Inject (HTML and Non ASP Pages)"
whatcode(1)="ASP Include Call (Advanced)"
codeline(0)="<script language=" & chr(34) & "JavaScript"& chr(34) & " src="& chr(34) & applicationurl & "xlaabsolutenm.asp?z=[ZONEID]" &chr(34) & "></script>"
codeline(1)="<!-- #include file=" & chr(34) & "xlaGC.asp" & chr(34) &" -->"&vbcrlf&"<" &"%=xlagc(" & chr(34) & applicationurl &  "xlaabsolutenm.asp?z=[ZONEID]" & chr(34) &")%" &">"
set conn=server.createobject("ADODB.Connection")
conn.open connection

kill=request("kill")
if kill<>"" and lvl=2 then
	psql="delete from zones where zoneid="&kill
	conn.execute(psql)
	'/// Delete Attachments ///
	psql="select articleid from articles where articleid not in (select articleid from iArticlesZones)"
	set rs=conn.execute(psql)
	do until rs.eof
		call deletefiles(rs("articleid"))
		rs.movenext
	loop
	rs.close
	set rs=nothing
	
	psql="delete from articles where articleid not in (select articleid from iArticlesZones)"
	conn.execute(psql)
end if

%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">
<%if lvl=2 then
img=""%>
function editzone(zoneid){
	self.location='editzone.asp?zoneid=' + zoneid;
}

function deletezone(zoneid){
	if (confirm('Delete this zone?')){
		self.location='zones.asp?kill=' + zoneid;
	}
}

<%else
img="0"
%>
function editzone(zoneid){
	alert('This option is only available to administrators');
}

function deletezone(zoneid){
	editzone(zoneid);
}
<%end if%>
function previewzone(what,whatname){
	window.open("previewzone.asp?zoneid=" + what + "&zonename=" + whatname,"","toolbar=0,location=0,status=1,menubar=0,scrollbars=1,resizable=1,width=220,height=480")
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr valign="top"> 
    <td colspan="7" align="left"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/icZones.gif" width="20" height="19" align="absmiddle"> 
            Headlines Zones </b></font></td>
          <td align="right"> <%if lvl=2 then%> <a href="editzone.asp"><img src="images/btnZone2.gif" width="114" height="18" alt="Create a New Zone" border="0"></a> 
            <%end if%> </td>
        </tr>
      </table></td>
  </tr>
  <tr valign="top" bgcolor="#666666"> 
    <td colspan="7" align="left"></td>
  </tr>
  <tr valign="top" bgcolor="#F3F3F3"> 
    <td colspan="7" align="left"><font size="1" face="Arial, Helvetica, sans-serif">Zones 
      are the places on your site where you want your latest headlines to be displayed 
      and they are analog to categories.<br>
      For example you may have a Sports section on your site, You may create a 
      zone called SPORTS where the sports news headlines will be shown, then copy 
      and paste its CODE into the pages where you want the sports headlines to 
      be displayed.</font></td>
  </tr>
  <tr valign="top" bgcolor="#666666"> 
    <td colspan="7" align="left"></td>
  </tr>
  <tr valign="top" bgcolor="#CCCCCC"> 
    <td colspan="7" align="left"><b><font face="Arial, Helvetica, sans-serif" size="2">Code 
      Type : 
      <select name="whichcode" onchange="self.location.href='zones.asp?whichcode=' + this.value;" style="font-size:9px">
        <%for x=0 to ubound(codeline)
	  	if x-whichcode=0 then sel=" selected" else sel=""
		response.write "<option value="&x&sel&">"&whatcode(x)&"</option>"
	  next%>
      </select>
      </font></b></td>
  </tr>
  <tr valign="top"> 
    <td width="5%" align="left" bgcolor="#003399"> <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">#</font></b></div></td>
    <td width="35%" align="left" bgcolor="#003399" valign="middle"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Zone 
      Name / Description </font></b></td>
    <td width="36%" align="left" bgcolor="#003399" valign="middle"> <div align="center"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Code 
        for Headlines Zones</font></b></div></td>
    <td width="8%" align="center" bgcolor="#003399" valign="middle"><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF"><b>Preview</b></font></td>
    <td width="8%" align="left" bgcolor="#003399" valign="middle"> <div align="center"><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF"><b>Template</b></font></div></td>
    <td width="8%" align="left" bgcolor="#003399" valign="middle"> <div align="center"><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b>View 
        / Edit</b></font></div></td>
    <td width="8%" align="left" bgcolor="#003399" valign="middle"> <div align="center"><b><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif">Delete</font></b></div></td>
  </tr>
  <%
	psql="select * from zones"
	if lvl=0 and pblaccess<>"" then psql=psql & " where zoneid in (select zoneid from publisherszones where publisherid="&usrid&")"
	psql=psql & " order by zonename asc;"
	set rs=conn.execute(psql)
	if not(rs.eof) then
   do until rs.eof
   cc=cc+1
   template=rs("template")
   articlespz=rs("articlespz")
   if articlespz=0 then articlespz="Show All"
%>
  <tr valign="top" bgcolor="#F3F3F3"> 
    <td width="5%" align="left"> <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif"><%=cc%>.</font></b></div></td>
    <td width="35%" align="left"><a href="editzone.asp?zoneid=<%=rs("zoneid")%>"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=rs("zonename")%></b></font></a><font face="Arial, Helvetica, sans-serif"><br>
      <font size="1">- Template : <a href="templates/<%=template%>" target="_blank"><%=template%></a><br>
      - Headlines : <%=articlespz%><br>
      - Description : <%=replace(""&rs("description"),vbcrlf,"<br>")%></font></font></td>
    <td width="36%" align="center" valign="top"> <textarea name="code" cols="40" readonly rows="4" style="font-family: Verdana; font-size: 8pt; border: 1 solid #000000"><%=replace(codeline(whichcode),"[ZONEID]",rs("zoneid"))%></textarea> 
    </td>
    <td width="8%" align="center" valign="top"> <br> <a href="javascript:previewzone(<%=rs("zoneid")%>,'<%=rs("zonename")%>')"><img src="images/btnPreviewZone.gif" width="27" height="27" border="0" alt="Click Preview This Zone"></a> 
    </td>
    <td width="8%" align="center" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><br>
      <a href="templates/<%=template%>" target="_blank"><img src="images/btnTemplate.gif" width="27" height="27" border="0" alt="View Template"></a> 
      </font> </td>
    <td width="8%" align="center" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><a href="editzone.asp?zoneid=<%=rs("zoneid")%>"><br>
      <img src="images/btnView.gif" width="27" height="27" alt="Edit Zone" border="0"></a> 
      <br>
      </font></td>
    <td width="8%" align="center" valign="top"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="javascript:deletezone(<%=rs("zoneid")%>)"><br>
      <img src="images/btnKill<%=img%>.gif" width="27" height="27" alt="Delete Zone" border="0"></a></font></td>
    <%rs.movenext
  loop%>
  <tr valign="top" bgcolor="#666666"> 
    <td colspan="7" align="left"></td>
  </tr>
  <% else%>
  <tr valign="top"> 
    <td colspan="7" align="left"> <div align="center"> 
        <p>&nbsp;</p>
        <p><font size="2" color="#FF0000" face="Arial, Helvetica, sans-serif"><b><br>
          There are no defined zones<br>
          At least one zone must be defined in order to edit / create articles</b></font></p>
        <p><font size="2" color="#FF0000" face="Arial, Helvetica, sans-serif"><b><br>
          <%if lvl=1 then%>
          <a href="editzone.asp"><img src="images/btnZone2.gif" width="114" height="18" alt="Create a New Zone" border="0"></a> 
          <%end if%>
          </b></font></p>
        <p>&nbsp;</p>
      </div></td>
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

