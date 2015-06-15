require 'logger'
require_relative './base'

class Services::BPS::OnlineTrading < Services::BPS::Base
  def initialize
    super 'http://10.26.53.91/BOProxyServiceNew/OnlineTradingService.asmx?wsdl'
  end

  def result(response)
    response.body[:get_accounts_response][:get_accounts_result]
  end

  def parse(response)
    begin
      result(response)[:get_accounts][:account].map do |account|
        account.select { |k, v| %i(account_number cash_available net_account_value purchase_power).include? k }
      end
    rescue NoMethodError => e
      logger.error e
      []
    end
  end
end
