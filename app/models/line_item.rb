class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :user
  belongs_to :meal
  belongs_to :plate

  belongs_to :orders

 public

  def add_total_price
      line_items.to_a.sum { |item| item.unit_price(item.quantity) }
  end

  def unit_price(quantity)
      11.99 * quantity
  end

 
  	
end
