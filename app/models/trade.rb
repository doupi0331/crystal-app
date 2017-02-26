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
  validates :amount, presence: true
  validates :creator, presence: true
  
  # fields
  field :trade_date, type: Date
  field :trade_type, type: String
  field :trade_name, type: String
  field :total, type: Integer
  field :product, type: String
  field :amount, type: Integer
  field :current_price, type: Integer
  field :creator, type: String

  def self.grouped(id)
    map = %Q{
      function() {
        emit({ trade_date: this.trade_date, trade_type: this.trade_type, trade_name: this.trade_name}, { total: this.total });
      }
    }
    
    reduce = %Q{
      function(key, values) {
        var result = { total: 0 };
        values.forEach(function(value) {
          result.total += value.total;
        });
        return result;
      }
    }
    
   trades = self.where(:member_id => id).map_reduce(map, reduce).out(:inline => true).to_a
   
   return trades.sort_by{ |hsh| hsh[:_id][:trade_date] }.reverse! 
   
  end
end
