app_name = 'whichmeme'
environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || "production"
app_path = "/home/deploy/apps/whichmeme"
bundle_path = "/home/deploy/apps/whichmeme/shared/vendor/bundle/ruby/2.2.0"

# set path to application
#app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_path}/shared"
working_directory "#{app_path}/current"


# Set unicorn options
worker_processes 4
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64
listen(3000, backlog: 64) if ENV['RAILS_ENV'] == 'development'

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
if ENV['RAILS_ENV'] == 'production'
  pid "#{shared_dir}/pids/unicorn.pid" 
elsif ENV['RAILS_ENV'] == 'development'
  pid "/tmp/#{app_name}.pid" 
end

Unicorn::HttpServer::START_CTX[0] = "#{bundle_path}/bin/unicorn"
Unicorn::Configurator::DEFAULTS[:logger].formatter = Logger::Formatter.new

before_exec do |_|
  paths = (ENV["PATH"] || "").split(File::PATH_SEPARATOR)
  paths.unshift "#{bundle_path}/bin"

  ENV["PATH"] = paths.uniq.join(File::PATH_SEPARATOR)
  ENV["GEM_HOME"] = ENV['GEM_PATH'] = bundle_path
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/current/Gemfile"
end

# Garbage collection settings.
GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true

# If using ActiveRecord, disconnect (from the database) before forking.
before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

# After forking, restore your ActiveRecord connection.
after_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
