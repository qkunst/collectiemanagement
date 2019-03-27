# frozen_string_literal: true

module Hidable
  extend ActiveSupport::Concern

  included do

    scope :not_hidden, -> {where(hide: [nil,false])}
    scope :show_hidden, ->(show_h=true){ where(hide: (show_h ? [true] : [false,nil])) }

  end
end
