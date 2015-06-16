require_relative './base'

class BPS::Client::OnlineTrading < BPS::Client::Base
  def initialize
    # TODO make it a config
    super 'http://10.26.53.91/BOProxyServiceNew/OnlineTradingService.asmx?wsdl'
  end
end
