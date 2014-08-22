<%
'/// Include file for ASPJpeg
'/// http://www.persits.com

sub imageresize()
	Set jpeg = Server.CreateObject("Persits.Jpeg")
	jpeg.Open(path)
	if ispc<>""then thesize=pcsize else thesize=tnsize
	if jpeg.width>jpeg.height then
		jpeg.Width = thesize
		jpeg.Height = jpeg.OriginalHeight * jpeg.Width / jpeg.OriginalWidth
	else
		jpeg.height = thesize
		jpeg.width = jpeg.OriginalWidth * jpeg.height / jpeg.Originalheight
	end if
	' Send thumbnail data to client browser
	jpeg.SendBinary
	
	if savetn<>"" and ispc="" then
		Jpeg.Save getpath(ipath) & "tn\"&tnprefix&ifile
	end if
set jpeg=nothing
end sub
%>
