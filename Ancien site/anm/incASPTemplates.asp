<!--#include file="configdata.asp" -->
<!--#include file="incviewarticle.asp" -->
<%articleid=request("articleid")
zoneid=request("zoneid")
call anmviewarticle(articleid,zoneid)
files=attachments
site=license
%>
