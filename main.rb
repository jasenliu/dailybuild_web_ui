require 'rubygems'
require 'sinatra'
require 'rake'
require 'erb'
require 'net/smtp'
require 'mailfactory'
require 'Rakefile.rb'
require 'email.rb'

def get_checkbox_item
	#tasks = "getlatest,increaseversion2,updateversion2,ThcLib,TZip,TRDSCrypto,TCnPool,TLogging,TMisc,TRDSData,TErrHandler,TMD,TASet,TDCalc,TSecurity,TRefEntity,TExchangeRateMgr,TStock,TOption,TOTS,TBond,TIRD,TCYD,TIntexCMO,TMarkit,TStruProd,TCDO,TOptionDeriv,TDBLoad,IntexCMOClient,TMongoDb,TPortfolio,TTask,TPathFileAnalyzer,TPathFileParser,TCalc,TPO,OASCalibrating,TRDSIRRCalc,TRDSCALL,TUserRole,IRRCalc,CollectOTS,IRRSvc,ThcGLView,ReverseEngineering,TFileDB,tnetcmd_all,TClientShell,TBusiness,TAnalysis,TClient,CrystalReportCom,CrystalReportClient,CreateReport,ReportSvc,UpdFunc,UpdSvc,tpl_XXX,tcamel,spda,TNetInfo,systest,RSSV,TSvc4ESeries,movetoreleasefiles,copy_to_products,copy_to_pcnest,ClientSetupPackage,IRRSvcSetupPackage,buildFiles_With_cmo322"
	
	tasks = "ThcLib,TZip,TRDSCrypto,TCnPool,TLogging,TMisc,TRDSData,TErrHandler,TMD,TASet,TDCalc,TSecurity,TRefEntity,TExchangeRateMgr,TStock,TOption,TOTS,TBond,TIRD,TCYD,TIntexCMO,TMarkit,TStruProd,TCDO,TOptionDeriv,TDBLoad,IntexCMOClient,TMongoDb,TPortfolio,TTask,TMAP,TPathFileAnalyzer,TPathFileParser,TCalc,TPO,OASCalibrating,TRDSIRRCalc,TRDSCALL,TUserRole,IRRCalc,CollectOTS,IRRSvc,ThcGLView,ReverseEngineering,TFileDB,tnetcmd_all,TClientShell,TBusiness,TAnalysis,TClient,CrystalReportCom,CrystalReportClient,CreateReport,ReportSvc,UpdFunc,UpdSvc,tpl_XXX,tcamel,spda,TNetInfo,systest,RSSV,copy_to_products,copy_to_pcnest,ClientSetupPackage,IRRSvcSetupPackage,update_web,update_dll,update_173,update_web_report_template"
	task_arr = tasks.split(',')
end

get '/index' do
	@task_arr = get_checkbox_item
	erb html = <<html_end
	<html>
		<body>
			<form id="build" method="post" action="/result">
				<table>
				<tr>
					<td>
						<% 0.upto 9 do |index| %>
							<input type="checkbox" name="<%= @task_arr[index] %>" value="<%= @task_arr[index] %>" /><%= @task_arr[index] %><br />
						<% end %>
					</td>
					<td>
						<% 10.upto 19 do |index| %>
							<input type="checkbox" name="<%= @task_arr[index] %>" value="<%= @task_arr[index] %>" /><%= @task_arr[index] %><br />
						<% end %>
					</td>
					<td>
						<% 20.upto 29 do |index| %>
							<input type="checkbox" name="<%= @task_arr[index] %>" value="<%= @task_arr[index] %>" /><%= @task_arr[index] %><br />
						<% end %>
					</td>
					<td>
						<% 30.upto 39 do |index| %>
						<input type="checkbox" name="<%= @task_arr[index] %>" value="<%= @task_arr[index] %>" /><%= @task_arr[index] %><br />
						<% end %>
					</td>
					<td>
						<% 40.upto 49 do |index| %>
						<input type="checkbox" name="<%= @task_arr[index] %>" value="<%= @task_arr[index] %>" /><%= @task_arr[index] %><br />
						<% end %>
					</td>
					<td>
						<% 50.upto 59 do |index| %>
						<input type="checkbox" name="<%= @task_arr[index] %>" value="<%= @task_arr[index] %>" /><%= @task_arr[index] %><br />
						<% end %>
					</td>
					<td>
						<% 60.upto 69 do |index| %>
						<input type="checkbox" name="<%= @task_arr[index] %>" value="<%= @task_arr[index] %>" /><%= @task_arr[index] %><br />
						<% end %>
					</td>
				</tr>
			</table><br />
			MailTo:<input type="text" name="mail" value="jsliu" />@thc.net.cn
			<input type="submit" name="run" value="run" />
			<input type="button" name="view_console" value="view_console" onclick="window.location = '/result_detail'" />
			</form>
		</body>
	</html>
