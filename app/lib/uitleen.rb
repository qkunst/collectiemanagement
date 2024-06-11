class Uitleen
  class << self
    def site
      Rails.application.credentials.uitleen_site
    end

    def configured?
      site.present?
    end
  end
end
