<!--#include file="incSystem.asp" -->
<!--#include file="incImage.asp" -->
<%
ipath=request("ipath")
ifile=request("ifile")
ispc=request("ispc")
path=getpath(ipath)&ifile
if ispc<>"" then path=getpath(ipath)
call imageresize()
%> 
 


