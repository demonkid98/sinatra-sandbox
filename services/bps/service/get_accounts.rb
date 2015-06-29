require_relative '../../base_service'
require_relative '../client/online_trading'

module BPS
  module Service
    class GetAccounts < BaseService
      def initialize
        super BPS::Client::OnlineTrading.instance
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
            account.select! do |k, v|
              %i(account_number cash_available net_account_value purchase_power real_money).include? k
            end.each do |k, v|
              account[k] = v.to_f if %i(cash_available net_account_value purchase_power real_money).include? k
            end
          end
        rescue NoMethodError => e
          logger.error e
          []
        end
      end
    end
  end
end
