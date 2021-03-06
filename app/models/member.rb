class Member
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  
  # relations
  has_many :trades, dependent: :destroy
  
  # validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 10 }
  validates :phone, presence: true, uniqueness: {case_sensitive: false}
  validates :birthdate, presence: true
  
  has_secure_password
  
  # fields
  field :first_name, type: String
  field :last_name, type: String
  field :birthdate, type: Date
  field :phone, type: String
  field :password_digest, type: String
  field :coin, type: Integer, default: 0
  field :total_coin, type: Integer, default: 0
  
  def full_name
    return "#{last_name}#{first_name}"
  end
  
  def add_coin(coin, creator)
    self.coin += coin
    self.total_coin += coin
    logger.debug self.coin
    
    trades = Trade.where(:trade_date => Date.today, :trade_type => "I", :member_id => self.id, :product => "現金加值").limit(1)
    
    logger.debug trades.to_json
    
    if trades.size > 0 
      trades.each do |trade|
        trade.current_price += coin
        trade.total += coin
        return self.save && trade.save
      end
    else
      trade = self.trades.new
      trade.trade_date = Date.today
      trade.trade_type = "I"
      trade.trade_name = "加值"
      trade.product = "現金加值"
      trade.current_price = coin
      trade.amount = 1
      trade.total = coin
      trade.creator = creator   
      return self.save && trade.save 
    end
  end
  
  def reverse(trade_type, total)
    if trade_type == "I"
      self.coin -= total
      self.total_coin -= total
      if self.coin < 0
        return false
      end
    else
      self.coin += total
      self.total_coin += total
    end
    
    return self.save
  end
  
  def self.search(param)
    return Member.none if param.blank?
    
    param.strip! #清除空白
    param.downcase!
    
    return phone_matches(param)
  end
  
  def self.phone_matches(param)
    return matches('phone', param)
  end
  
  def self.matches(field_name, param)
    return where("#{field_name}" => /.*#{param}.*/i)
  end

end
