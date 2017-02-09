class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :coin, :add_coin]
  
  def index
    @members = Member.order_by(:phone => 'asc').paginate(page: params[:page])     #(:created_at => 'desc')
  end
  
  def search
    if params[:search_param] == ""
      @members = Member.order_by(:phone => 'asc').paginate(page: params[:page]) 
      render 'index'
    else
      @members = Member.search(params[:search_param]).order_by(:phone => 'asc').paginate(page: params[:page]) 
      if @members
        render 'index'
      else
        render status: :not_found, nothing: true
      end
    end
  end
  
  def show
    @trades = @member.trades.order_by(:created_at => 'desc').paginate(page: params[:page]) 
  end
  
  def new
    @member = Member.new
  end
  
  def create
    @member = Member.new(member_params)
    if @member.save 
      flash[:success] = t('.created', default: "Member was successfully created")
      redirect_to members_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @member.update(member_params)
      flash[:success] = t('.updated', default: "Member was successfully updated")
      redirect_to member_path(@member)
    else
      render 'edit'
    end
  end
  
  def destroy
    @member.destroy
    flash[:danger] = t('.deleted', default: "Member was successfully deleted")
    redirect_to members_path
  end
  
  def coin  
  end
  
  def add_coin
    coin = params[:coin_param].to_i
    
    if coin > 0
      if @member.add_coin(coin, current_user.email)
        redirect_to member_path(@member)
      end
      #redirect_to coin_member_path(@member)
    else
      flash[:danger] = t('.add_coin_fail', default: "Please enter a validate number")
      redirect_to coin_member_path(@member)
    end
  end
  
  private
  def member_params
    params.require(:member).permit(:last_name, :first_name, :phone, :birthdate, :password, :password_confirmation )
  end
  def set_member
    @member = Member.find(params[:id])
  end
  
end
