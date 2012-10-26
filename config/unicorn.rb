worker_processes 3
preload_app true
listen 8080

after_fork do |server, worker|
	ActiveRecord::Base.establish_connection
end