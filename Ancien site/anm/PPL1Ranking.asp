<!-- #include file="incSystem.asp" -->
<%
lvl=validate(1)

function whichrank(what)
	select case what
		case 1
			whichrank="Top 100 Rated Articles"
		case 2
			whichrank="Top 100 Most Talked About"
		case 3
			whichrank="Top 100 Worst Rated Articles"
		case 4
			whichrank="Top 100 Most Viewed Articles (With Reviews)"
	end select
end function

psql="SELECT TOP 100 PPL1Reviews.articleid, articles.headline,articles.clicks, articles.summary, Sum(PPL1Reviews.review) AS thumbsup, Count(PPL1Reviews.articleid) AS reviews "
psql=psql & " FROM articles INNER JOIN PPL1Reviews ON articles.articleid = PPL1Reviews.articleid "
psql=psql & " GROUP BY PPL1Reviews.articleid, articles.headline,articles.clicks, articles.summary "


rank=request("rank")
if rank="" or not(isnumeric(rank)) then rank=1
select case rank
	case 1
		psql=psql & " ORDER BY Sum(PPL1Reviews.review) / Count(PPL1Reviews.articleid) desc;"
		
	case 2
		psql=psql & " Order by Count(PPL1Reviews.articleid) desc;"
		
	case 3
		psql=psql & " Order by Sum(PPL1Reviews.review) / Count(PPL1Reviews.articleid) asc;"
		
	case 4
		psql=psql & " Order by clicks desc;"

end select

%>
<html>
<head>
<title>Article Ranking</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="PPL1Ranking.asp">
<table width="90%" border="0" cellspacing="2" cellpadding="2" align="center">
  <tr> 
      <td><font face="Arial, Helvetica, sans-serif" size="2"><b>Article Ranking</b></font></td>
  </tr>
  <tr> 
    <td bgcolor="#666666"></td>
  </tr>
  <tr>
      <td bgcolor="#F3F3F3"><font face="Arial, Helvetica, sans-serif"><b><font size="2">Select 
        Ranking : </font></b></font> 
        <select name="rank" onchange="javascript:form.submit();">
          <%for x=1 to 4
			if x-rank=0 then sel=" selected" else sel=""
			response.write "<option value="&x&sel&">"&whichrank(x)&"</option>"
		 next%>
        </select>
      </td>
  </tr>
  <tr> 
    <td bgcolor="#666666"></td>
  </tr>
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="1" cellpadding="2" bgcolor="#000099">
        <tr> 
            <td><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF"><b><%=whichrank(rank)%></b></font></td>
        </tr>
        <tr> 
          <td bgcolor="#FFFFFF"> 
              <table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
                <%
				set conn=server.createobject("ADODB.Connection")
				conn.open connection
			  set rs=conn.execute(psql)
			  do until rs.eof
				cc=cc+1
				headline=rs("headline")
				summary=left(rs("summary")&"",255)&"..."
				articleid=rs("articleid")
				thumbsup=rs("thumbsup")
				reviews=rs("reviews")
				rating=thumbsup/reviews
				trating=int(rating*5)
				clicks=rs("clicks")
				stars=""
				for x=1 to 5
					if x<=trating then img="staron.gif" else img="staroff.gif"
					stars=stars &"<img src=ppl1images/"&img&" border=0 alt=" & chr(34) & "Click to view this article's reviews" & chr(34) &">"
				next
				
			  %>
                <tr align="left" valign="top" bgcolor="#F3F3F3"> 
                  <td width="5%" align="right"><font face="Arial, Helvetica, sans-serif" size="2"><b><%=cc%>.</b></font></td>
                  <td width="63%"><font face="Arial, Helvetica, sans-serif" size="2"><b><a href="viewarticle.asp?articleid=<%=articleid%>"><%=headline%></a></b><br>
                    <%=summary%></font></td>
                  <td width="17%" align="center"><a href="PPL1Reviewsearch.asp?articleid=<%=articleid%>"><%=stars%></a></td>
                  <td width="15%"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Reviews 
                    : <%=reviews%><br>
                    Rating : <%=formatnumber(rating*5,2)%><br>
                    Views : <%=clicks%></font></td>
                </tr>
                <%
				rs.movenext
				loop
				rs.close
				set rs=nothing
				conn.close
				set conn=nothing
				%>
              </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</body>
</html>
