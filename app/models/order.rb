class Order < ActiveRecord::Base

	belongs_to :line_items
	belongs_to :buyer, class_name: "User"
end
