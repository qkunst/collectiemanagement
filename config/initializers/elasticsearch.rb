# frozen_string_literal: true

if Rails.application.credentials.elasticsearch_host
  Rails.application.config.elasticsearch = {
    hosts: [{
      host: Rails.application.credentials.elasticsearch_host,
      port: Rails.application.credentials.elasticsearch_port,
      user: Rails.application.credentials.elasticsearch_user,
      password: Rails.application.credentials.elasticsearch_password,
      scheme: Rails.application.credentials.elasticsearch_scheme
    }]
  }
end


hosts = begin
  Rails.application.config.elasticsearch[:hosts]
rescue NoMethodError
  [{host: "localhost", port: 9200, protocol: "http"}]
end
Elasticsearch::Model.client = Elasticsearch::Client.new hosts: hosts
