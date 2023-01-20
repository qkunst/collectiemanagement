class Uitleen
  class << self
    def site
      Rails.application.secrets.uitleen_site
    end

    def configured?
      site.present?
    end
  end
end
