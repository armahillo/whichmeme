# set path to application
#root = "/home/deploy/apps/whichmeme"
#app_dir = root + "/current"
#shared_dir = root + "/shared"

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir


# Set unicorn options
worker_processes 4
preload_app true
timeout 30

before_fork do |server, worker|
  # ...
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # ...
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end


# Set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", backlog: 64

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/pids/unicorn.pid"
