require_relative '../spec_helper'
require_relative '../../services/bps/service/get_portfolios'

# TODO stub inner service call
describe 'GetPortfolios service' do
  before :context do
    @service = BPS::Service::GetPortfolios.instance
  end

  it 'is not nil' do
    expect(@service).not_to be_nil
  end

  describe 'execute' do
    it 'wont raise error' do
      @service.execute '0001032424'
    end

    it 'returns an array' do
      response = @service.execute '0001032424'
      expect(response).to be_kind_of Array
      expect(response.length).to be > 0
    end

    it 'returns an array with member containing several keys' do
      response = @service.execute '0001032424'
      expect(response.length).to be > 0

      item = response[0]
      expect(item).to have_key :cost_price
      expect(item).to have_key :current_price
      expect(item).to have_key :quantity
      expect(item).to have_key :symbol

      expect(item[:cost_price]).to be_kind_of Numeric
      expect(item[:current_price]).to be_kind_of Numeric
      expect(item[:quantity]).to be_kind_of Numeric
      expect(item[:symbol]).to be_kind_of String
    end

    it 'adds several keys to result array member' do
      response = @service.execute '0001032424'
      expect(response.length).to be > 0

      item = response[0]
      expect(item).to have_key :cost_value
      expect(item).to have_key :market_value
      expect(item).to have_key :gain_loss
      expect(item).to have_key :gain_loss_ratio

      expect(item[:cost_value]).to be_within(1e-6).of item[:quantity] * item[:cost_price]
      expect(item[:market_value]).to be_within(1e-6).of item[:quantity] * item[:current_price]
      expect(item[:gain_loss]).to be_within(1e-6).of item[:market_value] - item[:cost_value]
    end
  end
end
