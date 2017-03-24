json.results do
  json.array!(@trades) do |trade|
    json.partial! 'api_v1/trades/trade', trade: trade
  end
end