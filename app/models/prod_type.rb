class ProdType
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # relations
  has_many :products, order: :price.asc
  
  # validations
  validates :name, presence: true, 
                   length: { minimum: 1, maximum: 10 },
                   uniqueness: {case_sensitive: false}
  validates :creator, presence: true
  
  # fields
  field :name, type: String
  field :creator, type: String
  
end
