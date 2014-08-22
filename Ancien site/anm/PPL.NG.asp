<!-- #include file="incSystem.asp" -->
<%
lvl=validate(1)

mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=15



redim codeline(2),whatcode(2)
whichcode=request("whichcode")
if whichcode="" or not(isnumeric(whichcode)) then whichcode=0
whatcode(0)="Javascript Inject (HTML and Non ASP Pages)"
whatcode(1)="ASP Include Call (Advanced)"
whatcode(2)="ASP.NET User Control (Advanced)"
codeline(0)="<script language=" & chr(34) & "JavaScript"& chr(34) & " src="& chr(34) & applicationurl & "PPL.NG.feed.asp?f=[feedID]" &chr(34) & "></script>"
codeline(1)="<!-- #include file=" & chr(34) & "xlaGC.asp" & chr(34) &" -->"&vbcrlf&"<" &"%=xlagc(" & chr(34) & applicationurl &  "PPL.NG.feed.asp?f=[feedID]" & chr(34) &")%" &">"
codeline(2)="<" & "%@ Register TagPrefix=""xigla"" TagName=""anm"" Src=""xlagc.ascx"" %" &">" & chr(13) & chr(13) & "<xigla:anm runat=""server"" location=" & chr(34) & applicationurl & "PPL.NG.feed.asp?f=[feedID]" & chr(34) &" />"
set conn=server.createobject("ADODB.Connection")
conn.open connection

kill=request("kill")
if kill<>"" and lvl=2 then
	psql="delete from xlaPPLNGfeeds where feedid="&kill
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
function editfeed(feedid){
	self.location='PPL.NG.editfeed.asp?feedid=' + feedid;
}

function deletefeed(feedid){
	if (confirm('Delete this newsfeed?')){
		self.location='PPL.NG.asp?kill=' + feedid;
	}
}

<%else
img="0"%>
function editfeed(feedid){
	alert('This option is only available to administrators');
}

function deletefeed(feedid){
	editfeed(feedid);
}
<%end if%>
function previewfeed(what,whatname){
	window.open("PPL.NG.previewfeed.asp?feedid=" + what + "&feedname=" + whatname,"","toolbar=0,location=0,status=1,menubar=0,scrollbars=1,resizable=1,width=220,height=480");
}

function openpourfeed(what){
	window.open("PPL.NG.pourfeed.asp?feedid=" + what,"","toolbar=0,location=0,status=1,menubar=0,scrollbars=1,resizable=1,width=520,height=380");
}


</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="96%" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr valign="top"> 
    <td colspan="2" align="left"><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="PPL.NG/rss.gif" width="36" height="14" align="absmiddle"> 
      NewsGrabber Feeds</b></font></td>
    <td colspan="5" align="right"> <%if lvl=2 then%>
      <a href="PPL.NG.editfeed.asp"><img src="PPL.NG/btnAddNewsfeed.gif" width="114" height="18" alt="Create a New feed" border="0"></a> 
      <%end if%> </td>
  </tr>
  <tr valign="top"> 
    <td colspan="7" align="left" bgcolor="#666666"></td>
  </tr>
  <tr valign="top"> 
    <td colspan="7" align="left" bgcolor="#F3F3F3"><font size="1" face="Arial, Helvetica, sans-serif">RSS 
      newsfeeds are a way to syndicate content from external sites through XML.<br>
      This plug-in can load those external newsfeeds and add them to your database 
      or render them as your zones.</font></td>
  </tr>
  <tr valign="top"> 
    <td colspan="7" align="left" bgcolor="#666666"></td>
  </tr>
  <tr valign="top"> 
    <td colspan="7" align="left" bgcolor="#CCCCCC"><b><font face="Arial, Helvetica, sans-serif" size="2">Code 
      Type : 
      <select name="whichcode" onchange="self.location.href='PPL.NG.asp?whichcode=' + this.value;" style="font-size:9px">
        <%for x=0 to ubound(codeline)
	  	if x-whichcode=0 then sel=" selected" else sel=""
		response.write "<option value="&x&sel&">"&whatcode(x)&"</option>"
	  next%>
      </select>
      </font></b></td>
  </tr>
  <tr valign="top"> 
    <td width="5%" align="left" valign="middle" bgcolor="#003399"> 
      <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">#</font></b></div></td>
    <td align="left" bgcolor="#003399" valign="middle"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Newsfeed 
      / Description </font></b></td>
    <td width="20%" align="left" bgcolor="#003399" valign="middle"> 
      <div align="center"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">Code 
        for Newsfeed</font></b></div></td>
    <td width="8%" align="center" bgcolor="#003399" valign="middle"><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF"><b>Preview</b></font></td>
    <td width="8%" align="center" bgcolor="#003399" valign="middle"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><b>Pour 
      to Database</b></font></td>
    <td width="8%" align="left" bgcolor="#003399" valign="middle"><div align="center"><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"><b>Edit</b></font></div></td>
    <td width="8%" align="left" bgcolor="#003399" valign="middle"><div align="center"><b><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif">Delete</font></b></div></td>
  </tr>
  <%psql="select * from xlaPPLNGfeeds order by feedname asc;"
	set rs=server.createobject("ADODB.Recordset")
	rs.open psql,conn,1 
	if not(rs.eof) then 
		maxval=rs.recordcount
		rs.movefirst
		rs.pagesize=mypagesize
		maxcount=cint(rs.pagecount)
		rs.absolutepage=mypage
		howmanyrecs=0
		howmanyfields=rs.fields.count-1
		cc=(mypagesize*mypage)-mypagesize
		do until rs.eof or howmanyrecs>=rs.pagesize
			cc=cc+1
			feedid=rs("feedid")
			feedname=rs("feedname")
			feedurl=rs("feedurl")
			description=rs("description")
			articlespz=rs("articlespz")
			lastpourdate=rs("lastpourdate")
			allowpouring=rs("allowpouring")
			articlespz=rs("articlespz")
   			if articlespz=0 then articlespz="Show All"
			if allowpouring<>"" then 
				lastpourdate="<br> - Last saved to DB : " & lastpourdate
				allowpouring=""
				pourlink="javascript:openpourfeed(" & feedid & ");"
			else
				lastpourdate=""
				allowpouring="0"
				pourlink="javascript:alert('This newsfeed cannot be poured to the database due to its configuration');"
			end if
