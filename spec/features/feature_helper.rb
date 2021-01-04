require "rails_helper"

module FeatureHelper
  def login user_or_email_address, password = "password"
    user = user_or_email_address.is_a?(User) ? user_or_email_address : User.find_by_email(user_or_email_address)

    if user.oauth_provider
      oauth_login(user_or_email_address)
    else
      password_login(user_or_email_address, password)
    end
  end

  def password_login user_or_email_address, password = "password"
    email_address = user_or_email_address.is_a?(User) ? user_or_email_address.email : user_or_email_address

    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: email_address)
    fill_in("Wachtwoord", with: password)
    first("#new_user input[type=submit]").click
  end

  def oauth_login user_or_email_address
    user = user_or_email_address.is_a?(User) ? user_or_email_address : User.find_by_email(user_or_email_address)

    oauth_provider = user.oauth_provider&.to_sym || :google_oauth2
    oauth_subject = user.oauth_subject || (rand * 100000).to_i

    # email_address = user_or_email_address.is_a?(User) ? user_or_email_address.email : user_or_email_address
    OmniAuth.config.mock_auth[oauth_provider] = OmniAuth::AuthHash.new({
      provider: oauth_provider,
      uid: oauth_subject,
      sub: oauth_subject,
      iss: "https://accounts.google.com",
      info: {
        email: user.email,
        email_verified: true,
        name: user.name
      }
    })

     #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash expires=true expires_at=1608830286 token="ya29.a0AfH6SMCeBElrapgmaumpoewUTz9R4i3gFEzuroMKopLVXFMYXO4eh1UZYoo0h_n_qDt7tjwmzINxrKKwvEAcu2ZiqJYikuvT9J-gJh47pxLApW1jDZS2tQm70LytWD9UKIBGqTJD-Z3JxjA7yV-e6pUArto82DqLOu6DIqVQPGiZ"> extra=#<OmniAuth::AuthHash id_info=#<OmniAuth::AuthHash at_hash="IpbCYNIcDXYURWqu-UOppg" aud="430435364642-jlqnomplv81cv9ls5vqndj3i63chr0q2.apps.googleusercontent.com" azp="430435364642-jlqnomplv81cv9ls5vqndj3i63chr0q2.apps.googleusercontent.com" email="maarten@qkunst.nl" email_verified=true exp=1608830287 family_name="Brouwers" given_name="Maarten" hd="qkunst.nl" iat=1608826687 iss="https://accounts.google.com" locale="nl" name="Maarten Brouwers" sub="107846751559360042899"> id_token="eyJhbGciOiJSUzI1NiIsImtpZCI6IjZhZGMxMDFjYzc0OThjMDljMDEwZGMzZDUxNzZmYTk3Yzk2MjdlY2IiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI0MzA0MzUzNjQ2NDItamxxbm9tcGx2ODFjdjlsczV2cW5kajNpNjNjaHIwcTIuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI0MzA0MzUzNjQ2NDItamxxbm9tcGx2ODFjdjlsczV2cW5kajNpNjNjaHIwcTIuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDc4NDY3NTE1NTkzNjAwNDI4OTkiLCJoZCI6InFrdW5zdC5ubCIsImVtYWlsIjoibWFhcnRlbkBxa3Vuc3QubmwiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IklwYkNZTkljRFhZVVJXcXUtVU9wcGciLCJuYW1lIjoiTWFhcnRlbiBCcm91d2VycyIsInBpY3R1cmUiOiJodHRwczovL2xoNC5nb29nbGV1c2VyY29udGVudC5jb20vLUgzMDgyeFNUMUt3L0FBQUFBQUFBQUFJL0FBQUFBQUFBQUFBL0FNWnV1Y2xwRS1takJ6YnlSOUFjbU1CcUhtUW5vUVZ6ckEvczk2LWMvcGhvdG8uanBnIiwiZ2l2ZW5fbmFtZSI6Ik1hYXJ0ZW4iLCJmYW1pbHlfbmFtZSI6IkJyb3V3ZXJzIiwibG9jYWxlIjoibmwiLCJpYXQiOjE2MDg4MjY2ODcsImV4cCI6MTYwODgzMDI4N30.h0SVQJYsazsaGnO0UCKKa-QQPBNx5fB7GDgkU5GJt3SvxhLWCwx7jN39AknlKguoz5OnjZCvyPGzIXm1ml8FendPdOWjlkrO3meHdbH_RG0-2JmMXnZvcW-pVcD78_LbkzUtFiWcTQG58uCEocaAKBIPyi96fdRHdNoZS82SpPKzzvjFhjpb08bR73d_c7ZRv0Gs8wDc1wBuU9XJF0d4xVUZi3lZqtVF26EdfLdioVmLKz4Eg7haIVbeeXYaX8KQwv7mnESqGwi2xPQ2fC-m9DMOcxJCLTGZohopxbo2UldqpMp42MM5du-bb6DjD8zGFmUxmq1wKqbtQ2jPSra3SQ" raw_info=#<OmniAuth::AuthHash email="maarten@qkunst.nl" email_verified=true family_name="Brouwers" given_name="Maarten" hd="qkunst.nl" locale="nl" name="Maarten Brouwers" sub="107846751559360042899">> info=#<OmniAuth::AuthHash::InfoHash email="maarten@qkunst.nl" email_verified=true first_name="Maarten" last_name="Brouwers" name="Maarten Brouwers" unverified_email="maarten@qkunst.nl"> provider="google_oauth2" uid="107846751559360042899">

    visit root_path
    first(".large-12.columns .button").click

    click_on("Log in met #{oauth_provider.to_s.titleize}")
  end

  def signout
    click_on "Uitloggen"
  end

  def email_to_role email
    name = email.gsub("@murb.nl", "").gsub("test", "").gsub(/[-_]/, " ").gsub("qkunst", "QKunst").gsub("admin user", "administrator")
    "as #{name}"
  end
end
