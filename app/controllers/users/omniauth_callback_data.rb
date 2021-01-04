# first line of defense; only allowed parameters

class Users::OmniauthCallbackData
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :email, :name, :oauth_subject, :oauth_provider, :qkunst, :facility_manager, :domain

  validates_presence_of :email, :oauth_subject, :oauth_provider

  validate :qkunst_only_in_qkunst_domain

  def qkunst_only_in_qkunst_domain
    if qkunst && domain != "qkunst.nl"
      errors.add(:qkunst, "not allowed for non qkunst domain")
    end
  end
end
