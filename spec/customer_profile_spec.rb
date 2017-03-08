require './customer_profile'

RSpec.describe CustomerProfile do

  context "generate a profile for a 35-year old with an income of $50,000 living in 6201" do
    before(:all) do
      RSpec::Mocks.with_temporary_scope do
        json_object = %{{"propensity": 0.26532, "ranking": "C"}}
        uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")
        allow(HttpRequest).to receive(:get_request).with(uri) { json_object }
        @library = CustomerProfile.new(age: 35, income: 50_000, zipcode: 6201)
      end
    end

    it "can generate a proper URI for not_real.com" do
      expect(@library.get_request_uri.query).to eq("income=50000&zipcode=6201&age=35")
    end

    it "can find ranking" do
      expect(@library.ranking).to eq("C")
    end

    it "can find propensity" do
      expect(@library.propensity).to eq(0.26532)
    end
  end

end

# Hm.

# User should query http://not-real.com/customer_sourcing?income=50000&zipcode=6201&age=35
# and receive a JSON object
# {
  # "propensity": 0.26532,
  # "ranking": C
# }

#