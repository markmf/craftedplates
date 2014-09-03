class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :user
  belongs_to :meal

  has_many :orders

 public

  def tot_price
      line_items.to_a.sum { |item| item.unit_price(item.quantity) }
  end

  def unit_price(quantity)
      11.99 * quantity
  end

 
  	
end
