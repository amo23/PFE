<!--#include file="incSystem.asp" -->
<%
imageid=request("imageid")
if imageid="" or not(isnumeric(imageid)) then imageid=0


Function downloadFile(strFile)  
	strFilename = getpath(strFile)  
	Response.Buffer = True  
	Response.Clear  
	Set s = Server.CreateObject("ADODB.Stream")  
	s.Open  
	s.Type = 1  
	on error resume next  
	Set fso = Server.CreateObject("Scripting.FileSystemObject")  
	if not fso.FileExists(strFilename) then  
		Response.Write("Error: File not found")
		Response.End  
	end if  
	Set f = fso.GetFile(strFilename)  
	intFilelength = f.size  
	s.LoadFromFile(strFilename)  
	if err then  
		Response.Write("Error: File not found") 
		Response.End  
	end if  
	Response.AddHeader "Content-Disposition", "attachment; filename=" & f.name  
	Response.AddHeader "Content-Length", intFilelength  
	Response.CharSet = "UTF-8"  
	Response.ContentType = "application/octet-stream"  
	Response.BinaryWrite s.Read  
	Response.Flush  
	s.Close  
	Set s = Nothing 
	response.end 
End Function  


set conn=server.createobject("ADODB.Connection")
conn.open connection
psql="select imagepath from "&vxlaAIGimagesCategories&" where imageid="&imageid
set rs=conn.execute(psql)
if not(rs.eof) then imagepath=rs("imagepath")
rs.close
set rs=nothing

if imagepath<>"" then downloadfile(imagepath)
Response.Write("Error: File not found")

%>
