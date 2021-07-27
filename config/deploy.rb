# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

# set :rbenv_type, :user # or :system, depends on your rbenv setup
# set :rbenv_ruby, '2.7.3'
set :application, "testapp"
set :repo_url, "https://github.com/patricio-arluciaga/testapp.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

set :linked_file, fetch(:linked_files, []).push('config/application.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :passenger_restart_with_touch, true
set :passenger_restart_command, '/usr/bin/passenger-config restart-app'
set :git_branch, run_locally('git rev-parse --abbrev-ref HEAD')

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :bundle_path, nil
set :bundle_without, nil
set :bundle_flags, nil
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }
set :deploy_to, "/home/parluciaga/testapp-deploy"

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  desc "Create a RELEASE file with the branch name"
  before :starting, :add_release_file
  task :add_release_file do
    run_locally do
      git_branch = `git rev-parse --abbrev-ref HEAD`.chomp
    end
    on release_roles(:all) do
      within release_path do
        execute :echo, "\"#{git_branch}\" > #{deploy_path.join('RELEASE')}"

      end
    end
  end
end
