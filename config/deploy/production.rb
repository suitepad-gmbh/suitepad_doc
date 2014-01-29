server 'monitor-server-01', user: 'suitepad', roles: %w{web app db}

# Unicorn
set :unicorn_pid,     -> { "#{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid" }
set :unicorn_config,  -> { "#{fetch(:deploy_to)}/current/config/unicorn/production.rb" }

# Rails
set :rails_env, :production