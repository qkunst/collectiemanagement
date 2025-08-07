# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnonymizeUnusedAccountsWorker, type: :model do
  it "removes users who don't have an account" do
    u = users(:qkunst)
    u.update(last_sign_in_at: 14.months.ago)
    u.reload
    expect(u).to be_persisted

    AnonymizeUnusedAccountsWorker.new.perform

    expect { u.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "removes users who don't have an account" do
    u = users(:collection_with_works_child_user)
    u.update(last_sign_in_at: 14.months.ago)
    u.reload
    expect(u).to be_persisted

    AnonymizeUnusedAccountsWorker.new.perform

    expect { u.reload }.not_to raise_error
    expect(u).to be_persisted
    expect(u.name).to match "removed"
  end
end
