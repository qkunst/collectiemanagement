# frozen_string_literal: true

require "rails_helper"

describe "Initializers" do
  describe "Exception Monitoring (implements QSECIMP0021)" do
    it "does not configure exeption monitoring in development" do
      expect(Rails.application.config.middleware).not_to include ExceptionNotification::Rack

      expect(Rails.env).to receive(:production?).and_return(false)
      expect(Rails.application.config.middleware).not_to receive(:use)
      load Rails.root.join("config/initializers/exception_monitoring.rb")
    end

    it "does configure exeption monitoring in production" do
      expect(Rails.env).to receive(:production?).and_return(true)
      expect(Rails.application.config.middleware).to receive(:use)
      load Rails.root.join("config/initializers/exception_monitoring.rb")
    end
  end

  describe "ElasticSearch" do
    it "configures elastic search" do
      Elasticsearch::Model.client = nil
      expect(Elasticsearch::Model.client.transport.transport.hosts).to eq([{host: "localhost", port: 9200, protocol: "http"}])
      expect(Rails.application.credentials).to receive(:elasticsearch_host).at_least(1).times.and_return("127.0.0.1")

      load Rails.root.join("config/initializers/elasticsearch.rb")
      expect(Elasticsearch::Model.client.transport.transport.hosts).to eq([{host: "127.0.0.1", password: nil, port: 9200, protocol: "http", scheme: nil, user: nil}])
    end
  end

  describe "Devise" do
    it "has support for time based unlocking [QSECIMP0028]" do
      expect(User.unlock_strategy_enabled?(:time)).to be_truthy
    end

    it "has support for email based unlocking [QSECIMP0028]" do
      expect(User.unlock_strategy_enabled?(:email)).to be_truthy
    end

    it "allows for a maximum of 10 requests [QSECIMP0028]" do
      expect(Devise.maximum_attempts).to be <= 10
    end

    it "automatically signs out users after 4 hours [QSECIMP0014]" do
      expect(Devise.timeout_in).to be <= 4.hours
    end

    it "enforces minimum password complexity [QSECIMP0015]" do
      expect(Devise.password_length.min).to be >= 12
    end
  end
end
