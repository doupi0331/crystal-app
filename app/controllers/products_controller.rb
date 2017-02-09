class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update]
  
  def index
    @products = Product.order_by(:prod_type_id => 'asc', :created_at => 'desc').paginate(page: params[:page]) 
  end
  
  def search
    if params[:search_param] == ""
      @products = Product.order_by(:prod_type_id => 'asc', :created_at => 'desc').paginate(page: params[:page]) 
      render 'index'
    else
      @products = Product.search(params[:search_param]).order_by(:prod_type_id => 'asc', :created_at => 'desc').paginate(page: params[:page]) 
      if @products
        render 'index'
      else
        render status: :not_found, nothing: true
      end
    end
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    @product.creator = current_user.email
    
    if @product.save
      flash[:success] = t('.created', default: 'Product was successfully created.')
      redirect_to products_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @product.update(product_params)
      flash[:success] = t('.updated', default: 'Product was successfully updated.')
      redirect_to products_path
    else
      render 'edit'
    end
  end
  
  private
  def product_params
    params.require(:product).permit(:name, :price, :prod_type_id)
  end
  def set_product
    @product = Product.find(params[:id])
  end
end
