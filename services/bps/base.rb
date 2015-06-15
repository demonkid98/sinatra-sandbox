require 'savon'
require 'logger'

module Services
  module BPS
    class Base
      attr_reader :client, :logger

      def initialize(url)
        @client = Savon.client(wsdl: url)
        @logger = Logger.new STDOUT
      end

      def call(method, params)
        message = {header: header}.merge params
        response = client.call(method, message: message)

        unless ok? response
          raise StandardError.new "[#{status(response)[:code]}] #{status(response)[:message]}"
        end
        parse response
      end

      def ok?(response)
        begin
          status(response)[:code].to_i >= 0
        rescue NoMethodError => e
          logger.error e
          false
        end
      end

      def status(response)
        result(response)[:status]
      end

      def result(response)
        raise NotImplementedError, '#result not implemented'
      end

      def parse(response)
        raise NotImplementedError, '#parse not implemented'
      end

      protected
      def header
        {'Username' => 'onlineadmin', 'Password' => 'onlineadmin@vnds'}
      end
    end
  end
end
