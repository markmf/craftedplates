class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy

	def add_product(meal_id)
		puts "*"*150
		puts "Meal ID is #{meal_id}"
		puts "*"*150
       current_item = line_items.find_by(meal_id: meal_id)
		if current_item
			current_item.quantity += 1
			puts "Quantity is #{current_item.quantity}"
		else
			current_item = line_items.build(meal_id: meal_id)
		end

		current_item
	end


	
end
