root = File.expand_path('../', File.dirname(__FILE__))

working_directory root
worker_processes 2

pid "#{root}/tmp/pids/unicorn.pid"

stdout_path "#{root}/log/unicorn.log"
stderr_path "#{root}/log/unicorn.log"

listen 80, tcp_nopush: false
listen "/tmp/unicorn.sock", backlog: 1024

preload_app true
timeout 60
