# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::ApiController, type: :controller do
  # -----------------------------------------------------------------------
  # Fixtures and shared test data
  # -----------------------------------------------------------------------
  let(:admin_user) { users(:admin) }
  let(:api_key_user) { users(:user_with_api_key) }
  let(:regular_user) { users(:user1) }

  let(:remote_ip) { "127.0.0.1" }
  let(:request_url) { "/api/v1/time_spans" }
  let(:request_body) { nil }

  # Bearer token fixtures
  let(:issuer) { "https://auth.example.com" }
  let(:regular_user_token_payload) do
    {
      "sub" => "user-123",
      "email" => "bearer-user@example.com",
      "email_verified" => true,
      "name" => "Bearer User",
      "iss" => issuer,
      "resources" => [],
      "roles" => []
    }
  end
  let(:app_user_token_payload) do
    {
      "sub" => "app-my_app",
      "name" => "My App",
      "iss" => issuer,
      "resources" => [],
      "roles" => []
    }
  end

  let(:mocked_strategy) { instance_double(OmniAuth::Strategies::CentralLogin) }

  # -----------------------------------------------------------------------
  # Helper: compute HMAC token for a given user, url, body
  # -----------------------------------------------------------------------
  def hmac_token_for(user:, url:, body: nil)
    data = "#{remote_ip}#{url}#{body}"
    digest = OpenSSL::Digest.new("sha512")
    OpenSSL::HMAC.hexdigest(digest, user.api_key, data)
  end

  # -----------------------------------------------------------------------
  # #current_api_user — positive / happy-path auth (no render needed)
  # -----------------------------------------------------------------------
  describe "#current_api_user" do
    # ------------------------------------------------------------------
    # 1. Cached @user
    # ------------------------------------------------------------------
    context "when @user is already set" do
      it "returns the cached user" do
        allow(controller).to receive(:current_user).and_return(nil)
        allow(controller).to receive(:request).and_return(
          instance_double(ActionDispatch::Request,
            headers: {},
            remote_ip: remote_ip,
            url: request_url,
            body: nil)
        )
        controller.instance_variable_set(:@user, admin_user)

        expect(controller.current_api_user).to eq(admin_user)
      end
    end

    # ------------------------------------------------------------------
    # 2. Session-based authentication (current_user from Devise)
    # ------------------------------------------------------------------
    context "when current_user is present" do
      it "returns the current Devise user" do
        allow(controller).to receive(:current_user).and_return(admin_user)

        expect(controller.current_api_user).to eq(admin_user)
      end
    end

    # ------------------------------------------------------------------
    # 3. HMAC authentication via X-user-id / X-hmac-token headers
    # ------------------------------------------------------------------
    context "with HMAC header authentication" do
      let(:user_id_header) { api_key_user.id.to_s }

      context "with valid token" do
        let(:token) { hmac_token_for(user: api_key_user, url: request_url, body: request_body) }

        it "returns the user identified by X-user-id" do
          request.headers["X-user-id"] = user_id_header
          request.headers["X-hmac-token"] = token
          request.instance_variable_set(:@remote_ip, remote_ip)

          allow(request).to receive(:url).and_return(request_url)
          allow(request).to receive(:body).and_return(nil)
          allow(controller).to receive(:current_user).and_return(nil)

          expect(controller.current_api_user).to eq(api_key_user)
        end
      end
    end

    # ------------------------------------------------------------------
    # 4. Bearer token authentication via Authorization header
    # ------------------------------------------------------------------
    context "with Bearer token authentication" do
      let(:bearer_token) { "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test" }

      before do
        request.headers["Authorization"] = "Bearer #{bearer_token}"
        request.instance_variable_set(:@remote_ip, remote_ip)

        allow(request).to receive(:url).and_return(request_url)
        allow(request).to receive(:body).and_return(nil)
        allow(controller).to receive(:current_user).and_return(nil)
        allow(controller).to receive(:central_login_oauth_strategy).and_return(mocked_strategy)
      end

      # ----------------------------------------------------------------
      # 4a. Regular (human) user
      # ----------------------------------------------------------------
      context "for a regular user" do
        let(:created_user) { User.new }

        before do
          allow(mocked_strategy).to receive(:validate_id_token).with(bearer_token).and_return(regular_user_token_payload)
          allow(User).to receive(:from_omniauth_callback_data).and_return(created_user)
        end

        it "validates the id_token via central_login_oauth_strategy" do
          controller.current_api_user
          expect(mocked_strategy).to have_received(:validate_id_token).with(bearer_token)
        end

        it "creates omniauth callback data with user fields" do
          callback_data = nil
          allow(User).to receive(:from_omniauth_callback_data) { |data|
            callback_data = data
            created_user
          }

          controller.current_api_user

          expect(callback_data).to be_a(Users::OmniauthCallbackData)
          expect(callback_data.email).to eq(regular_user_token_payload["email"])
          expect(callback_data.email_confirmed).to eq(regular_user_token_payload["email_verified"])
          expect(callback_data.name).to eq(regular_user_token_payload["name"])
          expect(callback_data.oauth_subject).to eq(regular_user_token_payload["sub"])
          expect(callback_data.oauth_provider).to eq(:central_login)
          expect(callback_data.qkunst).to eq(false)
          expect(callback_data.app).to eq(false)
        end

        it "sets the issuer on callback data" do
          callback_data = nil
          allow(User).to receive(:from_omniauth_callback_data) { |data|
            callback_data = data
            created_user
          }

          controller.current_api_user

          expect(callback_data.issuer).to eq("central_login/#{issuer}")
        end

        it "returns the user from from_omniauth_callback_data" do
          expect(controller.current_api_user).to eq(created_user)
        end

        it "uses 'sub' as oauth_subject when 'uid' is missing" do
          callback_data = nil
          allow(User).to receive(:from_omniauth_callback_data) { |data|
            callback_data = data
            created_user
          }

          controller.current_api_user

          expect(callback_data.oauth_subject).to eq(regular_user_token_payload["sub"])
        end

        context "when the token has 'uid' instead of 'sub'" do
          let(:regular_user_token_payload) do
            {
              "uid" => "uid-456",
              "sub" => "sub-789",
              "email" => "uid-user@example.com",
              "email_verified" => true,
              "name" => "UID User",
              "iss" => issuer,
              "resources" => [],
              "roles" => []
            }
          end

          it "uses 'uid' as oauth_subject" do
            callback_data = nil
            allow(User).to receive(:from_omniauth_callback_data) { |data|
              callback_data = data
              created_user
            }

            controller.current_api_user

            expect(callback_data.oauth_subject).to eq("uid-456")
          end
        end
      end

      # ----------------------------------------------------------------
      # 4b. App user (sub starts with "app-")
      # ----------------------------------------------------------------
      context "for an app user" do
        let(:created_user) { User.new }
        let(:issuer_hostname) { issuer.split("//").last.delete("/") }

        before do
          allow(mocked_strategy).to receive(:validate_id_token).with(bearer_token).and_return(app_user_token_payload)
          allow(User).to receive(:from_omniauth_callback_data).and_return(created_user)
        end

        it "validates the id_token via central_login_oauth_strategy" do
          controller.current_api_user
          expect(mocked_strategy).to have_received(:validate_id_token).with(bearer_token)
        end

        it "creates omniauth callback data with app fields" do
          callback_data = nil
          allow(User).to receive(:from_omniauth_callback_data) { |data|
            callback_data = data
            created_user
          }

          controller.current_api_user

          expect(callback_data).to be_a(Users::OmniauthCallbackData)
          expect(callback_data.app).to eq(true)
          expect(callback_data.email).to eq("app-connection-app-my_app@#{issuer_hostname}")
          expect(callback_data.email_confirmed).to eq("app-connection-app-my_app@#{issuer_hostname}")
          expect(callback_data.name).to eq("My App")
          expect(callback_data.oauth_subject).to eq(app_user_token_payload["sub"])
          expect(callback_data.oauth_provider).to eq(:central_login)
          expect(callback_data.qkunst).to eq(false)
        end

        it "sets the issuer with app/ prefix for app users" do
          callback_data = nil
          allow(User).to receive(:from_omniauth_callback_data) { |data|
            callback_data = data
            created_user
          }

          controller.current_api_user

          expect(callback_data.issuer).to eq("central_login/app/#{issuer}")
        end

        it "returns the user from from_omniauth_callback_data" do
          expect(controller.current_api_user).to eq(created_user)
        end

        context "when the app has no 'name' field" do
          let(:app_user_token_payload) do
            {
              "sub" => "app-my_app",
              "iss" => issuer,
              "resources" => [],
              "roles" => []
            }
          end

          it "derives the name from sub and issuer" do
            callback_data = nil
            allow(User).to receive(:from_omniauth_callback_data) { |data|
              callback_data = data
              created_user
            }

            controller.current_api_user

            expect(callback_data.name).to eq("my app @ #{issuer_hostname}")
          end
        end

        context "when app sub contains underscores" do
          let(:app_user_token_payload) do
            {
              "sub" => "app-my_service_name",
              "iss" => issuer,
              "resources" => [],
              "roles" => []
            }
          end

          it "replaces underscores with spaces in the derived name" do
            callback_data = nil
            allow(User).to receive(:from_omniauth_callback_data) { |data|
              callback_data = data
              created_user
            }

            controller.current_api_user

            expect(callback_data.name).to include("my service name")
          end
        end
      end

      # ----------------------------------------------------------------
      # 4c. Sets resources and roles from token payload
      # ----------------------------------------------------------------
      context "when token includes resources and roles" do
        let(:created_user) { User.new }
        let(:resources) { [{"api" => "https://api.example.com"}] }
        let(:roles) { ["admin"] }
        let(:regular_user_token_payload) do
          {
            "sub" => "user-with-resources",
            "email" => "resource-user@example.com",
            "email_verified" => true,
            "name" => "Resource User",
            "iss" => issuer,
            "resources" => resources,
            "roles" => roles
          }
        end

        before do
          allow(mocked_strategy).to receive(:validate_id_token).with(bearer_token).and_return(regular_user_token_payload)
          allow(User).to receive(:from_omniauth_callback_data).and_return(created_user)
        end

        it "passes resources and roles to the callback data" do
          callback_data = nil
          allow(User).to receive(:from_omniauth_callback_data) { |data|
            callback_data = data
            created_user
          }

          controller.current_api_user

          expect(callback_data.resources).to eq(resources)
          expect(callback_data.roles).to eq(roles)
        end
      end
    end
  end

  # -----------------------------------------------------------------------
  # #api_authorize!
  # -----------------------------------------------------------------------
  describe "#api_authorize!" do
    let(:ability) { Ability.new(admin_user) }

    before do
      allow(controller).to receive(:current_api_user).and_return(admin_user)
      allow(Ability).to receive(:new).with(admin_user).and_return(ability)
    end

    context "when the user is authorized" do
      before do
        allow(ability).to receive(:authorize!).and_return(true)
      end

      it "delegates to Ability#authorize!" do
        controller.api_authorize! :read, Collection
        expect(ability).to have_received(:authorize!).with(:read, Collection)
      end
    end

    context "when the user is not authorized" do
      before do
        allow(ability).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end

      it "raises CanCan::AccessDenied" do
        expect { controller.api_authorize! :manage, Collection }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  # -----------------------------------------------------------------------
  # #authenticate_activated_user!
  # -----------------------------------------------------------------------
  describe "#authenticate_activated_user!" do
    context "when current_api_user returns a user" do
      before do
        allow(controller).to receive(:current_api_user).and_return(admin_user)
      end

      it "returns the user" do
        expect(controller.authenticate_activated_user!).to eq(admin_user)
      end
    end

    context "when current_api_user returns nil/false" do
      before do
        allow(controller).to receive(:current_api_user).and_return(false)
      end

      it "returns falsey value" do
        expect(controller.authenticate_activated_user!).to be_falsey
      end
    end
  end
