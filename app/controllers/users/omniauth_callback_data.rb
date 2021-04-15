# frozen_string_literal: true

# first line of defense; only allowed parameters

class Users::OmniauthCallbackData
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :email, :email_confirmed, :name, :oauth_subject, :oauth_provider, :qkunst, :facility_manager, :domain, :raw_open_id_token

  validates_presence_of :email, :oauth_subject, :oauth_provider

  validate :qkunst_only_in_qkunst_domain

  def email_confirmed?
    !!(email && email_confirmed)
  end

  def qkunst_only_in_qkunst_domain
    if qkunst && domain != "qkunst.nl"
      errors.add(:qkunst, "not allowed for non qkunst domain")
    end
  end
end
