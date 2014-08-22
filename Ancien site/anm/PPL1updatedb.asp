<%on error resume next
Const adInteger = 3
Const adVarWChar = 202
Const adLongVarWChar = 203
%>
<!--#include file="databasedata.asp" -->
<%

'/// Create New Tables ////
Set objADOXDatabase = Server.CreateObject("ADOX.Catalog")
objADOXDatabase.ActiveConnection =connection
Set objFirstTable = Server.CreateObject("ADOX.Table")
objFirstTable.ParentCatalog = objADOXDatabase

'//// Rate & Review Table 
objFirstTable.Name = "PPL1Reviews"
objFirstTable.Columns.Append "reviewid", adInteger
objFirstTable.Columns.item("reviewid").properties("AutoIncrement")=true
objFirstTable.Columns.Append "articleid", adInteger
objFirstTable.Columns.item("articleid").properties("Default")=0
objFirstTable.Columns.Append "name", adVarWChar, 255
objFirstTable.Columns.item("name").properties("Jet OLEDB:Allow Zero Length")=true
objFirstTable.Columns.Append "reviewdate", adVarWChar, 50
objFirstTable.Columns.item("reviewdate").properties("Jet OLEDB:Allow Zero Length")=true
objFirstTable.Columns.Append "review", adInteger
objFirstTable.Columns.item("review").properties("Default")=0
objFirstTable.Columns.Append "comments", adLongVarWChar
objFirstTable.Columns.item("comments").properties("Jet OLEDB:Allow Zero Length")=true
objFirstTable.Columns.Append "isannonymous", adVarWChar, 50
objFirstTable.Columns.item("isannonymous").properties("Jet OLEDB:Allow Zero Length")=true
objFirstTable.Keys.Append "PK_reviewid", 1, "reviewid"
objADOXDatabase.Tables.Append objFirstTable

'/// Table Relationship
Set rel = Server.CreateObject("ADOX.key")
With rel
	.Name = "PPLreviews"
	.Type = 2
	.UpdateRule=1
	.DeleteRule=1
	.RelatedTable = "articles"
	.Columns.Append "articleid"
	.Columns("articleid").RelatedColumn = "articleid"
End With
objADOXDatabase.Tables("PPL1reviews").Keys.Append Rel
set rel=nothing
set objFirstTable=nothing
set objADOXDatabase=nothing

if err.number<>0 then errormsg=err.description

%>
<html>
<head>
<title>PowerPlugs : Update Database utility</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="100%" border="0" cellspacing="2" cellpadding="2" height="100%">
<%if errormsg="" then%>
  <tr>
    <td> 
      <p align="center"><font face="Arial, Helvetica, sans-serif" size="4"><b><font color="#003399">Update 
        Completed</font></b></font><font face="Arial, Helvetica, sans-serif" size="2"><br>
        The database has been updated<br>
        Now you can install the plug-ins (Please refer to the documentation).</font></p>
      <p align="center"><font face="Arial, Helvetica, sans-serif" size="2">Please 
        delete this file : PPL1updatedb.asp</font></p>
</td>
  </tr>
  <%else%>
  <tr>
    <td>
      <div align="center"><font face="Arial, Helvetica, sans-serif" size="4"><b><font color="#FF0000">An 
        Error has Ocurred :</font></b></font><font face="Arial, Helvetica, sans-serif" size="2"><br>
        <%=errormsg%></font></div>
    </td>
  </tr>
  <%end if%>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>

