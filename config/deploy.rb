# frozen_string_literal: true

# config valid only for current version of Capistrano
# lock '3.5.0'

set :application, "collectiemanagement"
set :remote_user, :qkunst

set :repo_url, "https://github.com/qkunst/collectiemanagement.git"

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
set :linked_files, %w[config/secrets.yml config/database.yml]

# Default value for linked_dirs is []
set :linked_dirs, %w[log tmp public/uploads storage node_modules]
# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# rbenv
set :rbenv_type, :user
set :rbenv_path, "/home/#{fetch(:remote_user)}/.rbenv"
set :rbenv_ruby, File.read(File.expand_path("../.ruby-version", __dir__)).strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all

set :local_user, `whoami`.strip
set :public_key, File.open("/Users/#{fetch(:local_user)}/.ssh/id_rsa.pub").read
set :database_name, "qkunst-prod"
set :database_user, "qkunst"

set :email, "maarten@murb.nl"

namespace :deploy do
  desc "Show logs"
  task :log do
    on roles(:app), in: :sequence, wait: 5 do
      execute :tail, " -n 100 #{shared_path}/log/#{fetch(:stage)}.log"
    end
  end

  desc "Restart application"
  after :restart, :clear_cache do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, :restart

  before "assets:precompile", :brand! do
    on roles(:app), in: :groups, limit: 5, wait: 0 do |role|
      execute "cd #{release_path} && RAILS_ENV=#{fetch(:stage)} #{fetch(:rbenv_prefix)} bundle exec rails branding:pull default"
    end
  end

end



namespace :rbenv do
  desc "Install rbenv"
  task :install do
    on roles(:setup) do
      begin
        execute "git clone https://github.com/rbenv/rbenv.git #{fetch(:rbenv_path)}"
      rescue SSHKit::Command::Failed
        puts "rbenv already installed, updating..."
        execute "cd #{fetch(:rbenv_path)} && git pull"
      end
      # execute "~/.rbenv/bin/rbenv init"
      execute "mkdir -p #{fetch(:rbenv_path)}/plugins"
      begin
        execute "git clone https://github.com/rbenv/ruby-build.git #{fetch(:rbenv_path)}/plugins/ruby-build"
      rescue SSHKit::Command::Failed
        puts "rbenv/ruby-build plugin already installed, updating..."
        execute "cd #{fetch(:rbenv_path)}/plugins/ruby-build && git pull"
      end
      rbenv_ruby = File.read(".ruby-version").strip
      execute "#{fetch(:rbenv_path)}/bin/rbenv install -s #{fetch(:rbenv_ruby) || rbenv_ruby}"
      execute "#{fetch(:rbenv_path)}/bin/rbenv global #{fetch(:rbenv_ruby) || rbenv_ruby}"
      execute "#{fetch(:rbenv_path)}/bin/rbenv local #{fetch(:rbenv_ruby) || rbenv_ruby}"
      # execute "#{fetch(:rbenv_path)}/bin/rbenv rehash"
      execute "export PATH=\"$HOME/.rbenv/bin:$PATH\" && eval \"$(rbenv init -)\" && ruby -v"

      execute "export PATH=\"$HOME/.rbenv/bin:$PATH\" && eval \"$(rbenv init -)\" && gem install bundler --no-document"
      if fetch(:rbenv_ruby).nil?
        puts "\nPlease uncomment the line `# set :rbenv_ruby, File.read('.ruby-version').strip` to enable capistrano rbenv"
      end
    end
  end
end

namespace :server do
  desc "Initialize"
  task :init do
    on roles(:app), in: :sequence do
      execute "mkdir -p #{shared_path}/config"

      begin
        execute "test -f #{shared_path}/config/secrets.yml && echo Secrets already present"
      rescue SSHKit::Command::Failed
        execute "printf \"#{fetch(:stage)}:\\n  secret_key_base: #{SecureRandom.hex(64)}\\n\" > #{shared_path}/config/secrets.yml"
      end

      begin
        execute "test -f #{shared_path}/config/database.yml && echo Database config already present"
      rescue SSHKit::Command::Failed
        execute "printf \"#{fetch(:stage)}:\\n  username: #{fetch(:database_user)}\\n  password: $PASSWORD\\n  adapter: postgresql\\n  encoding: unicode\\n  database: #{fetch(:database_name)}\\n  host: localhost\\n  pool: 5\\n  timeout: 5000\\n\" > #{shared_path}/config/database.yml"
      end
    end
  end

  desc "Install ruby"
  task :install_ruby do
    on roles(:app), in: :sequence do
      execute :rbenv, " install #{fetch(:rbenv_ruby)} -k"
      execute :rbenv, " global #{fetch(:rbenv_ruby)}"
      execute :gem, " install bundler"
      execute :echo, "'export PATH=\"$HOME/.rbenv/bin:$PATH\"'", ">>", "~/.bashrc"
      execute :echo, "'eval \"$(rbenv init -)\"'", ">>", "~/.bashrc"
    end
  end
end
