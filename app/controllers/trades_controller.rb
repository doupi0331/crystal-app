class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :destroy]
  before_action :set_member, only: [:destroy]
  
  def show
    
  end
  
  def destroy
    if @trade.trade_type == "I"
      @member.coin -= @trade.total
      @member.total_coin -= @trade.total
    else
      @member.coin += @trade.total
      @member.total_coin += @trade.total
    end
    
    if @member.save
      @trade.destroy
      flash[:danger] = t('.deleted', default: 'Trade was successfully deleted')
      redirect_to member_path(@member)
    end

  end
  
  private
  def set_trade
    @trade = Trade.find(params[:id])
  end
  def set_member
    @member = Member.find(params[:member_id])
  end
end
