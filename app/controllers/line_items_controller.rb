class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  
  # GET /line_items
  # GET /line_items.json
  def index
   # @line_items = LineItem.all
    if user_signed_in? 
      @line_items = LineItem.all.where(user: current_user).order("created_at DESC")
    else
      @line_items = LineItem.all.where(user: 0)
    end

  end
   # p = ActiveRecord::Base.connection.execute("select m.name, m.id, m.image_url, l.* from meals as m INNER JOIN line_items as l  where l.meal_id = m.id and l.user_id = #{current_user}" )

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_items = LineItem.all.where(user: current_user).order("created_at DESC")
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    meal = Meal.find(params[:meal_id])
    @line_item = @cart.add_product(meal.id)

puts "The Plate QTY is," 
puts params[:plate_qty]

    if params[:plate_qty].present?
      @line_item.quantity = params[:plate_qty]
      @line_item.plate_qty = @line_item.quantity
    else
      @line_item.quantity = 6
      @line_item.plate_qty = 6
    end

    Rails.logger.debug params.inspect

    #Rails.logger.info("PARAMS: #{params.inspect}")

    #@line_item = @cart.line_items.build(meal: meal)

    if user_signed_in? 
      @line_item.user_id = current_user.id
    else
      @line_item.user_id = 0
    end

    @line_item.image_url = meal.image_url
    @line_item.name = meal.name
    

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_path, notice: 'Meal item was successfully added onto the cart. '}
      #  format.html { redirect_to @line_item.cart, notice: 'Meal item was successfully added onto the cart. '}
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:meal_id, :cart_id, :plate_qty)
    end
end
