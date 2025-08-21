# frozen_string_literal: true

module Ability::Report
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    def report_field_abilities(ability: :edit)
      app_roles = User::ROLES

      field_method = (ability == :edit) ? :editable_work_fields_grouped : :viewable_work_fields_grouped

      all_fields = Ability.new(Ability::TestUser.new(:admin)).send(field_method)

      field_report = {header: [], data: {}}
      all_fields.each do |model_key, model_fields|
        model_key_translated = I18n.t "activerecord.models.#{model_key.to_s.sub("s_attributes", "")}"
        field_report[:data][model_key_translated] = {}
        model_fields.each do |attribute|
          attribute_translated = I18n.t "activerecord.attributes.#{model_key.to_s.sub("s_attributes", "")}.#{attribute}"
          field_report[:data][model_key_translated][attribute_translated] = []
        end
      end

      abilities = {}

      app_roles.each do |role|
        user = Ability::TestUser.new(role)
        ability = Ability.new(user)
        abilities[role] = ability
        field_report[:header] << {ability: ability, user: user}
      end

      all_fields.each do |model_key, model_fields|
        model_key_translated = I18n.t "activerecord.models.#{model_key.to_s.sub("s_attributes", "")}"

        model_fields.each do |attribute|
          attribute_translated = I18n.t "activerecord.attributes.#{model_key.to_s.sub("s_attributes", "")}.#{attribute}"

          field_report[:header].each_with_index do |ability, index|
            contains_attribute = ability[:ability].send(field_method)[model_key]&.include?(attribute)
            field_report[:data][model_key_translated][attribute_translated][index] = contains_attribute
          end
        end
      end

      field_report
    end

    def report_abilities
      app_roles = User::ROLES # - [:qkunst]

      ability_report = {header: [], data: {}}

      permissions_per_thing = {}

      app_roles.each do |role|
        user = Ability::TestUser.new(role)
        ability = Ability.new(user)

        ability.permissions[:can].each do |permission, things|
          things.each do |thing, _|
            permissions_per_thing[thing] ||= []
            # alias_action :index, :show, :to => :read
            # alias_action :new, :to => :create
            # alias_action :edit, :to => :update
            unless [:index, :show, :new, :edit].include? permission # ignore aliased actions
              permissions_per_thing[thing] << permission unless permissions_per_thing[thing].include? permission
            end
          end
        end
      end

      app_roles.each do |role|
        user = Ability::TestUser.new(role)
        ability = Ability.new(user)

        ability_report[:header] << {ability: ability, user: user}

        permissions_per_thing.each do |thing, permissions|
          thing_i18n = I18n.t thing.downcase, scope: [:activerecord, :models]
          ability_report[:data][thing_i18n] ||= {}
          permissions.each do |permission|
            permission_i18n = I18n.t permission, scope: [:abilities]
            ability_report[:data][thing_i18n][permission_i18n] ||= []
            thing_constantize = begin; thing.constantize; rescue; thing; end
            ability_report[:data][thing_i18n][permission_i18n] << ability.can?(permission, thing_constantize)
          end
        end
      end

      ability_report
    end
  end
end
