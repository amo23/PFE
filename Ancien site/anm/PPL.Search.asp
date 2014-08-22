<!-- #include file="incSystem.asp" -->
<%

'//// Receive Search Criteria ////
search=request("search")&""
ssearch=replace(search,"'","''")
zoneid=request("zoneid")&""
sarchives=request("sarchives")

psql="select * from articles where (headline like '%"&ssearch&"%' or article like '%"&ssearch&"%' or summary like '%"&ssearch&"%' or source like '%"&ssearch&"%') and (article not like '' or articleurl not like '')"
if zoneid<>"" then 
	psql=psql & " and articleid in (select articleid from iArticlesZones where zoneid="&zoneid&")"
end if
if sarchives<>"" then
	psql=psql & " and (status=1 or status=4)"
else
	psql=psql & " and status=1 "
end if


psql=psql & " order by startdate , headline asc"
searchsql=psql

mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=10
scriptname="PPL.Search.asp?search="&server.urlencode(search)&"&zoneid="&zoneid&"&sarchives="&sarchives

set conn=server.createobject("ADODB.Connection")
conn.open connection


%>
<html>
<head>
<title>Search articles</title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=charset%>">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<!-- PPL Search Plug-In Begins -->
<form name="form1" method="post" action="PPL.Search.asp" style="margin:0">
  <table width="96%" border="0" cellspacing="2" cellpadding="2">
    <tr valign="bottom"> 
      <td colspan="2"><font size="4" face="Arial, Helvetica, sans-serif" color="#000066"><b>Search 
        Results </b></font> </td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="20%"><font face="Arial, Helvetica, sans-serif" size="2">Keywords 
        :</font> <font face="Arial, Helvetica, sans-serif" size="2"> </font></td>
      <td width="80%"><font face="Arial, Helvetica, sans-serif" size="2"> 
        <input type="text" name="search" size="40" value="<%=search%>">
        <input type="submit" name="Submit" value="Search">
        </font> </td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="20%"><font face="Arial, Helvetica, sans-serif" size="2">Category 
        :</font></td>
      <td width="80%"><font face="Arial, Helvetica, sans-serif" size="2"> 
        <select name="zoneid">
          <option value=''>-- All --</option>
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
        <input type="checkbox" value="checked" name="sarchives" <%=sarchives%>>
        Search archives</font></td>
    </tr>
  </table>
  <table border="0" cellspacing="1" width="96%" cellpadding="0">
    <tr> 
      <td width="100%" align="left" valign="top"> 
        <hr>
      </td>
    </tr>
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
      <td width="0" align="left" valign="top" height="0"> 
        <table border="0" cellpadding="3" width="100%">
          <%
	cc=(mypagesize*mypage)-mypagesize
	if zoneid<>0 then zone="&z="&zoneid 
	do until rs.eof or howmanyrecs>=rs.pagesize
		cc=cc+1
		articleid=rs("articleid")
		headline=rs("headline")
		headlinedate=rs("headlinedate")
		source=rs("source")
		summary=rs("summary")
	
%>
          <tr align="left" valign="top"> 
            <td align="right" width="40"><font face="Arial, Helvetica, sans-serif" size="2"><%=cc%>.</font></td>
            <td><font face="Arial, Helvetica, sans-serif" size="2"><a
              href="anmviewer.asp?a=<%=articleid%><%=zone%>"><b><%=headline%></b></a> 
              <font size="1">(<%=headlinedate & " - " & source%>)</font><br>
              <font size="1" face="Verdana, Arial, Helvetica, sans-serif"><%=server.htmlencode(summary)%><br>
              </font></font></td>
          </tr>
          <%
		rs.movenext
		howmanyrecs=howmanyrecs+1
		loop
			%>
        </table>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" valign="top" align="left"> 
        <hr>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" valign="top" align="left"><font face="Arial, Helvetica, sans-serif" size="2"><b>Articles 
      Found </b><b> : <%=maxval%><br>
      Page <%=mypage%> of <%=maxcount%></b></font><b><font face="Arial, Helvetica, sans-serif" size="2"><br>
        Go to Page : 
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
	  	window.location.href='<%=scriptname%>&whichpage=' + what;
	  }
	  </script>
        <%if cint(mypage)>1 then response.write "<a href='"&scriptname&"&whichpage="&mypage-1&"'>&lt;&lt;</a> "  
	  if cint(mypage)<maxcount then response.write "<a href='"&scriptname&"&whichpage="&mypage+1&"'>&gt;&gt;</a>"%>
        </font></b></td>
    </tr>
    <%else%>
    <tr align="center"> 
      <td width="100%" valign="top" align="left"> 
        <p align="center">&nbsp; 
        <p><b><font face="Arial, Helvetica, sans-serif" size="2" color="#000066">No 
          Articles were found for the specified criteria</font></b> 
        <p>&nbsp; 
        <hr>
      </td>
    </tr>
    <%end if
  rs.close
	set rs=nothing
	conn.close
	set conn=nothing

  %>
  </table>
</form>
<!-- PPL Search Plug-in Ends -->
</body>
</html>

