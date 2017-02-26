class ProdTypesController < ApplicationController
  before_action :set_prod_type, only: [:edit, :update]
  
  def index
    @prod_types = ProdType.order_by(:name => 'desc').paginate(page: params[:page]) 
  end
  
  def new
    @prod_type = ProdType.new
  end
  
  def create
    @prod_type = ProdType.new(prod_type_params)
    
    if @prod_type.save
      flash[:success] = t('.created', default: 'Product type was successfully created.')
      redirect_to prod_types_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @prod_type.update(prod_type_params)
      flash[:success] = t('.updated', default: 'Product type was successfully updated.')
      redirect_to prod_types_path
    else
      render 'edit'
    end
  end
  
  private
  def prod_type_params
    params.require(:prod_type).permit(:name,:creator)
  end
  def set_prod_type
    @prod_type = ProdType.find(params[:id])
  end
end
