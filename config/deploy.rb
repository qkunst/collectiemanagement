# config valid only for current version of Capistrano
# lock '3.5.0'

set :application, 'collectiebeheer'
set :repo_url, 'https://github.com/qkunst/collectiebeheer.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp public/uploads storage}
# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

namespace :deploy do
  desc 'Show logs'
  task :log do
    on roles(:app), in: :sequence, wait: 5 do
      execute :tail, " -n 100 #{shared_path}/log/#{fetch(:stage)}.log"
    end
  end

  desc 'Restart application'
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

namespace :delayed_job do
  desc 'Start delayed job'
  task :start do
    on roles(:app) do
      # execute '~/.profile'
      # execute '~/.bashrc'
      execute "export PATH=\"$HOME/.rbenv/bin:$PATH\" && eval \"$(rbenv init -)\" && RAILS_ENV=#{fetch(:stage)} #{release_path.sub('/home/rails/','~/').join('bin/delayed_job').to_s} start"
    end
  end
  desc 'Stop delayed job'
  task :stop do
    on roles(:app) do
      # execute '~/.profile'
      # execute '~/.bashrc'
      execute "export PATH=\"$HOME/.rbenv/bin:$PATH\" && eval \"$(rbenv init -)\" && RAILS_ENV=#{fetch(:stage)} #{current_path.sub('/home/rails/','~/').join('bin/delayed_job').to_s} stop"
    end
  end
  desc 'Status delayed job'
  task :status do
    on roles(:app) do
      # execute '~/.profile'
      # execute '~/.bashrc'
      execute "export PATH=\"$HOME/.rbenv/bin:$PATH\" && eval \"$(rbenv init -)\" && RAILS_ENV=#{fetch(:stage)} #{current_path.sub('/home/rails/','~/').join('bin/delayed_job').to_s} status"
    end
  end
end

before :deploy, "delayed_job:stop" # Niet aanzetten in het begin
after :deploy, "delayed_job:start"