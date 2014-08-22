<%
'//// Include for ServerObject's ASPMail Component ////
'///  http://www.serverobjects.com
emailcomponent="ServerObjects ASPMail"
sub sendmail(recipient,senderemail,subject,message)
	Set Mailer = Server.CreateObject("SMTPsvg.Mailer")
	Mailer.FromName   = senderemail
	Mailer.FromAddress= defaultemail
	Mailer.Replyto = senderemail
	Mailer.RemoteHost = smtpserver
	Mailer.AddRecipient recipient
	Mailer.Subject    = subject
	Mailer.BodyText   = message
	if not(Mailer.SendMail) then
	  errormsg= "Mail send failure. Error was " & Mailer.Response
	end if
	set Mailer=nothing
end sub
%>