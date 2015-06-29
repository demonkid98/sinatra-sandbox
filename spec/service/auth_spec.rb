require_relative '../spec_helper'
require_relative '../../services/ws/service/auth'

# TODO stub inner service call
describe 'GetPortfolios service' do
  before :context do
    @service = WS::Service::Auth.instance
  end

  it 'is not nil' do
    expect(@service).not_to be_nil
  end

  describe 'execute' do
    it 'wont raise any error' do
      resp = @service.execute 'test02', '123456'
    end
  end
end
