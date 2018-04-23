require 'sinatra'

get '/ping' do
  'pong'
end

post '/v1/payments' do
  puts JSON.parse(request.body.read)
  201
end
