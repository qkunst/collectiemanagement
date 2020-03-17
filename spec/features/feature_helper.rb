require "rails_helper"

module FeatureHelper
  def login user_or_email_address, password = "password"
    email_address = user_or_email_address.is_a?(User) ? user_or_email_address.email : user_or_email_address

    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: email_address)
    fill_in("Wachtwoord", with: password)
    first("#new_user input[type=submit]").click
  end

  def signout
    click_on "Uitloggen"
  end

  def email_to_role email
    name = ""
    name = email.gsub("@murb.nl", "").gsub("test", "").gsub(/[-_]/, " ").gsub("qkunst", "QKunst").gsub("admin user", "administrator")
    "as #{name}"
  end
end