%>
  <tr valign="top"> 
    <td width="5%" align="left" bgcolor="#F3F3F3"> <div align="right"><b><font size="2" face="Arial, Helvetica, sans-serif"><%=cc%>.</font></b></div></td>
    <td align="left" bgcolor="#F3F3F3"><a href="PPL.NG.editfeed.asp?feedid=<%=feedid%>"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=feedname%></b></font></a><font face="Arial, Helvetica, sans-serif"><br>
      <font size="1">- Headlines : <%=articlespz%><br>
      - Source URL : <a href="<%=feedurl%>" target="_blank"><%=left(feedurl,50) & "..."%></a><%=lastpourdate%><br>
      - Description : <%=replace(""&rs("description"),vbcrlf,"<br>")%></font></font><font size="1">&nbsp;</font></font></td>
    <td width="20%" align="center" valign="top" bgcolor="#F3F3F3"> 
      <textarea name="code" cols="40" readonly rows="4" style="font-family: Verdana; font-size: 8pt; border: 1 solid #000000"><%=replace(codeline(whichcode),"[feedID]",rs("feedid"))%></textarea> 
    </td>
    <td width="8%" align="center" valign="top" bgcolor="#F3F3F3"> <br> <a href="javascript:previewfeed(<%=feedid%>,'<%=replace(feedname,"'","\'")%>')"><img src="PPL.NG/btnView.gif" width="27" height="27" border="0" alt="Click Preview This feed"></a> 
    </td>
    <td width="8%" align="center" valign="top" bgcolor="#F3F3F3"><br>
      <a href="<%=pourlink%>"><img src="PPL.NG/btnPour<%=allowpouring%>.gif" width="27" height="27" border="0"></a></td>
    <td width="8%" align="center" valign="top" bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif" size="2"><a href="javascript:editfeed(<%=feedid%>);"><br>
      <img src="PPL.NG/btnEdit<%=img%>.gif" width="27" height="27" alt="Edit feed" border="0"></a> 
      <br>
      </font></td>
    <td width="8%" align="center" valign="top" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="javascript:deletefeed(<%=feedid%>)"><br>
      <img src="images/btnKill<%=img%>.gif" width="27" height="27" alt="Delete feed" border="0"></a></font></td>
    <%rs.movenext
	  howmanyrecs=howmanyrecs+1
	loop%>
  <tr valign="top"> 
    <td colspan="7" align="left" bgcolor="#666666"></td>
  </tr>
  <tr valign="top"> 
    <td colspan="7" align="left"><b><font face="Arial, Helvetica, sans-serif" size="2"> 
      Page : 
      <select name="pageselector" onchange="javascript:gopage(this.value);">
        <%for counter=1 to maxcount
		if counter-mypage=0 then sel=" selected" else sel=""
			response.write "<option value="&counter&sel&">"&counter&"</option>"
		next
		%>
      </select>
      of <%=maxcount%> 
      <script language="JavaScript">
	  function gopage(what){
	  	self.location.href='PPL.NG.asp?whichpage=' + what;
	  }
	  </script>
      </font></b></td>
  </tr>
 <%end if
   rs.close
  set rs=nothing
  conn.close
  set conn=nothing%>
</table>
</body>
</html>


