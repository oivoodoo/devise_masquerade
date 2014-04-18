require "bundler/gem_tasks"

task :default do
  system 'cd spec/dummy/ && bundle exec rake db:setup && bundle exec rake db:test:prepare && cd ../../'
  system 'bundle exec rspec && bundle exec cucumber'
end

