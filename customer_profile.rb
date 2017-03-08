require 'net/http'
require 'json'
require_relative 'http_request'

class CustomerProfile
  attr_reader :age, :income, :zipcode, :propensity, :ranking

  def initialize(age:, income:, zipcode:)
    @age = age
    @income = income
    @zipcode = zipcode
    json = JSON.parse(HttpRequest.get_request(get_request_uri))
    @propensity = json["propensity"]
    @ranking = json["ranking"]
  end

  def get_request_uri
    URI("https://not_real.com/customer_scoring?income=#{income}&zipcode=#{zipcode}&age=#{age}")
  end

end