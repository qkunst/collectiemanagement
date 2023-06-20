# == Schema Information
#
# Table name: contacts
#
#  id            :bigint           not null, primary key
#  address       :text
#  contact_type  :string
#  external      :boolean
#  name          :string
#  remote_data   :text
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#
class Contact < ApplicationRecord
  belongs_to :collection

  validates_presence_of :name
  validates_presence_of :url, if: :external_and_no_remote_data?
  validates_uniqueness_of :url, if: :external_and_no_remote_data?, scope: :collection

  scope :internal, -> { where(external: [nil, false]) }
  scope :external, -> { where(external: true) }
  scope :without_url, -> { where(url: nil) }

  has_many :time_spans

  def name
    read_attribute(:name) || (external? ? "External" : nil)
  end

  def to_s
    "#{name} (#{url})"
  end

  def external_and_no_remote_data?
    external? && remote_data.blank?
  end

  def business?
    contact_type == "business"
  end

  def to_select_value
    external_and_no_remote_data? ? Uitleen::Customer.new(uri: url) : self
  end

  class << self
    def merge_and_prefer_collection_id collection_id
      pluck(:url).tally.select { |k, v| v > 1 }.map do |k, v|
        remove = Contact.where(url: k).where.not(collection_id: collection_id)
        time_spans_to_move = remove.flat_map(&:time_spans)
        final_contact = Contact.find_by(url: k, collection_id: collection_id)

        time_spans_to_move.each { |ts| (!ts.update(contact: final_contact) && ts.subject_type == "WorkSet") ? ts.destroy : nil }

        remove = Contact.where(url: k).where.not(collection_id: collection_id)
        remove.each do |r|
          r.destroy if r.time_spans.empty?
        end
      end
    end

    # more of a code stash for one of migration
    def create_work_sets_for_contacts(work_set_type: WorkSetType.first, start_date: Date.new(2023, 1, 1), id_post_fix: "Actief uitgeleend", collection: Collection.first)
      id_prefix = "#{start_date.year}-01"
      each do |contact|
        work_set = WorkSet.create(works: Work.where(id: contact.time_spans.active.rental_outgoing.where(subject_type: "Work").pluck(:subject_id)), work_set_type: work_set_type, identification_number: "#{id_prefix} #{contact.name} #{id_post_fix}", comment: "Automatisch aangemaakt voor #{contact.name}")
        work_set.time_spans.create(starts_at: start_date, status: "active", classification: "rental_outgoing", comments: "Automatisch aangemaakt voor #{contact.name}", collection: collection, contact: contact)
      end
    end

    def update_localhost_urls
      contact_count = Contact.where("url LIKE 'http://localhost:5001/customers/%'").count
      Contact.where("url LIKE 'http://localhost:5001/customers/%'").each do |c|
        c.update_columns(url: c.url.sub("http://localhost:5001/", Rails.application.secrets.uitleen_site))
      end
      puts "#{contact_count} contacts updated."
    end

    def update_with_remote_uitleen_data(current_user:)
      customers = Uitleen::Customer.all(current_user: current_user)
      customers.each do |customer|
        new_data = {
          contact_type: customer.customer_type
        }
        new_data["name"] = customer.name if customer.public_name?
        Contact.where(url: customer.uri).update_all(new_data)
      end
    end
  end
end
