<!-- #include file="_ppl.tb.functions.asp" -->
<%
articleurl="../anmviewer.asp?a=" & articleid & "&z=" & zoneid

'/// Get The Article ///'
set conn=server.createobject("ADODB.Connection")
conn.open connection
psql="select headline,summary,article from articles where articleid=" & articleid & " and (status=1 or status=4) and articleurl=''"
set rs=conn.execute(psql)
if not(rs.eof) then
	headline=rs("headline")
	summary=rs("summary")
	article=rs("article")
end if
rs.close
set rs=nothing

'/// Get Next 140 articles from the same zone
psql="select * from (select top 35 articleid,headline,summary,zoneid from (SELECT articles.articleid, articles.headline, articles.summary, zones.zoneid FROM zones INNER JOIN (articles INNER JOIN iArticlesZones ON articles.articleid = iArticlesZones.articleid) ON zones.zoneid = iArticlesZones.zoneid where status=1 or status=4) derivedtbl  where articleid>" & articleid & " and articleid in (select articleid from iArticlesZones where zoneid=" & zoneid &") order by articleid asc) DERIVEDTBL" & vbcrlf 
psql=psql & "UNION" & vbcrlf
psql=psql & "select * from (select top 35 articleid,headline,summary,zoneid from (SELECT articles.articleid, articles.headline, articles.summary, zones.zoneid FROM zones INNER JOIN (articles INNER JOIN iArticlesZones ON articles.articleid = iArticlesZones.articleid) ON zones.zoneid = iArticlesZones.zoneid where status=1 or status=4) derivedtbl where articleid<" & articleid & " and articleid in (select articleid from iArticlesZones where zoneid=" & zoneid &") order by articleid desc) DERIVEDTBL" & vbcrlf
psql = psql & "UNION" & vbcrlf
psql=psql & "select * from (select top 35 articleid,headline,summary,zoneid from (SELECT articles.articleid, articles.headline, articles.summary, zones.zoneid FROM zones INNER JOIN (articles INNER JOIN iArticlesZones ON articles.articleid = iArticlesZones.articleid) ON zones.zoneid = iArticlesZones.zoneid where status=1 or status=4) derivedtbl where articleid<>" & articleid & " and articleid in (select articleid from iArticlesZones where zoneid<>" & zoneid &") order by articleid asc) DERIVEDTBL" & vbcrlf
psql=psql & "UNION" & vbcrlf
psql=psql & "select * from (select top 35 articleid,headline,summary,zoneid from (SELECT articles.articleid, articles.headline, articles.summary, zones.zoneid FROM zones INNER JOIN (articles INNER JOIN iArticlesZones ON articles.articleid = iArticlesZones.articleid) ON zones.zoneid = iArticlesZones.zoneid where status=1 or status=4) derivedtbl where articleid<>" & articleid & " and articleid in (select articleid from iArticlesZones where zoneid<>" & zoneid &") order by articleid desc) DERIVEDTBL" & vbcrlf

set rs=conn.execute(psql)
if not(rs.eof) then linkarray=rs.getrows
rs.close
set rs=nothing
conn.close
set conn=nothing


%>
<html>
<head>
<script language="JavaScript" src="_ppl.tb.js.asp?a=<%=articleid%>&z=<%=zoneid%>"></script>
<meta name="GENERATOR" content="Microsoft FrontPage 8.02">
<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<META NAME="description" CONTENT="<%=setdesc()%>">
<LINK REL=Home>
<META NAME="robots" CONTENT="index, follow">
<META NAME="keywords" CONTENT="<%=setkeywords()%>">
<META NAME="revisit-after" CONTENT="30 days">
<META NAME="robots" CONTENT="noarchive">
<TITLE><%=headline%></TITLE>
</head>
<BODY  bgcolor="#FFFFFF" leftmargin="2" topmargin="2" marginwidth="2" marginheight="2">
<div style="position:absolute; left:-9000; top:-9000;z-index:1">
  <table width="800" border="0" align="center" cellpadding="2" cellspacing="2">
  <tr align="left" valign="top"> 
    <td colspan="2"><font color="#003399" size="3" face="Arial, Helvetica, sans-serif"><b><%=headline%></b></font><br>
      <font size="2" face="Arial, Helvetica, sans-serif"><%=summary%><br>
      </font>
      <hr>
    </td>
  </tr>
  <tr align="left" valign="top">
	  <td width="20%" bgcolor="#CCCCCC"> <b><a href="<%=siteurl%>"><font size="4" face="Tahoma, Arial, Verdana">Home</font></a></b><br>
        <%followlinks(linkarray)%>
    </td> 
    <td><font size="2" face="Arial, Helvetica, sans-serif"><%=article%></font></td>
  </tr>
    <tr bgcolor="#009966"> 
      <td colspan="2">Powered By Traffic Booster <a href="http://www.xigla.com/absolutenm">Absolute 
        News Manager</a> Plug-in by <a href="http://www.xigla.com"><b>Xigla Software</b></a></td>
  </tr>
</table>
</div>
<p><font size="2" face="Arial, Helvetica, sans-serif"><b>This article has been 
  moved <a href="<%=articleurl%>">here</a> 
  </b></font> </p>

</body>
</html>
