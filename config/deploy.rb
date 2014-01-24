# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'suitepad_doc'
set :user,        'suitepad'
set :group,       'suitepad'

set :scm,         :git
set :repo_url,    'git@github.com:suitepad-gmbh/suitepad_doc.git'

set :ssh_options, { port: 2899 }
set :deploy_to,   '/home/suitepad/web/suitepad_doc'
set :use_sudo,    false

set :log_level,   :info


# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{doc bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for keep_releases is 5
set :keep_releases, 1


namespace :unicorn do
  desc 'Stop Unicorn'
  task :stop do
    on roles(:app) do
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        execute :kill, capture(:cat, fetch(:unicorn_pid))
      end
    end
  end

  desc 'Start Unicorn'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec unicorn -c #{fetch(:unicorn_config)} -D"
        end
      end
    end
  end

  desc 'Reload Unicorn without killing master process'
  task :reload do
    on roles(:app) do
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        execute :kill, '-s USR2', capture(:cat, fetch(:unicorn_pid))
      else
        error 'Unicorn process not running'
      end
    end
  end

  desc 'Restart Unicorn'
  task :restart
  before :restart, :stop
  before :restart, :start
end


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
