class MembersController < ApplicationController
  def index
    @members = Member.all
  end
  
  def new
    @member = Member.new
  end
  
  def create
    @member = Member.new(member_params)
    if @member.save 
      flash[:success] = "Member was successfully created"
      redirect_to members_path
    else
      render 'new'
    end
  end
  
  def edit
    @member = Member.find(params[:id])
  end
  
  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      flash[:success] = "Member was successfully updated"
      redirect_to members_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    flash[:danger] = "Member was successfully deleted"
    redirect_to members_path
  end
  
  private
  def member_params
    params.require(:member).permit(:last_name, :first_name, :phone, :birthdate, :password, :password_confirmation )
  end
  
end
