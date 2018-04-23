require 'sinatra'

get '/ping' do
  'pong'
end

post '/v1/payments' do
  'created'
end
