json.results do
  json.array!(@trades) do |trade|
    json.partial! 'trade_detail', trade: trade
  end
end