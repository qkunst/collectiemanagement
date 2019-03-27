# frozen_string_literal: true

namespace :carrierwave do
  desc "Regenerate versions"
  task :regenerate => :environment do
    Work.all.each do |fp|
      fp.photo_front.recreate_versions! if fp.photo_front?
      fp.photo_back.recreate_versions! if fp.photo_back?
      fp.photo_detail_1.recreate_versions! if fp.photo_detail_1?
      fp.photo_detail_2.recreate_versions! if fp.photo_detail_2?
    end
  end
end
