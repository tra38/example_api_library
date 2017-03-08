module HttpRequest
  class InvalidResponse < StandardError; end

  def self.get_request(uri)
    request = Net::HTTP::Get.new(uri)

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    if response.code.to_i >= 200 && response.code.to_i < 400
      response.body
    else
      raise HttpRequest::InvalidResponse
    end
  end

end