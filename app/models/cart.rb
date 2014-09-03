class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy

	def add_product(meal_id)
       current_item = line_items.find_by(meal_id: meal_id)
		if current_item
			current_item.quantity += 1
		else
			current_item = line_items.build(meal_id: meal_id)
		end
		current_item

	end


	
end
