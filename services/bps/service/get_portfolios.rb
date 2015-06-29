require_relative '../../base_service'
require_relative '../client/online_trading'

module BPS
  module Service
    class GetPortfolios < BaseService
      def initialize
        super BPS::Client::OnlineTrading.instance
      end

      def execute(account_number)
        response = client.call :get_portfolios, contractNo: account_number
        raise StandardError.new(status(response)[:message]) unless ok? response
        parse response

      end

      def result(response)
        response.body[:get_portfolios_response][:get_portfolios_result]
      end

      def parse(response)
        begin
          result(response)[:list_portfolio][:portfolio].map do |sec|
            sec.select! do |k, v|
              %i(cost_price current_price symbol quantity).include? k
            end.each do |k, v|
              sec[k] = v.to_f if %i(cost_price current_price quantity).include? k
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
