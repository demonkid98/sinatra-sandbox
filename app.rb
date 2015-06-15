require 'sinatra'
require 'json'
require 'savon'

enable :sessions

configure do
  set :session_secret, 'a secret'
  set :show_exceptions, :after_handler
end

get '/' do
  'Hi world'
end

get '/accounts' do
  content_type :json
  session['customer_id'] = '0001715094' unless session.key? 'customer_id'

  require_relative 'services/bps/online_trading'
  service = Services::BPS::OnlineTrading.new

  accounts = service.call :get_accounts, customerId: session['customer_id']

  accounts.to_json
end

error StandardError do |e|
  halt 500, e.message
end
