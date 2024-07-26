class WorkDisplayForm
  include ActiveModel::Model

  attr_accessor :group
  attr_accessor :sort
  attr_accessor :display
  attr_accessor :attributes_to_display
  attr_accessor :current_user
  attr_accessor :collection
  attr_accessor :force_display_all_used_fields

  def initialize(*)
    super
    set_to_valid_values
  end

  def group_options
    return [] if current_user.nil?
    return @group_options if @group_options
    proto_selection_group_options = {
      "Niet" => :no_grouping,
      "Cluster" => :cluster,
      "Deelcollectie" => :subset,
      "Herkomst" => :sources,
      "Niveau" => :grade_within_collection,
      "Plaatsbaarheid" => :placeability,
      "Techniek" => :techniques,
      "Thema" => :themes
    }
    @group_options = {}
    proto_selection_group_options.each do |k, v|
      @group_options[k] = v if current_user.can_filter_and_group?(v)
    end
  end

  def display_options
    return [] if current_user.nil?
    return @display_options if @display_options
    @display_options = {"Compact" => :compact, "Basis" => :detailed}
    if /vermist/i.match?(collection&.name)
      @display_options["Basis met locatiegeschiedenis"] = :detailed_with_location_history
    end
    @display_options["Basis Discreet"] = :detailed_discreet if current_user.qkunst? || current_user.facility_manager?
    @display_options["Compleet"] = :complete unless current_user.read_only? || current_user.facility_manager_support?
    if current_user.qkunst?
      @display_options["Beperkt"] = :limited
      if collection&.commercial?
        @display_options["Beperkt (+verkoop)"] = :limited_selling_price
        @display_options["Beperkt (+huur particulier)"] = :limited_default_rent_price
        @display_options["Beperkt (+huur zakelijk)"] = :limited_business_rent_price
        @display_options["Beperkt (+huur/verkoop particulier)"] = :limited_selling_price_and_default_rent_price
        @display_options["Beperkt (+huur/verkoop zakelijk)"] = :limited_selling_price_and_business_rent_price
      end
      @display_options["Veilinghuis"] = :limited_auction
    end
    @display_options
  end

  def sort_options
    return @sort_options if @sort_options
    @sort_options = {
      "Inventarisnummer" => :stock_number,
      "Vervaardiger" => :artist_name,
      "Locatie" => :location,
      "Toevoegdatum (nieuwste eerst)" => :created_at,
      "Toevoegdatum (oudste eerst)" => :created_at_asc,
      "Wijzigingsdatum (nieuwste eerst)" => :significantly_updated_at,
      "Wijzigingsdatum (oudste eerst)" => :significantly_updated_at_asc
    }
  end

  def selectable_work_attributes
    collection&.displayable_work_attributes_present || []
  end

  private

  def set_to_valid_values
    self.group = group&.to_sym || current_user&.filter_params&.[](:group) || :no_grouping
    self.sort = sort&.to_sym || current_user&.filter_params&.[](:sort) || :stock_number
    self.display = display&.to_sym || current_user&.filter_params&.[](:display) || (current_user&.can?(:show_details, Work.new(collection_id: collection.id)) ? :complete : :detailed)
    self.group = nil unless group.nil? || valid_groups.include?(group)
    self.sort = nil unless sort.nil? || valid_sorts.include?(sort)
    self.display = nil unless display.nil? || valid_displays.include?(display)
    self.attributes_to_display = (attributes_to_display || []).select(&:present?).map(&:to_sym)
    self.force_display_all_used_fields = ["1", "true", true].include?(force_display_all_used_fields.to_s)
  end

  def valid_groups
    group_options.collect { |k, v| v }
  end

  def valid_sorts
    [:stock_number, :artist_name, :location, :created_at, :created_at_asc, :significantly_updated_at, :significantly_updated_at_asc, :id, :"-id"]
  end

  def valid_displays
    display_options.collect { |k, v| v }
  end
end
