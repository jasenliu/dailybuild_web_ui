require 'rubygems'
require 'sinatra'
require 'rake'
require 'erb'
require 'net/smtp'
require 'mailfactory'
require 'Rakefile.rb'
require 'email.rb'

def get_checkbox_item
	tasks = "getlatest,increaseversion2,updateversion2,ThcLib,TZip,TRDSCrypto,TCnPool,TLogging,TMisc,TRDSData,TErrHandler,TMD,TASet,TDCalc,TSecurity,TRefEntity,TExchangeRateMgr,TStock,TOption,TOTS,TBond,TIRD,TCYD,TIntexCMO,TMarkit,TStruProd,TCDO,TOptionDeriv,TDBLoad,IntexCMOClient,TMongoDb,TPortfolio,TTask,TPathFileAnalyzer,TPathFileParser,TCalc,TPO,OASCalibrating,TRDSIRRCalc,TRDSCALL,TUserRole,IRRCalc,CollectOTS,IRRSvc,ThcGLView,ReverseEngineering,TFileDB,tnetcmd_all,TClientShell,TBusiness,TAnalysis,TClient,CrystalReportCom,CrystalReportClient,CreateReport,ReportSvc,UpdFunc,UpdSvc,tpl_XXX,tcamel,spda,TNetInfo,systest,RSSV,TSvc4ESeries,movetoreleasefiles,copy_to_products,copy_to_pcnest,ClientSetupPackage,IRRSvcSetupPackage,buildFiles_With_cmo322"
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
			</form>
			<form id="redirect" action="/result_detail">
				<input type="submit" name="log" value="view_log" />
			</form>
		</body>
	</html>
html_end

end

post '/result' do
	log = File.new("logs/build.log", "w")
	$stdout = STDOUT
	$stderr = STDERR
	$stdout.reopen(log)
	$stdout.sync = true
	$stderr.reopen(log)
	task_hash = @env["rack.request.form_hash"]
	task_hash.delete('run')
	task_hash.delete('mail')
	task_hash = task_depends(task_hash)
	task_hash.each do |key, value|
		task = Rake::Task[key.downcase]
		task.reenable
		task.invoke
	end
	puts "overhaha"
	
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
	@output = File.open("logs/build.log").readlines
	@flag = File.open("logs/build.log").read
	html = <<html_end
	<html>
		<% if(@flag.include?('overhaha')) %>
			<style>body{background:green}</style>
		<% else %>
			<meta http-equiv="Refresh" content="5" />
		<% end %>
		<body>
			<% @output.each do |line| %>
				<% if line.include?('result_detail?')%>
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
		send_email(mail, 'build failed', erb.result(binding))
	else
		send_email(mail, 'build success', erb.result(binding))
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
	
	if(!task_hash.has_key?('RSSV'))
		task_hash.store('RSSV', 'RSSV')
	end
	task_hash
end
