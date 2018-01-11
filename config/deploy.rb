# config valid only for current version of Capistrano
# lock '3.5.0'

set :application, 'collectiebeheer'
set :remote_user, :qkunst

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
set :linked_files, %w{config/secrets.yml config/database.yml config/appsignal.yml}

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
set :rbenv_ruby, '2.5.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :local_user, `whoami`.strip
set :public_key, File.open("/Users/#{fetch(:local_user)}/.ssh/id_rsa.pub").read
set :database_name, "#{fetch(:application).gsub(".","")}-#{fetch(:stage)}"
set :database_user, fetch(:database_name)
set :application_production_domain_name, fetch(:application)


set :email, "maarten@murb.nl"

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

namespace :server do
  desc 'Initialize'
  task :init do
    puts "ssh root@#{fetch(:application)}"
    puts "passwd #set it to something extremely long"
    puts "apt-get update"
    puts "apt-get upgrade"
    puts "apt-get install nginx fail2ban unattended-upgrades logwatch git-core build-essential libssl-dev libcurl4-openssl-dev libreadline-dev nodejs sqlite3 libsqlite3-dev dirmngr gnupg apt-transport-https ca-certificates postgresql postgresql-client libpq-dev vim zlib1g-dev"
    puts "useradd #{fetch(:local_user)}"
    puts "mkdir /home/#{fetch(:local_user)}"
    puts "mkdir /home/#{fetch(:local_user)}/.ssh"
    puts "chmod 700 /home/#{fetch(:local_user)}/.ssh"
    puts "echo \"#{fetch(:public_key)}\" > /home/#{fetch(:local_user)}/.ssh/authorized_keys"
    puts "chmod 400 /home/#{fetch(:local_user)}/.ssh/authorized_keys"
    puts "chown #{fetch(:local_user)}:#{fetch(:local_user)} /home/#{fetch(:local_user)} -R"

    puts "useradd #{fetch(:remote_user)}"
    puts "mkdir /home/#{fetch(:remote_user)}"
    puts "mkdir /home/#{fetch(:remote_user)}/.ssh"
    puts "chmod 700 /home/#{fetch(:remote_user)}/.ssh"
    puts "cp /home/#{fetch(:local_user)}/.ssh/id_rsa.pub /home/#{fetch(:remote_user)}/.ssh/authorized_keys"
    puts "chmod 400 /home/#{fetch(:remote_user)}/.ssh/authorized_keys"
    puts "chown #{fetch(:remote_user)}:#{fetch(:remote_user)} /home/#{fetch(:remote_user)} -R"

    puts "passwd #{fetch(:local_user)}"
    puts "visudo"
    puts ""
    puts "# Comment all existing user/group grant lines and add:"
    puts "    root    ALL=(ALL) ALL"
    puts "    #{fetch(:local_user)}  ALL=(ALL) ALL"
    puts ""
    puts "vim /etc/ssh/sshd_config"
    puts ""
    puts "# Make sure that you can ssh witht password and sudo and then add these lines:"
    puts "    PermitRootLogin no"
    puts "    PasswordAuthentication no"
    puts ""
    puts "service ssh restart"
    puts "ufw allow 22"
    puts "ufw allow 80"
    puts "ufw allow 443"
    puts "ufw enable"
    puts "vim /etc/apt/apt.conf.d/10periodic"
    puts ""
    puts "# make it look like this"
    puts ""
    puts '    APT::Periodic::Update-Package-Lists "1";'
    puts '    APT::Periodic::Download-Upgradeable-Packages "1";'
    puts '    APT::Periodic::AutocleanInterval "7";'
    puts '    APT::Periodic::Unattended-Upgrade "1";'
    puts ""
    puts "vim /etc/apt/apt.conf.d/50unattended-upgrades"
    puts "# make it look like this"
    puts "    Unattended-Upgrade::Allowed-Origins {"
    puts "      \"Ubuntu lucid-security\";"
    puts "      //\"Ubuntu lucid-updates\";"
    puts "    };"
    puts ""
    puts "vim /etc/cron.daily/00logwatch"
    puts "# add this line"
    puts ""
    puts "    /usr/sbin/logwatch --output mail --mailto #{fetch(:email)} --detail high"
    puts ""
    puts "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7"
    puts "sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger stretch main > /etc/apt/sources.list.d/passenger.list'"
    puts "apt-get update"
    puts "apt-get install -y libnginx-mod-http-passenger"
    puts "if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi"
    puts "cat /etc/nginx/conf.d/mod-http-passenger.conf"
    puts "# set settings:"
    puts "    passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;"
    puts "    passenger_ruby /usr/bin/passenger_free_ruby;"
    puts "service nginx restart"
    puts "/usr/bin/passenger-config validate-install"
    puts "su #{fetch(:remote_user)}"
    puts "git clone https://github.com/sstephenson/rbenv.git ~/.rbenv"
    puts "git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
    puts "git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash"
    puts "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.bashrc"
    puts "echo 'eval \"$(rbenv init -)\"' >> ~/.bashrc"
    puts "exit"
    puts "Install postfix: Select internet site and set the FQDN accordingly (your site’s domainname)."
    puts "apt-get install postfix"
    puts "You can test it by running `mail test@murb.nl`"
    puts "su postgres"
    puts "psql"
    require 'securerandom'
    random_db_pw = SecureRandom.base64(24).gsub(/['"]/,"[");
    puts "CREATE USER \"#{fetch(:database_user)}\" WITH PASSWORD '#{random_db_pw}';"
    puts "CREATE DATABASE \"#{fetch(:database_name)}\" OWNER \"#{fetch(:database_user)}\";"
    puts "\\q"
    puts "exit"
    puts "su #{fetch(:remote_user)}"
    puts "mkdir ~/public"
    puts "mkdir ~/public/#{fetch(:application)}"
    puts "mkdir #{shared_path}"
    puts "mkdir #{shared_path}/config"
    puts "printf \"#{fetch(:stage)}:\\n  username: #{fetch(:database_user)}\\n  password: #{random_db_pw}\\n  adapter: postgresql\\n  encoding: unicode\\n  database: #{fetch(:database_name)}\\n  host: localhost\\n  pool: 5\\n  timeout: 5000\\n\" > #{shared_path}/config/database.yml"
    puts "printf \"#{fetch(:stage)}:\\n  secret_key_base: #{SecureRandom.hex(64)}\\n\" > #{shared_path}/config/secrets.yml"
  end

  desc 'Install ruby'
  task :install_ruby do
    on roles(:app), in: :sequence do
      execute :rbenv, " install #{fetch(:rbenv_ruby)} -k"
      execute :rbenv, " global #{fetch(:rbenv_ruby)}"
      execute :gem, " install bundler"
    end
  end

  desc 'App specific instructions for nginx+passenger over http2'
  task :server_config do
puts "# sudo vim /etc/nginx/sites-available/#{fetch(:application)}"
puts "server {
  listen 80;
  server_name #{fetch(:application)} www.#{fetch(:application)};
  client_max_body_size 50M;

  if ($http_host = www.#{fetch(:application)}) {
      rewrite ^/(.*) http://#{fetch(:application)}/$1 permanent;
  }

  root #{fetch(:deploy_to)}/current/public;
  passenger_ruby /home/#{fetch(:remote_user)}/.rbenv/shims/ruby;
  passenger_app_env #{fetch(:stage)};
  passenger_enabled on;
}"
puts "\n\n# sudo ln -s /etc/nginx/sites-available/#{fetch(:application)} /etc/nginx/sites-enabled"
puts "\n\n# sudo service nginx restart"
puts "\n\n# sudo certbot certonly --webroot -w #{fetch(:deploy_to)}/current/public -d #{fetch(:application)} -d www.#{fetch(:application)}\n\n"
puts "server {
  listen 443 ssl http2;
  server_name #{fetch(:application)} www.#{fetch(:application)};
  client_max_body_size 50M;
  ssl on;
  ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:RSA+3DES:!ADH:!AECDH:!MD5;
  ssl_prefer_server_ciphers on;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_certificate /etc/letsencrypt/live/#{fetch(:application)}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/#{fetch(:application)}/privkey.pem;

  if ($http_host = www.#{fetch(:application)}) {
      rewrite ^/(.*) https://#{fetch(:application)}/$1 permanent;
  }

  root #{fetch(:deploy_to)}/current/public;
  passenger_ruby /home/#{fetch(:remote_user)}/.rbenv/shims/ruby;
  passenger_app_env #{fetch(:stage)};
  passenger_enabled on;
}
server {
  listen 80;
  server_name #{fetch(:application)} www.#{fetch(:application)};
  rewrite ^/(.*) https://#{fetch(:application)}/$1 permanent;
}"
  end
end

# before :deploy, "delayed_job:stop" # Niet aanzetten in het begin
after :deploy, "delayed_job:start"