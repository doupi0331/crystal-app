class Trade
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # relations
  belongs_to :member
  
  # validations
  validates :trade_date, presence: true
  validates :trade_type, presence: true, length: { minimum: 1, maximum: 2 }
  validates :trade_name, presence: true, length: { minimum: 1, maximum: 20 }
  validates :total, presence: true
  validates :creator, presence: true
  
  # fields
  field :trade_date, type: Date
  field :trade_type, type: String
  field :trade_name, type: String
  field :total, type: Integer
  field :creator, type: String

end
