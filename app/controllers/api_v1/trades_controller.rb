class ApiV1::TradesController < ApiController
  def show
    @trades = Trade.where(:trade_date => params[:date], :trade_type => params[:type], :member_id => params[:id]).order_by(:created_at => 'desc') 
    # show.json.jbuilder
  end
end