require 'faraday'
require 'faraday_middleware'

class ApiConnection
  class << self
    def url
      "#{endpoint}/api/v1"
    end

    def client
      @client ||= new_connection
    end

    private

    def new_connection
      Faraday.new(url: url) do |faraday|
        faraday.use :instrumentation
        faraday.headers['Content-Type'] = 'application/json'

        faraday.response :json, parser_options: { symbolize_names: true },
                                content_type: /\bjson$/
        faraday.adapter :net_http
      end
    end
  end
end