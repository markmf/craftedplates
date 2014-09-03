class Meal < ActiveRecord::Base
	has_many :line_items
	
  	validates :name, :description, :serving, :calories, :image_url, presence: true
  	validates :calories, :serving, numericality: {greate_than_or_equal_to: 1}
  	validates :name, uniqueness: true
  	validates :image_url, allow_blank: true, format: {
     with:  %r{\.(gif|jpg|png)\Z}i,
     message: 'must be a URL for GIF, JPG or PNG image.'
    }

    private

    	#ensure that there are no line items referencing this product
    	def ensure_not_reference_by_any_line_item
    		if line_items.empty?
    			return true
    		else
    			errors.add(:base, 'Meal Item present')
    			return false
    		end
    	end
end
