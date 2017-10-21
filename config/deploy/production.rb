# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
set :stage, :production
set :rails_env, :production

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}
server 'whichmeme.info', user: 'deploy', roles: %w{web app db}, primary: true, port: 2222


# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

#role :app, %w{deploy@45.55.181.42}
#role :web, %w{deploy@45.55.181.42}
#role :db,  %w{deploy@45.55.181.42}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.

set :deploy_to, "/home/deploy/apps/whichmeme"

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
set :ssh_options, {
   keys: %w(/home/aaron/.ssh/id_rsa),
   forward_agent: false,
   auth_methods: %w(publickey),
   user: 'deploy',
   port: 2222
 }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

# For sudo'ing
set :pty, true

after 'deploy:finishing', 'deploy:restart'
after 'deploy:rollback', 'deploy:restart'

namespace :deploy do
  desc "Restart app"
    task :restart do
    on role(:app) do
      say "Restarting Unicorn..."
      execute "RAILS_ENV=production bundle exec unicorn --daemonize --config-file config/unicorn.rb"
    end
  end
end

