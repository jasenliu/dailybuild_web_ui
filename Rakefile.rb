require 'fileutils'
require 'stringio'
require 'ftools'
require 'net/ssh'

=begin
module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
  end
end
=end
#================================Default config=====================================
#bak = :increaseversion,:updateversion,
task :default => [:precondition,:increaseversion,:updateversion,:thclib,:tzip,:trdscrypto,:tcnpool,:tlogging,:tmisc,:trdsdata,:terrhandler,:tmd,:taset,:tdcalc,:tsecurity,:trefentity,:texchangeratemgr,:tstock,:toption,:tots,:tbond,:tird,:tcyd,:tintexcmo,:tmarkit,:tstruprod,:tcdo,:toptionderiv,:tdbload,:intexcmoclient,:tmongodb,:tportfolio,:ttask,:tpathfileanalyzer,:tpathfileparser,:tcalc,:tpo,:oascalibrating,:trdsirrcalc,:trdscall,:tuserrole,:irrcalc,:collectots,:irrsvc,:thcglview,:reverseengineering,:tfiledb,:tnetcmd_all,:tclientshell,:tbusiness,:tanalysis,:tclient,:crystalreportcom,:crystalreportclient,:createreport,:reportsvc,:updfunc,:updsvc,:tpl_xxx,:tcamel,:spda,:tnetinfo,:systest,:rssv,:tsvc4eseries,:copy_to_products,:copy_to_pcnest:clientsetuppackage,:irrsvcsetuppackage,:buildFiles_With_cmo322] do
	puts "daily build finished"
end

#================================Precondition config=================================================
task :precondition do
	sh "svn revert -R D:/THC/C0702/W-Series"
	sh "svn update D:/THC/C0702/W-Series"
	
	sh "svn revert -R D:/THC/C0702/E-Series"
	sh "svn update D:/THC/C0702/E-Series"
	
	sh "svn revert -R D:/THC/C0702/ReleaseFiles"
	sh "svn update D:/THC/C0702/ReleaseFiles"
	
	sh "svn revert -R D:/THC/C0702/DatabaseScript"
	sh "svn update D:/THC/C0702/DatabaseScript"
	
	sh "svn revert -R D:/THC/C0702/out/MDOperator.dll"
	sh "svn update D:/THC/C0702/out/MDOperator.dll"	
	copy_files('D:/THC/C0702/out/MDOperator.dll', 'D:/THC/C0702/ReleaseFiles/MDOperator.dll')
end

#================================IncreaseVersion config=====================================
task :increaseversion do
	sh "attrib -R D:/THC/C0702/TCom2/contrib/VersionNo.h"
	copy_files('D:/THC/C0702/TCom2/contrib/VersionNo.h', 'D:/THC/C0702/BuildScript/VersionNo.h')
	sh "D:/THC/C0702/BuildScript/VersionEditor.exe true D:/THC/C0702/TCom2/contrib/VersionNo.h"
end

#================================UpdateVersion config==========================================
task :updateversion do
	sh "svn update D:/THC/C0702/TCom2/contrib"
	sh "svn commit D:/THC/C0702/TCom2/contrib/VersionNo.h -m \"update C0702 version control file\""
end
#================================ThcLib config=================================================
desc "build thclib project ..."
task :thclib => [:get_latest_thclib, :setintel] do
	#puts "delete the old file ThcLib-vc6-mt-s-0_3_8.lib ..."
	#delete_file('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	sh "BuildConsole \"D:/THC/C0702/ThcLib/ThcLib.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	Rake::Task[:resetvs6].invoke
	puts "copy file to lib folder ..."
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel')
end

desc "get latest thclib version from svn ..."
task :get_latest_thclib do |t|
	t.reenable
	if(File.exists?('D:/THC/C0702/SetupTest/dailybuildFinished.dat'))
		delete_file('D:/THC/C0702/SetupTest/dailybuildFinished.dat')
	end
	sh "svn revert -R D:/THC/C0702/ThcLib"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/ThcLib D:/THC/C0702/ThcLib"
	sh "svn update D:/THC/C0702/ThcLib"
end

#================================TZip config=====================================
desc "build tzip project ...."
task :tzip => [:get_latest_tzip, :resetvs6] do
	#puts "delete the old file TZip.dll ..."
	#delete_file('D:/THC/C0702/out/TZip.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TZip/TZip.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TZip.dll to release files folder"
	copy_files('D:/THC/C0702/out/TZip.dll', 'D:/THC/C0702/ReleaseFiles/TZip.dll')
end

desc "get latest tzip version from svn ..."
task :get_latest_tzip do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TZip"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TZip D:/THC/C0702/TCom2/TZip"
	sh "svn update D:/THC/C0702/TCom2/TZip"
end

#================================TRDSCrypto config=====================================
desc "build trdscrypto project ..."
task :trdscrypto => [:get_latest_trdscrypto, :resetvs6] do
	#puts "delete the old file TRDSCrypto.dll ..."
	#delete_file('D:/THC/C0702/out/TRDSCrypto.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TRDSCrypto/TRDSCrypto.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TRDSCrypto.dll to release files folder"
	copy_files('D:/THC/C0702/out/TRDSCrypto.dll', 'D:/THC/C0702/ReleaseFiles/TRDSCrypto.dll')
end

desc "get latest trdscrypto version from svn ..."
task :get_latest_trdscrypto do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TRDSCrypto"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TRDSCrypto D:/THC/C0702/TCom2/TRDSCrypto"
	sh "svn update D:/THC/C0702/TCom2/TRDSCrypto"
end

#================================TCnPool config=====================================
desc "build tcnpool project ..."
task :tcnpool => [:get_latest_tcnpool, :resetvs6] do
	#puts "delete the old file TCnPool.dll"
	#delete_file('D:/THC/C0702/out/TCnPool.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TCnPool/TCnPool.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	puts "copy TCnPool.dll to release files folder"
	copy_files('D:/THC/C0702/out/TCnPool.dll', 'D:/THC/C0702/ReleaseFiles/TCnPool.dll')
end

desc "get latest trdscrypto version from svn ..."
task :get_latest_tcnpool do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TCnPool"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TCnPool D:/THC/C0702/TCom2/TCnPool"
	sh "svn update D:/THC/C0702/TCom2/TCnPool"
end 

#================================TLogging config=====================================
desc "build tlogging project ..."
task :tlogging => [:get_latest_tlogging, :resetvs6] do
	if(!File.exists?('D:/THC/C0702/out/log4cxx.dll'))
		copy_files('D:/THC/C0702/ReleaseFiles/log4cxx.dll', 'D:/THC/C0702/out/log4cxx.dll')
	end
	#puts "delete the old file TLogging.dll"
	#delete_file('D:/THC/C0702/out/TLogging.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TLogging/TLogging.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TLogging.dll to release files folder"
	copy_files('D:/THC/C0702/out/TLogging.dll', 'D:/THC/C0702/ReleaseFiles/TLogging.dll')
end

desc "get latest tlogging version from svn ..."
task :get_latest_tlogging do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TLogging"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TLogging D:/THC/C0702/TCom2/TLogging"
	sh "svn update D:/THC/C0702/TCom2/TLogging"
end 

