<!--#include file="incSystem.asp" -->
<%

function preparecode(what)
	toprepare=what
	toprepare=replace(toprepare,"\","\\")
	toprepare=replace(toprepare,"'","\'")		
	toprepare=replace(toprepare,vbcrlf,"\n")
	toprepare=replace(toprepare,"/","\/")
	toprepare=replace(toprepare,chr(34),"\"&chr(34))
	preparecode=toprepare
end function

psql="SELECT zones.zoneid, zones.zonename, Max(articles.articleid) AS articleid, articles.status "
psql=psql & "FROM zones INNER JOIN (articles INNER JOIN iArticlesZones ON articles.articleid = iArticlesZones.articleid) ON zones.zoneid = iArticlesZones.zoneid "
psql=psql & "GROUP BY zones.zoneid, zones.zonename, articles.status "
psql=psql & "HAVING (((articles.status)=1)) ORDER BY zones.zonename, Max(articles.articleid) DESC;"


set conn=server.createobject("ADODB.Connection")
conn.open connection
set rs=conn.execute(psql)
do until rs.eof
	options=options & "<option value='"&applicationurl&"anmviewer.asp?a="&rs("articleid")&"&z="&rs("zoneid")&"'>"&rs("zonename")&"</option>"
rs.movenext
loop
rs.close
set rs=nothing
conn.close
set conn=nothing
options="<select name=PPL1QuickNav onchange=javascript:ppl1quicknavgo(this);><option value=''> -- Select --</option>"&options&"</select>"

options=preparecode(options)
%>
function ppl1quicknavgo(what){
	var theval=what.value;
	if (theval!='') self.location.href=theval
}
document.write("<%=options%>");