class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # users have to sign in!
  before_action :authenticate_user!
end
