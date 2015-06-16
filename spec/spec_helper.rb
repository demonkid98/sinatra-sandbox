require 'simplecov'
require 'rack/test'
require 'rspec'

SimpleCov.start

require_relative '../app'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }
