# frozen_string_literal: true

# config valid only for current version of Capistrano
# lock '3.5.0'

set :application, "collectiemanagement"

set :repo_url, "https://gitlab.com/murb-org/collectiemanagement.git"

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
set :linked_files, %w[config/secrets.yml config/database.yml config/initializers/mailer.rb]

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
set :rbenv_path, "~/.rbenv"
set :node_version, File.read(File.expand_path("../.nvmrc", __dir__)).strip
set :rbenv_ruby, File.read(File.expand_path("../.ruby-version", __dir__)).strip
set :rbenv_prefix, "NVM_DIR=~/.nvm RBENV_ROOT=~/.rbenv NODE_VERSION=#{fetch(:node_version)} RBENV_VERSION=#{fetch(:rbenv_ruby)} ~/.nvm/nvm-exec ~/.rbenv/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all
set :nvm_node, File.read(File.expand_path("../.nvmrc", __dir__)).strip
set :nvm_map_bins, %w[node npm yarn rake]

set :sidekiq_enable_lingering, false

set :email, "maarten@murb.nl"

set :migration_servers, -> { release_roles("db") }

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
    on roles(:app) do |role|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :echo, "#{host.properties.brand || "default"} > .current_brand"
          execute :rails, "branding:pull"
        end
      end
    end
  end

  # to make the pdf writer work it is essential that the asset host is properly configured to use absolute urls; not just paths
  before "assets:precompile", :configure_asset_host do
    on roles(:app) do |role|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :echo, "\"Rails.application.config.action_controller.asset_host = 'https://#{role.hostname}'\" > config/initializers/asset_hosts.rb"
        end
      end
    end
  end
end

Rake::Task["rbenv:validate"].clear_actions

namespace :rbenv do
  desc "Install rbenv"
  task :install do
    on roles(:app) do
      begin
        execute "git clone https://github.com/rbenv/rbenv.git ~/.rbenv"
      rescue SSHKit::Command::Failed
        puts "rbenv already installed, updating..."
      end
      begin
        execute "cd ~/.rbenv && git pull"
      rescue SSHKit::Command::Failed
        warn "rbenv:install rbenv could not be updated; not a git directory? remove existing .rbenv directory"
        exit 1
      end
      # execute "~/.rbenv/bin/rbenv init"
      execute "mkdir -p ~/.rbenv/plugins"
      begin
        execute "git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build"
      rescue SSHKit::Command::Failed
        puts "rbenv/ruby-build plugin already installed, updating..."
        execute "cd ~/.rbenv/plugins/ruby-build && git pull"
      end
      rbenv_ruby = File.read(".ruby-version").strip
      execute "~/.rbenv/bin/rbenv install -s #{fetch(:rbenv_ruby) || rbenv_ruby}"
      execute "~/.rbenv/bin/rbenv global #{fetch(:rbenv_ruby) || rbenv_ruby}"
      execute "~/.rbenv/bin/rbenv local #{fetch(:rbenv_ruby) || rbenv_ruby}"
      # execute "~/.rbenv/bin/rbenv rehash"
      execute "export PATH=\"$HOME/.rbenv/bin:$PATH\" && eval \"$(rbenv init -)\" && ruby -v"

      execute "export PATH=\"$HOME/.rbenv/bin:$PATH\" && eval \"$(rbenv init -)\" && gem install bundler --no-document"
      if fetch(:rbenv_ruby).nil?
        puts "\nPlease uncomment the line `# set :rbenv_ruby, File.read('.ruby-version').strip` to enable capistrano rbenv"
      end

      execute :echo, "'export PATH=\"$HOME/.rbenv/bin:$PATH\"'", ">>", "~/.bashrc"
      execute :echo, "'eval \"$(rbenv init -)\"'", ">>", "~/.bashrc"
    end
  end

  task :validate do
    on release_roles(fetch(:rbenv_roles)) do |host|
      rbenv_ruby = fetch(:rbenv_ruby)
      if rbenv_ruby.nil?
        info "rbenv: rbenv_ruby is not set; ruby version will be defined by the remote hosts via rbenv"
      end

      # don't check the rbenv_ruby_dir if :rbenv_ruby is not set (it will always fail)
      unless rbenv_ruby.nil? || (test "[ -d #{fetch(:rbenv_ruby_dir)} ]") || ARGV.include?("rbenv:install")
        warn "rbenv: #{rbenv_ruby} is not installed or not found in #{fetch(:rbenv_ruby_dir)} on #{host}"
        exit 1
      end
    end
  end

  desc "update ruby"
  task :update do
    on roles(:app), in: :sequence do
      execute "git -C ~/.rbenv/plugins/ruby-build pull"
      execute " RBENV_ROOT=~/.rbenv ~/.rbenv/bin/rbenv install #{fetch(:rbenv_ruby)} -s -k"
      execute " RBENV_ROOT=~/.rbenv ~/.rbenv/bin/rbenv global #{fetch(:rbenv_ruby)}"
      execute " RBENV_ROOT=~/.rbenv RBENV_VERSION=#{fetch(:rbenv_ruby)} ~/.rbenv/bin/rbenv exec gem install -N bundler"
    end
  end
