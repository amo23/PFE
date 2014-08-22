<!-- #include file="incSystem.asp" -->
<%

'//// Receive Search Criteria ////
search=request("search")&""
ssearch=replace(search,"'","''")
zoneid=request("zoneid")&""
sarchives=request("sarchives")

psql="select * from articles where (headline like '%"&ssearch&"%' or article like '%"&ssearch&"%' or summary like '%"&ssearch&"%' or source like '%"&ssearch&"%') and (article not like '' or articleurl not like '')"
if zoneid<>"" then 
	psql=psql & " and articleid in (select articleid from iArticlesZones where zoneid="&zoneid&")"
end if
if sarchives<>"" then
	psql=psql & " and (status=1 or status=4)"
else
	psql=psql & " and status=1 "
end if


psql=psql & " order by startdate , headline asc"
searchsql=psql

mypage=request("whichpage")
if mypage="" then mypage=1
mypagesize=10
scriptname="PPL.Search.asp?search="&server.urlencode(search)&"&zoneid="&zoneid&"&sarchives="&sarchives

set conn=server.createobject("ADODB.Connection")
conn.open connection


%>
<html>

<head>
<title>LENTIC</title>
</head>

<body link="#800000" vlink="#800000" alink="#800000">

<div align="center">
  <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" width="770" id="table1" bordercolor="#336699">
    <tr>
      <td valign="top">
      <div align="center">
        <table border="0" cellpadding="0" style="border-collapse: collapse" width="770" id="table2">
          <tr>
            <td height="19" bgcolor="#B8BCC4" width="484">&nbsp;</td>
            <td colspan="2" height="19" bgcolor="#B8BCC4">
            <table border="0" cellpadding="2" style="border-collapse: collapse" width="100%" id="table8">
              <tr>
                <td>
                <p align="right"><font face="Verdana" size="1" color="#336699">
                <b>LENTIC - 
                  Université de Liège&nbsp;</b></font></td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td height="115" colspan="3">
            <table border="0" cellpadding="0" style="border-collapse: collapse" width="100%" id="table3">
              <tr>
                <td width="452" bgcolor="#FFFFFF" height="115">
                <img border="0" src="../images/logopredpointcorrige.jpg" width="267" height="120"></td>
                <td valign="top" bgcolor="#FFFFFF" height="115">
                <table border="1" cellpadding="6" style="border-width:0px; border-collapse: collapse" width="100%" id="table4">
                  <tr>
                    <td style="border-style: none; border-width: medium">
                    <p align="right">
                    <font face="Verdana" size="1" color="#336699">Boulevard du Rectorat, 19 - B 51 
                    <br>4000 Sart Tilman <br>Belgique </font></p>
                    <p align="right">
                    <font size="1" face="Verdana" color="#336699">Tél. : +32 4 366 
                  30 70 <br>Fax. : +32 4 366 29 47 <br>Email : 
                    <a href="mailto:info@lentic.be"><font color="#336699">
                    <span style="text-decoration: none">info@lentic.be</span></font></a>
                    </font></td>
                  </tr>
                </table></td>
              </tr>
              <tr>
                <td height="115" colspan="2" valign="top">
                <div align="center">
                  <table border="0" cellpadding="0" style="border-collapse: collapse" width="100%" id="table13" height="204">
                    <tr>
                      <td width="256" height="182" style="border-top-style: solid; border-top-width: 1px">
                      <map name="FPMap0">
                      <area href="anmviewer.asp?a=97&z=47" shape="rect" coords="48, 14, 170, 42">
                      <area href="anmviewer.asp?a=93&z=44" shape="rect" coords="47, 45, 172, 76">
                      <area href="anmviewer.asp?a=98&z=49" shape="rect" coords="47, 76, 171, 102">
                      <area href="../absoluteig/gallery.asp" shape="rect" coords="49, 102, 172, 132">
                      <area href="anmviewer.asp?a=92&z=51" shape="rect" coords="49, 134, 174, 166">
                      <area href="../index.htm" shape="rect" coords="187, 15, 241, 61">
                      <area href="../plan.htm" shape="rect" coords="188, 65, 241, 112">
                      <area href="mailto:info@lentic.be" shape="rect" coords="190, 119, 242, 167">
                      </map>
                      <img border="0" src="../images/menusite.jpg" width="256" height="182" usemap="#FPMap0"></td>
                      <td width="514" height="182" background="../images/dessin_lentic_web_grey.jpg" style="border-top-style: solid; border-top-width: 1px; border-bottom-style: solid; border-bottom-width: 1px">&nbsp;</td>
                    </tr>
                    <tr>
                      <td width="256" height="22" style="border-top-style: solid; border-top-width: 1px; border-right-style:none; border-right-width:medium" bgcolor="#6D7585">
                      &nbsp;</td>
                      <td width="514" height="22" style="border-bottom-style: none; border-bottom-width: medium; border-left-style:none; border-left-width:medium; border-right-style:none; border-right-width:medium" bgcolor="#6D7585">
                      <table border="0" cellpadding="4" style="border-collapse: collapse" width="100%" id="table17">
                        <tr>
                          <td>
                          <p align="left"><span lang="fr-be"><b>
                          <font size="2" face="Verdana" color="#FFFFFF">// 
                          RESULTATS DE LA RECHERCHE</font></b></span></td>
                        </tr>
                      </table>
                      </td>
                    </tr>
                  </table>
                </div>
                </td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td colspan="3" valign="top">
            <table border="0" cellpadding="5" style="border-collapse: collapse" width="100%" id="table9">
              <tr>
                <td width="256" bgcolor="#EFEEE9" valign="top">
                <table border="0" cellpadding="4" style="border-collapse: collapse" width="100%" id="table15">
                  <tr>
                    <td>
                    &nbsp;</td>
                  </tr>
                  <tr>
                    <td>
                    <div align="center">
                      <table border="1" cellpadding="6" style="border-collapse: collapse" width="80%" id="table18" bgcolor="#FFFFFF" bordercolorlight="#C0C0C0" bordercolordark="#808080" bordercolor="#808080">
                        <tr>
                          <td style="border-style: solid; border-width: 1px">
                  <span lang="fr-be"> 
                  <form name="form2" method="post" action="PPL.search2.asp">
                    <div align="center"><font face="Verdana" size="1">Rechercher 
                      sur le site :<br>
