class StoreController < ApplicationController
	include CurrentCart
	before_action :set_cart
	
	def index
		#@meals = Meal.all
		@meals = Meal.order(:id)
	 end
end
