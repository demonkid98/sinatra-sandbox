require 'savon'
require 'singleton'
require 'logger'

module WS
  module Client
    class Base
      include Singleton

      attr_reader :client, :logger

      def initialize(url)
        @client = Savon.client(wsdl: url)
        @logger = Logger.new STDOUT
      end

      def call(method, params)
        message = {'in0' => header}.merge params
        client.call(method, message: message)
      end

      protected
      def header
        {'username' => 'vndirectadmin', 'password' => 'ipa4services'}
      end
    end
  end
end
