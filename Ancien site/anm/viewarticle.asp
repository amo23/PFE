<!-- #include file="incSystem.asp" -->
<!-- #include file="incViewArticle.asp" -->
<!-- #include file="incGetThumbnail.asp" -->
<%
lvl=validate(0)
set conn=server.createobject("ADODB.Connection")
conn.open connection
articleid=request("articleid")
if articleid="" or not(isnumeric(articleid)) then response.redirect "logout.asp"

psql="select * from vArticlesZones where articleid="&articleid
if pblaccess<>"" and lvl=0 then psql=psql & " and publisherid="&usrid
set rs=conn.execute(psql)
if rs.eof then response.redirect "logout.asp"
headline=rs("headline")
zonename=rs("zonename")
startdate=rs("startdate")
enddate=rs("enddate")
posted=rs("posted")
lastupdate=rs("lastupdate")
articleurl=rs("articleurl")
article=rs("article")
summary=replace(rs("summary")&"",vbcrlf,"<br>")
publisherid=rs("publisherid")
zonetemplate=rs("template")
status=rs("status")
clicks=rs("clicks")
zoneid=request("zoneid")
if zoneid="" then zoneid=rs("zoneid")
do until rs.eof
	if rs("zoneid")-zoneid=0 then zonename=rs("zonename")&" ("&rs("template")&")"
	zones=zones &"<a href='viewarticle.asp?articleid="&articleid&"&zoneid="&rs("zoneid")&"'>"& rs("zonename")&"</a><br>"
	rs.movenext
loop
rs.close
set rs=nothing

if lcase(right(zonetemplate,4))=".asp" then isasp=server.urlencode(zonetemplate) else isasp=""


publisher=""
if publisherid<>"" and isnumeric(publisherid) then
	psql="select * from Publishers where publisherid="&publisherid
	set rs=conn.execute(psql)
	if not(rs.eof) then
		publisher=rs("name")
		if pblusers="" or lvl>0 then publisher="<a href='viewpublisher.asp?publisherid="&publisherid&"'>"&publisher&"</a>"
		editable=0
		if lvl=0 then
			if usrid=rs("publisherid") then editable=1
		else
			editable=1
		end if
	end if
	rs.close
	set rs=nothing
end if
conn.close
set conn=nothing

'/// Archive Access ?
if status="4" and (lvl<1 or archiveaccess="") then response.redirect "logout.asp"

if publisher="" then
	publisher="No Publisher Found"
	if lvl>0 then editable=1 else editable=0
end if
delimage=request("delimage")
if editable=1 and delimage="1" then
	call deleteimage(articleid)
end if
tnimage=gettnimage(articleid,"left")

'/// Only Admins Can Change Status
if onlyadmins<>"" and status<>2 and lvl=0 then editable=0
%>
<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function viewarticle(){
	articlepreview=window.open('anmviewer.asp?a=<%=articleid%>&z=<%=zoneid%>&nocache=true');
}

function confirmupdate(what){
	// update status
	<%if lvl>0 then%>
	if (confirm('Change the status for this article?')){
		document.statusimg.src='updatestatus.asp?articleid=<%=articleid%>&status=' + what;
		document.body.focus();
	}
	<%end if%>
}
</script>
</head>

<body topmargin="3" onLoad="javascript:Layer1.style.display='none';">
<div id="Layer1" style="position:absolute; left:20%; top:20%; width:60%; height:20%; z-index:1; background-color: #99CC00; layer-background-color: #99CC00; border: 1px none #000000; visibility: visible"> 
  <div align="center"> 
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <p><font size="4" color="#FFFFFF" face="Arial, Helvetica, sans-serif"><b>Loading, 
      Please Wait...</b></font></p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
  </div>
