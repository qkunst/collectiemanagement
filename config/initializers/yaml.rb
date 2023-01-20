Rails.application.config.active_record.yaml_column_permitted_classes = [
  ActiveSupport::HashWithIndifferentAccess,
  Symbol,
  DateTime,
  Time,
  Date,
  BigDecimal,
  "User",
  "ActsAsTaggableOn::TagList",
  "ActsAsTaggableOn::DefaultParser",
  ActiveSupport::TimeWithZone,
  ActiveSupport::TimeZone,
  Hashie::Array
]
::ActiveRecord.yaml_column_permitted_classes = Rails.application.config.active_record.yaml_column_permitted_classes