&nbsp;<input type="text" name="search" size="17">
                      <input type="submit" name="Submit1" value="&gt;&gt;" style="color: #000000; font-family: Arial; font-size: 8pt; background-color: #FFFFFF">
                      </font></div>
                  </form></td>
                        </tr>
                     </table>
                    </div>
                    </td>
                  </tr>
                  </table>
&nbsp;</td>
                <td bgcolor="#FFFFFF" width="494" valign="top">
                <table border="0" cellpadding="6" style="border-collapse: collapse" width="100%" id="table16">
                  <tr>
                    <td> 
                    <!-- PPL Search Plug-In Begins -->
<form name="form1" method="post" action="PPL.Search2.asp" style="margin:0">
  <table width="96%" border="0" cellspacing="2" cellpadding="2">
    <tr valign="top" align="left"> 
      <td width="20%"><span lang="fr-be">
      <font face="Arial, Helvetica, sans-serif" size="2">Mots-clés</font></span><font face="Arial, Helvetica, sans-serif" size="2"> 
        :</font> <font face="Arial, Helvetica, sans-serif" size="2"> </font></td>
      <td width="80%"><font face="Arial, Helvetica, sans-serif" size="2"> 
        <input type="text" name="search" size="37" value="<%=search%>">
        <input type="submit" name="Submit" value="Chercher">
        </font> </td>
    </tr>
    <tr valign="top" align="left"> 
      <td width="20%"><font face="Arial, Helvetica, sans-serif" size="2">
      Categorie :</font></td>
      <td width="80%"><font face="Arial, Helvetica, sans-serif" size="2"> 
        <select name="zoneid">
          <option value=''>-- Tout le site --</option>
          <%
		if zoneid="" or not(isnumeric(zoneid)) then zoneid=0
		psql="select * from zones order by zonename asc;"
		set rs=conn.execute(psql)
		do until rs.eof
			if zoneid-rs("zoneid")=0 then sel=" selected" else sel=""
			response.write "<option value='"&rs("zoneid")&"'"&sel&">"&rs("zonename")&"</option>"
			rs.movenext
		loop	
		rs.close
		set rs=nothing
		%>
        </select>
        </font></td>
    </tr>
  </table>
  <table border="0" cellspacing="1" width="96%" cellpadding="0">
    <tr> 
      <td width="100%" align="left" valign="top"> 
        <hr>
      </td>
    </tr>
    <%
set rs=server.createobject("ADODB.Recordset")
rs.open searchsql,conn,1 
if not(rs.eof) then 
	maxval=rs.recordcount
	rs.movefirst
	rs.pagesize=mypagesize
	maxcount=cint(rs.pagecount)
	rs.absolutepage=mypage
	howmanyrecs=0
	howmanyfields=rs.fields.count-1
%>
    <tr> 
      <td width="0" align="left" valign="top" height="0"> 
        <table border="0" cellpadding="3" width="100%">
          <%
	cc=(mypagesize*mypage)-mypagesize
	if zoneid<>0 then zone="&z="&zoneid 
	do until rs.eof or howmanyrecs>=rs.pagesize
		cc=cc+1
		articleid=rs("articleid")
		headline=rs("headline")
		headlinedate=rs("headlinedate")
		source=rs("source")
		summary=rs("summary")
	
