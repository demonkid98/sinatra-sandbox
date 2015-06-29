require_relative './base'

class WS::Client::OnlineUser < WS::Client::Base
  def initialize
    # TODO make it a config
    super 'http://10.26.53.32/webservice/OnlineUserService?wsdl'
  end
end
