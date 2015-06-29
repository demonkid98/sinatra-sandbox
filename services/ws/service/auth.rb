require_relative '../../base_service'
require_relative '../client/online_user'

module WS
  module Service
    class Auth < BaseService
      def initialize
        super WS::Client::OnlineUser.instance
      end

      def execute(username, password)
        response = client.call :check_auth, 'in1' => {'userName' => username, 'password' => password}
        raise StandardError.new(status(response)[:message]) unless ok? response

        response
        parse response
      end

      def result(response)
        response.body[:check_auth_response][:out]
      end

      def parse(response)
        begin
          profile = result(response)[:user_profile]
          {
            customer_id: profile[:customer_id].to_s,
            full_name: profile[:full_name].to_s,
            email: profile[:email].to_s
          }
        rescue NoMethodError => e
          logger.error e
          {}
        end
      end
    end
  end
end
