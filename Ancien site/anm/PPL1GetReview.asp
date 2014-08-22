<!--#include file="incSystem.asp"-->
<%
articleid=request("articleid")
if articleid="" or not(isnumeric(articleid)) then articleid=0


mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=10
scriptname="PPL1GetReview.asp?articleid="&articleid
searchsql="select * from ppl1reviews where articleid="&articleid&" order by reviewid desc;"

set conn=server.createobject("ADODB.Connection")
conn.open connection

'/// get New Rating ///
psql="SELECT Count(PPL1Reviews.review) AS totalreviews, Sum(PPL1Reviews.review) AS thumbsup, PPL1Reviews.articleid FROM PPL1Reviews where articleid="&articleid&" GROUP BY PPL1Reviews.articleid"
set rs=conn.execute(psql)
if not(rs.eof) then
	totalreviews=rs("totalreviews")
	thumbsup=rs("thumbsup")
	rating=int(thumbsup*5/totalreviews)
else
	rating=0
end if
rs.close
set rs=nothing

psql="select * from articles where articleid="&articleid
set rs=conn.execute(psql)
headline=rs("headline")
rs.close
set rs=nothing

'/// Get Stars ///
stars=""
for x=1 to 5
	if x-rating<=0 then img="staron.gif" else img="staroff.gif"
	stars=stars & "<img src=ppl1images/"&img&" border=0>"
next

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
else
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
	response.redirect "ppl1postreview.asp?articleid="&articleid&"&isfirst=true&headline="&server.urlencode(headline)
end if	

%>
<html>
<head>
<title>Rate & Review : </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" rightmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr> 
    <td bgcolor="#333333"> <font face="Arial, Helvetica, sans-serif" size="2"><b><font color="#FFCC00"><%=headline%></font></b></font></td>
  </tr>

  <tr> 
    <td> 
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td width="75%"><font face="Arial, Helvetica, sans-serif" size="2"><b><font color="#666666">Reviews 
            : <%=maxval%><br>
            Page <%=mypage%> of <%=maxcount%></font></b></font></td>
          <td width="25%" align="center"><font size="1" face="Tahoma, Verdana, Arial" color="#666666">User 
            Rating :<br>
            <a href="ppl1postreview.asp?articleid=<%=articleid%>&headline=<%=server.urlencode(headline)%>"><%=stars%></a></font></td>
        </tr>
      </table>
    </td>
  </tr>
  <%
	do until rs.eof or howmanyrecs>=rs.pagesize
		name=rs("name")
		reviewdate=revertdate(rs("reviewdate"))
		review=rs("review")
		isannonymous=rs("isannonymous")&""
		if isannonymous<>"" then name="Annonymous"
		comments=server.htmlencode(rs("comments")&"")
		if review=0 then img="thumbsdown.gif" else img="thumbsup.gif"
		c=c+1
		if c mod 2=0 then bgcolor="#FFFFFF" else bgcolor="#EFEFEF"
%>
  <tr> 
    <td bgcolor="<%=bgcolor%>"> 
      <table width="98%" border="0" cellspacing="2" cellpadding="2" align="center">
        <tr align="left" valign="top"> 
          <td width="2%"><img src="PPL1Images/<%=img%>" width="14" height="17"></td>
          <td width="98%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><%=name%> 
            - <%=reviewdate%></b><br>
            <%=comments%></font> </td>
        </tr>
      </table>
    </td>
  </tr>
  <%rs.movenext
  howmanyrecs=howmanyrecs+1 
  loop%>
  <tr> 
    <td align="center"> 
      <%if mypage-maxcount<=0 and mypage>1 then%>
      <a href="<%=scriptname%>&whichpage=<%=mypage-1%>&rating=<%=rating%>"><img src="PPL1Images/prev.gif" width="74" height="19" border="0"></a> 
      <%end if%>
      <%if mypage-maxcount<0 then%>
      <a href="<%=scriptname%>&whichpage=<%=mypage+1%>&rating=<%=rating%>"><img src="PPL1Images/next.gif" width="74" height="19" border="0"></a> 
      <%end if%>
      <br>
      <a href="ppl1postreview.asp?articleid=<%=articleid%>&headline=<%=server.urlencode(headline)%>"><font face="Arial, Helvetica, sans-serif" size="1">Submit 
      your Review</font></a></td>
  </tr>
  <%
 rs.close
 set rs=nothing
 conn.close%>
</table>
</body>
</html>
