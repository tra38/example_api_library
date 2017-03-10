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
    http_request_code = http_request[:code]
    if http_request_code >= 200 && http_request_code < 400
      JSON.parse(http_request[:response])
    elsif http_request_code >= 400 && http_request_code < 500
      message = JSON.parse(http_request[:response])["message"]
      raise "The server rejects the request. HTTP Response Code: #{http_request_code}. Message: #{message}"
    elsif http_request_code >= 500
      raise "The API server is currently down. HTTP Response Code: #{http_request_code}."
    else
      raise "An unknown error has occurred. HTTP Response Code: #{http_request}"
    end
  end

end