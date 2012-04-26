=begin
**************************************************************************************
	DefName: send_email
	Description: send_email
	ParameterList: to
								 subject
								 html
	Return:

	Author: LiuJingsen
	CreatedDate: 2012-01-18
**************************************************************************************
	History: Date                Changer      			Reason
          2012-01-18          LiuJingsen          create 
					2012-02-16          LiuJingSen				  remove file_path of attach
**************************************************************************************
=end
def send_email(to, subject, html)
	mail = MailFactory.new
	mail.to = to.join(',')
	mail.from = 'DailyBuild@thc.net.cn'
	mail.subject = subject
	mail.html = html
	#mail.attach(file_path)
	
	Net::SMTP.start('192.168.0.190') { |smtp|
    smtp.send_message(mail.to_s(), 'DailyBuild@thc.net.cn', to)
}
end
