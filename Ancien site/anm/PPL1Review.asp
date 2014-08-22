<!--#include file="incSystem.asp" -->
<%
articleid=request("a")
if articleid="" or not(isnumeric(articleid)) then response.end
font="tahoma"
fontsize="1"

function preparecode(what)
	toprepare=what
	toprepare=replace(toprepare,"\","\\")
	toprepare=replace(toprepare,"'","\'")		
	toprepare=replace(toprepare,vbcrlf,"\n")
	toprepare=replace(toprepare,"/","\/")
	toprepare=replace(toprepare,chr(34),"\"&chr(34))
	preparecode=toprepare
end function


psql="SELECT Count(PPL1Reviews.review) AS totalreviews, Sum(PPL1Reviews.review) AS thumbsup, PPL1Reviews.articleid FROM PPL1Reviews where articleid="&articleid&" GROUP BY PPL1Reviews.articleid"
set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
if not(rs.eof) then
	totalreviews=rs("totalreviews")
	thumbsup=rs("thumbsup")
	rating=int(thumbsup*5/totalreviews)
else
	totalreviews=0
end if
rs.close
set rs=nothing

'/// Get Stars
stars=""
msg="Click to Review"
if totalreviews>0 then
	for x=1 to 5
		if x<=rating then img="staron.gif" else img="staroff.gif"
		stars=stars & "<img src="&applicationurl&"/ppl1images/"&img&" border=0>"
	next
	msg="Avg. User Rating"
end if



'/// Prepare Display ///
show="<table border=0 cellspacing=0 cellpadding=0><tr><td align=center valign=middle><a href=javascript:ppl1review();>"&stars&"</a></td>"
show=show & "</tr><tr><td align=center valign=middle><font face=" & font & " size="&fontsize&"><a href=javascript:ppl1review();>"&msg&"</a></font></td>"
show=show & "</tr></table>"
show=preparecode(show)
%>
function ppl1review(){
	openppl('PPL1getreview.asp?articleid=<%=articleid%>&rating=<%=rating%>',0,0,340,470);
}

document.write ("<%=show%>");

