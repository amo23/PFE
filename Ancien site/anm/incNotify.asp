<!--#include file="incEmail.asp" -->
<%
function sendnotification(zones,message)
	message=message & vbcrlf&vbcrlf & "To log into the application go to : "&applicationurl&vbcrlf&vbcrlf&emailsignature
	psql="select email from publishers where email like '%@%' and publisherid in( select publisherid from publisherszones where zoneid in ("&zones&"))"

	if notifyadmin<>"" and notifyeditor<>"" then
		 psql=psql & " and plevel>0 "
	elseif notifyeditor<>"" then
		psql=psql & " and plevel=1 "
	elseif notifyadmin<>"" then
		psql=psql &" and plevel=2 "
	end if

	set rs=conn.execute(psql)
	do until rs.eof
		cc=cc & rs("email")&","
		rs.movenext
	loop
	rs.close
	set rs=nothing
	if cc<>"" then call sendmail(cc,"",defaultemail,notifysubject,message)
end function
%>

