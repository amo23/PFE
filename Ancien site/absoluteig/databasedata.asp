<%
'/// Connection Using an Access Database ///
database="db/absoluteig.mdb"
connection="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="& server.mappath(database) 

'/// Connection Using a SQL Server database ////
'connection="PROVIDER=SQLOLEDB;DATA SOURCE=YOUR_SERVER;DATABASE=absoluteig;USER ID=YOUR_USERNAME;PASSWORD=YOUR_PASSWORD;"


'//// Internal Settings, Do not change :
galleryfolder="gallery/"
gallerypath=server.mappath(galleryfolder)
gallerypath=left(gallerypath,len(gallerypath)-len(galleryfolder))&"\"
%>