end

namespace :nvm do
  desc "Install node version manager"
  task :install do
    on roles(:setup) do
      execute "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    rescue SSHKit::Command::Failed
      info "nvm already installed."
    end
  end
  after :install, :update

  desc "update node"
  task :update do
    on roles(:app) do
      node_version = File.read(File.expand_path("../.nvmrc", __dir__)).strip
      begin
        execute "nvm install #{node_version}"
        execute "nvm exec #{node_version} npm install -g yarn"
        execute "nvm use #{node_version}"
      rescue SSHKit::Command::Failed
        warn "nvm not installed, run nvm:install first (requires setup role)"
        exit 1
      end
    end
  end
end

namespace :server do
  desc "Initialize"
  task :init do
    on roles(:app), in: :sequence do |app|
      execute "mkdir -p #{shared_path}/config"

      begin
        execute "test -f #{shared_path}/config/secrets.yml && echo Secrets already present"
      rescue SSHKit::Command::Failed
        execute "printf \"#{fetch(:stage)}:\\n  secret_key_base: #{SecureRandom.hex(64)}\\n\" > #{shared_path}/config/secrets.yml"
      end

      begin
        execute "test -f #{shared_path}/config/database.yml && echo Database config already present"
      rescue SSHKit::Command::Failed
        execute "printf \"#{fetch(:stage)}:\\n  username: $DATABASE_USER\\n  password: $PASSWORD\\n  adapter: postgresql\\n  encoding: unicode\\n  database: $DATABASE_NAME\\n  host: localhost\\n  pool: 5\\n  timeout: 5000\\n\" > #{shared_path}/config/database.yml"
      end

      begin
        execute "mkdir -p #{shared_path}/config/initializers"
        execute "test -f #{shared_path}/config/initializers/mailer.rb && echo Mailer config already present"
      rescue SSHKit::Command::Failed
        execute "printf \"Rails.application.config.action_mailer.delivery_method = :sendmail\\nRails.application.config.action_mailer.default_url_options = {host: '#{app.hostname}'}\\n\" > #{shared_path}/config/initializers/mailer.rb"
      end
    end
  end
end

after "server:init", "sidekiq:install"

namespace :sidekiq do
  desc "Sidekiq install"
  task :install do
    on roles(:app), in: :sequence do |app|
      # execute "rm ~/.config/systemd/user/sidekiq.service"
      execute "mkdir -p ~/.config/systemd/user"
      execute "test -f ~/.config/systemd/user/sidekiq.service && echo Sidekiq service config already present"
    rescue SSHKit::Command::Failed
      template = ERB.new(File.read("sidekiq.service.erb"))
      host_tmp_dir = File.join(__dir__, "..", "tmp", app.hostname).to_s
      `mkdir -p #{host_tmp_dir}`
      File.write("#{host_tmp_dir}/sidekiq.service", template.result_with_hash(stage: fetch(:stage), homedir: "/home/#{app.user}"))
      upload! "#{host_tmp_dir}/sidekiq.service", ".config/systemd/user/" # , "~/.config/systemd/user/default.target.want/"
      execute "systemctl --user daemon-reload"
      execute "systemctl --user enable sidekiq"
    end
  end
end

after "sidekiq:install", "sidekiq:start"
