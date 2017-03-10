require 'net/http'
require 'json'
require_relative 'http_request'

class CustomerProfile
  attr_reader :age, :income, :zipcode, :propensity, :ranking

  def initialize(age:, income:, zipcode:)
    @age = age
    @income = income
    @zipcode = zipcode

    json = acquire_json

    if json
      @propensity = json["propensity"]
      @ranking = json["ranking"]
    end
  end

  def get_request_uri
    URI("https://not_real.com/customer_scoring?income=#{income}&zipcode=#{zipcode}&age=#{age}")
  end

  def acquire_json
    http_request = HttpRequest.get_request(get_request_uri)
    code = http_request[:code]
    if request_successful?(code)
      JSON.parse(http_request[:response])
    elsif client_error?(code)
      message = JSON.parse(http_request[:response])["message"]
      raise "The server rejects the request. HTTP Response Code: #{code}. Message: #{message}"
    else
      raise "The API server is currently down. HTTP Response Code: #{code}."
    end
  end

  private
  def request_successful?(code)
    code.between?(200, 399)
  end

  def client_error?(code)
    code.between?(400,499)
  end

end