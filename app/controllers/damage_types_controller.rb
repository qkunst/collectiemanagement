class DamageTypesController < ApplicationController
  include BaseController

  private

  def controlled_class
    DamageType
  end
end
