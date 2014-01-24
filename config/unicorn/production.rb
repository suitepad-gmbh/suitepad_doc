# Define your root directory
root = "/home/suitepad/web/suitepad_doc/current"

# Define worker directory for Unicorn
working_directory root

# Location of PID file
pid "#{root}/tmp/pids/unicorn.pid"

# Define Log paths
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

# Listen on a UNIX data socket
listen "#{root}/tmp/sockets/app.socket"

# 16 worker processes for production environment
worker_processes 1

# Load rails before forking workers for better worker spawn time
preload_app true

# Restart workes hangin' out for more than 240 secs
timeout 120

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

# Force the bundler gemfile environment variable to
# reference the Сapistrano "current" symlink
before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
end