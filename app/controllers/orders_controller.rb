class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new

  #  if @cart.line_items.empty?
  #    redirect_to store_index_path, notice: "Your cart is empty"
  #  end

  puts "=====ENTERING ORDER new routine========"

    if user_signed_in? 
      @line_items = LineItem.all.where(user: current_user).order("created_at DESC")
    else
      @line_items = LineItem.all.where(user: 0)
    end
    @order = Order.new

  puts "========DONE with ORDER.new============="
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create

    puts "======ENTERING ORDER CREATE ROUTINE==="

    @order = Order.new(order_params)

    puts "=====EXECUTED ORDER.new ==============="

    @order.user_id = current_user.id

    puts "===Retrieving LINE_ITEMS in Order.create=============="
    if user_signed_in? 
      @line_items = LineItem.all.where(user: current_user).order("created_at DESC")
    else
      @line_items = LineItem.all.where(user: 0)
    end

    @line_item = @line_items.first
    @order.delivery_date = @line_item.delivery_date
    @order.total_price = @line_items.to_a.sum { |item| item.unit_price(item.quantity) }

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => (  11.99 * 100).floor,
        :currency => "usd",
        :card => token
        )
      flash[:notice] = "Thanks for ordering!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end
    
    puts "=======Entering Order.save====="

    respond_to do |format|
      if @order.save
        
        puts "=====EXECUTED ORDER.new Order Id is #{@order.id}"
        LineItem.where(:user_id => current_user).update_all("order_id = #{@order.id}")

        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil

        format.html { redirect_to store_index_path, notice: 'Thank you for your order.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:first_name, :last_name, :email, :address, :city, :state, :zip, :user_id)
    end
end