html_end

end

post '/result' do
	$date = Time.now.strftime("%Y%m%d %H%M")
	log = File.new("logs/build_#{$date}.log", "w")
	$stdout = STDOUT
	$stderr = STDERR
	$stdout.reopen(log)
	$stdout.sync = true
	$stderr.reopen(log)
	task_hash = @env["rack.request.form_hash"]
	task_hash = task_depends(task_hash)
	sort_task = sort_task(task_hash)
	sort_task.each do |key|
		task = Rake::Task[key.downcase]
		task.reenable
		task.invoke
	end
	p task_hash
	puts "overhaha"
	#redirect '/result_detail'
	
end

get '/result_detail' do
	erb result = mail_body
end

configure :development do
  enable :logging, :dump_errors
  set :raise_errors, true
	set :env, :development
end

after do
	req = Rack::Request.new(env)
  if(req.post?)
		send_result
	end
end

def mail_body
	@output = File.open("logs/build_#{$date}.log").readlines
	@flag = File.open("logs/build_#{$date}.log").read
	html = <<html_end
	<html>
		<style>body{background:black; color:white;}</style>
		<% if(@flag.include?('overhaha')) %>
			<style>body{background:green;}</style>
		<% else %>
			<meta http-equiv="Refresh" content="2" />
		<% end %>
		<body onLoad="window.document.body.scrollTop = document.body.scrollHeight; ">
			<% @output.each do |line| %>
				<% if line.include?('result_detail')%>
					<% next %>
				<% end %>
				<%= line %> <br />
			<% end %>
		</body>
	</html>
html_end
	html
end

def send_result()
	mail = params[:mail]
	if(mail.include?(','))
		mail = mail.split(',')
		mail.collect! do |pre|
			pre += "@thc.net.cn"
		end
	else
		mail = mail + "@thc.net.cn"
		mail = ["#{mail}"]
	end
	
	error = @env['sinatra.error']
	content = mail_body
	erb = ERB.new(content)
	if(error != nil)
		puts "the error is:" + error
		send_email(mail, 'THC C0702 Develop Version Build Failure', erb.result(binding))
	else
		send_email(mail, 'THC C0702 Develop Version Build Success', erb.result(binding))
	end
end

def task_depends(task_hash)
	if(task_hash.has_key?('TClientShell') && !task_hash.has_key?('TClient'))
		task_hash.store('TClient', 'TClient')
	end
	
	if(task_hash.has_key?('TClientShell') && !task_hash.has_key?('CrystalReportCom'))
		task_hash.store('CrystalReportCom', 'CrystalReportCom')
	end
	
	if(task_hash.has_key?('TClientShell') && !task_hash.has_key?('TAnalysis'))
		task_hash.store('TAnalysis', 'TAnalysis')
	end
	
	if(task_hash.has_key?('TAnalysis') && !task_hash.has_key?('tpl_XXX'))
		task_hash.store('tpl_XXX', 'tpl_XXX')
	end

	if(task_hash.has_key?('TAnalysis') && !task_hash.has_key?('RSSV'))
		task_hash.store('RSSV', 'RSSV')
	end
	
	if(!task_hash.has_key?('copy_to_products'))
		task_hash.store('copy_to_products', 'copy_to_products')
	end
	
	if(task_hash.has_key?('update_web') || task_hash.has_key?('update_173') || task_hash.has_key?('update_all') || task_hash.has_key?('get_web_file') || task_hash.has_key?('update_web_report_template'))
		task_hash.delete('copy_to_products')
	end
	task_hash
end

def sort_task(task_hash)
	task_arr = get_checkbox_item
	sort_task = []
	task_arr.each do |task|
		if(task_hash.has_key?(task))
			sort_task << task
		end
	end
	sort_task
end
