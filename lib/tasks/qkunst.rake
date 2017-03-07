namespace :qkunst do
  desc "Herindexeer alle werken"
  task reindex: :environment do
    Work.reindex!
  end

  desc "Import Geonames data"
  task geonames_import: :environment do
    Geoname.import_all!
    puts "Done!"
  end

  desc "Doe de schoonmaak"
  task rinse_and_clean: :environment do
    Cluster.remove_all_without_works
    Artist.destroy_all_empty_artists!
    Work.update_artist_name_rendered!
    Artist.destroy_all_artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name!
    Artist.collapse_by_name!({only_when_created_at_date_is_equal: true})
  end

  desc "Bouw nieuwe index op en herindexeer alle werken (traag)"
  task new_index: :environment do
    Work.reindex!(true)
  end

  desc "Send all reminders"
  task send_reminders: :environment do
    Reminder.actual.all.each do |reminder|
      begin
        reminder.send_message_if_current_date_is_next_date!
      rescue NoMethodError

      end
    end
  end

  desc "import bank codes"
  task import_fases: :environment do
    Collection.create(name: "Zonder Kring")
    Workbook::Book.open("#{Rails.root}/data/fase_import_one_time.csv").sheet.table.each do | line |
      [:bankcode, :roepnaam_bank, :soort_locatie, :type_vestiging, :adres, :postcode, :plaatsnaam, :telefoonnummer, :emailadres, :offerte, :inventarisatie, :waardering, :advies, :besluitvorming_fase_altijd_van_toepassing_maar_omdat_intern_datum_bij_ons_vrijwel_nooit_bekend, :ontzamelen, :inrichten, :kunst_in_opdracht, :beheer]
      unless line.header?
        c = nil
        if line[:bankcode].value
          c = Collection.find_or_initialize_by(external_reference_code: line[:bankcode].value.to_i)
          name = "Rabobank #{line[:roepnaam_bank].value}"
          if c.parent_collection.nil?
            if Collection.find_by_name(name)
              raise "#{name} found, but no match on id"
            end
            c.parent_collection = Collection.find_by_name("Zonder kring")
          end
          c.name = name unless c.name
        else
          c = Collection.find_by_name(line[:roepnaam_bank].value)
        end

        if c
          c.save
          stages = {inventarisatie: "Inventarisatie", waardering: "Waardering", advies: "Advies", besluitvorming_fase_altijd_van_toepassing_maar_omdat_intern_datum_bij_ons_vrijwel_nooit_bekend: "Besluitvorming", ontzamelen: "Ontzamelen", inrichten: "Inrichten", kunst_in_opdracht: "Kunst in opdracht", beheer: "Beheer"}
          line_has_stages = false
          stages.each do |k,v|
            line_has_stages= true unless line[k].nil?
          end
          if line_has_stages
            stages.each do |k,v|
              date_text = line[k].value.to_s.strip
              if date_text != "nvt"
                col_stage = c.collections_stages.find_or_initialize_by(stage: Stage.find_by_name(v))
                if date_text.match(/\d\d\d\d\d\d/)
                  date = Date.new("20#{date_text[0..1]}".to_i, date_text[2..3].to_i, date_text[4..5].to_i)
                  col_stage.completed_at = date
                end
                col_stage.save
              end
            end
          end
        end

      end
    end
  end
end
