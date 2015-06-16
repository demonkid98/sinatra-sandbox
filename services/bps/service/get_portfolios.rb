require_relative './base'
require_relative '../client/online_trading'

class BPS::Service::GetPortfolios < BPS::Service::Base
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
        sec[:cost_value] = sec[:cost_price] * sec[:quantity]
        sec[:market_value] = sec[:current_price] * sec[:quantity]
        sec[:gain_loss] = sec[:market_value] - sec[:cost_value]
        sec[:gain_loss_ratio] = sec[:cost_value] != 0 ? sec[:gain_loss] / sec[:cost_value] : 0
        sec
      end
    rescue NoMethodError => e
      logger.error e
      []
    end
  end
end
