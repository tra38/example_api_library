#Leapfrog API Challenge

This API will allow you to query ```not_real.com``` and gather information about a specific customer.

##Requirements:
- Ruby 2.2.2
- RSpec

###Setup Instructions

1. ```git clone``` the repo.
2. ```bundle install``` to get all the dependencies

###Usage Instructions

This library requires internet access.

```ruby
require_relative 'path/to/lib/customer_profile'

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

Note that age, income, and zipcode is **required** to be able to use this library.

When you create a new CustomerProfile object, we perform an API call to not_real.com. If the API server is down (5XX Server Errors) or the client's request fails for other reasons (4XX Client Errors), an error will be raised informing you of the situation.

```http_request.rb```, a file that ```customer_profile.rb``` is using to help query the API, may warn you if the API has moved to a different location (or raise a seperate error in case too many redirections occur).

###Automated Tests
To run the test suite, simply type ```rspec``` in the terminal.

```bash
>rspec

..............

Finished in 0.02442 seconds (files took 0.25255 seconds to load)
14 examples, 0 failures
```