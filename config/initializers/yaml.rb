Rails.application.config.active_record.yaml_column_permitted_classes = [
  ActiveSupport::HashWithIndifferentAccess,
  Symbol,
  DateTime,
  Time,
  Date,
  User,
  Hashie::Array
]
ActiveRecord::Base.yaml_column_permitted_classes = Rails.application.config.active_record.yaml_column_permitted_classes