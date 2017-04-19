class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :destroy]
  before_action :set_member, only: [:destroy, :new, :create, :show, :add_trade_item, :cancel_trade_item]
  before_action :set_today_trades, only: [:new, :create]
  
  def show
    #@today_trades = @trades.order_by(:created_at => 'desc').paginate(page: params[:page]) 
    @total = @trades.sum(:total)
  end
  
  def new
    @trade = Trade.new
    #logger.debug "#{trades_array}--------"
  end
  
  def create
    if trades_array.count > 0
      @member.coin -=  @total
      if @member.coin >= 0
        if @member.save && Trade.save_array_hash(trades_array, @member.id, current_user.email)
          delete_trades
          flash[:success] = t('.success', default: 'Trade was successfully created')
          redirect_to member_path(@member)
        else
          render 'new'
        end
      else
        flash[:danger] = t('.not_enough', default: 'Not enough money.')
        redirect_to new_trade_path(@member)
      end
    else
      flash[:danger] = t('.add_an_item', default: 'Please add an item.')
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
  
  def add_trade_item
    if params[:product_id] != ""
      @trades = trades_array
      has_item = false
      @trades.each do |trade|
        if trade["product"] == params[:product]
          amount = trade["amount"].to_i + params[:amount].to_i
          total = trade["total"].to_i + (params[:current_price].to_i * params[:amount].to_i)
          trade["amount"] = amount
          trade["total"] = total
          has_item = true
        end
      end
      
      if !has_item
        total = params[:current_price].to_i * params[:amount].to_i
        new_trade = {
          "trade_date" => params[:trade_date],
          "product" => params[:product],
          "current_price" => params[:current_price],
          "amount" => params[:amount],
          "total" => total
        }
        
        @trades << new_trade
        #logger.debug @trades
      end
      
      save_trades(@trades)
      cal_total
      
      render partial: "form"
    else
      flash[:danger] = t('.add_an_item', default: 'Please add an item.')
      redirect_to new_trade_path(@member)
    end
  end
  
  def cancel_trade_item
    @trades = trades_array
    trade = @trades.select {|trade| trade["product"] == params[:product]}
    @trades.delete(trade[0])
    save_trades(@trades)
    cal_total
    render partial: "form"
  end
  
  private
  def set_trade
    @trades = Trade.where(:trade_date => params[:date], :trade_type => params[:type], :member_id => params[:member_id]).order_by(:created_at => 'desc') 
  end
  def set_member
    @member = Member.find(params[:member_id] ? params[:member_id] : params[:id])
  end
  def set_today_trades
     @trades = trades_array
     cal_total
  end
  # shopping cart function
  def save_trades(trades)
    session["#{@member.phone}"] = (trades.class == Array) ? trades : ''
  end
  def trades_array
    session["#{@member.phone}"] ? session["#{@member.phone}"] : []
  end
  def delete_trades
    session["#{@member.phone}"] = nil
  end
  def cal_total
    @total = 0
    trades_array.each do |trade|
       #logger.debug "#{trade["total"]}----"
       @total += trade["total"].to_i
     end
  end
end
