require "rvm/capistrano"

set :application, "happy_photos"
set :repository,  "git://github.com/anykeyh/happy-photos.git"
set :scm, "git"

set :rvm_type, :system
set :rvm_ruby_string, "2.0.0"
set :rvm_path_source, "/usr/local/rvm/bin/rvm"
set :rvm_path, "/usr/local/rvm"
ssh_options[:forward_agent] = true

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "anykeyh"                          # Your HTTP server, Apache/etc
role :app, "anykeyh"                          # This may be the same as your `Web` server
role :db,  "anykeyh", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
set :deploy_to, "/home/www/#{application}"
set :use_sudo, false
set :user, "root"


task :configure, :roles => :web do
  run "ln #{shared_path}/config/database.yml #{current_release}/config/database.yml"
  run "ln #{shared_path}/config/happy_photos.yml #{current_release}/config/happy_photos.yml"

  #run [
  #  "mkdir -p #{shared_path}/log",
  #  "touch #{shared_path}/log/production.log",
  #  "ln -s #{shared_path}/log/production.log #{current_release}/log/production.log"
  #].join(" && ")

  #run "rm -rf #{current_release}/.bundle  && ln -s #{shared_path}/dot_bundle #{current_release}/.bundle"
end

task :bundle2 do
  run [
    "cd #{release_path} &&",
    "bundle install",
    "--gemfile #{release_path}/Gemfile",
    "--path #{shared_path}/bundle",
    "--deployment --quiet",
    "--without development test"
  ].join(" ")
end

namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run "source #{rvm_path_source} && cd #{release_path} && unicorn_rails -c config/unicorn.rb -D -E production"
  end

  desc "Stop the Thin processes"
  task :stop do
    run "source #{rvm_path_source} && cd #{release_path} && kill -QUIT `cat tmp/pids/unicorn.pid`"
  end

  desc "Restart the Thin processes"
  task :restart do
    run "test -e #{shared_path}/pids/unicorn.pid && (source #{rvm_path_source} && cd #{release_path} && kill -QUIT `cat #{shared_path}/pids/unicorn.pid`); true"
    run "source #{rvm_path_source} && cd #{release_path} && unicorn_rails -c config/unicorn.rb -D -E production"
  end

end

after 'deploy:update_code', :configure
after 'deploy:update_code', :bundle2
after 'deploy:update_code', 'deploy:compile_assets'
after 'deploy:update_code', 'deploy:migrate'
after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do

  task :migrate, :roles => :db do
    rake 'db:migrate'
  end

  task :seed, :roles => :db do
    rake 'db:seed'
  end
  
  task :compile_assets do
    rake 'assets:clean'
    rake 'assets:precompile'
  end

end

def rake(task)
  run [
    "source #{rvm_path_source} &&",
    "cd #{release_path} &&",
    "RAILS_ENV=production rake #{task}",
  ].join(" ")
end


