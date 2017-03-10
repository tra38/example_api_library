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
require_relative 'path/to/customer_profile'

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

When you create a new CustomerProfile object, we perform an API call to not_real.com. If the API call fails (Internal Service Error) or the API is unable to determine profile information (4XX Client Error), an error will be raised informing you of the situation.

```http_request.rb```, a file that ```customer_profile.rb``` is using to help query the API, may warn you if the API has moved to a different location (or raise a seperate error in case too many redirections occur).