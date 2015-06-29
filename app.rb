require 'sinatra'
require 'json'
require 'savon'

enable :sessions

Dir["#{Dir.pwd}/services/bps/service/*.rb"].each {|f| require f}
Dir["#{Dir.pwd}/services/ws/service/*.rb"].each {|f| require f}


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

  service.execute(session['customer_id']).to_json
end

get '/accounts/:account_number/portfolio' do
  content_type :json

  # TODO before_filter to check if account belongs to customer

  service = BPS::Service::GetPortfolios.instance

  service.execute(params[:account_number]).to_json
  # TODO token generation
end

post '/auth' do
  content_type :json
  request.body.rewind
  @payload = JSON.parse request.body.read

  service = WS::Service::Auth.instance

  service.execute(@payload['username'], @payload['password']).to_json
end

error StandardError do |e|
  halt 500, e.message
end
