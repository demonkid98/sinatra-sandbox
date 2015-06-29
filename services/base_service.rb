require 'singleton'

class BaseService
  include Singleton

  attr_reader :client, :logger

  def initialize(client)
    @client = client
    @logger = Logger.new STDOUT
  end

  def ok?(response)
    begin
      status(response)[:code].to_i == 0
    rescue NoMethodError => e
      logger.error e
      false
    end
  end

  def status(response)
    result(response)[:status] || result(response)[:msg_status]
  end

  def execute(response)
    raise NotImplementedError, '#execute not implemented'
  end

  def result(response)
    raise NotImplementedError, '#result not implemented'
  end

  def parse(response)
    raise NotImplementedError, '#parse not implemented'
  end
end
