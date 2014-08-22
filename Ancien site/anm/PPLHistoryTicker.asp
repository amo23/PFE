<!--#include file="configdata.asp"-->
<%
h=request("h")
if h=0 then h=220
z=request("z")
font=request("verdana")
size=request("1")
bg=request("bg")
fg=request("fg")
sp=request("sp")
t="<IFRAME ID=IFrame1 FRAMEBORDER=0 SCROLLING=NO width=100% height="&h&" SRC='" & applicationurl & "PPLHistoryTickerCore.asp?z="&z&"&h="&h&"&font="&font&"&size="&size&"&bg="&bg&"&fg="&fg&"&sp="&sp&"'></iframe>" 
t=replace(t,"'","\'")
t=replace(t,"/","\/")
%>
document.write ("<%=t%>");