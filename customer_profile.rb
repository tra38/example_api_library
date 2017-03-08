require 'net/http'
require 'json'
require 'pry'


class CustomerProfile
  attr_reader :age, :income, :zipcode, :propensity, :ranking

  def initialize(age:, income:, zipcode:)
    @age = age
    @income = income
    @zipcode = zipcode
  end

end