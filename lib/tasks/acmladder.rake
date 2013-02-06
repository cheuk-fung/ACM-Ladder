desc 'Start ACM Ladder (Arguments: env=[development(default)|production])'
task :start, :env do |t, args|
  args.with_defaults(:env => "development")
  return unless check_env(args.env)

  puts "Set RAILS_ENV to #{args.env}"
  ENV['RAILS_ENV'] = args.env
  verbose(false) do
    puts "Starting unicorn_rails..."
    sh "unicorn_rails -c config/unicorn.rb -D"
    puts "Done."
    sleep 1
    puts "Starting delayed_job..."
    sh "script/delayed_job start"
    puts "Done."
  end
end

desc 'Restart ACM Ladder (Arguments: env=[development(default)|production])'
task :restart, :env do |t, args|
  args.with_defaults(:env => "development")
  return unless check_env(args.env)

  Rake::Task[:stop].invoke
  puts ""
  sleep 1
  Rake::Task[:start].invoke(args.env)
end

desc 'Stop ACM Ladder'
task :stop do
  verbose(false) do
    puts "Stopping delayed_job..."
    sh "script/delayed_job stop"
    puts "Done."
    sleep 1
    puts "Stopping unicorn_rails..."
    sh "pkill -QUIT unicorn_rails"
    puts "Done."
  end
end

def check_env(env)
  return true if ["development", "production"].include?(env)
  puts "Error: env must be development or producton."
  false
end
