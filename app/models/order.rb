class Order < ActiveRecord::Base
	validates :first_name, :last_name, :address, :email, presence: true

	belongs_to :line_items
	belongs_to :buyer, class_name: "User"
end
