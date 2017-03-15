class ApiV1::MembersController < ApiController
  def show
    @member = Member.find(params[:id])
    # show.json.jbuilder
    
  end

  def create
    @member = Member.new( :first_name => params[:first_name],
                          :last_name => params[:last_name],
                          :phone => params[:phone],
                          :birthdate => params[:birthdate],
                          :password => params[:password], 
                          :password_confirmation => params[:password_confirmation])

    if @member.save
      
      #render :json => { :id =>"#{@member.id}" }
      render :json => { :message => "successed" }
    else
      
      render :json => { :message => "failed", :errors => @member.errors.full_messages.to_a }, :status => 400
    end
  end

  def update
    @member = Member.find( params[:id] )

    columns = [:first_name, :last_name, :birthdate]

    #if params.slice(*columns).keys.any?
    if columns.any?{ |c| params.key?(c) }
      columns.each do |column|
        @member[column] = params[column] if params[column]
      end

      if @member.save
        render :json => { :id => @member.id }
      else
        render :json => { :message => "failed", :errors => @member.errors }, :status => 400
      end

    else
      render :json => { :message => "no keys"}, :status => 400
    end
  end
end
