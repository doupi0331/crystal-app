class ApiV1::AuthController < ApiController
  # before_action :authenticate_user!, :only => [:logout]
  
  def login
    success = false

    if params[:phone] && params[:password]
      # 由手機號碼找出member
      # 並確認member存在並且密碼正確
      # success = user && user.valid_password?( params[:password] ) 參考
    end

    if success
      # 回傳正確訊息
      #render :json => { :auth_token => user.authentication_token,
      #                  :user_id => user.id}
    else
      # 回傳錯誤訊息
      #render :json => { :message => "email or password is not correct" }, :status => 401
    end

  end

  def logout
    # user = current_user
# 
    # user.generate_authentication_token
    # user.save!
# 
    # render :json => { :message => "ok" }
  end
  
end
