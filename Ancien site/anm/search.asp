<!-- #include file="incSystem.asp" -->
<%
lvl=validate(0)

'//// Receive Search Criteria ////
text=request("text")&""
stext=replace(text,"'","''")

if pblusers="" or lvl>0 then
	pblname=request("pblname")&""
	spblname=replace(pblname,"'","''")
end if

articles=replace(request("articles")&""," ","")
zoneid=request("zoneid")&""
status=request("status")&""
datecriteria=request("datecriteria")
date1=request("date1")
if not(isdate(date1)) then date1=request("year1")&"/"&request("month1")&"/"&request("day1")
date2=request("date2")
if not(isdate(date2)) then date2=request("year2")&"/"&request("month2")&"/"&request("day2")

datecriteria2=request("datecriteria2")
date21=request("date21")
if not(isdate(date21)) then date21=request("year21")&"/"&request("month21")&"/"&request("day21")
date22=request("date22")
if not(isdate(date22)) then date22=request("year22")&"/"&request("month22")&"/"&request("day22")

orderby=request("orderby")

psql="select * from articles where (headline like '%"&stext&"%' or article like '%"&stext&"%' or summary like '%"&stext&"%' or source like '%"&stext&"%') "
if pblaccess<>"" and lvl=0 then psql=psql & " and publisherid="&usrid
if zoneid<>"" then 
	if zoneid="m" then
		psql=psql &" and articleid in (select articleid from iArticlesZones where zoneid in (select zoneid from publisherszones where publisherid="&usrid&"))"
	else
		psql=psql & " and articleid in (select articleid from iArticlesZones where zoneid="&zoneid&")"
	end if
end if

if articles<>"" then
	if isnumeric(replace(articles,",","")) then psql=psql &" and articleid in ("&articles&")"
end if

if pblname<>"" then
	if not(isnumeric(pblname)) then 
		psql=psql & " and publisherid in (select publisherid from publishers where name like '%"&spblname&"%')"
	else
		psql=psql & " and publisherid="&pblname
	end if
end if

if status="4" and (lvl<1 or archiveaccess="") then response.redirect "logout.asp"
if status<>"" then 
	psql=psql & " and status="&status
elseif archiveaccess="" or lvl=0 then
	psql=psql & " and status<4"
end if

if datecriteria<>"" and isdate(date1) and isdate(date2) then
	psql=psql & " and ((startdate>='"&date1&"' and startdate<='"&date2&"') or (enddate>='"&date1&"' and enddate<='"&date2&"') or ((startdate>='"&date1&"' or startdate<='"&date2&"') and enddate='-'))"
end if

if datecriteria2<>"" and isdate(date21) and isdate(date22) then
	psql=psql & " and (lastupdate>='"&date21&"' and lastupdate<='"&date22&"') "
end if

if not(isdate(date1)) then date1=date
if not(isdate(date2)) then date2=date
if not(isdate(date21)) then date21=date
if not(isdate(date22)) then date22=date

if orderby="" then 
	psql=psql & " order by startdate , headline asc"
else
	psql=psql & " order by "&orderby
end if

searchsql=psql


mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=10
scriptname="search.asp?text="&server.urlencode(text)&"&zoneid="&zoneid&"&status="&status&"&datecriteria="&datecriteria&"&date1="&server.urlencode(date1)&"&date2="&server.urlencode(date2)&"&pblname="&server.urlencode(pblname)&"&articles="&server.urlencode(articles)&"&datecriteria2="&datecriteria2&"&date21="&server.urlencode(date21)&"&date22="&server.urlencode(date22)

set conn=server.createobject("ADODB.Connection")
conn.open connection

'/// Delete an Article  ////
kill=request("kill")
if kill<>"" then 
	if lvl>0 then 
		deleteable=1
	else
		psql="select * from articles where articleid="&kill&" and publisherid="&usrid
		set rs=conn.execute(psql)
		if rs.eof then deleteable=0 else deleteable=1
		rs.close
		set rs=nothing
	end if
	
	if deleteable=1 then
		'/// Delete Associated Files ///
		call deletefiles(kill)
		
		'/// Delete article ////	
		psql="delete from articles where articleid="&kill
		conn.execute(psql)
		
		'/// Delete Thumbnail if any
		Set Fs=createobject("scripting.filesystemobject")
		thefile=server.mappath("thumbnails")&"\"&kill &".*"
		if fs.fileexists(thefile) then fs.deletefile thefile
		set fs=nothing
	end if
end if

