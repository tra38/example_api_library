require 'net/http'

module HttpRequest
  class InvalidResponse < StandardError; end

  class << self

    # Source: http://ruby-doc.org/stdlib-2.1.2/libdoc/net/http/rdoc/Net/HTTP.html#class-Net::HTTP-label-HTTPS
    def get_request(uri, limit = 10)

      raise "Redirect limit exceeded" if limit == 0

      response = send_http_request(uri)

      response_code = response.code.to_i

      case
      when is_redirect?(response_code)
        new_location_url = response["location"]
        warn "redirected to #{new_location_url}"
        new_location_uri = URI(new_location_url)
        get_request(new_location_uri, limit - 1)
      else
        {
          code: response_code,
          response: response.body
        }
      end
    end

    def is_redirect?(response_code)
      response_code.between?(300, 399)
    end

    private
    def send_http_request(uri)
      request = Net::HTTP::Get.new(uri)

      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end
    end

  end

end