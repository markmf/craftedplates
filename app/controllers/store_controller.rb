class StoreController < ApplicationController
  def index
	#@meals = Meal.all
	@meals = Meal.order(:id)
  end
end
