# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  let(:valid_google_auth) do
    {
      provider: "google_oauth2",
      uid: "google-uid-123",
      info: {
        email: "testuser@example.com",
        email_verified: true,
        name: "Test User"
      },
      extra: {
        raw_info: {
          hd: "example.com"
        },
        id_info: {
          hd: "example.com"
        }
      }
    }
  end

  let(:valid_central_login_auth) do
    {
      provider: "central_login",
      uid: "cl-uid-456",
      info: {
        email: "cluser@example.com",
        email_verified: true,
        name: "Central Login User"
      },
      credentials: {
        expires_at: Time.now.utc + 3600,
        refresh_token: "refresh-token-abc",
        token: "access-token-xyz"
      },
      extra: {
        raw_info: {
          issuer: "cl-issuer",
          resources: ["resource1"],
          roles: ["role1"]
        }
      }
    }
  end

  let(:valid_azure_auth) do
    {
      provider: "azureactivedirectory",
      uid: "azure-uid-789",
      info: {
        email: "azureuser@example.com",
        name: "Azure User"
      },
      extra: {
        raw_info: {
          id_token_claims: {
            iss: "azure-iss",
            groups: ["group-1", "group-2"],
            wids: ["wid-1", "wid-2"]
          }
        }
      }
    }
  end

  describe "POST /users/auth/google_oauth2/callback" do
    context "with valid auth data" do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(valid_google_auth)
      end

      after do
        OmniAuth.config.mock_auth[:google_oauth2] = nil
      end

      it "creates and signs in the user" do
        expect do
          post user_google_oauth2_omniauth_callback_path
        end.to change(User, :count).by(1)

        expect(response).to be_redirect
        expect(controller.current_user).to be_present
      end

      it "sets the correct user attributes" do
        post user_google_oauth2_omniauth_callback_path

        user = User.last
        expect(user.oauth_subject).to eq("google-uid-123")
        expect(user.oauth_provider).to eq("google_oauth2")
        expect(user.email).to eq("testuser@example.com")
        expect(user.confirmed?).to be true
      end

      context "with unverified email" do
        let(:valid_google_auth) do
          super().tap { |h| h[:info][:email_verified] = false }
        end

        it "sets the email but does not confirm the user" do
          post user_google_oauth2_omniauth_callback_path

          user = User.last
          expect(user.email).to eq("testuser@example.com")
          expect(user.confirmed?).to be false
        end
      end

      context "with qkunst domain" do
        let(:valid_google_auth) do
          super().tap do |h|
            h[:extra][:raw_info][:hd] = "qkunst.nl"
            h[:extra][:id_info][:hd] = "qkunst.nl"
          end
        end

        it "marks the user as qkunst" do
          post user_google_oauth2_omniauth_callback_path

          user = User.last
          expect(user.qkunst).to be true
        end
      end

      context "with non-qkunst domain" do
        it "does not mark the user as qkunst" do
          post user_google_oauth2_omniauth_callback_path

          user = User.last
          expect(user.qkunst).to be_falsey
        end
      end
    end

    context "with invalid auth data (missing email)" do
      let(:invalid_auth) do
        valid_google_auth.tap { |h| h[:info].delete(:email) }
      end

      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(invalid_auth)
      end

      after do
        OmniAuth.config.mock_auth[:google_oauth2] = nil
      end

      it "redirects to registration with an alert" do
        post user_google_oauth2_omniauth_callback_path

        expect(response).to redirect_to(new_user_registration_url)
        expect(flash[:alert]).to be_present
      end

      it "stores omniauth data in session" do
        post user_google_oauth2_omniauth_callback_path

        expect(controller.session["devise.omniauth_data"]).to be_present
      end
    end
  end

  describe "POST /users/auth/central_login/callback" do
    context "with valid auth data" do
      before do
        OmniAuth.config.mock_auth[:central_login] = OmniAuth::AuthHash.new(valid_central_login_auth)
      end

      after do
        OmniAuth.config.mock_auth[:central_login] = nil
      end

      it "creates and signs in the user" do
        expect do
          post user_central_login_omniauth_callback_path
        end.to change(User, :count).by(1)

        expect(response).to be_redirect
        expect(controller.current_user).to be_present
      end

      it "sets the correct user attributes" do
        post user_central_login_omniauth_callback_path

        user = User.last
        expect(user.oauth_subject).to eq("cl-uid-456")
        expect(user.oauth_provider).to eq("central_login")
        expect(user.email).to eq("cluser@example.com")
        expect(user.qkunst).to be_falsey
      end

      it "stores oauth tokens" do
        post user_central_login_omniauth_callback_path

        user = User.last
        expect(user.oauth_access_token).to eq("access-token-xyz")
        expect(user.oauth_refresh_token).to eq("refresh-token-abc")
        expect(user.oauth_expires_at).to be_present
      end
    end

    context "with invalid auth data" do
      let(:invalid_auth) do
        valid_central_login_auth.tap { |h| h[:info].delete(:email) }
      end

      before do
        OmniAuth.config.mock_auth[:central_login] = OmniAuth::AuthHash.new(invalid_auth)
      end

      after do
        OmniAuth.config.mock_auth[:central_login] = nil
      end

      it "redirects to registration with an alert" do
        post user_central_login_omniauth_callback_path

        expect(response).to redirect_to(new_user_registration_url)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "POST /users/auth/azureactivedirectory/callback" do
    context "with valid auth data" do
      before do
        OmniAuth.config.mock_auth[:azureactivedirectory] = OmniAuth::AuthHash.new(valid_azure_auth)
      end

      after do
        OmniAuth.config.mock_auth[:azureactivedirectory] = nil
      end

      it "creates and signs in the user" do
        expect do
          post user_azureactivedirectory_omniauth_callback_path
        end.to change(User, :count).by(1)

        expect(response).to be_redirect
        expect(controller.current_user).to be_present
      end

      it "sets the correct user attributes" do
        post user_azureactivedirectory_omniauth_callback_path

        user = User.last
        expect(user.oauth_subject).to eq("azure-uid-789")
        expect(user.oauth_provider).to eq("azureactivedirectory")
        expect(user.email).to eq("azureuser@example.com")
        expect(user.qkunst).to be_falsey
        expect(user.confirmed?).to be true
      end

      it "stores groups and roles as strings" do
        post user_azureactivedirectory_omniauth_callback_path

        user = User.last
        expect(user.raw_open_id_token).to be_present
      end
    end

    context "with invalid auth data" do
      let(:invalid_auth) do
        valid_azure_auth.tap { |h| h[:info].delete(:email) }
      end

      before do
        OmniAuth.config.mock_auth[:azureactivedirectory] = OmniAuth::AuthHash.new(invalid_auth)
      end

      after do
        OmniAuth.config.mock_auth[:azureactivedirectory] = nil
      end

      it "redirects to registration with an alert" do
        post user_azureactivedirectory_omniauth_callback_path

        expect(response).to redirect_to(new_user_registration_url)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "user already exists with matching oauth credentials" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(valid_google_auth)
      # Create user directly via from_omniauth_callback_data to ensure proper persistence
      User.from_omniauth_callback_data(
        Users::OmniauthCallbackData.new(
          email: "testuser@example.com",
          oauth_provider: "google_oauth2",
          oauth_subject: "google-uid-123",
          email_confirmed: true
        )
      )
    end

    after do
      OmniAuth.config.mock_auth[:google_oauth2] = nil
    end

    it "signs in the existing user without creating a duplicate" do
      initial_count = User.count
      expect do
        post user_google_oauth2_omniauth_callback_path
      end.not_to change(User, :count).from(initial_count)

      expect(response).to be_redirect
      expect(controller.current_user).not_to be_nil
      expect(controller.current_user.oauth_subject).to eq("google-uid-123")
    end
  end
end