</div>
<table width="96%" border="0" cellspacing="2" cellpadding="2" align="center" bgcolor="#FFFFFF">
  <tr bgcolor="#FFFFFF"> 
    <td colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="24%"><font size="2" face="Arial, Helvetica, sans-serif"><b><img src="images/icArticle.gif" width="20" height="16" align="absmiddle"> 
            View Article</b></font> </td>
          <td width="76%"> <div align="right"> 
              <%if editable=1 then%>
              <a href="editarticle1.asp?articleid=<%=articleid%>"><img src="images/btnEditArticle2.gif" width="114" height="18" alt="Edit Article" border="0" hspace="1"></a><a href="editarticle2.asp?articleid=<%=articleid%>"><img src="images/btnArticleFiles.gif" width="114" height="18" border="0" alt="Article Files" hspace="1"></a><a href="related.asp?articleid=<%=articleid%>"><img src="images/btnRelated.gif" width="114" height="18" border="0" alt="Related Article"></a><a href="search.asp?kill=<%=articleid%>"><img src="images/btnDeleteArticle.gif" width="114" height="18" border="0" alt="Delete This Article" hspace="1"></a> 
              <%end if%>
            </div></td>
        </tr>
      </table> </td>
  </tr>
  <tr> 
    <td colspan="4" bgcolor="#666666"></td>
  </tr>
  <tr> 
    <td colspan="4" bgcolor="#003399"><b><font color="#FFFFFF" size="3" face="Arial, Helvetica, sans-serif">Article 
      Properties</font></b></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Headline 
      :</font></b></td>
    <td colspan="3" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=headline%></b></font></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Article 
      ID :</font></b></td>
    <td colspan="3" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="4"><b><%=articleid%></b></font></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Zones 
      :</font></b></td>
    <td colspan="3" bgcolor="#F5F5F5"><font face="Arial, Helvetica, sans-serif" size="2"><%=zones%><font size="1">Click on a Zone To preview the article using 
      that zone's template</font></font></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Views 
      : </font></b></td>
    <td colspan="3" bgcolor="#F5F5F5"><b><font face="Arial, Helvetica, sans-serif" size="2"><%=clicks%></font></b></td>
  </tr>
  <tr align="left" valign="top"> 
    <td colspan="4" bgcolor="#666666"></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Posted 
      </font></b><b><font size="2" face="Arial, Helvetica, sans-serif"> :</font></b></td>
    <td width="25%" bgcolor="#F5F5F5"><font face="Arial, Helvetica, sans-serif" size="2"><%=revertdate(posted)%></font></td>
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Start 
      Date </font> <font size="2" face="Arial, Helvetica, sans-serif">:</font></b></td>
    <td width="25%" bgcolor="#F5F5F5"><font face="Arial, Helvetica, sans-serif" size="2"><%=revertdate(startdate)%></font></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Last 
      Updated</font> <font size="2" face="Arial, Helvetica, sans-serif">:</font></b></td>
    <td width="25%" bgcolor="#F5F5F5"><font face="Arial, Helvetica, sans-serif" size="2"><%=revertdate(lastupdate)%></font></td>
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">End 
      Date </font> <font size="2" face="Arial, Helvetica, sans-serif">:</font></b></td>
    <td width="25%" bgcolor="#F5F5F5"><font face="Arial, Helvetica, sans-serif" size="2"><%=revertdate(enddate)%></font></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Status 
      :</font></b></td>
    <td width="25%" bgcolor="#F5F5F5"><font size="2" face="Arial, Helvetica, sans-serif"><b><font face="Arial, Helvetica, sans-serif" size="2">
      <select name="status" onchange="javascript:confirmupdate(this.value);" <%if lvl=0 then response.write "disabled"%>>
        <option value="1" <%if status="1" then response.write "selected"%>><%=whichstatus(1)%></option>
        <option value="2" <%if status="2" then response.write "selected"%>><%=whichstatus(2)%></option>
        <option value="3" <%if status="3" then response.write "selected"%>><%=whichstatus(3)%></option>
		<%if archiveaccess<>"" and lvl>0 then%><option value="4" <%if status="4" then response.write "selected"%>><%=whichstatus(4)%></option><%end if%>
      </select>
      <b><font face="Arial, Helvetica, sans-serif" size="2"><b><font face="Arial, Helvetica, sans-serif" size="2"><img src="images/<%=whichstatus(status)%>.gif" name="statusimg" align="absmiddle" id="statusimg"></font></b></font></b> 
      </font></b></font></td>
    <td width="25%" bgcolor="#CCCCCC"><b><font size="2" face="Arial, Helvetica, sans-serif">Publisher 
      :</font></b></td>
    <td width="25%" bgcolor="#F5F5F5"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=publisher%></b></font></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Direct 
      Link URL :</b></font></td>
    <td colspan="3" bgcolor="#F5F5F5"><font face="Arial, Helvetica, sans-serif"><a href="<%=applicationurl%>/anmviewer.asp?a=<%=articleid%>&z=<%=zoneid%>" target="_blank"><font size="2"><%=applicationurl%>anmviewer.asp?a=<%=articleid%>&amp;z=<%=zoneid%></font></a><br>
      <font size="1">You can use this URL to directly link to this article from 
      your web pages.</font></font></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#CCCCCC"><font face="Arial, Helvetica, sans-serif" size="2"><b>Article 
      Thumbnail :</b></font></td>
    <td colspan="3" bgcolor="#F5F5F5"> <table width="100%" border="0" cellspacing="2" cellpadding="0">
        <tr> 
          <td> <div id="logo"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=tnimage%></b></font></div></td>
          <td> <%if editable=1 then%> <input type="button" value="Upload" name="Button" onClick="javascript:upload();"> 
            <input type="button" value="Delete" name="Button2" onClick="javascript:self.location='viewarticle.asp?articleid=<%=articleid%>&delimage=1';"> 
            <script language="JavaScript">
function upload(){
	window.open('uploadthumbnail.asp?articleid=<%=articleid%>','','width=480,height=200,status=yes,toolbar=no,scrollbars=yes,resizable=yes,navbar=no');
}

function writediv(what){
	document.all.logo.innerHTML=what;
}
</script> <%end if%> </td>
        </tr>
      </table></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#666666"><font size="4" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b>Summary 
      : </b></font></td>
    <td colspan="3" bgcolor="#F5F5F5"><font face="Arial, Helvetica, sans-serif" size="2"><%=summary%></font></td>
  </tr>
  <%if articleurl<>"" then%>
  <tr align="left" valign="top"> 
    <td width="25%" bgcolor="#666666"><font size="4" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b>Article 
      URL : </b></font></td>
    <td colspan="3" bgcolor="#F5F5F5"><a href="<%=articleurl%>" target="_blank"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=articleurl%></b></font></a></td>
  </tr>
  <%end if%>
</table><br>
<%if articleurl="" and article<>""then%>
<table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#003399">
  <tr> 
    <td height="40" width="98%"><b><font face="Tahoma, Arial, Verdana" size="2" color="#FFFFFF">Article 
      Preview - As seen on your site using the template file from zone : <%=zonename%></font></b></td>
    <td height="40" width="2%"><a href="javascript:viewarticle();"><img src="images/btnView.gif" width="27" height="27" alt="Preview Article" border="0"></a></td>
  </tr>
</table>
</body>
</html>
<%if isasp="" then call anmviewarticle(articleid,zoneid)
end if%>