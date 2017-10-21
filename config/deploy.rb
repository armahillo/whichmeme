# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'whichmeme'
set :repo_url, 'git@github.com:armahillo/whichmeme.git'
# 'aaron@45.55.181.42:~/git/whichmeme.git'

# RVM configuration
# set :rvm_type, :user # Default is "auto"
# set :rvm_ruby_version, '2.2.1' # Default is "default"


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/apps/whichmeme'

set :ssh_options, { 
  user: 'deploy',
  port: 2222
}

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'vendor/bundle', 'public/system', 'data')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

#after 'deploy:publishing', 'deploy:restart'

#namespace :deploy do

#  desc "Restart Unicorn"
#  task :restart do
#    run "#{try_sudo} kill `cat #{unicorn_pid}`"
#    run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
 
#  end
#  task :restart do
#    run "RAILS_ENV=production bundle exec unicorn --daemonize --config-file config/unicorn.rb"
#  end

#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
#      within release_path do
#        execute :rake, 'cache:clear'
#      end
#    end
#  end

#end
