<%
'//// Include for JMail Component ////
'/// http://www.dimac.net
emailcomponent="Dimac JMail"
sub sendmail(recipient,senderemail,subject,message)
	Set JMail = Server.CreateObject("JMail.SMTPMail")
	JMail.ServerAddress = smtpserver
	JMail.Sender = defaultemail
	JMail.Subject = subject
	JMail.sendername = senderemail
	JMail.Replyto = senderemail
	JMail.Body = message
	JMail.AddRecipient recipient
	JMail.Priority = 1
	JMail.Execute
	set Jmail=nothing
end sub
%>