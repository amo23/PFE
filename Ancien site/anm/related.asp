<!-- #include file="incSystem.asp" -->
<%
lvl=validate(0)
articleid=request("articleid")
if articleid="" or not(isnumeric(articleid)) then articleid=0

set conn=server.createobject("ADODB.Connection")
conn.open connection

'/// Update or Get Related Articles 
update=request("update")
button=request("button")
psql="select * from articles where articleid="&articleid
if lvl=0 then psql=psql & " and publisherid="&usrid
Set rs = Server.CreateObject("ADODB.Recordset") 
rs.open psql,conn,1,2
if rs.eof then response.redirect "logout.asp"
relatedid=rs("relatedid")

if update<>"" then 
	redim newrelated(0)
	deleteid=request("deleteid")
	deleteid=replace(deleteid," ","")
	deleteid=split(deleteid,",")
	relatedid=replace(""&relatedid," ","")
	ther=split(relatedid,",")
	for x=0 to ubound(ther)
		for y=0 to ubound(deleteid)
			if ther(x)=deleteid(y) then ther(x)=0
		next' y
		if isnumeric(ther(x)) then
			if ther(x)<>0 then
				redim preserve newrelated(c)
				newrelated(c)=ther(x)
				c=c+1
			end if
		end if
	next
	relatedid=join(newrelated,",")
	rs("relatedid")=relatedid
end if
rs.Update
relatedid=rs("relatedid")
rs.close
set rs=nothing



'//// Receive Search Criteria ////
text=request("text")&""
stext=replace(text,"'","''")
zoneid=request("zoneid")
status=request("status")
datecriteria=request("datecriteria")
date1=request("year1")&"/"&request("month1")&"/"&request("day1")
date2=request("year2")&"/"&request("month2")&"/"&request("day2")

psql="select * from articles where (headline like '%"&stext&"%' or article like '%"&stext&"%' or summary like '%"&stext&"%' or source like '%"&stext&"%') "
if zoneid<>"" then 
	if zoneid="m" then
		psql=psql &" and articleid in (select articleid from iArticlesZones where zoneid in (select zoneid from publisherszones where publisherid="&usrid&"))"
	else
		psql=psql &" and articleid in (select articleid from iArticlesZones where zoneid="&zoneid&") "
	end if
end if

if status<>"" then psql=psql & " and status="&status
if datecriteria<>"" and isdate(date1) and isdate(date2) then
	psql=psql & " and ((startdate>='"&date1&"' and startdate<='"&date2&"') or (enddate>='"&date1&"' and enddate<='"&date2&"') or ((startdate>='"&date1&"' or startdate<='"&date2&"') and enddate='-'))"
end if

if not(isdate(date1)) then date1=date
if not(isdate(date2)) then date2=date
psql=psql & " and articleid<>"&articleid&condit&" order by startdate , headline asc"
searchsql=psql

scriptname="related.asp?text="&server.urlencode(text)&"&zoneid="&zoneid&"&status="&status&"&datecriteria="&datecriteria&"&date1="&server.urlencode(date1)&"&date2="&server.urlencode(date2)&"&button=1"

'/// Add related Articles
related=request("related")
related=replace(related," ","")
if related<>"" then
	r=split(related,",")
	for x=0 to ubound(r)
		if instr("," & relatedid &",",","&r(x)&",")=0 then
			relatedid=relatedid &","&r(x)
			if left(relatedid,1)="," then relatedid=r(x)
			psql="update articles set relatedid='"&relatedid&"' where articleid="&articleid
			conn.execute(psql)
		end if
	next
