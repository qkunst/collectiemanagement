# frozen_string_literal: true

require "highline"
set :rbenv_ruby, nil

PASSWORD_HANDLER = SSHKit::MappingInteractionHandler.new(lambda { |data|
  case data
    when "(current) UNIX password: ", "(huidig) UNIX-wachtwoord:"
      "#{QA.sudo_pass}\n"
    when "sudo: no tty present and no askpass program specified\n"
      "\n"
    when "sudo: geen terminal aanwezig en geen wachtwoordvraag(askpass)-programma opgegeven\n"
      "\n"
    when "geen terminal aanwezig en geen wachtwoordvraag(askpass)-programma opgegeven"
      "\n"
    when ": "
      ""
    when "\n"
      ""
    when /(\[sudo\]\s)(([Pp]assword)|([Ww]achtwoord)).*:/
      "#{QA.sudo_pass}\n"
    when /root(.*)\'s password\:/
      "#{QA.root_pass}\n"
    when "sudo"
      "\n"
    when " [J/n] "
      "J\n"
    else
      ""
    # raise "Unexpected stderr #{stderr}"
  end
})

class QA
  class << self
    def sudo_pass
      @@sudo_pass ||= HighLine.new.ask("Enter your (SUDO) password: ") { |q| q.echo = "*" }
    end
  end
end

def sudo_exec command
  execute :sudo, "-S DEBIAN_FRONTEND=noninteractive", command, interaction_handler: PASSWORD_HANDLER
end

namespace :server do
  desc "prepare sidekiq script"
  task :sidekiq_setup do
    on roles(:app) do |host|
      service_erb_file_path = File.join(__dir__, "fixtures", "sidekiq.service.erb")

      sidekiq_start_cmd = "#{fetch(:rbenv_prefix)} bundle exec sidekiq -e #{fetch(:stage)}"
      sudo_user = "murb"
      remote_user = sudo_user

      service_erb = ERB.new File.read(service_erb_file_path)
      service_result = service_erb.result(binding)

      tmp_filename = "sidekiq.service.erb.tmp"
      tmp_filepath = File.join(__dir__, "fixtures", tmp_filename)
      tmp_file = File.open(tmp_filepath, "w")
      tmp_file.write(service_result.to_s.gsub("~/", "/home/#{fetch(:sudo_user)}"))
      tmp_file.close
      upload!(tmp_filepath, tmp_filename.to_s)
      sudo_exec("cp ~/sidekiq.service.erb.tmp /lib/systemd/system/sidekiq.service")
      sudo_exec("systemctl enable sidekiq")
    end
  end
end
