require 'sinatra'
require 'json'
require 'savon'

enable :sessions

Dir["#{Dir.pwd}/services/bps/service/*.rb"].each {|f| require f}


configure do
  set :bind, '0.0.0.0'
  set :session_secret, 'a secret'
  set :show_exceptions, :after_handler
end

get '/' do
  'Hi world'
end

get '/accounts' do
  content_type :json
  session['customer_id'] = '0001715094' unless session.key? 'customer_id'

  service = BPS::Service::GetAccounts.instance

  accounts = service.execute session['customer_id']

  accounts.to_json
end

error StandardError do |e|
  halt 500, e.message
end
