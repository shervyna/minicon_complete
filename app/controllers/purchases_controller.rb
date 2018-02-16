class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:new, :create]
  
  def index
    @purchases = current_user.purchases.order(created_at: :desc)
  end

  def new
    @purchase = Purchase.new
  end
  
  def create
    begin
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => params[:purchase][:total_price],
        :description => 'Rails Stripe customer',
        :currency    => 'jpy'
      )
    
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_event_purchase_path
    end

    @purchase = Purchase.new(purchase_params)
    @purchase.user_id = current_user.id
    
    if @purchase.save
      redirect_to purchases_path, notice: 'Your order was successfully placed.'
    else
      flash.now[:alert] = 'Error placing your order.'
      render :new
    end
  end
  
  private
  
    def set_event
      @event = Event.find(params[:event_id])
    end
  
    def purchase_params
      params.require(:purchase).permit(:event_id, :ticket_quantity, :total_price)
    end
end
