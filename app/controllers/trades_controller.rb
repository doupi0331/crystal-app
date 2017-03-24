class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :destroy]
  before_action :set_member, only: [:destroy, :new, :create, :show]
  before_action :set_today_trades, only: [:new, :create]
  
  def show
    #@today_trades = @trades.order_by(:created_at => 'desc').paginate(page: params[:page]) 
    @trades = @trades.paginate(page: params[:page])
  end
  
  def new
    @trade = Trade.new
  end
  
  def create
    @trade = Trade.new(trade_params)
    #logger.debug "!!!!!!! #{params[:product_id]}"
    
    if params[:product_id] != ""
      # TODO 看有沒有辦法簡化
      amount = @trade.amount ? @trade.amount.abs : 1
      @trade.total = @trade.current_price * amount
      @member.coin -=  @trade.total
      
      if @member.coin >= 0
        if @trade.save && @member.save
          flash[:success] = t('.success', default: 'Trade was successfully created')
          redirect_to new_trade_path(@member)
        else
          render 'new'
        end
      else
        flash[:danger] = t('.not_enough', default: 'Not enough money.')
        redirect_to new_trade_path(@member)
      end
    else
      flash[:danger] = t('.product_error', default: 'Please choose a product.')
      redirect_to new_trade_path(@member)
    end
  end
  
  def destroy
    #logger.debug "#{@trades.first.trade_type} #{@trades.sum(:total)} #{@trades.size}"
    if @member.reverse(@trades.first.trade_type, @trades.sum(:total))
      @trades.destroy
      flash[:warning] = t('.deleted', default: 'Trade was successfully deleted')
      redirect_to member_path(@member)
    else
      flash[:danger] = t('.reverse-fail', default: 'This trade cant be reversed')
      redirect_to member_path(@member)
    end
  end
  
  private
  def set_trade
    @trades = Trade.where(:trade_date => params[:date], :trade_type => params[:type], :member_id => params[:member_id]).order_by(:created_at => 'desc') 
  end
  def set_member
    @member = Member.find(params[:member_id] ? params[:member_id] : params[:id])
  end
  def set_today_trades
    @today_trades = @member.trades.where(trade_date: Date.today, trade_type: "O").order_by(:created_at => 'desc').paginate(page: params[:page]) 
  end
  def trade_params
    params.require(:trade).permit(:trade_date, :trade_type, :trade_name, :product, :amount, :current_price, :creator, :member_id)
  end
end
