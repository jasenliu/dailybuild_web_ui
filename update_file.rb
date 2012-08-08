require 'rubygems'
require 'net/ssh'
require 'net/sftp'
require 'find'
require 'logger'

def update_remote_file(host, user, passwd, local_path, remote_path)
  update_date = Time.now.strftime('%y%m%d')
  local_path = "#{local_path}/#{update_date}"

  log = Logger.new(STDOUT)
  log = Logger.new(STDERR)
  log.datetime_format = '%Y-%m-%d %H:%M:%S'


  puts "Connecting to remote server #{host} ..."
  begin_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  Net::SSH.start(host, user, :password => passwd, :paranoid => false) do |ssh|
    ssh.sftp.connect do |sftp|
      i = 0
      Find.find(local_path) do |file|
        i += 1
        local_file = file
        remote_file = remote_path + local_file.sub(local_path, '')

        if (File.directory?(file) && i != 1)
          log.info("#{remote_file} dir not exists")
          sftp.mkdir!(remote_file, :permissions => 0755)
          log.info("mkremotedir #{remote_file}")
          next
        end
     
        begin
          rstat = sftp.stat!(remote_file)
        rescue Net::SFTP::StatusException => e
          raise unless e.code == 2
          sftp.upload!(local_file, remote_file)
          log.info("Copying #{local_file} --> #{remote_file}")
        end
      end
    end
  
    puts "begin time:#{begin_time} end time:#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
    puts "Disconnecting from remote server #{host} ..."
  end

  puts 'File transfer complete'
end
