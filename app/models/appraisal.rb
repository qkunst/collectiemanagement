class Appraisal < ApplicationRecord
  belongs_to :work
  belongs_to :user

  scope :descending_appraisal_on, -> { order("appraisals.appraised_on is null, appraisals.appraised_on desc") }
end
