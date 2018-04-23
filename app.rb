require 'sinatra'

get '/ping' do
  'pong'
end

@@store = {
    histories: [],
    accounts: {},
}

post '/v1/payments' do
  payload = JSON.parse(request.body.read)
  account = @@store[:accounts][payload['account_id']] || build_account
  updated_account = { balance: account[:balance] - payload['amount'] }
  @@store[:accounts][payload['account_id']] = updated_account
  201
end

def build_account
  { balance: rand(positive_balance_amount_range) }
end

def positive_balance_amount_range
  1..10000
end
