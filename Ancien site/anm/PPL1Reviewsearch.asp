<!-- #include file="incSystem.asp" -->
<%
function whichreview(what)
	if what=1 then whichreview="Thumbs Up (Positive)" else whichreview="Thumbs Down (Negative)"
end function

lvl=validate(1)

'//// Receive Search Criteria ////
text=request("text")&""
stext=replace(text,"'","''")
headline=request("headline")&""
lheadline=replace(headline,"'","''")
articleid=request("articleid")
review=request("review")

datecriteria=request("datecriteria")
date1=request("year1")&"/"&request("month1")&"/"&request("day1")
date2=request("year2")&"/"&request("month2")&"/"&request("day2")
orderby=request("orderby")

psql="SELECT PPL1Reviews.*, articles.headline FROM articles INNER JOIN PPL1Reviews ON articles.articleid = PPL1Reviews.articleid"
psql=psql & " where comments like '%"&stext&"%' and headline like '%"& headline & "%'"

if articleid<>"" and isnumeric(articleid) then psql=psql & " and PPL1reviews.articleid="&articleid
if review<>"" then psql=psql & " and review="&review

if datecriteria<>"" and isdate(date1) and isdate(date2) then
	psql=psql & " and reviewdate>='"&date1&"' and reviewdate<='"&date2&"'"
end if

if not(isdate(date1)) then date1=date
if not(isdate(date2)) then date2=date
if orderby="" then 
	psql=psql & " order by reviewdate , headline asc"
else
	psql=psql & " order by "&orderby
end if
searchsql=psql

mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=10
scriptname="PPL1reviewsearch.asp?text="&server.urlencode(text)&"& headline="&server.urlencode(headline)&"&articleid="&articleid&"&review="&review&"&datecriteria="&datecriteria&"&date1="&server.urlencode(date1)&"&date2="&server.urlencode(date2)

set conn=server.createobject("ADODB.Connection")
conn.open connection

'/// Delete a Review  ////
kill=request("kill")
if kill<>"" and lvl=1 then 
	psql="delete from PPL1reviews where reviewid="&kill
	conn.execute(psql)
end if

%>
<html>
<head>
<title>Search Reviews</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function deletereview(reviewid){
	if (confirm('Delete Review?')){
		self.location.href='<%=scriptname%>&whichpage=<%=mypage%>&orderby=<%=server.urlencode(orderby)%>&kill=' + reviewid;
	}
}

