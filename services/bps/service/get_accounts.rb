require 'logger'
require_relative './base'
require_relative '../client/online_trading'

class BPS::Service::GetAccounts < BPS::Service::Base
  def initialize
    super(BPS::Client::OnlineTrading.instance)
  end

  def execute(customer_id)
    response = client.call :get_accounts, customerId: customer_id
    raise StandardError.new(status(response)[:message]) unless ok? response
    parse response

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
