# Be sure to restart your server when you modify this file.
#
# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    if Rails.env.development?
      policy.default_src :self, "http://localhost:3035", "ws://localhost:3035" # bin/webpacker-dev-server reloading
    else
      policy.default_src :self
    end
    policy.font_src :self, "https://vps601.directvps.nl"
    policy.img_src :self, "https://stamen-tiles-a.a.ssl.fastly.net", "https://stamen-tiles-b.a.ssl.fastly.net", "https://stamen-tiles-c.a.ssl.fastly.net", "https://stamen-tiles-d.a.ssl.fastly.net", :data
    policy.object_src :none
    policy.script_src :self, "'unsafe-eval'", "'eval'", "'wasm-unsafe-eval'"
    policy.style_src :self
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap and inline scripts
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src]

  # Report violations without enforcing the policy.
  # config.content_security_policy_report_only = true
end
