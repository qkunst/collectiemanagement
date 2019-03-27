# frozen_string_literal: true

class FixStringValuesToNilWhenEmpty < ActiveRecord::Migration
  def self.up
    puts "Fixing string values for at least #{Work.where(:grade_within_collection=>nil).count} works"
    columns = [:location, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2, :title, :print, :grade_within_collection, :entry_status, :abstract_or_figurative, :location_detail]
    Work.all.each{|a| columns.each{|c| a.send("#{c}=".to_sym,nil) if a.send(c).to_s.strip == ""}; a.save}
  end
  def self.down
    puts "Cannot reverse fixing string values"
  end
end