end

# ---------------------------------------------------------------------------
# Request-level specs for methods that call render (not_authorized, etc.)
# These exercise the actual HTTP response path through child controllers.
# ---------------------------------------------------------------------------
RSpec.describe "Api::V1 Authentication (request-level)", type: :request do
  let(:admin_user) { users(:admin) }
  let(:api_key_user) { users(:user_with_api_key) }
  let(:regular_user) { users(:user1) }

  # Bearer token fixtures
  let(:issuer) { "https://auth.example.com" }
  let(:regular_user_token_payload) do
    {
      "sub" => "user-123",
      "email" => "bearer-user@example.com",
      "email_verified" => true,
      "name" => "Bearer User",
      "iss" => issuer,
      "resources" => [],
      "roles" => []
    }
  end
  let(:app_user_token_payload) do
    {
      "sub" => "app-my_app",
      "name" => "My App",
      "iss" => issuer,
      "resources" => [],
      "roles" => []
    }
  end

  let(:mocked_strategy) { instance_double(OmniAuth::Strategies::CentralLogin) }

  # Use any endpoint under Api::V1 that calls authenticate_activated_user!
  let(:endpoint) { api_v1_time_spans_path(format: :json) }

  # ------------------------------------------------------------------
  # HMAC authentication — failure cases
  # ------------------------------------------------------------------
  describe "HMAC authentication failure cases" do
    context "with missing api_key on the user" do
      before do
        allow(regular_user).to receive(:api_key).and_return(nil)
      end

      it "returns 401" do
        get endpoint, headers: {"X-user-id" => regular_user.id.to_s}
        expect(response).to have_http_status(401)
      end
    end

    context "with invalid token" do
      it "returns 401" do
        get endpoint, headers: {"X-user-id" => api_key_user.id.to_s, "X-hmac-token" => "invalid-token"}
        expect(response).to have_http_status(401)
      end
    end

    context "with non-existent user id" do
      it "returns 401" do
        get endpoint, headers: {"X-user-id" => "-1"}
        expect(response).to have_http_status(401)
      end
    end
  end

  # ------------------------------------------------------------------
  # Bearer token — failure cases
  # ------------------------------------------------------------------
  describe "Bearer token authentication failure cases" do
    context "when the JWT token has expired" do
      let(:bearer_token) { "expired-token" }

      before do
        allow_any_instance_of(Api::V1::ApiController).to receive(:central_login_oauth_strategy).and_return(mocked_strategy)
        allow(mocked_strategy).to receive(:validate_id_token).with(bearer_token).and_raise(JWT::ExpiredSignature)
      end

      it "returns 401 with expiration message" do
        get endpoint, headers: {"Authorization" => "Bearer #{bearer_token}"}
        expect(response).to have_http_status(401)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Not authorized JWT token is expired")
      end
    end

    context "when Authorization header lacks Bearer prefix" do
      it "returns 401" do
        get endpoint, headers: {"Authorization" => "Token some-token"}
        expect(response).to have_http_status(401)
      end
    end

    context "when Authorization header is just 'Bearer '" do
      let(:bearer_token) { "" }

      before do
        allow_any_instance_of(Api::V1::ApiController).to receive(:central_login_oauth_strategy).and_return(mocked_strategy)
        allow(mocked_strategy).to receive(:validate_id_token).with("").and_raise(JWT::DecodeError.new)
      end

      it "raises JWT::DecodeError (not caught by the controller)" do
        expect {
          get endpoint, headers: {"Authorization" => "Bearer "}
        }.to raise_error(JWT::DecodeError)
      end
    end
  end

  # ------------------------------------------------------------------
  # Bearer token — success cases (end-to-end with actual request)
  # ------------------------------------------------------------------
  describe "Bearer token authentication success cases" do
    let(:bearer_token) { "valid-id-token" }
    let(:created_user) { users(:admin) }

    before do
      allow_any_instance_of(Api::V1::ApiController).to receive(:central_login_oauth_strategy).and_return(mocked_strategy)
      allow(mocked_strategy).to receive(:validate_id_token).with(bearer_token).and_return(regular_user_token_payload)
      allow(User).to receive(:from_omniauth_callback_data).and_return(created_user)
    end

    context "for a regular user" do
      it "returns 200 with data" do
        get endpoint, headers: {"Authorization" => "Bearer #{bearer_token}"}
        expect(response).to be_successful
      end

      it "calls the strategy validate_id_token" do
        get endpoint, headers: {"Authorization" => "Bearer #{bearer_token}"}
        expect(mocked_strategy).to have_received(:validate_id_token).with(bearer_token)
      end
    end

    context "for an app user" do
      let(:app_user_token_payload) do
        {
          "sub" => "app-my_app",
          "name" => "My App",
          "iss" => issuer,
          "resources" => [],
          "roles" => []
        }
      end

      before do
        allow(mocked_strategy).to receive(:validate_id_token).with(bearer_token).and_return(app_user_token_payload)
      end

      it "returns 200 with data" do
        get endpoint, headers: {"Authorization" => "Bearer #{bearer_token}"}
        expect(response).to be_successful
      end
    end
  end

  # ------------------------------------------------------------------
  # No authentication
  # ------------------------------------------------------------------
  describe "without any authentication" do
    it "returns 401" do
      get endpoint
      expect(response).to have_http_status(401)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Not authorized")
    end
  end

  # ------------------------------------------------------------------
  # Session-based auth (Devise sign_in)
  # ------------------------------------------------------------------
  describe "session-based authentication" do
    context "when signed in via Devise" do
      before do
        sign_in admin_user
      end

      it "returns 200" do
        get endpoint
        expect(response).to be_successful
      end
    end
  end
end
