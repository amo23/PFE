<!-- #include file="incSystem.asp" -->
<%
lvl=validate(0)
if lvl=0 and pblusers<>"" then response.redirect "logout.asp"

publisherid=request("publisherid")
set conn=server.createobject("ADODB.Connection")
conn.open connection
'/// Get Publisher Info ///
psql="select * from publishers where publisherid="&publisherid
set rs=conn.execute(psql)
	name=rs("name")
	email=rs("email")
	username=rs("username")
	password=rs("password")
	plevel=whichlevel(rs("plevel"))
	additional=rs("additional")
rs.close
set rs=nothing

'/// Get publisher's Zones ///
psql="select * from vPublishersZones where publisherid="&publisherid
set rs=conn.execute(psql)
do until rs.eof
	zones=zones & rs("zonename")&"<br>"
	rs.movenext
loop
rs.close
set rs=nothing
if zones="" then zones="<b>- No Zones Assigned -</b>"

'/// Get Total Articles ///
psql="SELECT Count(articleid) AS totalarticles FROM articles where publisherid="&publisherid
set rs=conn.execute(psql)
if rs.eof then
	totalarticles="- No Articles Found -"
else
	totalarticles="<a href='search.asp?pblname="&publisherid&"'>"&rs("totalarticles")&"</a>"
end if
rs.close
set rs=nothing



%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<body bgcolor="#FFFFFF" text="#000000">
  
<table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr> 
    <td colspan="2"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="27%"><b><font size="2" face="Arial, Helvetica, sans-serif"><img src="images/icPublishers.gif" width="18" height="20" align="absmiddle"> 
            View User</font></b></td>
          <td align="right" width="73%"> 
            <%if lvl=2 then%>
            <script language="JavaScript">
			function deletepublisher(){
				if (confirm('Delete this publisher?')){
					self.location='publishers.asp?kill=<%=publisherid%>';
				}
			}
			
</script>
            <a href="editpublisher.asp"><img src="images/btnAddPublisher.gif" width="114" height="18" border="0" alt="Register a New Publisher"></a> 
            <a href="editpublisher.asp?publisherid=<%=publisherid%>"> <img src="images/btnEditPublisher.gif" width="114" height="18" alt="Edit Publisher's Info" border="0"></a> 
            <a href="javascript:deletepublisher()"><img src="images/btnDeletePublisher.gif" width="114" height="18" border="0" alt="Delete Publisher"></a> 
            <%end if%>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr valign="top" align="left"> 
    <td colspan="2" bgcolor="#666666"></td>
  </tr>
  <tr valign="top" align="left" bgcolor="#000099"> 
    <td width="28%"><b><font size="3" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Name 
      :</font></b></td>
    <td width="72%"><font size="3" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b><%=name%></b></font></td>
  </tr>
  <tr valign="top" align="left"> 
    <td width="28%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>User 
      ID : </b></font></td>
    <td width="72%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><b><%=publisherid%></b></font></td>
  </tr>
  <tr valign="top" align="left"> 
    <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">E-mail 
      :</font></b></td>
    <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
      <a href="mailto:<%=email%>"><%=email%></a></font></b></td>
  </tr>
  <tr valign="top" align="left"> 
    <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Username 
      :</font></b></td>
    <td width="72%" bgcolor="#F3F3F3"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
      <%=username%></font></b></td>
  </tr>
  <tr valign="top" align="left"> 
    <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Level 
      :</font></b></td>
    <td width="72%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
      <%=plevel%></font></td>
  </tr>
  <tr valign="top" align="left"> 
    <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Zones 
      :</font></b></td>
    <td width="72%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><%=zones%></font></td>
  </tr>
  <tr valign="top" align="left"> 
    <td width="28%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Articles 
      Published : </b></font></td>
    <td width="72%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><%=totalarticles%></font></td>
  </tr>
  <tr valign="top" align="left"> 
    <td width="28%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Additional 
      Info :</font></b></td>
    <td width="72%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"><%=replace(""&additional,vbcrlf,"<br>")%></font></td>
  </tr>
  <tr valign="top" align="left"> 
    <td colspan="2" bgcolor="#666666"></td>
  </tr>
</table>
<br>
<%if (pblaccess<>"" and publisherid=usrid) or (pblaccess="") or lvl>0 then%>
<table width="96%" border="0" cellspacing="1" cellpadding="2" align="center" bgcolor="#000099">
  <tr>
    <td><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF"><b>Last 
      10 Articles</b></font></td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF" align="left" valign="top"> 
	<div style="overflow:auto;width:100%;height:240;"> 
        <table width="100%" border="0" cellspacing="1" cellpadding="2">
          <tr bgcolor="#E0E0E0"> 
            <td><b><font face="Arial, Helvetica, sans-serif" size="2">Article</font></b></td>
            <td width="10%" align="center"><b><font face="Arial, Helvetica, sans-serif" size="2">Source</font></b></td>
            <td width="10%" align="center"><b><font face="Arial, Helvetica, sans-serif" size="2">Posted</font></b></td>
            <td width="10%" align="center"><b><font face="Arial, Helvetica, sans-serif" size="2">Updated</font></b></td>
            <td width="10%" align="center"><b><font face="Arial, Helvetica, sans-serif" size="2">Displayed</font></b></td>
            <td width="10%" align="center"><b><font face="Arial, Helvetica, sans-serif" size="2">Status</font></b></td>
            <td width="10%" align="center"><b><font face="Arial, Helvetica, sans-serif" size="2">View</font></b></td>
        </tr>
        <%		
		psql="select * from articles where publisherid="&publisherid
		if archiveaccess="" then psql=psql & " and status<4"
		psql=psql &" order by articleid desc;"
		set rs=conn.execute(psql)
		c=0
		do until rs.eof or c>10
			c=c+1
			articleid=rs("articleid")
			headline=rs("headline")
			summary=server.htmlencode(summary)
			status=whichstatus(rs("status"))
			startdate=revertdate(rs("startdate"))
			enddate=revertdate(rs("enddate"))
			source=rs("source")
			posted=revertdate(rs("posted"))
			lastupdate=revertdate(rs("lastupdate"))
			
		%>
        <tr bgcolor="#F3F3F3"> 
          <td valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><b><a href="viewarticle.asp?articleid=<%=articleid%>"><%=headline%></a></b></font><br>
            <font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=summary%></font></td>
          <td width="10%" valign="top" align="center"><font face="Arial, Helvetica, sans-serif" size="2"><%=source%></font></td>
          <td width="10%" valign="top" align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=posted%></font></td>
          <td width="10%" valign="top" align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=lastupdate%></font></td>
          <td width="10%" align="center" valign="top"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=startdate & "<br>" & enddate%></font></td>
          <td width="10%" align="center" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/<%=status%>.gif" width="27" height="27" alt="<%=status%>"><br>
            <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#666666"><%=status%></font></b></font></td>
          <td width="10%" align="center" valign="top"><a href="viewarticle.asp?articleid=<%=articleid%>"><img src="images/btnView.gif" width="27" height="27" border="0"></a></td>
        </tr>
        <%
		rs.movenext
		loop
		rs.close
		set rs=nothing
		%>
      </table>
	  </div>
    </td>
  </tr>
</table>
<%end if
conn.close
set conn=nothing%>
</body>
</html>
