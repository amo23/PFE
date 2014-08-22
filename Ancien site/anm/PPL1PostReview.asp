<!--#include file="incSystem.asp"-->
<%
articleid=request("articleid")
if articleid="" or not(isnumeric(articleid)) then articleid=0
headline=request("headline")
comments=request("comments")
review=request("review")
name=request("name")
isannonymous=request("isannonymous")

if comments<>"" and review<>"" then
	set conn=server.createobject("ADODB.Connection")
	conn.open connection
	set rs=server.createobject("ADODB.Recordset")
	rs.open "ppl1reviews",conn,1,3,2
	rs.addnew
	rs("name")=name
	rs("comments")=comments
	rs("review")=review
	rs("reviewdate")=todaydate
	rs("isannonymous")=isannonymous&""
	rs("articleid")=articleid
	rs.update
	rs.close
	set rs=nothing
	
	'/// get New Rating ///
	psql="SELECT Count(PPL1Reviews.review) AS totalreviews, Sum(PPL1Reviews.review) AS thumbsup, PPL1Reviews.articleid FROM PPL1Reviews where articleid="&articleid&" GROUP BY PPL1Reviews.articleid"
	set rs=conn.execute(psql)
	totalreviews=rs("totalreviews")
	thumbsup=rs("thumbsup")
	rating=int(thumbsup*5/totalreviews)
	rs.close
	set rs=nothing
	conn.close
	set conn=nothing
	response.redirect "ppl1getreview.asp?articleid="&articleid&"&rating="&rating
end if
%>
<html>
<head>
<title>Write a Review : <%=headline%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function validate(){
	if (form1.comments.value!='') form1.submit();
	else alert('Please provide a comment before submitting');
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" rightmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="PPL1PostReview.asp?topost=1">
  <table width="100%" border="0" cellspacing="0" cellpadding="4">
    <tr> 
    <td bgcolor="#333333"><font face="Arial, Helvetica, sans-serif" size="4"><b><font color="#FFCC00" size="2"><%=headline%></font></b></font></td>
  </tr>
  <tr> 
    <td>
      <table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
        <tr>
            <td><font face="Arial, Helvetica, sans-serif" size="2" color="#999999"><b><font color="#666666">Write 
              a review :</font></b></font><font face="Arial, Helvetica, sans-serif" size="2"><br>
            <font color="#666666">Fill out the form below to tell the world what 
            you think! Strong opinions -- positive or negative -- are welcome, 
            but please keep your language clean. </font></font></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
      <td bgcolor="#EFEFEF"> 
        <table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
        <tr>
            <td> 
              <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b>THUMBS 
                UP OR THUMBS DOWN?<br>
                <input type="radio" name="review" value="1" checked>
                <img src="PPL1Images/thumbsup.gif" width="14" height="17"> 
                <input type="radio" name="review" value="0">
                <img src="PPL1Images/thumbsdown.gif" width="14" height="17"></b></font></p>
              <p><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">COMMENTS 
                :<br>
                <textarea name="comments" rows="8" style="width:100%"></textarea>
                </font></b></p>
              <p><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">YOUR 
                NAME : 
                <input type="text" name="name" maxlength="200">
                <br>
                </font></b><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#666666"> 
                <input type="checkbox" name="isannonymous" value="checked">
                KEEP ME ANNONYMOUS
                <input type="hidden" name="articleid" value="<%=articleid%>">
                </font></p>
            </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
      <td height="60" align="center"> <a href="javascript:self.close();"><img src="PPL1Images/cancel.gif" width="109" height="24" hspace="8" border="0"></a><a href="javascript:validate();"><img src="PPL1Images/submit.gif" width="109" height="24" border="0"></a></td>
  </tr>
</table>
</form>
</body>
</html>