</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="PPL1Reviewsearch.asp?orderby=<%=server.urlencode(orderby)%>">
  <table width="96%" border="0" cellspacing="1" cellpadding="2" align="center">
    <tr> 
      <td colspan="2"> <font size="2" face="Arial, Helvetica, sans-serif"><b>Search 
        / View Reviews :</b></font></td>
    </tr>
    <tr bgcolor="#666666"> 
      <td colspan="2"></td>
    </tr>
    <tr bgcolor="#CCCCCC"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif">Keywords 
        (Comments) :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="text" size="40" value="<%=text%>" maxlength="200">
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif">Headline 
        :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="text" name="headline" size="40" value="<%=headline%>" maxlength="200">
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC">
      <td width="25%"><font face="Arial, Helvetica, sans-serif" size="2"><b>Article 
        ID : </b></font></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif">
        <input type="text" name="articleid" size="6" value="<%=articleid%>" maxlength="200">
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif">Review 
        :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="review">
          <option value="">All</option>
          <%
		for x=0 to 1
			if review<>"" then
				if review-x=0 then sel=" selected" else sel=""
			end if
			response.write "<option value="&x&sel&">"&whichreview(x)&"</option>"
		next%>
        </select>
        </font></td>
    </tr>
    <tr bgcolor="#CCCCCC"> 
      <td width="25%"><b><font size="2" face="Arial, Helvetica, sans-serif"> 
        <input type="checkbox" name="datecriteria" value="checked" <%=datecriteria%>>
        Posted Between :</font></b></td>
      <td width="75%" bgcolor="#EFEFEF"><font size="2" face="Arial, Helvetica, sans-serif"> 
        <font size="1" face="Verdana, Arial, Helvetica, sans-serif">(mm/dd/yyyy) 
        :</font><font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="month1">
          <%
			  	for x=1 to 12
				if x=month(date1) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        </font> /<font size="2" face="Arial, Helvetica, sans-serif"> 
        <select name="day1">
          <%
			  	for x=1 to 31
				if x=day(date1) then sel=" selected" else sel=""
					response.write "<option"&sel&">"& right("0" & x ,2) & "</option>"
				next
			  %>
        </select>
        </font> / 
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
      <td colspan="2"><b><font size="2" face="Arial, Helvetica, sans-serif"> <font color="#FFFFFF"> 
        </font></font></b> 
        <div align="right"><font size="2" face="Arial, Helvetica, sans-serif"> 
          <input type="submit" name="Submit" value="Search Reviews">
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
    <td width="100%" align="left" valign="top"><font face="Arial, Helvetica, sans-serif" size="2"><b>Reviews 
      Found </b><b> : <%=maxval%><br>
      Page <%=mypage%> of <%=maxcount%></b></font></td>
        </tr>
        <tr> 
  
    <td width="0" align="left" valign="top" height="0"> 
      <div align="left"> 
        <table border="0" cellpadding="3" width="100%">
          <tr bgcolor="#003399"> 
            <td align="right" width="3%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">#</font></b></td>
            <td align="center"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Review</font><br>
              <a href="<%=scriptname%>&orderby=name+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&orderby=name+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><br>
              </b></td>
            <td align="center" width="22%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Headline</font><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"><br>
              </font><a href="<%=scriptname%>&orderby=headline+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&orderby=headline+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"> 
              </font></b></td>
            <td  align="center" width="11%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Date<br>
              </font><a href="<%=scriptname%>&orderby=reviewdate+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&orderby=reviewdate+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"> 
              </font></b></td>
            <td  align="center" width="8%"><b><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2">Review</font><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"><br>
              </font><a href="<%=scriptname%>&orderby=review+asc"><img src="images/btnOrderAsc.gif" width="12" height="9" border="0"></a> 
              <a href="<%=scriptname%>&orderby=review+desc"><img src="images/btnOrderDesc.gif" width="12" height="9" border="0"></a><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"> 
              </font><font color="#FFFFFF" face="Arial, Helvetica, sans-serif" size="2"> 
              <br>
              </font></b></td>
            <td  align="center" width="7%"><b><font size="2" color="#FFFFFF" face="Arial, Helvetica, sans-serif">Delete</font></b></td>
          </tr>
          <%
	cc=(mypagesize*mypage)-mypagesize
	do until rs.eof or howmanyrecs>=rs.pagesize
		cc=cc+1
		articleid=rs("articleid")
		name=rs("name")
		reviewid=rs("reviewid")
		headline=rs("headline")
		reviewdate=rs("reviewdate")
		review=rs("review")
		comments=rs("comments")
		reviewdate=revertdate(reviewdate)
		if review=0 then review="thumbsdown.gif" else review="thumbsup.gif"
		comments=server.htmlencode(comments)
		
	
%>
          <tr align="left" bgcolor="#EAEAEA" valign="top"> 
            <td width="3%"><font face="Arial, Helvetica, sans-serif" size="2"><%=cc%>.</font></td>
            <td bgcolor="#EAEAEA"><font face="Arial, Helvetica, sans-serif" size="2"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=name%></font></b><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><br>
              <%=comments%></font><br>
              </font></td>
            <td width="22%"> <font face="Arial, Helvetica, sans-serif" size="2"><a href="viewarticle.asp?articleid=<%=articleid%>"><b><%=headline%></b></a></font></td>
            <td width="11%"> 
              <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=reviewdate%></font></div>
            </td>
            <td width="8%"> 
              <div align="center"><b><a href="PPL1Reviewsearch.asp?articleid=<%=articleid%>"><img src="PPL1Images/<%=review%>" alt="Click to View this article's reviews" border=0></a></b></div>
            </td>
            <td width="7%"> 
              <div align="center"><b><a href="javascript:deletereview(<%=reviewid%>);"><img src="images/btnKill.gif" width="27" height="27" border="0" alt="Delete Review"></a></b></div>
            </td>
          </tr>
          <%
		rs.movenext
		howmanyrecs=howmanyrecs+1
		loop
			%>
        </table>
            </div>
          </td>
        </tr>
        <tr align="center"> 
          
    <td width="100%" valign="top" align="left"><b><font face="Arial, Helvetica, sans-serif" size="2">Go 
      to Page : 
      <%
				pad="0"
				
				
				for counter=1 to maxcount
					if counter>=10 then	pad=""
					ref="<a href='"&scriptname&"&orderby="&server.urlencode(orderby)&"&whichpage="&counter&"'>"&pad&counter&"</a>"
					response.write ref & " "
					if counter mod 30 = 0 then response.write "<br>"
				next
%>
      </font></b></td>
        </tr>
        <%else%>
        <tr align="center"> 
          
    <td width="100%" valign="top" align="left"> 
      <p align="center">&nbsp;
      <p align="center"><b><font face="Arial, Helvetica, sans-serif" size="2" color="#FF0000">No 
        Reviews Were Found For The Specified Criteria</font></b> 
      <p align="center">&nbsp;
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
