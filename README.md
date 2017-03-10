#Leapfrog API Challenge

This API will allow you to query ```not_real.com``` and gather information about a specific customer.

##Requirements:
- Ruby 2.2.2
- RSpec

###Setup Instructions

1. ```git clone``` the repo.
2. ```bundle install``` to get all the dependencies

###Usage Instructions

```ruby
require_relative 'customer_profile'

profile = CustomerProfile.new(age: 35, income: 50_000, zipcode: 6201)

profile.age
=>35

profile.income
=>50000

profile.zipcode
=>6201

profile.propensity
=>0.26532

profile.ranking
=>"C"
```

