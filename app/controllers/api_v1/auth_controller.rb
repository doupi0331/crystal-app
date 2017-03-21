class ApiV1::AuthController < ApiController
  # before_action :authenticate_user!, :only => [:logout]
  
  def login

    if params[:phone] && params[:password]
      # 由手機號碼找出member
      member = Member.find_by(phone: params[:phone])
      # 並確認member存在並且密碼正確
      
      if member 
        if member.authenticate( params[:password] )
          # 回傳正確訊息
          render :json => { :message => "successed",
                            :id => "#{member.id}",
                            :first_name => member.first_name,
                            :last_name => member.last_name,
                            :phone => member.phone,
                            :coin => member.coin}     
        else
          # 回傳錯誤訊息
          render :json => { :message => "failed", 
                            :error => "密碼不正確" }, :status => 401
        end
      else
        # 回傳錯誤訊息
        render :json => { :message => "failed", 
                          :error => "此行動電話尚未註冊" }, :status => 401
      end
      
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
