
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # attr_accessor :email, :name, :oauth_subject, :oauth_provider, :qkunst, :facility_manager, :domain

    data = Users::OmniauthCallbackData.new(oauth_subject: omniauth_data["uid"], oauth_provider: "google_oauth2")
    data.email = omniauth_data.info[:email] unless omniauth_data.info[:email_verified] == false
    data.email_confirmed = omniauth_data.info[:email_verified]
    data.name = omniauth_data.info[:name]
    data.qkunst = true if omniauth_data.info[:hd] == "qkunst.nl"
    data.domain = omniauth_data.dig("extra","id_info","hd")  # hd contains organisation's domain in case of GoogleSuite-subscriber

    @user = User.from_omniauth_callback_data(data)

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    if failure_message == "Csrf detected"
      set_flash_message! :alert, "Er ging iets mis bij het inloggen via de externe dienst (CSRF Fout), probeer het nogmaals."
    else
      set_flash_message! :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    end
    redirect_to after_omniauth_failure_path_for(resource_name)
  end

  private

  def omniauth_data
    request.env['omniauth.auth']
  end
end