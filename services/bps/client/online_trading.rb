require 'logger'
require 'singleton'
require_relative './base'

class BPS::Client::OnlineTrading < BPS::Client::Base
  include Singleton
  def initialize
    super 'http://10.26.53.91/BOProxyServiceNew/OnlineTradingService.asmx?wsdl'
  end
end