#================================TMisc config=====================================
desc "build TMisc project ..."
task :tmisc => [:get_latest_tmisc, :setintel] do
	#puts "delete the old file TMisc.dll"
	#delete_file('D:/THC/C0702/out/TMisc.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TMisc/TMisc.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TMisc.dll to release files folder"
	copy_files('D:/THC/C0702/out/TMisc.dll', 'D:/THC/C0702/ReleaseFiles/TMisc.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tmisc version from svn ..."
task :get_latest_tmisc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TMisc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TMisc D:/THC/C0702/TCom2/TMisc"
	sh "svn update D:/THC/C0702/TCom2/TMisc"
end 

#================================TRDSData config=====================================
desc "build TRDSData project ..."
task :trdsdata => [:get_latest_trdsdata, :setintel] do
	#puts "delete the old file TRDSData.dll"
	#delete_file('D:/THC/C0702/out/TRDSData.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TRDSData/TRDSData.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TRDSData.dll to release files folder"
	copy_files('D:/THC/C0702/out/TRDSData.dll', 'D:/THC/C0702/ReleaseFiles/TRDSData.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tmisc version from svn ..."
task :get_latest_trdsdata do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TRDSData"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TRDSData D:/THC/C0702/TCom2/TRDSData"
	sh "svn update D:/THC/C0702/TCom2/TRDSData"
end

#================================TErrHandler config=====================================
desc "build TErrHandler project ..."
task :terrhandler => [:get_latest_terrhandler, :setintel] do
	#puts "delete the old file TErrHandler.dll"
	#delete_file('D:/THC/C0702/out/TErrHandler.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TErrHandler/TErrHandler.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TErrHandler.dll to release files folder"
	copy_files('D:/THC/C0702/out/TErrHandler.dll', 'D:/THC/C0702/ReleaseFiles/TErrHandler.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest terrhandler version from svn ..."
task :get_latest_terrhandler do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TErrHandler"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TErrHandler D:/THC/C0702/TCom2/TErrHandler"
	sh "svn update D:/THC/C0702/TCom2/TErrHandler"
end

#================================TMD config=====================================
desc "build TMD project ..."
task :tmd => [:get_latest_tmd, :setintel] do |t|
	t.reenable
	#puts "delete the old file TMD.dll"
	#delete_file('D:/THC/C0702/out/TMD.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TMD/TMD.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TMD.dll to release files folder"
	copy_files('D:/THC/C0702/out/TMD.dll', 'D:/THC/C0702/ReleaseFiles/TMD.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tmd version from svn ..."
task :get_latest_tmd do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TMD"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TMD D:/THC/C0702/TCom2/TMD"
	sh "svn update D:/THC/C0702/TCom2/TMD"
end

#================================TASet config=====================================
desc "build TASet project ..."
task :taset => [:get_latest_taset, :setintel] do
	#puts "delete the old file TASet.dll"
	#delete_file('D:/THC/C0702/out/TASet.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TASet/TASet.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TASet.dll to release files folder"
	copy_files('D:/THC/C0702/out/TASet.dll', 'D:/THC/C0702/ReleaseFiles/TASet.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest taset version from svn ..."
task :get_latest_taset do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TASet"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TASet D:/THC/C0702/TCom2/TASet"
	sh "svn update D:/THC/C0702/TCom2/TASet"
end

#================================TDCalc config=====================================
desc "build TDCalc project ..."
task :tdcalc => [:get_latest_tdcalc, :resetvs6] do
	#puts "delete the old file TDCalc.dll"
	#delete_file('D:/THC/C0702/out/TDCalc.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TDCalc/TDCalc.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TDCalc.dll to release files folder"
	copy_files('D:/THC/C0702/out/TDCalc.dll', 'D:/THC/C0702/ReleaseFiles/TDCalc.dll')
end

desc "get latest tdcalc version from svn ..."
task :get_latest_tdcalc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TDCalc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TDCalc D:/THC/C0702/TCom2/TDCalc"
	sh "svn update D:/THC/C0702/TCom2/TDCalc"
end

#================================TSecurity config=====================================
desc "build TSecurity project ..."
task :tsecurity => [:get_latest_tsecurity, :setintel] do
	#puts "delete the old file TSecurity.dll"
	#delete_file('D:/THC/C0702/out/TSecurity.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TSecurity/TSecurity.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TSecurity.dll to release files folder"
	copy_files('D:/THC/C0702/out/TSecurity.dll', 'D:/THC/C0702/ReleaseFiles/TSecurity.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tsecurity version from svn ..."
task :get_latest_tsecurity do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TSecurity"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TSecurity D:/THC/C0702/TCom2/TSecurity"
	sh "svn update D:/THC/C0702/TCom2/TSecurity"
end

#================================TRefEntity config=====================================
desc "build TRefEntity project ..."
task :trefentity => [:get_latest_trefentity, :setintel] do
	#puts "delete the old file TRefEntity.dll"
	#delete_file('D:/THC/C0702/out/TRefEntity.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TRefEntity/TRefEntity.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TRefEntity.dll to release files folder"
	copy_files('D:/THC/C0702/out/TRefEntity.dll', 'D:/THC/C0702/ReleaseFiles/TRefEntity.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest trefentity version from svn ..."
task :get_latest_trefentity do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TRefEntity"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TRefEntity D:/THC/C0702/TCom2/TRefEntity"
	sh "svn update D:/THC/C0702/TCom2/TRefEntity"
end

#================================TExchangeRateMgr config=====================================
desc "build TExchangeRateMgr project ..."
task :texchangeratemgr => [:get_latest_texchangeratemgr, :setintel] do
	#puts "delete the old file TExchangeRateMgr.dll"
	#delete_file('D:/THC/C0702/out/TExchangeRateMgr.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TExchangeRateMgr/TExchangeRateMgr.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TExchangeRateMgr.dll to release files folder"
	copy_files('D:/THC/C0702/out/TExchangeRateMgr.dll', 'D:/THC/C0702/ReleaseFiles/TExchangeRateMgr.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest texchangeratemgr version from svn ..."
task :get_latest_texchangeratemgr do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TExchangeRateMgr"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TExchangeRateMgr D:/THC/C0702/TCom2/TExchangeRateMgr"
	sh "svn update D:/THC/C0702/TCom2/TExchangeRateMgr"
end

#================================TStock config=====================================
desc "build TStock project ..."
task :tstock => [:get_latest_tstock, :setintel] do
	#puts "delete the old file TStock.dll"
	#delete_file('D:/THC/C0702/out/TStock.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TStock/TStock.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TStock.dll to release files folder"
	copy_files('D:/THC/C0702/out/TStock.dll', 'D:/THC/C0702/ReleaseFiles/TStock.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tstock version from svn ..."
task :get_latest_tstock do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TStock"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TStock D:/THC/C0702/TCom2/TStock"
	sh "svn update D:/THC/C0702/TCom2/TStock"
end

#================================TOption config=====================================
desc "build TOption project ..."
task :toption => [:get_latest_toption, :setintel] do
	#puts "delete the old file TOption.dll"
	#delete_file('D:/THC/C0702/out/TOption.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TOption/TOption.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TOption.dll to release files folder"
	copy_files('D:/THC/C0702/out/TOption.dll', 'D:/THC/C0702/ReleaseFiles/TOption.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest toption version from svn ..."
task :get_latest_toption do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TOption"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TOption D:/THC/C0702/TCom2/TOption"
	sh "svn update D:/THC/C0702/TCom2/TOption"
end

#================================TOTS config=====================================
desc "build TOTS project ..."
task :tots => [:get_latest_tots, :setintel] do
	#puts "delete the old file TOTS.dll"
	#delete_file('D:/THC/C0702/out/TOTS.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TOTS/TOTS.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TOTS.dll to release files folder"
	copy_files('D:/THC/C0702/out/TOTS.dll', 'D:/THC/C0702/ReleaseFiles/TOTS.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tots version from svn ..."
task :get_latest_tots do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TOTS"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TOTS D:/THC/C0702/TCom2/TOTS"
	sh "svn update D:/THC/C0702/TCom2/TOTS"
end

#================================TBond config=====================================
desc "build TBond project ..."
task :tbond => [:get_latest_tbond, :setintel] do
	#puts "delete the old file TBond.dll"
	#delete_file('D:/THC/C0702/out/TBond.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TBond/TBond.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TBond.dll to release files folder"
	copy_files('D:/THC/C0702/out/TBond.dll', 'D:/THC/C0702/ReleaseFiles/TBond.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tbond version from svn ..."
task :get_latest_tbond do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TBond"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TBond D:/THC/C0702/TCom2/TBond"
	sh "svn update D:/THC/C0702/TCom2/TBond"
end

#================================TIRD config=====================================
desc "build TIRD project ..."
task :tird => [:get_latest_tird, :setintel] do
	#puts "delete the old file TIRD.dll"
	#delete_file('D:/THC/C0702/out/TIRD.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TIRD/TIRD.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TIRD.dll to release files folder"
	copy_files('D:/THC/C0702/out/TIRD.dll', 'D:/THC/C0702/ReleaseFiles/TIRD.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tird version from svn ..."
task :get_latest_tird do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TIRD"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TIRD D:/THC/C0702/TCom2/TIRD"
	sh "svn update D:/THC/C0702/TCom2/TIRD"
end

#================================TCYD config=====================================
desc "build TCYD project ..."
task :tcyd => [:get_latest_tcyd, :setintel] do
	#puts "delete the old file TCYD.dll"
	#delete_file('D:/THC/C0702/out/TCYD.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TCYD/TCYD.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TCYD.dll to release files folder"
	copy_files('D:/THC/C0702/out/TCYD.dll', 'D:/THC/C0702/ReleaseFiles/TCYD.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tcyd version from svn ..."
task :get_latest_tcyd do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TCYD"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TCYD D:/THC/C0702/TCom2/TCYD"
	sh "svn update D:/THC/C0702/TCom2/TCYD"
end

#================================TIntexCMO config=====================================
desc "build TIntexCMO project ..."
task :tintexcmo => [:get_latest_tintexcmo, :resetvs6, :presvthclib] do |t|
	Rake::Task[:buildvc6thclib].invoke
	#puts "delete the old file TIntexCMO.dll..."
	#delete_file('D:/THC/C0702/out/TIntexCMO.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TIntexCMO/TIntexCMO.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	
	#recoverthclib
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/TIntexCMO.dll'))
		copy_files('D:/THC/C0702/out/TIntexCMO.dll', 'D:/THC/C0702/ReleaseFiles/TIntexCMO.dll')
		puts "Build D:/THC/C0702/out/TIntexCMO.dll failed in project #{t.name}!"
	end
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
	
	puts "copy TIntexCMO.dll to release files folder..."
	copy_files('D:/THC/C0702/out/TIntexCMO.dll', 'D:/THC/C0702/ReleaseFiles/TIntexCMO.dll')
end

desc "get latest tintexcmo version from svn ..."
task :get_latest_tintexcmo do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TIntexCMO"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TIntexCMO D:/THC/C0702/TCom2/TIntexCMO"
	sh "svn update D:/THC/C0702/TCom2/TIntexCMO"
end

#================================TMarkit config=====================================
desc "build TMarkit project ..."
task :tmarkit => [:get_latest_tmarkit, :setintel] do
	#puts "delete the old file TMarkit.dll"
	#delete_file('D:/THC/C0702/out/TMarkit.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TMarkit/TMarkit.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TMarkit.dll to release files folder"
	copy_files('D:/THC/C0702/out/TMarkit.dll', 'D:/THC/C0702/ReleaseFiles/TMarkit.dll')
	puts "copy cmo_W32.dll to release files folder"
	copy_files('D:/THC/C0702/TCom2/TMarkit/cmo_W32.dll', 'D:/THC/C0702/ReleaseFiles/cmo_W32.dll')
	puts "copy cmo_W32.dll to out folder"
	copy_files('D:/THC/C0702/TCom2/TMarkit/cmo_W32.dll', 'D:/THC/C0702/out/cmo_W32.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tmarkit version from svn ..."
task :get_latest_tmarkit do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TMarkit"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TMarkit D:/THC/C0702/TCom2/TMarkit"
	sh "svn update D:/THC/C0702/TCom2/TMarkit"
end

#================================TStruProd config=====================================
desc "build TStruProd project ..."
task :tstruprod => [:get_latest_tstruprod, :resetvs6, :presvthclib] do |t|
	Rake::Task[:buildvc6thclib].invoke
	#puts "delete the old file TStruProd.dll..."
	#delete_file('D:/THC/C0702/out/TStruProd.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TStruProd/TStruProd.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	
	#recoverthclib
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/TStruProd.dll'))
		copy_files('D:/THC/C0702/out/TStruProd.dll', 'D:/THC/C0702/ReleaseFiles/TStruProd.dll')
		puts "Build D:/THC/C0702/out/TStruProd.dll failed in project #{t.name}!"
	end
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
	
	puts "copy TStruProd.dll to release files folder..."
	copy_files('D:/THC/C0702/out/TStruProd.dll', 'D:/THC/C0702/ReleaseFiles/TStruProd.dll')
end

desc "get latest tstruprod version from svn ..."
task :get_latest_tstruprod do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TStruProd"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TStruProd D:/THC/C0702/TCom2/TStruProd"
	sh "svn update D:/THC/C0702/TCom2/TStruProd"
end

#================================TCDO config=====================================
desc "build TCDO project ..."
task :tcdo => [:get_latest_tcdo, :resetvs6, :presvthclib] do |t|
	Rake::Task[:buildvc6thclib].invoke
	#puts "delete the old file TCDO.dll..."
	#delete_file('D:/THC/C0702/out/TCDO.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TCDO/TCDO.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	
	#recoverthclib
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/TCDO.dll'))
		copy_files('D:/THC/C0702/out/TCDO.dll', 'D:/THC/C0702/ReleaseFiles/TCDO.dll')
		puts "Build D:/THC/C0702/out/TCDO.dll failed in project #{t.name}!"
	end
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
	
	puts "copy TCDO.dll to release files folder..."
	copy_files('D:/THC/C0702/out/TCDO.dll', 'D:/THC/C0702/ReleaseFiles/TCDO.dll')
end

desc "get latest tcdo version from svn ..."
task :get_latest_tcdo do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TCDO"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TCDO D:/THC/C0702/TCom2/TCDO"
	sh "svn update D:/THC/C0702/TCom2/TCDO"
end

#================================TOptionDeriv config=====================================
desc "build TOptionDeriv project ..."
task :toptionderiv => [:get_latest_toptionderiv, :setintel] do
	#puts "delete the old file TOptionDeriv.dll"
	#delete_file('D:/THC/C0702/out/TOptionDeriv.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TOptionDeriv/TOptionDeriv.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TOptionDeriv.dll to release files folder"
	copy_files('D:/THC/C0702/out/TOptionDeriv.dll', 'D:/THC/C0702/ReleaseFiles/TOptionDeriv.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest toptionderiv version from svn ..."
task :get_latest_toptionderiv do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TOptionDeriv"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TOptionDeriv D:/THC/C0702/TCom2/TOptionDeriv"
	sh "svn update D:/THC/C0702/TCom2/TOptionDeriv"
end

#================================TDBLoad config=====================================
desc "build TDBLoad project ..."
task :tdbload => [:get_latest_tdbload, :setintel] do
	#puts "delete the old file TDBLoad.dll"
	#delete_file('D:/THC/C0702/out/TDBLoad.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TDBLoad/TDBLoad.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TDBLoad.dll to release files folder"
	copy_files('D:/THC/C0702/out/TDBLoad.dll', 'D:/THC/C0702/ReleaseFiles/TDBLoad.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tdbload version from svn ..."
task :get_latest_tdbload do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TDBLoad"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TDBLoad D:/THC/C0702/TCom2/TDBLoad"
	sh "svn update D:/THC/C0702/TCom2/TDBLoad"
end

#================================IntexCMOClient config=====================================
desc "build IntexCMOClient project ..."
task :intexcmoclient => [:get_latest_intexcmoclient] do
	sh "VB6.exe /make D:/THC/C0702/Misc/IntexCMOClient/IntexCMO.vbp /out D:/THC/C0702/BuildScript/buildLog/buildintexcmoclient.log /outdir D:/THC/C0702/ReleaseFiles/ "
end

desc "get latest intexcmoclient version from svn ..."
task :get_latest_intexcmoclient do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/Misc/IntexCMOClient"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/Misc/IntexCMOClient D:/THC/C0702/Misc/IntexCMOClient"
	sh "svn update D:/THC/C0702/Misc/IntexCMOClient"
end

#================================TMongoDb config=====================================
desc "build TMongoDb project ..."
task :tmongodb => [:get_latest_tmongodb, :resetvs6] do
	#puts "delete the old file TMongoDb.dll"
	#delete_file('D:/THC/C0702/out/TMongoDb.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TMongoDb/TMongoDb.vcproj\" /rebuild /OpenMonitor /cfg=\"Release|Win32\" /Out=D:/THC/C0702/BuildScript/buildLog/mongoDb.log"
	puts "copy TMongoDb.dll to release files folder"
	copy_files('D:/THC/C0702/out/TMongoDb.dll', 'D:/THC/C0702/ReleaseFiles/TMongoDb.dll')
end

desc "get latest tmongodb version from svn ..."
task :get_latest_tmongodb do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TMongoDb"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TMongoDb D:/THC/C0702/TCom2/TMongoDb"
	sh "svn update D:/THC/C0702/TCom2/TMongoDb"
end

#================================TPortfolio config=====================================
desc "build TPortfolio project ..."
task :tportfolio => [:get_latest_tportfolio, :setintel] do
	#puts "delete the old file TPortfolio.dll"
	#delete_file('D:/THC/C0702/out/TPortfolio.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TPortfolio/TPortfolio.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TPortfolio.dll to release files folder"
	copy_files('D:/THC/C0702/out/TPortfolio.dll', 'D:/THC/C0702/ReleaseFiles/TPortfolio.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tportfolio version from svn ..."
task :get_latest_tportfolio do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TPortfolio"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TPortfolio D:/THC/C0702/TCom2/TPortfolio"
	sh "svn update D:/THC/C0702/TCom2/TPortfolio"
end

#================================TTask config=====================================
desc "build TTask project ..."
task :ttask => [:get_latest_ttask, :resetvs6] do
	#puts "delete the old file TTask.dll"
	#delete_file('D:/THC/C0702/out/TTask.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TTask/TTask.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TTask.dll to release files folder"
	copy_files('D:/THC/C0702/out/TTask.dll', 'D:/THC/C0702/ReleaseFiles/TTask.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest ttask version from svn ..."
task :get_latest_ttask do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TTask"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TTask D:/THC/C0702/TCom2/TTask"
	sh "svn update D:/THC/C0702/TCom2/TTask"
end

#================================TMAP config=====================================
desc "build TTask project ..."
task :tmap => [:get_latest_tmap, :resetvs6] do
	#puts "delete the old file TTask.dll"
	#delete_file('D:/THC/C0702/out/TTask.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TMAP/TMAP.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TMAP.dll to release files folder"
	copy_files('D:/THC/C0702/out/TMAP.dll', 'D:/THC/C0702/ReleaseFiles/TMAP.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tmap version from svn ..."
task :get_latest_tmap do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TMAP"
	sh "svn update D:/THC/C0702/TCom2/TMAP"
end

#================================TPathFileAnalyzer config=====================================
desc "build TPathFileAnalyzer project ..."
task :tpathfileanalyzer => [:get_latest_tpathfileanalyzer, :resetvs6] do
	#puts "delete the old file TPathFileAnalyzer.dll"
	#delete_file('D:/THC/C0702/out/TPathFileAnalyzer.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TPathFileAnalyzer/TPathfileAnalyzer.vcproj\" /rebuild /OpenMonitor /cfg=\"Release|Win32\""
	puts "copy TPathFileAnalyzer.dll to release files folder"
	copy_files('D:/THC/C0702/out/TPathFileAnalyzer.dll', 'D:/THC/C0702/ReleaseFiles/TPathFileAnalyzer.dll')
end

desc "get latest tpathfileanalyzer version from svn ..."
task :get_latest_tpathfileanalyzer do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TPathfileAnalyzer"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TPathfileAnalyzer D:/THC/C0702/TCom2/TPathFileAnalyzer"
	sh "svn update D:/THC/C0702/TCom2/TPathFileAnalyzer"
end

#================================TPathFileParser config=====================================
desc "build TPathFileParser project ..."
task :tpathfileparser => [:get_latest_tpathfileparser, :resetvs6] do
	#puts "delete the old file TPathFileParser.dll"
	#delete_file('D:/THC/C0702/out/TPathFileParser.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TPathFileParser/TPathFileParser.vcproj\" /rebuild /OpenMonitor /cfg=\"Release|Win32\""
	puts "copy TPathFileParser.dll to release files folder"
	copy_files('D:/THC/C0702/out/TPathFileParser.dll', 'D:/THC/C0702/ReleaseFiles/TPathFileParser.dll')
	puts "copy PathfileRules.xml to release files folder"
	copy_files('D:/THC/C0702/TCom2/TPathfileParser/XML/PathfileRules.xml', 'D:/THC/C0702/ReleaseFiles/PathfileRules.xml')
	puts "copy PathfileHeads.xml to release files folder"
	copy_files('D:/THC/C0702/TCom2/TPathfileParser/XML/PathfileHeads.xml', 'D:/THC/C0702/ReleaseFiles/PathfileHeads.xml')
	puts "copy PathFile.xla to release files folder"
	#copy_files('D:/THC/C0702/TCom2/TPathfileParser/XML/PathFile.xla', 'D:/THC/C0702/ReleaseFiles/PathFile.xla')
	sh "xcopy D:\\THC\\C0702\\TCom2\\TPathfileParser\\XML\\PathFile.xla D:\\THC\\C0702\\ReleaseFiles\\ /H /R /Y"
end

desc "get latest tpathfileparser version from svn ..."
task :get_latest_tpathfileparser do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TPathFileParser"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TPathfileParser D:/THC/C0702/TCom2/TPathFileParser"
	sh "svn update D:/THC/C0702/TCom2/TPathFileParser"
end

#================================TCalc config=====================================
desc "build TCalc project ..."
task :tcalc => [:get_latest_tcalc, :resetvs6] do
	#puts "delete the old file TTask.dll"
	#delete_file('D:/THC/C0702/out/TCalc.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TCalc/TCalc.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TCalc.dll to release files folder"
	copy_files('D:/THC/C0702/out/TCalc.dll', 'D:/THC/C0702/ReleaseFiles/TCalc.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tcalc version from svn ..."
task :get_latest_tcalc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TCalc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TCalc D:/THC/C0702/TCom2/TCalc"
	sh "svn update D:/THC/C0702/TCom2/TCalc"
end

#================================TPO config=====================================
desc "build TPO project ..."
task :tpo => [:get_latest_tpo, :setintel] do
	#puts "delete the old file TPO.dll"
	#delete_file('D:/THC/C0702/out/TPO.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TPO/TPO.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TPO.dll to release files folder"
	copy_files('D:/THC/C0702/out/TPO.dll', 'D:/THC/C0702/ReleaseFiles/TPO.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tpo version from svn ..."
task :get_latest_tpo do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TPO"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TPO D:/THC/C0702/TCom2/TPO"
	sh "svn update D:/THC/C0702/TCom2/TPO"
end

#================================OASCalibrating config=====================================
desc "build OASCalibrating project ..."
task :oascalibrating => [:get_latest_oascalibrating, :resetvs6] do
	#puts "delete the old file OASCalibrating.dll"
	#delete_file('D:/THC/C0702/out/OASCalibrating.dll')
	#sh "BuildConsole \"D:/THC/C0702/PCNest/OASCalibrating/OASCalibrating.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	sh "msdev.exe D:/THC/C0702/PCNest/OASCalibrating/OASCalibrating.dsp /make \"OASCalibrating - Win32 Release\" /Rebuild"
	puts "copy OASCalibrating.dll to release files folder"
	copy_files('D:/THC/C0702/out/OASCalibrating.dll', 'D:/THC/C0702/ReleaseFiles/OASCalibrating.dll')
end

desc "get latest oascalibrating version from svn ..."
task :get_latest_oascalibrating do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/PCNest/OASCalibrating"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/PCNest/OASCalibrating D:/THC/C0702/PCNest/OASCalibrating"
	sh "svn update D:/THC/C0702/PCNest/OASCalibrating"
end

#================================TRDSIRRCalc config=====================================
desc "build TRDSIRRCalc project ..."
task :trdsirrcalc => [:get_latest_trdsirrcalc, :resetvs6] do
	#puts "delete the old file TRDSIRRCalc.dll"
	#delete_file('D:/THC/C0702/out/TRDSIRRCalc.dll')
	sh "msdev.exe D:/THC/C0702/TCom2/TRDSIRRCalc/TRDSIRRCalc.dsp /make \"TRDSIRRCalc - Win32 Release MinSize\" /Rebuild"
	puts "copy TRDSIRRCalc.dll to release files folder"
	copy_files('D:/THC/C0702/out/TRDSIRRCalc.dll', 'D:/THC/C0702/ReleaseFiles/TRDSIRRCalc.dll')
end

desc "get latest trdsirrcalc version from svn ..."
task :get_latest_trdsirrcalc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TRDSIRRCalc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TRDSIRRCalc D:/THC/C0702/TCom2/TRDSIRRCalc"
	sh "svn update D:/THC/C0702/TCom2/TRDSIRRCalc"
end

#================================TRDSCALL config=====================================
desc "build TRDSCALL project ..."
task :trdscall => [:get_latest_trdscall, :resetvs6] do
	#puts "delete the old file TRDSCALL.dll"
	#delete_file('D:/THC/C0702/out/TRDSCALL.dll')
	sh "msdev.exe D:/THC/C0702/TCom2/TRDSCALL/TRDSCALL.dsp /make \"TRDSCALL - Win32 Release MinSize\" /Rebuild"
	puts "copy TRDSCALL.dll to release files folder"
	copy_files('D:/THC/C0702/out/TRDSCALL.dll', 'D:/THC/C0702/ReleaseFiles/TRDSCALL.dll')
end

desc "get latest trdscall version from svn ..."
task :get_latest_trdscall do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TRDSCALL"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TRDSCALL D:/THC/C0702/TCom2/TRDSCALL"
	sh "svn update D:/THC/C0702/TCom2/TRDSCALL"
end

#================================TUserRole config=====================================
desc "build TUserRole project ..."
task :tuserrole => [:get_latest_tuserrole, :resetvs6] do
	#puts "delete the old file TUserRole.dll"
	#delete_file('D:/THC/C0702/out/TUserRole.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TUserRole/TUserRole.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TUserRole.dll to release files folder"
	copy_files('D:/THC/C0702/out/TUserRole.dll', 'D:/THC/C0702/ReleaseFiles/TUserRole.dll')
end

desc "get latest tuserrole version from svn ..."
task :get_latest_tuserrole do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TUserRole"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TUserRole D:/THC/C0702/TCom2/TUserRole"
	sh "svn update D:/THC/C0702/TCom2/TUserRole"
end

#================================IRRCalc config=====================================
desc "build IRRCalc project ..."
task :irrcalc => [:get_latest_irrcalc, :resetvs6, :presvthclib] do |t|
	Rake::Task[:buildvc6thclib].invoke
	#puts "delete the old file IRRCalc.dll..."
	#delete_file('D:/THC/C0702/out/IRRCalc.dll')
	#sh "BuildConsole \"D:/THC/C0702/PCNest/IRRCalc/IRRCalc.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	sh "msdev.exe D:/THC/C0702/PCNest/IRRCalc/IRRCalc.dsp /make \"IRRCalc - Win32 Release\" /Rebuild"
	
	#recoverthclib
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/IRRCalc.dll'))
		copy_files('D:/THC/C0702/out/IRRCalc.dll', 'D:/THC/C0702/ReleaseFiles/IRRCalc.dll')
		puts "Build D:/THC/C0702/out/IRRCalc.dll failed in project #{t.name}!"
	end
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
	
	puts "copy IRRCalc.dll to release files folder..."
	copy_files('D:/THC/C0702/out/IRRCalc.dll', 'D:/THC/C0702/ReleaseFiles/IRRCalc.dll')
end

desc "get latest irrcalc version from svn ..."
task :get_latest_irrcalc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/PCNest/IRRCalc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/PCNest/IRRCalc D:/THC/C0702/PCNest/IRRCalc"
	sh "svn update D:/THC/C0702/PCNest/IRRCalc"
end

#================================CollectOTS config=====================================
desc "build CollectOTS project ..."
task :collectots => [:get_latest_collectots, :resetvs6, :presvthclib] do |t|
	Rake::Task[:buildvc6thclib].invoke
	#puts "delete the old file CollectOTS.dll..."
	#delete_file('D:/THC/C0702/out/CollectOTS.dll')
	sh "BuildConsole \"D:/THC/C0702/PCNest/CollectOTS/CollectOTS.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	
	#recoverthclib
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/CollectOTS.dll'))
		copy_files('D:/THC/C0702/out/CollectOTS.dll', 'D:/THC/C0702/ReleaseFiles/CollectOTS.dll')
		puts "Build D:/THC/C0702/out/CollectOTS.dll failed in project #{t.name}!"
	end
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
	
	puts "copy CollectOTS.dll to release files folder..."
	copy_files('D:/THC/C0702/out/CollectOTS.dll', 'D:/THC/C0702/ReleaseFiles/CollectOTS.dll')
end

desc "get latest collectots version from svn ..."
task :get_latest_collectots do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/PCNest/COLLECTOTS"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/PCNest/COLLECTOTS D:/THC/C0702/PCNest/COLLECTOTS"
	sh "svn update D:/THC/C0702/PCNest/COLLECTOTS"
end

#================================IRRSvc config=====================================
desc "build IRRSvc project ..."
task :irrsvc => [:get_latest_irrsvc, :resetvs6] do
	#puts "delete the old file IRRSvc.exe"
	#delete_file('D:/THC/C0702/out/IRRSvc.exe')
	sh "msdev.exe D:/THC/C0702/PCNest/IRRSvc2/IRRSvc.dsp /make \"IRRSvc - Win32 Release\" /Rebuild"
	puts "copy IRRSvc.exe to release files folder"
	copy_files('D:/THC/C0702/out/IRRSvc.exe', 'D:/THC/C0702/ReleaseFiles/IRRSvc.exe')
end

desc "get latest irrsvc version from svn ..."
task :get_latest_irrsvc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/PCNest/IRRSvc2"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/PCNest/IRRSvc2 D:/THC/C0702/PCNest/IRRSvc2"
	sh "svn update D:/THC/C0702/PCNest/IRRSvc2"
end

#================================ThcGLView config=====================================
desc "build ThcGLView project ..."
task :thcglview => [:get_latest_thcglview, :resetvs6] do
	#puts "delete the old file ThcGLView.dll"
	#delete_file('D:/THC/C0702/out/ThcGLView.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/ThcGLView/ThcGLView.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy ThcGLView.dll to release files folder"
	copy_files('D:/THC/C0702/out/ThcGLView.dll', 'D:/THC/C0702/ReleaseFiles/ThcGLView.dll')
end

desc "get latest thcglview version from svn ..."
task :get_latest_thcglview do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/ThcGLView"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/ThcGLView D:/THC/C0702/TCom2/ThcGLView"
	sh "svn update D:/THC/C0702/TCom2/ThcGLView"
end

#=============================ReverseEngineering config===================================
desc "build ReverseEngineering project ..."
task :reverseengineering => [:get_latest_reverseengineering] do
	sh "VB6.exe /make D:/THC/C0702/Misc/Reverseengineering/TranchesTool.vbp /out D:/THC/C0702/BuildScript/buildLog/buildreverseengineering.log /outdir D:/THC/C0702/ReleaseFiles/ "
end

desc "get latest reverseengineering version from svn ..."
task :get_latest_reverseengineering do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/Misc/Reverseengineering"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/Misc/Reverseengineering D:/THC/C0702/Misc/Reverseengineering"
	sh "svn update D:/THC/C0702/Misc/Reverseengineering"
end

#================================TFileDB config=====================================
desc "build TFileDB project ..."
task :tfiledb => [:get_latest_tfiledb, :resetvs6] do
	#puts "delete the old file TFileDB.dll"
	#delete_file('D:/THC/C0702/out/TFileDB.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TFileDB/TFileDB.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TFileDB.dll to release files folder"
	copy_files('D:/THC/C0702/out/TFileDB.dll', 'D:/THC/C0702/ReleaseFiles/TFileDB.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tfiledb version from svn ..."
task :get_latest_tfiledb do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TFileDB"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TFileDB D:/THC/C0702/TCom2/TFileDB"
	sh "svn update D:/THC/C0702/TCom2/TFileDB"
end

#==================================TNetCmd config=======================================
task :tnetcmd_all => [:resetvs6, :tnetcmd, :tnetsvr, :tprogress, :tmqsvr, :tactivemq, :tnetcalc] do
	Rake::Task[:resetvs6].invoke
end

desc "build TNetCmd project ..."
task :tnetcmd => [:get_latest_tnetcmd] do
	#puts "delete the old file TNetCmd.dll"
	#delete_file('D:/THC/C0702/out/TNetCmd.dll')
	sh "BuildConsole \"D:/THC/C0702/CalcOTF/TNetCmd/TNetCmd.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TNetCmd.dll to release files folder"
	copy_files('D:/THC/C0702/out/TNetCmd.dll', 'D:/THC/C0702/ReleaseFiles/TNetCmd.dll')
end

desc "get latest tnetcmd version from svn ..."
task :get_latest_tnetcmd do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/TNetCmd"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/TNetCmd D:/THC/C0702/CalcOTF/TNetCmd"
	sh "svn update D:/THC/C0702/CalcOTF/TNetCmd"
end

desc "build TNetSvr project ..."
task :tnetsvr => [:get_latest_tnetsvr] do
	#puts "delete the old file TNetSvr.exe"
	#delete_file('D:/THC/C0702/out/TNetSvr.exe')
	sh "BuildConsole \"D:/THC/C0702/CalcOTF/TNetSvr/TNetSvr.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	puts "copy TNetSvr.dll to release files folder"
	copy_files('D:/THC/C0702/out/TNetSvr.exe', 'D:/THC/C0702/ReleaseFiles/TNetSvr.exe')
end

desc "get latest tnetsvr version from svn ..."
task :get_latest_tnetsvr do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/TNetSvr"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/TNetSvr D:/THC/C0702/CalcOTF/TNetSvr"
	sh "svn update D:/THC/C0702/CalcOTF/TNetSvr"
end

desc "build TProgress project ..."
task :tprogress => [:get_latest_tprogress] do
	#puts "delete the old file TProgress.dll"
	#delete_file('D:/THC/C0702/out/TProgress.dll')
	sh "BuildConsole \"D:/THC/C0702/CalcOTF/TProgress/TProgress.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	puts "copy TProgress.dll to release files folder"
	copy_files('D:/THC/C0702/out/TProgress.dll', 'D:/THC/C0702/ReleaseFiles/TProgress.dll')
end

desc "get latest tprogress version from svn ..."
task :get_latest_tprogress do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/TProgress"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/TProgress D:/THC/C0702/CalcOTF/TProgress"
	sh "svn update D:/THC/C0702/CalcOTF/TProgress"
end

desc "build TMQSvr project ..."
task :tmqsvr => [:get_latest_tmqsvr] do
	#puts "delete the old file TMQSvr.exe"
	#delete_file('D:/THC/C0702/out/TMQSvr.exe')
	sh "BuildConsole \"D:/THC/C0702/CalcOTF/TMQSvr/TMQSvr.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	puts "copy TMQSvr.dll to release files folder"
	copy_files('D:/THC/C0702/out/TMQSvr.exe', 'D:/THC/C0702/ReleaseFiles/TMQSvr.exe')
end

desc "get latest tmqsvr version from svn ..."
task :get_latest_tmqsvr do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/TMQSvr"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/TMQSvr D:/THC/C0702/CalcOTF/TMQSvr"
	sh "svn update D:/THC/C0702/CalcOTF/TMQSvr"
end

desc "build TActiveMQ project ..."
task :tactivemq => [:get_latest_tactivemq] do
	#puts "delete the old file TActiveMQ.dll"
	#delete_file('D:/THC/C0702/out/TActiveMQ.dll')
	sh "BuildConsole \"D:/THC/C0702/CalcOTF/TActiveMQ/TActiveMQ.vcproj\" /rebuild /OpenMonitor /cfg=\"Release|Win32\" /Out=D:/THC/C0702/BuildScript/buildLog/TActiveMQ.log"
	puts "copy TActiveMQ.dll to release files folder"
	copy_files('D:/THC/C0702/out/TActiveMQ.dll', 'D:/THC/C0702/ReleaseFiles/TActiveMQ.dll')
end

desc "get latest tactivemq version from svn ..."
task :get_latest_tactivemq do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/TActiveMQ"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/TActiveMQ D:/THC/C0702/CalcOTF/TActiveMQ"
	sh "svn update D:/THC/C0702/CalcOTF/TActiveMQ"
end

desc "build TNetCalc project ..."
task :tnetcalc => [:get_latest_tnetcalc] do
	#puts "delete the old file TNetCalc.exe"
	#delete_file('D:/THC/C0702/out/TNetCalc.exe')
	sh "BuildConsole \"D:/THC/C0702/CalcOTF/TNetCalc/TNetCalc.vcproj\" /rebuild /OpenMonitor /cfg=\"Release|Win32\" /Out=D:/THC/C0702/BuildScript/buildLog/TNetCalc.log"
	puts "copy TNetCalc.exe to release files folder"
	copy_files('D:/THC/C0702/out/TNetCalc.exe', 'D:/THC/C0702/ReleaseFiles/TNetCalc.exe')
end

desc "get latest tnetcalc version from svn ..."
task :get_latest_tnetcalc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/TNetCalc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/TNetCalc D:/THC/C0702/CalcOTF/TNetCalc"
	sh "svn update D:/THC/C0702/CalcOTF/TNetCalc"
end

#=============================TClientShell config===================================
desc "build TClientShell project ..."
task :tclientshell => [:get_latest_tclientshell] do
	sh "VB6.exe /make D:/THC/C0702/TCom2/TClientShell/TClientShell.vbp /out D:/THC/C0702/BuildScript/buildlog/TClientshell.log /outdir D:/THC/C0702/out/"
	sh "regsvr32.exe D:/THC/C0702/out/TClientShell.dll /s /u"
	sh "regsvr32.exe D:/THC/C0702/out/TClientShell.dll /s"
	puts "copy TClientShell.dll to release files folder"
	copy_files('D:/THC/C0702/out/TClientShell.dll', 'D:/THC/C0702/ReleaseFiles/TClientShell.dll')
end

desc "get latest tclientshell version from svn ..."
task :get_latest_tclientshell do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TClientShell"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TClientShell D:/THC/C0702/TCom2/TClientShell"
	sh "svn update D:/THC/C0702/TCom2/TClientShell"
end

#================================TBusiness config=====================================
desc "build TBusiness project ..."
task :tbusiness => [:get_latest_tbusiness, :setintel] do
	#puts "delete the old file TBusiness.dll"
	#delete_file('D:/THC/C0702/out/TBusiness.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TBusiness/TBusiness.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	puts "copy TBusiness.dll to release files folder"
	copy_files('D:/THC/C0702/out/TBusiness.dll', 'D:/THC/C0702/ReleaseFiles/TBusiness.dll')
	Rake::Task[:resetvs6].invoke
end

desc "get latest tbusiness version from svn ..."
task :get_latest_tbusiness do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TBusiness"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TBusiness D:/THC/C0702/TCom2/TBusiness"
	sh "svn update D:/THC/C0702/TCom2/TBusiness"
end

#=============================TAnalysis config===================================
desc "build TAnalysis project ..."
task :tanalysis => [:get_latest_tanalysis] do
	sh "VB6.exe /make D:/THC/C0702/TCom2/TAnalysis/TAnalysis.vbp /out D:/THC/C0702/BuildScript/buildlog/buildTAnalysis.log /outdir D:/THC/C0702/out/"
	sh "regsvr32.exe D:/THC/C0702/out/TAnalysis.dll /s /u"
	sh "regsvr32.exe D:/THC/C0702/out/TAnalysis.dll /s"
	puts "copy TAnalysis.dll to release files folder"
	copy_files('D:/THC/C0702/out/TAnalysis.dll', 'D:/THC/C0702/ReleaseFiles/TAnalysis.dll')
end

desc "get latest tanalysis version from svn ..."
task :get_latest_tanalysis do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TAnalysis"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TAnalysis D:/THC/C0702/TCom2/TAnalysis"
	sh "svn update D:/THC/C0702/TCom2/TAnalysis"
end

#=============================TClient config===================================
desc "build TClient project ..."
task :tclient => [:get_latest_tclient] do
	sh "VB6.exe /make D:/THC/C0702/TClient/TRDS.vbp /out D:/THC/C0702/BuildScript/buildlog/buildclient.log /outdir D:/THC/C0702/out/"
	puts "copy thc.exe to release files folder"
	copy_files('D:/THC/C0702/out/thc.exe', 'D:/THC/C0702/ReleaseFiles/thc.exe')
end

desc "get latest tclient version from svn ..."
task :get_latest_tclient do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TClient"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TClient D:/THC/C0702/TClient"
	sh "svn update D:/THC/C0702/TClient"
end

#=============================CrystalReportCom config===================================
desc "build CrystalReportCom project ..."
task :crystalreportcom => [:get_latest_crystalreportcom] do
	sh "regsvr32.exe D:/THC/C0702/out/ThcCrystalReports.dll /s /u"
	sh "VB6.exe /make D:/THC/C0702/ThcCrystalReport/ReportWriter/ThcCrystalReportDll/ThcCrystalReports.vbp /out D:/THC/C0702/BuildScript/buildlog/buildCryRepCom.log /outdir D:/THC/C0702/out/"
	sh "regsvr32.exe D:/THC/C0702/out/ThcCrystalReports.dll /s"
	puts "copy ThcCrystalReports.dll to release files folder"
	copy_files('D:/THC/C0702/out/ThcCrystalReports.dll', 'D:/THC/C0702/ReleaseFiles/ThcCrystalReports.dll')
end

desc "get latest crystalreportcom version from svn ..."
task :get_latest_crystalreportcom do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/ThcCrystalReport/ReportWriter/ThcCrystalReportDll"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/ThcCrystalReport/ReportWriter/ThcCrystalReportDll D:/THC/C0702/ThcCrystalReport/ReportWriter/ThcCrystalReportDll"
	sh "svn update D:/THC/C0702/ThcCrystalReport/ReportWriter/ThcCrystalReportDll"
end

#=============================CrystalReportClient config===================================
desc "build CrystalReportClient project ..."
task :crystalreportclient => [:get_latest_crystalreportclient] do
	sh "VB6.exe /make D:/THC/C0702/ThcCrystalReport/ReportWriter/Client/ThcCrystalReport.vbp /out D:/THC/C0702/BuildScript/buildlog/buildCryRepClient.log /outdir D:/THC/C0702/out/"
	puts "copy ThcCrystalReport.exe to release files folder"
	copy_files('D:/THC/C0702/out/ThcCrystalReport.exe', 'D:/THC/C0702/ReleaseFiles/ThcCrystalReport.exe')
end

desc "get latest crystalreportclient version from svn ..."
task :get_latest_crystalreportclient do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/ThcCrystalReport/ReportWriter/Client"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/ThcCrystalReport/ReportWriter/Client D:/THC/C0702/ThcCrystalReport/ReportWriter/Client"
	sh "svn update D:/THC/C0702/ThcCrystalReport/ReportWriter/Client"
end

#=============================CreateReport config===================================
desc "build CreateReport project ..."
task :createreport => [:get_latest_createreport] do
	sh "regsvr32.exe D:/THC/C0702/out/CreateReport.dll /s /u"
	sh "VB6.exe /make D:/THC/C0702/ThcCrystalReport/ReportService/CreateReportDll/CreateOutput.vbp /out D:/THC/C0702/BuildScript/buildlog/buildCreateOutput.log /outdir D:/THC/C0702/out/"
	sh "regsvr32.exe D:/THC/C0702/out/CreateReport.dll /s"
	puts "copy CreateReport.dll to release files folder"
	copy_files('D:/THC/C0702/out/CreateReport.dll', 'D:/THC/C0702/ReleaseFiles/CreateReport.dll')
end

desc "get latest createreport version from svn ..."
task :get_latest_createreport do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/ThcCrystalReport/ReportService/CreateReportDll"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/ThcCrystalReport/ReportService/CreateReportDll D:/THC/C0702/ThcCrystalReport/ReportService/CreateReportDll"
	sh "svn update D:/THC/C0702/ThcCrystalReport/ReportService/CreateReportDll"
end

#================================ReportSvc config=====================================
desc "build ReportSvc project ..."
task :reportsvc => [:get_latest_reportsvc, :resetvs6] do
	#puts "delete the old file RptSvc.exe"
	#delete_file('D:/THC/C0702/out/RptSvc.exe')
	sh "BuildConsole \"D:/THC/C0702/ThcCrystalReport/ReportService/Service/RptSvc.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	puts "copy RptSvc.exe to release files folder"
	copy_files('D:/THC/C0702/out/RptSvc.exe', 'D:/THC/C0702/ReleaseFiles/RptSvc.exe')
end

desc "get latest reportsvc version from svn ..."
task :get_latest_reportsvc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/ThcCrystalReport/ReportService/Service"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/ThcCrystalReport/ReportService/Service D:/THC/C0702/ThcCrystalReport/ReportService/Service"
	sh "svn update D:/THC/C0702/ThcCrystalReport/ReportService/Service"
end

#================================UpdFunc config=====================================
desc "build UpdFunc project ..."
task :updfunc => [:get_latest_updfunc, :resetvs6] do
	#puts "delete the old file UpdFunc.dll"
	#delete_file('D:/THC/C0702/out/UpdFunc.dll')
	sh "BuildConsole \"D:/THC/C0702/TRDSUpd/UpdFunc/UpdFunc.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	puts "copy UpdFunc.dll to release files folder"
	copy_files('D:/THC/C0702/out/UpdFunc.dll', 'D:/THC/C0702/ReleaseFiles/UpdFunc.dll')
end

desc "get latest updfunc version from svn ..."
task :get_latest_updfunc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TRDSUpd/UpdFunc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TRDSUpd/UpdFunc D:/THC/C0702/TRDSUpd/UpdFunc"
	sh "svn update D:/THC/C0702/TRDSUpd/UpdFunc"
end

#================================UpdSvc config=====================================
desc "build UpdSvc project ..."
task :updsvc => [:get_latest_updsvc, :resetvs6] do
	#puts "delete the old file UpdSvc.exe"
	#delete_file('D:/THC/C0702/out/UpdSvc.exe')
	sh "BuildConsole \"D:/THC/C0702/TRDSUpd/UpdSvc/UpdSvc.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	puts "copy UpdSvc.exe to release files folder"
	copy_files('D:/THC/C0702/out/UpdSvc.exe', 'D:/THC/C0702/ReleaseFiles/UpdSvc.exe')
end

desc "get latest updsvc version from svn ..."
task :get_latest_updsvc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TRDSUpd/UpdSvc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TRDSUpd/UpdSvc D:/THC/C0702/TRDSUpd/UpdSvc"
	sh "svn update D:/THC/C0702/TRDSUpd/UpdSvc"
end

#================================tpl_XXX config=====================================
desc desc "build tpl_XXX project ..."
task :tpl_xxx => [:resetvs6, :tpl_web, :tpl_calc, :tpl_SingleCalc, :tpl_DistributedCalc, :tpl_optimize, :tgroupCalcItemStr] do
	Rake::Task[:resetvs6].invoke
end

desc "build tpl_web project ..."
task :tpl_web => [:get_latest_tpl_web] do
	#puts "delete the old file tpl_web.dll"
	#delete_file('D:/THC/C0702/out/Plugins/tpl_web.dll')
	sh "msdev.exe D:/THC/C0702/CalcOTF/plugins/tpl_web/tpl_web.dsp /make \"tpl_web - Win32 Release\" /Rebuild"
	puts "copy tpl_web.dll to release files folder"
	copy_files('D:/THC/C0702/out/tpl_web.dll', 'D:/THC/C0702/ReleaseFiles/Plugins/tpl_web.dll')
end

desc "get latest tpl_web version from svn ..."
task :get_latest_tpl_web do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/plugins/tpl_web"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/plugins/tpl_web D:/THC/C0702/CalcOTF/plugins/tpl_web"
	sh "svn update D:/THC/C0702/CalcOTF/plugins/tpl_web"
end

desc "build tpl_calc project ..."
task :tpl_calc => [:get_latest_tpl_calc] do
	#puts "delete the old file tpl_calc.dll"
	#delete_file('D:/THC/C0702/out/Plugins/tpl_calc.dll')
	sh "msdev.exe D:/THC/C0702/CalcOTF/plugins/tpl_calc/tpl_calc.dsp /make \"tpl_calc - Win32 Release\" /Rebuild"
	puts "copy tpl_calc.dll to release files folder"
	copy_files('D:/THC/C0702/out/tpl_calc.dll', 'D:/THC/C0702/ReleaseFiles/Plugins/tpl_calc.dll')
end

desc "get latest tpl_calc version from svn ..."
task :get_latest_tpl_calc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/plugins/tpl_calc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/plugins/tpl_calc D:/THC/C0702/CalcOTF/plugins/tpl_calc"
	sh "svn update D:/THC/C0702/CalcOTF/plugins/tpl_calc"
end

desc "build tpl_SingleCalc project ..."
task :tpl_SingleCalc => [:get_latest_tpl_SingleCalc] do
	#puts "delete the old file tpl_SingleCalc.dll"
	#delete_file('D:/THC/C0702/out/Plugins/tpl_SingleCalc.dll')
	sh "msdev.exe D:/THC/C0702/CalcOTF/plugins/tpl_SingleCalc/tpl_SingleCalc.dsp /make \"tpl_SingleCalc - Win32 Release\" /Rebuild"
	puts "copy tpl_SingleCalc.dll to release files folder"
	copy_files('D:/THC/C0702/out/tpl_SingleCalc.dll', 'D:/THC/C0702/ReleaseFiles/Plugins/tpl_SingleCalc.dll')
end

desc "get latest tpl_SingleCalc version from svn ..."
task :get_latest_tpl_SingleCalc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/plugins/tpl_SingleCalc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/plugins/tpl_SingleCalc D:/THC/C0702/CalcOTF/plugins/tpl_SingleCalc"
	sh "svn update D:/THC/C0702/CalcOTF/plugins/tpl_SingleCalc"
end

desc "build tpl_DistributedCalc project ..."
task :tpl_DistributedCalc => [:get_latest_tpl_DistributedCalc] do
	#puts "delete the old file tpl_DistributedCalc.dll"
	#delete_file('D:/THC/C0702/out/Plugins/tpl_DistributedCalc.dll')
	sh "msdev.exe D:/THC/C0702/CalcOTF/plugins/tpl_DistributedCalc/tpl_DistributedCalc.dsp /make \"tpl_DistributedCalc - Win32 Release\" /Rebuild"
	puts "copy tpl_DistributedCalc.dll to release files folder"
	copy_files('D:/THC/C0702/out/tpl_DistributedCalc.dll', 'D:/THC/C0702/ReleaseFiles/Plugins/tpl_DistributedCalc.dll')
end

desc "get latest tpl_DistributedCalc version from svn ..."
task :get_latest_tpl_DistributedCalc do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/plugins/tpl_DistributedCalc"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/plugins/tpl_DistributedCalc D:/THC/C0702/CalcOTF/plugins/tpl_DistributedCalc"
	sh "svn update D:/THC/C0702/CalcOTF/plugins/tpl_DistributedCalc"
end

desc "build tpl_optimize project ..."
task :tpl_optimize => [:get_latest_tpl_optimize] do
	#puts "delete the old file tpl_optimize.dll"
	#delete_file('D:/THC/C0702/out/tpl_optimize.dll')
	sh "msdev.exe D:/THC/C0702/CalcOTF/plugins/tpl_optimize/tpl_optimize.dsp /make \"tpl_optimize - Win32 Release\" /Rebuild"
	puts "copy tpl_optimize.dll to release files folder"
	copy_files('D:/THC/C0702/out/tpl_optimize.dll', 'D:/THC/C0702/ReleaseFiles/tpl_optimize.dll')
end

desc "get latest tpl_optimize version from svn ..."
task :get_latest_tpl_optimize do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/CalcOTF/plugins/tpl_optimize"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/CalcOTF/plugins/tpl_optimize D:/THC/C0702/CalcOTF/plugins/tpl_optimize"
	sh "svn update D:/THC/C0702/CalcOTF/plugins/tpl_optimize"
end

desc "build TGroupCalcItemStr project ..."
task :tgroupCalcItemStr => [:get_latest_tgroupCalcItemStr] do
	#puts "delete the old file TGroupCalcItemStr.dll"
	#delete_file('D:/THC/C0702/out/TGroupCalcItemStr.dll')
	sh "msdev.exe D:/THC/C0702/TCom2/TGroupCalcItemStr/TGroupCalcItemStr.dsp /make \"TGroupCalcItemStr - Win32 Release MinSize\" /Rebuild"
	puts "copy TGroupCalcItemStr.dll to release files folder"
	copy_files('D:/THC/C0702/out/TGroupCalcItemStr.dll', 'D:/THC/C0702/ReleaseFiles/TGroupCalcItemStr.dll')
end

desc "get latest TGroupCalcItemStr version from svn ..."
task :get_latest_tgroupCalcItemStr do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TGroupCalcItemStr"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TGroupCalcItemStr D:/THC/C0702/TCom2/TGroupCalcItemStr"
	sh "svn update D:/THC/C0702/TCom2/TGroupCalcItemStr"
end

#================================Tcamel config=======================================
desc "build Tcamel project ..."
task :tcamel => [:get_latest_tcamel] do
	sh "VB6.exe /make D:/THC/C0702/TCom2/TCamel/TCamel.vbp /outdir D:/THC/C0702/out/"
	puts "copy TCamel.dll to release files folder"
	copy_files('D:/THC/C0702/out/TCamel.dll', 'D:/THC/C0702/ReleaseFiles/TCamel.dll')
end

desc "get latest tcamel version from svn ..."
task :get_latest_tcamel do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TCom2/TCamel"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TCom2/TCamel D:/THC/C0702/TCom2/TCamel"
	sh "svn update D:/THC/C0702/TCom2/TCamel"
end

#=================================SPDA config=========================================
desc "build SPDA project ..."
task :spda => [:get_latest_spda] do
	#puts "delete the old file SPDA.dll"
	#delete_file('D:/THC/C0702/out/SPDA.dll')
	sh "msdev.exe D:/THC/C0702/Misc/SPDA/SPDA.dsp /make \"SPDA - Win32 Release\" /Rebuild"
	puts "copy SPDA.dll to release files folder"
	copy_files('D:/THC/C0702/out/SPDA.dll', 'D:/THC/C0702/ReleaseFiles/SPDA.dll')
end

desc "get latest spda version from svn ..."
task :get_latest_spda do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/Misc/SPDA"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/Misc/SPDA D:/THC/C0702/Misc/SPDA"
	sh "svn update D:/THC/C0702/Misc/SPDA"
end
#================================TNetInfo config=====================================
desc "build TNetInfo project ..."
task :tnetinfo => [:get_latest_tnetinfo, :resetvs6] do
	#puts "delete the old file TNetInfo.dll"
	#delete_file('D:/THC/C0702/out/TNetInfo.dll')
	sh "BuildConsole \"D:/THC/C0702/TRDSUpd/TNetInfo/TNetInfo.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release\""
	puts "copy TNetInfo.dll to release files folder"
	copy_files('D:/THC/C0702/out/TNetInfo.dll', 'D:/THC/C0702/ReleaseFiles/TNetInfo.dll')
end

desc "get latest tnetinfo version from svn ..."
task :get_latest_tnetinfo do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/TRDSUpd/TNetInfo"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/TRDSUpd/TNetInfo D:/THC/C0702/TRDSUpd/TNetInfo"
	sh "svn update D:/THC/C0702/TRDSUpd/TNetInfo"
end

#================================SysTest config=====================================
task :systest => [:get_latest_systest] do
	sh "VB6.exe /make D:/THC/C0702/Misc/ThcSysTest/ThcSysTest.vbp /out D:/THC/C0702/BuildScript/buildLog/buildThcSysTest.log /outdir D:/THC/C0702/ReleaseFiles"
end

desc "get latest systest version from svn ..."
task :get_latest_systest do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/Misc/ThcSysTest"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/Misc/ThcSysTest D:/THC/C0702/Misc/ThcSysTest"
	sh "svn update D:/THC/C0702/Misc/ThcSysTest"
end

#================================ClientSetupPackage config=====================================
desc "build ClientSetupPackage project ..."
task :clientsetuppackage do
	build_date = Time.now.strftime("%Y%m%d")
	config = "C0702 " + build_date
	config1 = config + Time.now.strftime("%H%M")
	sh "IsCmdBld.exe -p D:/THC/C0702/Setup/TRDSDev.ism -c COMP -e y -r #{build_date} -a \"#{config}\""
	
	if(!File.directory?("D:/THC/C0702/SetupPack/#{config}/"))
		Dir.mkdir("D:/THC/C0702/SetupPack/#{config}/")
	end
	
	copy_files("D:/THC/C0702/Setup/TRDSDev/#{config}/#{build_date}/DiskImages/DISK1/setup.exe", "D:/THC/C0702/SetupPack/#{config}/THCClientSetup#{config1}Updated.exe")
	
	copy_files("D:/THC/C0702/Setup/TRDSDev/#{config}/#{build_date}/DiskImages/DISK1/setup.exe", "D:/THC/C0702/SetupPack/SetupTest/THCClientSetup.exe")
end

#================================IRRSvcSetupPackage config=====================================
desc "build IRRSvcSetupPackage project ..."
task :irrsvcsetuppackage do
	build_date = Time.now.strftime("%Y%m%d")
	config = "C0702 " + build_date
	config1 = config + Time.now.strftime("%H%M")
	sh "IsCmdBld.exe -p D:/THC/C0702/Setup/IRRSvcDev.ism -c COMP -e y -r #{build_date} -a \"#{config}\""
	
	if(!File.directory?("D:/THC/C0702/SetupPack/#{config}/"))
		Dir.mkdir("D:/THC/C0702/SetupPack/#{config}/")
	end
	
	copy_files("D:/THC/C0702/Setup/IRRSvcDev/#{config}/#{build_date}/DiskImages/DISK1/setup.exe", "D:/THC/C0702/SetupPack/#{config}/THCIRRSvcSetup#{config1}Updated.exe")
	
	copy_files('D:/THC/C0702/BuildScript/dailybuildNotF.dat', 'D:/THC/C0702/SetupPack/SetupTest/dailybuildFinished.dat')
	copy_files('D:/THC/C0702/BuildScript/dailybuildNotF.dat', 'D:/THC/C0702/ReleaseFiles/dailybuildFinished.dat')
	release = "dev"
	if(release == "release")
		copy_files('D:/THC/C0702/BuildScript/dailybuildNotF.dat', 'D:/THC/C0702/BuildScript/buildReleaseVersion.dat')
	end
	
	copy_files("D:/THC/C0702/Setup/IRRSvcDev/#{config}/#{build_date}/DiskImages/DISK1/setup.exe", "D:/THC/C0702/SetupPack/SetupTest/THCIRRSvcSetup.exe")
end
#=============================RSSV config===================================
desc "build RSSV project ..."
task :rssv => [:resetvs6, :splitportfolio, :mappingtool, :automktdata, :amdsv] do
	puts "rssv build finished"
end

desc "build SplitPortfolio project ..."
task :splitportfolio => [:get_latest_splitportfolio] do
	sh "VB6.exe /make D:/THC/C0702/PCNest/RSSV/SplitPortfolio/SplitPortfolio.vbp /out D:/THC/C0702/BuildScript/buildlog/SplitPortfolio.log /outdir D:/THC/C0702/out/"
	puts "copy SplitPortfolio.dll to release files folder"
	copy_files('D:/THC/C0702/out/SplitPortfolio.dll', 'D:/THC/C0702/ReleaseFiles/SplitPortfolio.dll')
	sh "regsvr32.exe D:/THC/C0702/out/SplitPortfolio.dll /s"
end

desc "get latest splitportfolio version from svn ..."
task :get_latest_splitportfolio do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/PCNest/RSSV/SplitPortfolio"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/PCNest/RSSV/SplitPortfolio D:/THC/C0702/PCNest/RSSV/SplitPortfolio"
	sh "svn update D:/THC/C0702/PCNest/RSSV/SplitPortfolio"
end

desc "build MappingTool project ..."
task :mappingtool => [:get_latest_mappingtool] do
	sh "VB6.exe /make D:/THC/C0702/PCNest/RSSV/MappingTool/MappingTool.vbp /out D:/THC/C0702/BuildScript/buildlog/MappingTool.log /outdir D:/THC/C0702/out/"
	puts "copy MappingTool.dll to release files folder"
	copy_files('D:/THC/C0702/out/MappingTool.dll', 'D:/THC/C0702/ReleaseFiles/MappingTool.dll')
	sh "regsvr32.exe D:/THC/C0702/out/MappingTool.dll /s"
end

desc "get latest mappingtool version from svn ..."
task :get_latest_mappingtool do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/PCNest/RSSV/MappingTool"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/PCNest/RSSV/MappingTool D:/THC/C0702/PCNest/RSSV/MappingTool"
	sh "svn update D:/THC/C0702/PCNest/RSSV/MappingTool"
end

desc "build AutoMktdata project ..."
task :automktdata => [:get_latest_automktdata] do
	#puts "delete the old file AutoMktdata.dll"
	#delete_file('D:/THC/C0702/out/AutoMktdata.dll')
	sh "msdev.exe D:/THC/C0702/PCNest/RSSV/AutoMktdata/AutoMktdata.dsp /make \"AutoMktdata - Win32 Release MinSize\" /Rebuild"
	puts "copy AutoMktdata.dll to release files folder"
	copy_files('D:/THC/C0702/out/AutoMktdata.dll', 'D:/THC/C0702/ReleaseFiles/AutoMktdata.dll')
end

desc "get latest automktdata version from svn ..."
task :get_latest_automktdata do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/PCNest/RSSV/AutoMktdata"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/PCNest/RSSV/AutoMktdata D:/THC/C0702/PCNest/RSSV/AutoMktdata"
	sh "svn update D:/THC/C0702/PCNest/RSSV/AutoMktdata"
end

desc "build AMDSV project ..."
task :amdsv => [:get_latest_amdsv] do
	#puts "delete the old file rssv.exe"
	#delete_file('D:/THC/C0702/out/rssv.exe')
	sh "msdev.exe D:/THC/C0702/PCNest/RSSV/AMDSV/amdsv.dsp /make \"amdsv - Win32 Release\" /Rebuild"
	puts "copy rssv.exe to release files folder"
	copy_files('D:/THC/C0702/out/rssv.exe', 'D:/THC/C0702/ReleaseFiles/rssv.exe')
end

desc "get latest amdsv version from svn ..."
task :get_latest_amdsv do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/PCNest/RSSV/AMDSV"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/PCNest/RSSV/AMDSV D:/THC/C0702/PCNest/RSSV/AMDSV"
	sh "svn update D:/THC/C0702/PCNest/RSSV/AMDSV"
end

#=============================GetWebDev config===================================
desc "get web dev"
task :getwebdev do
	sh "D:/THC/DailyWeb/daily.bat"
end

#=============================TSvc4ESeries config===================================
desc "build TSvc4ESeries project ..."
task :tsvc4eseries => [:resetvs6, :tsvcclient, :rtdserver, :webservice] do
	puts "build TSvc4ESeries finished"
end

desc "build TSvcClient project ..."
task :tsvcclient => [:get_latest_tsvcclient] do
	#puts "delete the old file TSvcClient.exe"
	#delete_file('D:/THC/C0702/out(E-Series)/TSvcClient.exe')
	#sh "devenv.exe D:/THC/C0702/E-Series/TSvcClient-vs2005/TSvcClient.vcproj /Out \"D:/THC/C0702/BuildScript/buildlog/TSvcClient.log\" \"Release|Win32\" /Rebuild"
	sh "BuildConsole \"D:/THC/C0702/E-Series/TSvcClient-vs2005/TSvcClient.vcproj\" /rebuild /OpenMonitor /cfg=\"Release|Win32\""
	puts "copy TSvcClient.exe to release files folder"
	copy_files('D:/THC/C0702/out(E-Series)/TSvcClient.exe', 'D:/THC/C0702/ReleaseFiles/TSvcClient.exe')
end

desc "get latest tsvcclient version from svn ..."
task :get_latest_tsvcclient do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/E-Series/TSvcClient-vs2005"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/E-Series/TSvcClient-vs2005 D:/THC/C0702/E-Series/TSvcClient-vs2005"
	sh "svn update D:/THC/C0702/E-Series/TSvcClient-vs2005"
end

desc "build RTDServer project ..."
task :rtdserver => [:get_latest_rtdserver] do
	#puts "delete the old file RTDServer.dll"
	#delete_file('D:/THC/C0702/out(E-Series)/RTDServer.dll')
	sh "BuildConsole \"D:/THC/C0702/E-Series/RTDServer/RTDServer.vcproj\" /rebuild /OpenMonitor /cfg=\"Release MinSize|Win32\""
	puts "copy RTDServer.dll to release files folder"
	copy_files('D:/THC/C0702/out(E-Series)/RTDServer.dll', 'D:/THC/C0702/ReleaseFiles/RTDServer.dll')
end

desc "get latest rtdserver version from svn ..."
task :get_latest_rtdserver do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/E-Series/RTDServer"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/E-Series/RTDServer D:/THC/C0702/E-Series/RTDServer"
	sh "svn update D:/THC/C0702/E-Series/RTDServer"
end

desc "build WebService project ..."
task :webservice => [:get_latest_webservice] do
	#puts "delete the old webservice file"
	#delete_file('D:/THC/C0702/ReleaseFiles/WebService')
	sh "devenv.exe D:/THC/C0702/W-Series/WebService/WebService.csproj /Rebuild"
	puts "copy webservice fill to release files folder"
	sh "xcopy D:\\THC\\C0702\\W-Series\\WebService\\*.asmx D:\\THC\\C0702\\ReleaseFiles\\WebService\\ /H /R /Y"
	copy_files('D:/THC/C0702/W-Series/WebService/web.config', 'D:/THC/C0702/ReleaseFiles/WebService/web.config')
	#copy_files('D:/THC/C0702/W-Series/WebService/bin/', 'D:/THC/C0702/ReleaseFiles/WebService/bin')
	sh "xcopy D:\\THC\\C0702\\W-Series\\WebService\\bin\\*.dll D:\\THC\\C0702\\ReleaseFiles\\WebService\\bin\\ /H /R /Y"
end

desc "get latest webservice version from svn ..."
task :get_latest_webservice do |t|
	t.reenable
	sh "svn revert -R D:/THC/C0702/W-Series/WebService"
	#sh "svn checkout https://192.168.0.6:8443/svn/Repo/THC/C0702/W-Series/WebService D:/THC/C0702/W-Series/WebService"
	sh "svn update D:/THC/C0702/W-Series/WebService"
end
#================================CopyToProducts config=============================================
desc "build CopyToProducts project ..."
task :copy_to_products => [:dll, :r0702, :trds, :rssv1, :tnetsvr1, :tmqsvr1, :irrsvc1, :updsvc1, :w0702] do
	puts "copy to products finished"
end

release_path = "D:/THC/C0702/ReleaseFiles/"
task :dll do |t|
	t.reenable
	release_dlls = "craxddrt.dll,craxdrt.dll,crviewer.dll,espedcf.esp,cmosub32.dll,espmodel.dll,adppmdl.dll,flexcell.ocx,log4cxx.dll,jmail.dll,msinet.ocx,unins.exe,TRDSLicense.dll,prepayscore.dll,stsvc.exe,pathfilerules.xml,pathfileheads.xml,pathfile.xla,ConnStringEditorC0702.exe,IRRSvcMonitor.exe,cmo_w32.dll,tzip.dll,trdscrypto.dll,tcnpool.dll,tlogging.dll,tmisc.dll,trdsdata.dll,terrhandler.dll,tmd.dll,taset.dll,tdcalc.dll,tsecurity.dll,trefentity.dll,texchangeratemgr.dll,tstock.dll,toption.dll,tots.dll,tbond.dll,tird.dll,tcyd.dll,tintexcmo.dll,tmarkit.dll,tstruprod.dll,tcdo.dll,toptionderiv.dll,tdbload.dll,tmongodb.dll,tportfolio.dll,ttask.dll,tmap.dll,tpathfileanalyzer.dll,tpathfileparser.dll,tcalc.dll,tpo.dll,trdsirrcalc.dll,trdscall.dll,tuserrole.dll,irrcalc.dll,thcglview.dll,tfiledb.dll,tnetcmd.dll,tactivemq.dll,tclientshell.dll,tanalysis.dll,tbusiness.dll,tnetinfo.dll,spda.dll,tcamel.dll,tgroupcalcitemstr.dll,tetldata.dll,oascalibrating.dll"
	release_dll_arr = release_dlls.split(',')
	product_Dll_path = "D:/THC/C0702/Products/Dll/"
	release_dll_arr.each do |dll|
		src_path = release_path + dll
		dest_path = product_Dll_path + dll
		copy_to_produc(src_path, dest_path, dll)
	end
	#file_list = FileList["craxddrt.dll", "craxdrt.dll", "crviewer.dll", "espedcf.esp", "cmosub32.dll", "espmodel.dll", "adppmdl.dll", "flexcell.ocx", "log4cxx.dll", "jmail.dll", "msinet.ocx", "unins.exe","TRDSLicense.dll", "prepayscore.dll", "stsvc.exe", "pathfilerules.xml", "pathfileheads.xml", "pathfile.xla", "ConnStringEditorC0702.exe", "IRRSvcMonitor.exe", "cmo_w32.dll", "tzip.dll", "trdscrypto.dll", "tcnpool.dll","tlogging.dll", "tmisc.dll", "trdsdata.dll", "terrhandler.dll", "tmd.dll", "taset.dll", "tdcalc.dll", "tsecurity.dll", "trefentity.dll", "texchangeratemgr.dll","tstock.dll", "toption.dll", "tots.dll", "tbond.dll", "tird.dll", "tcyd.dll", "tintexcmo.dll", "tmarkit.dll", "tstruprod.dll", "tcdo.dll", "toptionderiv.dll","tdbload.dll", "tmongodb.dll", "tportfolio.dll", "ttask.dll", "tpathfileanalyzer.dll", "tpathfileparser.dll", "tcalc.dll", "tpo.dll", "trdsirrcalc.dll", "trdscall.dll", "tuserrole.dll", "irrcalc.dll", "thcglview.dll", "tfiledb.dll", "tnetcmd.dll", "tactivemq.dll", "tclientshell.dll", "tanalysis.dll", "tbusiness.dll", "tnetinfo.dll", "spda.dll", "tcamel.dll", "tgroupcalcitemstr.dll", "tetldata.dll", "oascalibrating.dll"]
	#source_dll = FileList["#{release_path}/*.dll", "#{release_path}unins.exe", "#{release_path}stsvc.exe", "#{release_path}ConnStringEditorC0702.exe", "#{release_path}IRRSvcMonitor.exe", "#{release_path}espedcf.esp", "#{release_path}flexcell.ocx", "#{release_path}msinet.ocx", "#{release_path}pathfilerules.xml", "#{release_path}pathfileheads.xml", "#{release_path}pathfile.xla"]
	#dest_dll = FileList["#{product_Dll_path}/*.dll", "#{product_Dll_path}unins.exe", "#{product_Dll_path}stsvc.exe", "#{product_Dll_path}ConnStringEditorC0702.exe", "#{product_Dll_path}IRRSvcMonitor.exe", "#{product_Dll_path}espedcf.esp", "#{product_Dll_path}flexcell.ocx", "#{product_Dll_path}msinet.ocx", "#{product_Dll_path}pathfilerules.xml", "#{product_Dll_path}pathfileheads.xml", "#{product_Dll_path}pathfile.xla"]
	#source_dll.each do |dll|
		#base = File.basename(dll)
		#dest = product_Dll_path + base
		#puts dll
		#file dest => dll do
			#cp dll, dest, :verbose => true
		#end
	#end
	#file_list.each do |dll|
		#src_path = release_path + dll
		#dest_path = product_Dll_path + dll
		#file "#{dest_path}" => "#{src_path}" do
			#cp src_path, dest_path, :verbose => true
		#end
	#end
	
end

task :r0702 do |t|
	t.reenable
	files = "createreport.dll,rptsvc.exe,thccrystalreport.exe,thccrystalreports.dll,tpl_optimize.dll,report setting.xml"
	release_R0702_arr = files.split(',')
	product_R0702_path = "D:/THC/C0702/Products/R0702/"
	release_R0702_arr.each do |file|
		src_path = release_path + file
		dest_path = product_R0702_path + file
		copy_to_produc(src_path, dest_path, file)
	end
end

task :trds do |t|
	t.reenable
	files = "cdo.exe,intexcmo.exe,oas.exe,otshelp.chm,pub.dat,thc.exe,thc_en.chm,thcclient.mdb,thcdatatransfer.exe,thcres.mdb,tranchestool.exe,MDOperator.dll"
	release_TRDS_arr = files.split(',')
	product_TRDS_path = "D:/THC/C0702/Products/TRDS/"
	release_TRDS_arr.each do |file|
		src_path = release_path + file
		dest_path = product_TRDS_path + file
		copy_to_produc(src_path, dest_path, file)
	end
end

task :rssv1 do |t|
	t.reenable
	files = "rssv.exe,automktdata.dll,mappingtool.dll,splitportfolio.dll,log4cxx.dll"
	release_RSSV_arr = files.split(',')
	product_RSSV_path = "D:/THC/C0702/Products/RSSV/"
	release_RSSV_arr.each do |file|
		src_path = release_path + file
		dest_path = product_RSSV_path + file
		copy_to_produc(src_path, dest_path, file)
	end
end

task :tnetsvr1 do |t|
	t.reenable
	files = "tnetcalc.exe,tnetsvr.exe,tprogress.dll,log4cxx.dll,log4cxxr.dll"
	release_TNetSvr_arr = files.split(',')
	product_TNetSvr_path = "D:/THC/C0702/Products/TNetSvr/"
	release_TNetSvr_arr.each do |file|
		src_path = release_path + file
		dest_path = product_TNetSvr_path + file
		copy_to_produc(src_path, dest_path, file)
	end

	sh "xcopy D:\\THC\\C0702\\ReleaseFiles\\Plugins\\*.dll D:\\THC\\C0702\\Products\\TNetSvr\\plugins\\ /H /R /Y /D"
end

task :tmqsvr1 do |t|
	t.reenable
	files = "tmqsvr.exe,mqviewer.exe,log4cxx.dll"
	release_TMQSvr_arr = files.split(',')
	product_TMQSvr_path = "D:/THC/C0702/Products/TMQSvr/"
	release_TMQSvr_arr.each do |file|
		src_path = release_path + file
		dest_path = product_TMQSvr_path + file
		copy_to_produc(src_path, dest_path, file)
	end
end

task :irrsvc1 do |t|
	t.reenable
	files = "irrsvc.exe,collectots.dll,log4cxx.dll"
	release_IRRSvc_arr = files.split(',')
	product_IRRSvc_path = "D:/THC/C0702/Products/IRRSvc/"
	release_IRRSvc_arr.each do |file|
		src_path = release_path + file
		dest_path = product_IRRSvc_path + file
		copy_to_produc(src_path, dest_path, file)
	end
end

task :updsvc1 do |t|
	t.reenable
	files = "updfunc.dll,updsvc.exe"
	release_UpdSvc_arr = files.split(',')
	product_UpdSvc_path = "D:/THC/C0702/Products/UpdSvc/"
	release_UpdSvc_arr.each do |file|
		src_path = release_path + file
		dest_path = product_UpdSvc_path + file
		copy_to_produc(src_path, dest_path, file)
	end
end

task :w0702 do |t|
	t.reenable
	product_W0702_path = "D:\\THC\\C0702\\Products\\W0702\\"
	src_w0702 = "D:\\w0702-dev"
	date = Time.now.strftime("%Y%m%d")
	release = "dev"
	if(release == "release")
		src_w0702 = "D:\\w0702-dev_release"
	end
	
	#FileUtils.remove_dir(product_W0702_path)
	if(!File.directory?(product_W0702_path))
		src_w0702 = "#{src_w0702}\\patches\\w0702-dev-#{date}"
	else
		src_w0702 = "#{src_w0702}\\project"
	end
	
	sh "xcopy #{src_w0702} #{product_W0702_path} /H /R /Y /E /D"

	puts "copy webservice fill to W0702 folder"
	sh "xcopy D:\\THC\\C0702\\W-Series\\WebService\\*.asmx #{product_W0702_path} /H /R /Y /E /D"
	#copy_files('D:/THC/C0702/W-Series/WebService/web.config', 'D:/THC/C0702/Products/W0702/')
	sh "xcopy D:\\THC\\C0702\\W-Series\\WebService\\bin\\*.dll #{product_W0702_path}\\bin\\ /H /R /Y /D"
end

#================================CopyToPcnest======================================================
desc "copy products file to pcnest"
task :copy_to_pcnest do
	pcnest_path = "\\\\192.168.0.4\\thc\\Back20070704\\FileList\\WebDev"
	src_path = "D:\\THC\\C0702\\Products"
	
	#copy_files("C:\\THC\\C0702\\Products\\R0702\\rptsvc.exe", "\\\\192.168.0.167\\thc\\Back20070704\\FileList\\WebDev\\")
	
	sh "xcopy #{src_path}\\Dll\\*.* #{pcnest_path}\\test\\ /H /R /Y /E /D"
	sh "xcopy #{src_path}\\IRRSvc\\*.* #{pcnest_path}\\IRRSvc\\ /H /R /Y /E /D"
	sh "xcopy #{src_path}\\R0702\\*.* #{pcnest_path}\\R0702\\ /H /R /Y /E /D"
	sh "xcopy #{src_path}\\RSSV\\*.* #{pcnest_path}\\RSSV\\ /H /R /Y /E /D"
	sh "xcopy #{src_path}\\TMQSvr\\*.* #{pcnest_path}\\TMQSvr\\ /H /R /Y /E /D"
	sh "xcopy #{src_path}\\TNetSvr\\*.* #{pcnest_path}\\TNetSvr\\ /H /R /Y /E /D"
	sh "xcopy #{src_path}\\TNetSvr\\plugins\\*.* #{pcnest_path}\\TNetSvr\\\\plugins\\ /H /R /Y /E /D"
	sh "xcopy #{src_path}\\TRDS\\*.* #{pcnest_path}\\TRDS\\ /H /R /Y /E /D"
	sh "xcopy #{src_path}\\UpdSvc\\*.* #{pcnest_path}\\UpdSvc\\ /H /R /Y /E /D"
	#sh "xcopy #{src_path}\\W0702 #{pcnest_path}\\W0702\\ /H /R /Y /E"
	puts "copy to pcnest finished!"
end

#================================buildFiles_With_cmo322 config=====================================
desc "build buildFiles_With_cmo322 project ..."
task :buildFiles_With_cmo322 => [:tintexcmo_with_com32, :tcdo_with_cmo32] do
	puts "build buildFiles_With_cmo322 finished"
end

desc "build IntexCMO_with_cmo32 project ..."
task :tintexcmo_with_com32 => [:get_latest_tintexcmo, :resetvs6, :presvthclib, :changedefine] do |t|
	Rake::Task[:buildvc6thclib].invoke
	#puts "delete the old file TIntexCMO.dll..."
	#delete_file('D:/THC/C0702/out/TIntexCMO.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TIntexCMO/TIntexCMO.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	Rake::Task[:recoverdefine].invoke
	
	#recoverthclib
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/TIntexCMO.dll'))
		copy_files('D:/THC/C0702/out/TIntexCMO.dll', 'D:/THC/C0702/ReleaseFiles/TIntexCMO.dll')
		puts "Build D:/THC/C0702/out/TIntexCMO.dll failed in project #{t.name}!"
	end
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
	
	puts "copy TIntexCMO.dll to IntexCMO_With_cmo32 folder..."
	copy_files("D:/THC/C0702/out/TIntexCMO.dll", "D:/THC/C0702/ReleaseFiles/IntexCMO_With_cmo32/TIntexCMO#{Time.now.strftime("%Y%m%d%H%M")}.dll")
	copy_files('D:/THC/C0702/ReleaseFiles/TIntexCMO.dll', 'D:/THC/C0702/out/TIntexCMO.dll')
end

desc "build TCDO_with_cmo32 project ..."
task :tcdo_with_cmo32 => [:get_latest_tcdo, :resetvs6, :presvthclib, :changedefine] do |t|
	Rake::Task[:buildvc6thclib].invoke
	#puts "delete the old file TCDO.dll..."
	#delete_file('D:/THC/C0702/out/TCDO.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TCDO/TCDO.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	Rake::Task[:recoverdefine].invoke
	
	#recoverthclib
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/TCDO.dll'))
		copy_files('D:/THC/C0702/out/TCDO.dll', 'D:/THC/C0702/ReleaseFiles/TCDO.dll')
		puts "Build D:/THC/C0702/out/TCDO.dll failed in project #{t.name}!"
	end
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
	
	puts "copy TCDO.dll to IntexCMO_With_cmo32 folder..."
	copy_files("D:/THC/C0702/out/TCDO.dll", "D:/THC/C0702/ReleaseFiles/IntexCMO_With_cmo32/TCDO#{Time.now.strftime("%Y%m%d%H%M")}.dll")
	copy_files('D:/THC/C0702/ReleaseFiles/TCDO.dll', 'D:/THC/C0702/out/TCDO.dll')
end

desc "build StruProd_with_com32 project ..."
task :tstruprod => [:get_latest_tstruprod, :resetvs6, :presvthclib, :changedefine] do |t|
	Rake::Task[:buildvc6thclib].invoke
	#puts "delete the old file TStruProd.dll..."
	#delete_file('D:/THC/C0702/out/TStruProd.dll')
	sh "BuildConsole \"D:/THC/C0702/TCom2/TStruProd/TStruProd.dsp\" /rebuild /OpenMonitor /cfg=\"Win32 Release MinSize\""
	Rake::Task[:recoverdefine].invoke
	
	#recoverthclib
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/TStruProd.dll'))
		copy_files('D:/THC/C0702/out/TStruProd.dll', 'D:/THC/C0702/ReleaseFiles/TStruProd.dll')
		puts "Build D:/THC/C0702/out/TStruProd.dll failed in project #{t.name}!"
	end
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
	
	puts "copy TStruProd.dll to IntexCMO_With_cmo32 folder..."
	copy_files("D:/THC/C0702/out/TStruProd.dll", "D:/THC/C0702/ReleaseFiles/IntexCMO_With_cmo32/TStruProd#{Time.now.strftime("%Y%m%d%H%M")}.dll")
	copy_files('D:/THC/C0702/ReleaseFiles/TStruProd.dll', 'D:/THC/C0702/out/TStruProd.dll')
end

#================================Update 13=========================
task :update_web do
	update_web_13("/cygdrive/d/Web_update_sev/Update_web_part.bat")
end

task :update_dll do
	update_web_13("/cygdrive/d/Web_update_sev/Update_dll_part_No_web_file.bat")
end

task :update_web_report_template do
	update_web_13("/cygdrive/d/Web_update_sev/Update_web_report_template.bat")
end

task :update_all do
	update_web_13("/cygdrive/d/Web_update_sev/web_Update_new.bat")
end

#================================GetWeb config===========================
task :get_web_file do
	sh "D:/THC/DailyWeb/GetWeb.bat"
end

#================================end=====================================
desc "intel compliler setting ...."
task :setintel do
	sh "reg.exe add \"HKCU\\Software\\Intel\\Intel Tools\\Select Compiler\\IDE\\6\" /v Compiler /t REG_SZ /d 91032 /f"
	sh "reg.exe add \"HKCU\\Software\\Intel\\Intel Tools\\Select Compiler\\IDE\\6\" /v Use_Intel_Cxx /t REG_DWORD /d 00000001 /f"
end

desc "reset back to vs6 ..."
task :resetvs6 do
	sh "reg.exe add \"HKCU\\Software\\Intel\\Intel Tools\\Select Compiler\\IDE\\6\" /v Compiler /t REG_SZ /d 91032 /f"
	sh "reg.exe add \"HKCU\\Software\\Intel\\Intel Tools\\Select Compiler\\IDE\\6\" /v Use_Intel_Cxx /t REG_DWORD /d 00000000 /f"
end

task :presvthclib do
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Intel.bat"
	else
		copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libMs6', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	end
end

task :buildvc6thclib do
	if(!is_lib_ms6_up_to_date)
		sh "BuildConsole \"D:/THC/C0702/ThcLib/ThcLib.dsp\" /build /OpenMonitor /cfg=\"Win32 Release\""
		
		if(!File.exists?('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')) #build ThcLib Failed
			copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
			Rake::Task[:recoverdefine].invoke
			#puts "Rebuild MS6 ThcLib failed in project ${project::get-name()}"
		else                                                      #build ThcLib Success
			copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libMs6')
		end
	else
		puts "thclib is up to date, so build omitted ."
	end
end

task :recoverdefine do
	copy_files('D:/THC/C0702/IntexUseable/IntexUseable_Real.h', 'D:/THC/C0702/TCom2/contrib/IntexUseable.h')
end

task :changedefine do
	copy_files('D:/THC/C0702/BuildScript/dailybuildNotF.dat', 'D:/THC/C0702/IntexUseable/IntexUseable_Fake.h')
	copy_files('D:/THC/C0702/TCom2/contrib/IntexUseable.h', 'D:/THC/C0702/IntexUseable/IntexUseable_Real.h')
	copy_files('D:/THC/C0702/IntexUseable/IntexUseable_Fake.h', 'D:/THC/C0702/TCom2/contrib/IntexUseable.h')
end

task :recoverthclib do
	copy_files('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel', 'D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.lib')
	if(!File.exists?('D:/THC/C0702/out/TIntexCMO.dll'))
		copy_files('D:/THC/C0702/out/TIntexCMO.dll', 'D:/THC/C0702/ReleaseFiles/TIntexCMO.dll')
		puts "Build ${DllFilePath} failed in project ${project::get-name()}!"
	end
	
	if(!is_lib_ms6_up_to_date)
		sh "D:/THC/C0702/BuildScript/Mov2Ms6.bat"
	end
end

def delete_file(path)
	File.delete(path)
end

def copy_files(from, to)
	#File.syscopy(from, to)
	File.cp(from, to, true)
	#FileUtils.cp(from, to)
end
	
def is_lib_ms6_up_to_date
	lib_ms6_time = File.mtime('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libMs6')
	lib_intel_time = File.mtime('D:/THC/lib/ThcLib-vc6-mt-s-0_3_8.libIntel')
	lib_ms6_time >= lib_intel_time ? true : false
end

def copy_to_produc(src_path, dest_path, file)
	if(File.exists?(src_path))
		if(File.exists?(dest_path))
			if(File.stat(src_path).mtime > File.stat(dest_path).mtime)
				copy_files(src_path, dest_path)
			end
		else
			copy_files(src_path, dest_path)
		end
	else
		puts "file #{file} not found!"
	end
end

def update_web_13(path)
	Net::SSH.start("192.168.0.13", "Administrator", :password => "thc013*", :paranoid => false) do |ssh|
	output = ssh.exec! path
	puts output
	end
end

def is_newer(source, target)
    File.stat(source).mtime > File.stat(target).mtime
end