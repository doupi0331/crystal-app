class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # relations
  belongs_to :prod_type
  
  # validations
  validates :name, presence: true, 
                   length: { minimum: 1, maximum: 50 },
                   uniqueness: {case_sensitive: false}
  validates :price, presence: true
  validates :creator, presence: true
  
  # fields
  field :name, type: String
  field :price, type: Integer
  field :creator, type: String
  
  def self.search(param)
    return Product.none if param.blank?
    
    param.strip! #清除空白
    param.downcase!
    
    return prod_type_matches(param)
  end
  
  def self.prod_type_matches(param)
    return matches('prod_type_id', param)
  end
  
  def self.matches(field_name, param)
    return where("#{field_name}" => param)
  end
  
end
