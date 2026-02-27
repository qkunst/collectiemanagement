class AddIssuerToUsers < ActiveRecord::Migration[8.0]
  def temp_issuer(user)
    case user.oauth_provider
    when "azureactivedirectory"
      "azureactivedirectory/#{user.raw_open_id_token["iss"]}"
    when "google_oauth2"
      "google_oauth2/#{user.domain}"
    when "central_login"
      "central_login/#{user.raw_open_id_token["issuer"]}"
    end
  end

  def change
    add_column :users, :issuer, :string
    ::User.where.not(oauth_provider: nil).find_each do |user|
      user.update_column(:issuer, temp_issuer(user))
    end
  end
end