end if
response.buffer=true
response.flush
%>
<html>
<head>
<title>Related Articles</title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="related.asp">
  <table width="96%" border="0" cellspacing="1" cellpadding="2" align="center">
    <tr> 
      <td colspan="2"> <font size="2" face="Arial, Helvetica, sans-serif"><b><img src="images/icArticle.gif" width="20" height="16" align="absmiddle"> 
        Edit Article</b></font></td>
    <tr bgcolor="#003399"> 
      <td colspan="2"><font face="Arial, Helvetica, sans-serif" size="3" color="#FFFFFF"><b>Related 
        Articles</b></font></td>
    </tr>
    <tr bgcolor="#CCCCCC"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif">Keywords 
        :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="text" size="40" value="<%=text%>" maxlength="200">
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif">Zone 
        :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="zoneid">
          <option value=''>All</option>
          <%if zoneid="m" then sel=" selected" else sel=""%>
          <option value='m' <%=sel%>>Articles From My Zones</option>
          <%
		if zoneid="" or not(isnumeric(zoneid)) then zoneid=0
		psql="select * from zones order by zonename asc;"
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
    <tr bgcolor="#CCCCCC"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif">Status 
        :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="status">
          <option value="">All</option>
          <%if status="" then status=0
		for x=1 to 4
			if status-x=0 then sel=" selected" else sel=""
			response.write "<option value="&x&sel&">"&whichstatus(x)&"</option>"
		next%>
        </select>
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="checkbox" name="datecriteria" value="checked" <%=datecriteria%>>
        Displayed Between :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <font size="1" face="Verdana, Arial, Helvetica, sans-serif">(mm/dd/yyyy) 
        : </font> 
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
    <tr bgcolor="#666666"> 
      <td colspan="2"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF"> 
        </font></b> 
        <div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
          <input type="hidden" name="articleid" value="<%=articleid%>">
          <input name="button" type="submit" id="button" value="Search Articles">
          </font></div>
      </td>
    </tr>
  </table>
  </form>
  <form name="form2" method="post" action="<%=scriptname%>">
  <table border="0" cellspacing="1" width="96%" cellpadding="0" align="center">
    <tr> 
      <td width="0" align="center" valign="top" height="0"> 
        <table width="100%" border="0" cellspacing="2" cellpadding="2">
            <tr align="center"> 
              <td colspan="2" bgcolor="#666666"></td>
            </tr>
            <tr align="center" valign="top"> 
              <td width="50%" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"><b>Articles 
                Found</b></font><br>
                <select name="related" size="10" multiple style="width:98%; font-size:11">
                  <%
				  if button<>"" then
				  set rs=conn.execute(searchsql)
				  do until rs.eof
					response.write "<option value="&rs("articleid")&">"&rs("headline")&" - "&rs("headlinedate")&" ("&whichstatus(rs("status"))&")</option>"
					rs.movenext
					loop
					rs.close
					set rs=nothing
					end if
					%>
                </select>
                <br>
                <input type="submit" name="Submit" value="Add Selected">
                <br>
              </td>
              <td width="50%" bgcolor="#F3F3F3"> <font face="Arial, Helvetica, sans-serif" size="2"><b>Related 
                Articles</b></font><br>
                <select name="deleteid" size="10" multiple style="width:98%; font-size:11">
                  <%if relatedid="" or isnull(relatedid) then relatedid="0"
				  psql="select * from articles where articleid in ("&relatedid&")"
				  set rs=conn.execute(psql)
				  do until rs.eof
				response.write "<option value="&rs("articleid")&">"&rs("headline")&" - "&rs("headlinedate")&" ("&whichstatus(rs("status"))&")</option>"
				rs.movenext
				loop
				rs.close
				set rs=nothing
				%>
                </select>
                <br>
                <input type="submit" name="update" value="Remove Selected">
              </td>
            </tr>
            <tr align="center" bgcolor="#666666"> 
              <td colspan="2"></td>
            </tr>
          </table>
        <br>
        <input type="button" name="Button2" value="&lt;&lt; Edit Article" onClick="javascript:self.location='editarticle1.asp?articleid=<%=articleid%>'">
          <input type="button" name="Button" value="Images And Files" onClick="javascript:self.location='editarticle2.asp?articleid=<%=articleid%>'">
          <input type="button" name="Button" value="View Article &gt;&gt;" onClick="javascript:self.location='viewarticle.asp?articleid=<%=articleid%>'">
          <input type="hidden" name="articleid" value="<%=articleid%>">
      </td>
    </tr>
  </table>
</form>
</body>
</html>
<%
conn.close
set conn=nothing
%>