%>
          <tr align="left" valign="top"> 
            <td align="right" width="40"><font face="Arial, Helvetica, sans-serif" size="2"><%=cc%>.</font></td>
            <td><font face="Arial, Helvetica, sans-serif" size="2"><a
              href="anmviewer.asp?a=<%=articleid%><%=zone%>"><b><%=headline%></b></a> 
              <font size="1">(<%=headlinedate & " - " & source%>)</font><br>
              <font size="1" face="Verdana, Arial, Helvetica, sans-serif"><%=server.htmlencode(summary)%><br>
              </font></font></td>
          </tr>
          <%
		rs.movenext
		howmanyrecs=howmanyrecs+1
		loop
			%>
        </table>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" valign="top" align="left"> 
        <hr>
      </td>
    </tr>
    <tr align="center"> 
      <td width="100%" valign="top" align="left"><font face="Arial, Helvetica, sans-serif" size="2"><b>Articles 
      <span lang="fr-be">trouvés</span> : <%=maxval%><br>
      Page <%=mypage%> <span lang="fr-be">sur</span> <%=maxcount%></b></font><b><font face="Arial, Helvetica, sans-serif" size="2"><br>
        <span lang="fr-be">Aller à la p</span>age : 
        <select name="pageselector" onchange="javascript:gopage(this.value);">
          <%
		for counter=1 to maxcount
		if counter-mypage=0 then sel=" selected" else sel=""
			response.write "<option value="&counter&sel&">"&counter&"</option>"
		next
		%>
        </select>
        <script language="JavaScript">
	  function gopage(what){
	  	window.location.href='<%=scriptname%>&whichpage=' + what;
	  }
	  </script>
        <%if cint(mypage)>1 then response.write "<a href='"&scriptname&"&whichpage="&mypage-1&"'>&lt;&lt;</a> "  
	  if cint(mypage)<maxcount then response.write "<a href='"&scriptname&"&whichpage="&mypage+1&"'>&gt;&gt;</a>"%>
        </font></b></td>
    </tr>
    <%else%>
    <tr align="center"> 
      <td width="100%" valign="top" align="left"> 
        <p align="center">&nbsp; 
        <p><b>
        <font face="Arial, Helvetica, sans-serif" size="2" color="#000066">
        <span lang="fr-be">Aucune information ne correspond à votre requête.</span></font></b> 
        <p>&nbsp; 
        <hr>
      </td>
    </tr>
    <%end if
  rs.close
	set rs=nothing
	conn.close
	set conn=nothing

  %>
  </table>
</form>
<!-- PPL Search Plug-in Ends -->
<br>
                    </td>
                  </tr>
                  <tr>
                    <td> 
                  <font face="Verdana" size="1">&gt;&gt;&gt;</font></td>
                  </tr>
                  </table>
                </td>
                <td bgcolor="#EFEEE9">
                &nbsp;</td>
              </tr>
              </table></td>
          </tr>
          <tr>
            <td height="25" bgcolor="#B8BCC4" colspan="2">
            <table border="0" cellpadding="6" style="border-collapse: collapse" width="99%" id="table5">
              <tr>
                <td>
                <!--webbot bot="Include" U-Include="inc/menubas.htm" TAG="BODY" startspan -->

<p><font face="Verdana" size="1">
<a href="http://www.lentic.be/anm/anmviewer.asp?a=97&z=47">
<span style="text-decoration: none"><font color="#000000">Missions</font></span></a> <span lang="fr-be">|</span> 
<a href="http://www.lentic.be/anm/anmviewer.asp?a=93&z=44">
<font color="#000000"><span style="text-decoration: none">Axes de recherche</span></font></a> 
                <span lang="fr-be">|</span> 
<a href="http://www.lentic.be/absoluteig/gallery.asp">
<font color="#000000"><span style="text-decoration: none">Ressources</span></font></a> <span lang="fr-be">|</span> 
              <a href="http://www.lentic.be/anm/anmviewer.asp?a=92&z=51">
<font color="#000000"><span style="text-decoration: none">Équipe</span></font></a> <span lang="fr-be">|</span> 
<a href="mailto:info@lentic.be"><font color="#000000">
<span style="text-decoration: none">Contact</span></font></a> <span lang="fr-be">|</span> 
<a href="http://www.lentic.be/plan.htm"><font color="#000000">
<span style="text-decoration: none">Plan du site</span></font></a> </font></p>

<!--webbot bot="Include" i-checksum="28933" endspan --></td>
              </tr>
            </table></td>
            <td height="25" width="286" bgcolor="#B8BCC4">
            <table border="0" cellpadding="0" style="border-collapse: collapse" width="100%" id="table6">
              <tr>
                <td>
                <p align="right"><span lang="fr-be">
                <font face="Verdana" size="1">© LENTIC - 2004
                <img border="0" src="../images/ulg40px.gif" width="40" height="28" align="absmiddle"></font></span></td>
              </tr>
            </table></td>
          </tr>
        </table>
      </div>
      </td>
    </tr>
  </table>
</div>

</body>

</html>