<!--#include file="configdata.asp"-->
<!--#include file="databasedata.asp"-->
<%
'//// Fonts Used In The Ticker ////
font=request("font")
size=request("size")
if font="" then font="arial"
if size="" then size="2"
target=request("target")
if target<>"" then target="target='"&target&"'"
sp=request("sp")
if sp="" or not(isnumeric(sp)) then sp=1

'//// Do Not Change Below /////
today=year(now)&"/"&right("0"&month(now),2)&"/"&right("0"&day(now),2)
response.buffer=true
zoneid=request("z")
if zoneid="" or not(isnumeric(zoneid)) then zoneid=0
psql="select * from vArticlesZones where zoneid="&zoneid&" and status=1 and startdate<='"&today&"' and enddate>='"&today&"' order by posted desc;"
set conn=server.createobject("ADODB.Connection")
conn.open connection
for x=1 to 15
	spacestring=spacestring &"&nbsp; "
next
set rs=conn.execute(psql)
c=0
do until rs.eof

articles=articles & "<a href='"&applicationurl&"anmviewer.asp?a="&rs("articleid")&"&z="&zoneid&"' "&target&">"&rs("headline")&"</a>"&spacestring

rs.movenext
loop
rs.close
set rs=nothing
conn.close
set conn=nothing

ticker="<marquee width=100% height=15 behavior=scroll direction=left loop=infinite scrolldelay=5 scrollamount=" & sp &"><font face='"&font&"' size='"&size&"'>"&articles&"</font></marquee>"
ticker=replace(ticker,"'","\'")
ticker=replace(ticker,chr(34),"\"&chr(34))
ticker=replace(ticker,"/","\/")
ticker=replace(ticker,vbcrlf,"\n")
%>
document.write ("<%=ticker%>");