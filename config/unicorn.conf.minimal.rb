# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# Based on http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

root = File.expand_path('../', File.dirname(__FILE__))
listen 2013 # by default Unicorn listens on port 8080
worker_processes 2 # this should be >= nr_cpus
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"
