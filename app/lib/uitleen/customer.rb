class Uitleen::Customer
  include ActiveModel::Model

  attr_accessor :uri, :name

  def to_param
    uri
  end

  def id
    uri
  end

  def to_select_value
    uri
  end

  class << self
    def authorization_header(current_user: nil)
      if current_user
        {"Authorization" => "Bearer #{current_user.refresh!.oauth_id_token}"}
      end
    end

    def find(id, current_user:)
      current_user.refresh!(force: false)

      if id.start_with?("http")
        id = id.split("/").last
      end

      response = Faraday.new(URI.join(Uitleen.site, "api/v1/customers/#{id}.json").to_s, headers: authorization_header(current_user: current_user)).get

      if response.status == 200
        json = JSON.parse(response.body)["data"]

        [json].flatten.map { |c| Uitleen::Customer.new(c) }.first
      end
    rescue Faraday::ConnectionFailed
      nil
    end

    def all(current_user:, recursive: false)
      response = Faraday.new(URI.join(Uitleen.site, "api/v1/customers").to_s, headers: authorization_header(current_user: current_user)).get

      if response.status == 200
        json = JSON.parse(response.body)["data"]
        json.map { |c| Uitleen::Customer.new(c) }
      elsif response.status == 401 && recursive == false
        current_user.refresh!(force: true)
        all(current_user: current_user, recursive: true)
      else
        current_user.refresh!(force: true)
        []
      end
    rescue JSON::ParserError => e
      if e.message.match?("JWT::ExpiredSignature")
        current_user.refresh!(force: true)
      end
    rescue Faraday::ConnectionFailed
      []
    end
  end
end
