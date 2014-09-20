class Order < ActiveRecord::Base
	validates :first_name, :last_name, :address, :email, presence: true

	belongs_to :buyer, class_name: "User"
	has_many :line_items, dependent: :destroy
end
