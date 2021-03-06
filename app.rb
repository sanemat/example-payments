require 'sinatra'
require 'securerandom'
require 'time'

get '/ping' do
  'pong'
end

class Store
  @@histories = []
  @@accounts = {}
end

post '/v1/payments' do
  payload = JSON.parse(request.body.read)
  transaction_id = SecureRandom.uuid
  existed_accounts = Store.class_variable_get(:@@accounts)
  account = existed_accounts[payload['account_id']] || build_account
  balanced_at_epoc = Time.now.to_f
  balance = account[:balance] + payload['amount']
  updated_account = { balance: balance }
  existed_accounts[payload['account_id']] = updated_account
  Store.class_variable_set(:@@accounts, existed_accounts)
  log = build_transaction_log(
          producer_id: payload['producer_id'],
          transaction_id: transaction_id,
          account_id: payload['account_id'],
          amount: payload['amount'],
          balance: balance,
          balanced_at_epoc: balanced_at_epoc,
        )
  Store.class_variable_set(:@@histories, Store.class_variable_get(:@@histories).push(log))

  status :created
  body JSON.generate(log)
end

def build_transaction_log(producer_id:, transaction_id:, account_id:, amount:, balance:, balanced_at_epoc:)
  {
    producer_id: producer_id,
    transaction_id: transaction_id,
    account_id: account_id,
    amount: amount,
    side: amount >= 0 ? 'topup' : 'payment',
    balance: balance,
    balanced_at_epoc: balanced_at_epoc,
  }
end

def build_account
  { balance: rand(positive_balance_amount_range) }
end

def positive_balance_amount_range
  1..10000
end
