require 'savon'
require 'singleton'
require 'logger'

module BPS
  module Client
    class Base
      include Singleton

      attr_reader :client, :logger

      def initialize(url)
        @client = Savon.client(wsdl: url)
        @logger = Logger.new STDOUT
      end

      def call(method, params)
        message = {header: header}.merge params
        client.call(method, message: message)
      end

      protected
      def header
        {'Username' => 'onlineadmin', 'Password' => 'onlineadmin@vnds'}
      end
    end
  end
end
