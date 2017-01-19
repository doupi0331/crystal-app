class Member
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  
  # validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 10 }
  validates :phone, presence: true
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