'/// Delete Expired Articles ///
del=request("del")
if del<>"" and lvl>0 then
	'/// Delete Associated Files ///
	psql="select articleid from articles where status=3"
	set rs=conn.execute(psql)
	do until rs.eof
		call deletefiles(rs("articleid"))
		rs.movenext
	loop
	rs.close
	set rs=nothing

	'/// Delete article ////
	psql="delete from articles where status=3"
	conn.execute(psql)
end if

'/// Is Archives Browsing enabled (Only Admins 6 Editors) ?
if lvl>0 and archiveaccess<>"" then maxstatus=4 else maxstatus=3
%>
<html>
<head>
<title>Search articles</title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
<script language="JavaScript">
function deletearticle(articleid){
	if (confirm('Delete article?')){
		self.location.href='<%=scriptname%>&whichpage=<%=mypage%>&orderby=<%=server.urlencode(orderby)%>&kill=' + articleid;
	}
}

function deleteexpired(articleid){
	if (confirm('This option will delete all the expired articles\nDo you want to continue?')){
		self.location.href='<%=scriptname%>&del=expired';
	}
}

function notallowed(term){
	alert('You\'re not allowed to ' + term + ' this article');
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="search.asp?orderby=<%=server.urlencode(orderby)%>">
  <table width="96%" border="0" cellspacing="1" cellpadding="2" align="center">
    <tr> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><font size="2" face="Arial, Helvetica, sans-serif"><b><img src="images/icSearch.gif" width="20" height="19" align="absmiddle">Search 
              / View Articles :</b></font></td>
            <td> 
              <div align="right"><a href="editarticle1.asp"><img src="images/btnNewArticle2.gif" width="114" height="18" border="0" alt="Create New Article"></a> 
                <%if lvl>0 then%>
                <%if lvl=2 then%>
                <a href="editzone.asp"><img src="images/btnZone2.gif" width="114" height="18" hspace="2" border="0" alt="Create New article Zone"></a> 
                <%end if%>
                <a href="javascript:deleteexpired()"><img src="images/btnDeleteExpired.gif" width="114" height="18" hspace="2" alt="Delete Expired Articles" border="0"></a> 
                <%end if%>
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr bgcolor="#666666"> 
      <td colspan="2"></td>
    </tr>
    <tr bgcolor="#F3F3F3"> 
      <td colspan="2"><font size="1" face="Arial, Helvetica, sans-serif">Use this 
        option to browse through your articles by defining any search criteria. 
        If you don't define any criteria, all your articles will be shown. </font></td>
    </tr>
    <tr bgcolor="#CCCCCC"> 
      <td colspan="2" bgcolor="#666666"></td>
    </tr>
    <tr bgcolor="#CCCCCC" align="left" valign="top"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif">Keywords 
        :</font></b></td>
      <td width="75%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="text" size="40" value="<%=text%>" maxlength="200">
        </font></td>
    </tr>
    <%if pblusers="" or lvl>0 then%>
    <tr bgcolor="#CCCCCC" align="left" valign="top"> 
      <td width="25%"><font face="Arial, Helvetica, sans-serif" size="2"><b>Publisher 
        Name / ID :</b></font></td>
      <td width="75%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="pblname" size="40" value="<%=pblname%>" maxlength="200">
        </font></td>
    </tr>
    <%end if%>
    <tr bgcolor="#CCCCCC" align="left" valign="top"> 
      <td width="25%" height="21"><b><font size="2" face="Arial, Helvetica, sans-serif">Zone 
        :</font></b></td>
      <td width="75%" bgcolor="#F3F3F3" height="21"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="zoneid">
          <option value=''>All</option>
          <%if zoneid="m" then sel=" selected" else sel=""%>
          <option value='m' <%=sel%>>Articles From My Zones</option>
          <%
		if zoneid="" or not(isnumeric(zoneid)) then zoneid=0
		psql="select * from zones " 
		if pblaccess<>"" and lvl=0 then psql=psql &" where zoneid in (select zoneid from publisherszones where publisherid="&usrid&")"
		psql=psql & "order by zonename asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if zoneid-rs("zoneid")=0 then sel=" selected" else sel=""
			response.write "<option value='"&rs("zoneid")&"'"&sel&">"&rs("zonename")&"</option>"
			rs.movenext
		loop	
		rs.close
		set rs=nothing
		%>
        </select>
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC" align="left" valign="top"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif">Status 
        :</font></b></td>
      <td width="75%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="status">
          <option value="">All</option>
          <%if status="" then status=0
		for x=1 to maxstatus
			if status-x=0 then sel=" selected" else sel=""
			response.write "<option value="&x&sel&">"&whichstatus(x)&"</option>"
		next%>
        </select>
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC" align="left" valign="top"> 
      <td width="25%"><font face="Arial, Helvetica, sans-serif" size="2"><b>Article 
        IDs :</b></font></td>
      <td width="75%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="articles" size="20" value="<%=articles%>">
        <br>
        <font size="1">Enter one or several article IDs separated by commas(,)</font></font></td>
    </tr>
    <tr bgcolor="#CCCCCC" align="left" valign="top"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="checkbox" name="datecriteria" value="checked" <%=datecriteria%>>
        Displayed Between :</font></b></td>
      <td width="75%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <font size="1" face="Verdana, Arial, Helvetica, sans-serif">(mm/dd/yyyy) 
        :</font> 
        <select name="month1">
          <%
			  	for x=1 to 12
				if x=month(date1) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day1">
          <%
			  	for x=1 to 31
				if x=day(date1) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year1">
          <%
			  a=year(date1)
			  for x=a-10 to a+10
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        And 
        <select name="month2">
          <%
			  	for x=1 to 12
				if x=month(date2) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day2">
          <%
			  	for x=1 to 31
				if x=day(date2) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year2">
          <%
			  a=year(date2)
			  for x=a-10 to a+10
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC" align="left" valign="top"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="checkbox" name="datecriteria2" value="checked" <%=datecriteria2%>>
        Modified Between :</font></b></td>
      <td width="75%" bgcolor="#F3F3F3"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <font size="1" face="Verdana, Arial, Helvetica, sans-serif">(mm/dd/yyyy) 
        :</font> 
        <select name="month21">
          <%
			  	for x=1 to 12
				if x=month(date21) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day21">
          <%
			  	for x=1 to 31
				if x=day(date21) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year21">
          <%
			  a=year(date21)
			  for x=a-50 to a+50
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        And 
        <select name="month22">
          <%
			  	for x=1 to 12
				if x=month(date22) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="day22">
          <%
			  	for x=1 to 31
				if x=day(date22) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        / 
        <select name="year22">
          <%
			  a=year(date22)
			  for x=a-50 to a+50
			  	if x=a then sel=" selected" else sel=""
			  	response.write "<option"&sel&">"& x&"</option>"	
			  next 
			  %>
        </select>
        </font></td>
    </tr>
    <tr bgcolor="#666666"> 
      <td colspan="2"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"> 
        </font></b> 
        <div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
          <input type="submit" name="Submit" value="Search Articles">
          </font></div>
      </td>
    </tr>
  </table>
</form>
<table border="0" cellspacing="1" width="96%" cellpadding="0" align="center">
  <%
set rs=server.createobject("ADODB.Recordset")
rs.open searchsql,conn,1 
if not(rs.eof) then 
	maxval=rs.recordcount
	rs.movefirst
	rs.pagesize=mypagesize
	maxcount=cint(rs.pagecount)
	rs.absolutepage=mypage
	howmanyrecs=0
	howmanyfields=rs.fields.count-1
%>
  <tr> 
    <td width="100%" align="left" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><b>Articles 
      Found </b><b> : <%=maxval%><br>
      Page <%=mypage%> of <%=maxcount%></b></font></td>
  </tr>
  <tr> 
    <td width="0" align="left" valign="top" height="0"> 
        <table border="0" cellpadding="3" width="100%">
          <tr bgcolor="#003399"> 
            
          <td align="right" width="4%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">#</font></b></td>
            
          <td align="center"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Article</font> 
            <br>
              <a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=headline+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=headline+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><br>
              </b></td>
            <td align="center" width="17%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Source<br>
              </font><a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=source+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=source+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"> 
              </font></b></td>
            <td  align="center" width="11%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Displayed 
              </font><a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=startdate+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=startdate+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"> 
              </font></b></td>
            
          <td  align="center" width="7%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Status</font><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"><br>
              </font><a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=status+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=status+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"> 
              <br>
              </font></b></td>
            
          <td  align="center" width="7%"><b><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif">Views</font><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif"><br>
              </font><a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=clicks+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&whichpage=<%=mypage%>&orderby=clicks+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif"> 
              </font></b></td>
            
          <td  align="center" width="7%"><b><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif">View</font></b></td>
            
          <td  align="center" width="7%"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><b>Edit</b></font></td>
            <td  align="center" width="7%"><b><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif">Delete</font></b></td>
          </tr>
          <%
	cc=(mypagesize*mypage)-mypagesize
	do until rs.eof or howmanyrecs>=rs.pagesize
		cc=cc+1
		articleid=rs("articleid")
		headline=rs("headline")
		headlinedate=rs("headlinedate")
		summary=rs("summary")
		source=rs("source")
		startdate=revertdate(rs("startdate"))
		enddate=revertdate(rs("enddate"))
		clicks=rs("clicks")
		status=whichstatus(rs("status"))
		publisherid=rs("publisherid")
		if not(isnumeric(publisherid)) then publisherid=0
		
		'/// Get Publisher's Name ///
		if pblusers="" or lvl>0 then
			psql="select name from publishers where publisherid="&publisherid
			set rs2=conn.execute(psql)
			if rs2.eof then
				publishername="No Publisher Found"
			else
				publishername="<a href='viewpublisher.asp?publisherid="&publisherid&"'>"&rs2("name")&"</a>"
			end if
			rs2.close
			set rs2=nothing
			publishername="Publisher : " & publishername&"<br>"
		end if
		
		if publisherid=usrid or lvl>0 then 
			editable="editarticle1.asp?articleid="&articleid
			deleteable="javascript:deletearticle("&articleid&");"
			img=""
		else
			editable="javascript:notallowed('edit');"
			deleteable="javascript:notallowed('delete');"
			img="0"
		end if
				
		if onlyadmins<>"" and lvl=0 and rs("status")<2 then
			editable="javascript:notallowed('edit');"
			deleteable="javascript:notallowed('delete');"
			img="0"
		end if
	
%>
          <tr align="left" bgcolor="#EAEAEA" valign="top"> 
            
          <td width="4%" align="right"><font face="Arial, Helvetica, sans-serif" size="2"><%=cc%>.</font></td>
            
          <td bgcolor="#EAEAEA"><font face="Arial, Helvetica, sans-serif" size="2"><a              href="viewarticle.asp?articleid=<%=articleid%>"><b><%=headline%></b></a><br>
              <font size="1" face="Verdana, Arial, Helvetica, sans-serif"> <%=publishername%><%=server.htmlencode(summary)%></font> </font></td>
            <td width="17%"><font face="Arial, Helvetica, sans-serif" size="2"><%=source%></font></td>
            <td width="11%"> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=startdate & "<br>" & enddate%></font></div></td>
            
          <td width="7%"> 
            <div align="center"><font face="Arial, Helvetica, sans-serif" size="2"><b><img src="images/<%=status%>.gif" width="27" height="27" alt="<%=status%>"><br>
                <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#666666"><%=status%></font></b></font></div></td>
            
          <td width="7%"> 
            <div align="center"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=clicks%></b></font><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><br>
                </font></div></td>
            
          <td width="7%"> 
            <div align="center"><b><a href="viewarticle.asp?articleid=<%=articleid%>"><img src="images/btnView.gif" width="27" height="27" border="0" alt="View article"></a></b></div></td>
            
          <td width="7%"> 
            <div align="center"><a href="<%=editable%>"><img src="images/btnEdit<%=img%>.gif" width="27" height="27" alt="Edit article" border="0"></a></div></td>
            <td width="7%"> <div align="center"><b><a href="<%=deleteable%>"><img src="images/btnKill<%=img%>.gif" width="27" height="27" border="0" alt="Delete article"></a></b></div></td>
          </tr>
          <%
		rs.movenext
		howmanyrecs=howmanyrecs+1
		loop
			%>
        </table>
      </td>
  </tr>
  <tr>
    <td height="1" bgcolor="#666666"></td>
  </tr>
  <tr> 
    <td width="100%" valign="top" align="left"><b><font face="Arial, Helvetica, sans-serif" size="2">Go 
      to Page : 
      <select name="pageselector" onchange="javascript:gopage(this.value);">
        <%
		for counter=1 to maxcount
		if counter-mypage=0 then sel=" selected" else sel=""
			response.write "<option value="&counter&sel&">"&counter&"</option>"
		next
		%>
      </select>
      <script language="JavaScript">
	  function gopage(what){
	  	self.location.href='<%=scriptname%>&orderby=<%=server.urlencode(orderby)%>&whichpage=' + what;
	  }
	  </script>
      <%if cint(mypage)>1 then response.write "<a href='"&scriptname&"&orderby="&server.urlencode(orderby)&"&whichpage="&mypage-1&"'>&lt;&lt;</a> "  
	  if cint(mypage)<maxcount then response.write "<a href='"&scriptname&"&orderby="&server.urlencode(orderby)&"&whichpage="&mypage+1&"'>&gt;&gt;</a>"%>
      </font></b></td>
  </tr>
  <%else%>
  <tr align="center"> 
    <td width="100%" valign="top" align="left"> <p align="center">&nbsp; 
      <p align="center"><b><font face="Arial, Helvetica, sans-serif" size="2" color="#FF0000">No 
        Articles were found for the specified criteria</font></b> 
      <p align="center">&nbsp; </td>
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
