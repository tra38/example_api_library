require_relative '../lib/customer_profile'

RSpec.describe CustomerProfile do

  context "generate a profile for a 35-year old with an income of $50,000 living in 6201" do
    before(:all) do
      RSpec::Mocks.with_temporary_scope do
        json_object = %{{"propensity": 0.26532, "ranking": "C"}}
        uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")
        allow(HttpRequest).to receive(:get_request).with(uri) { { code: 200, response: json_object } }
        @library = CustomerProfile.new(age: 35, income: 50_000, zipcode: 6201)
      end
    end

    it "can generate a proper query string for not_real.com" do
      expect(@library.get_request_uri.query).to eq("income=50000&zipcode=6201&age=35")
    end

    it "can find ranking" do
      expect(@library.ranking).to eq("C")
    end

    it "can find propensity" do
      expect(@library.propensity).to eq(0.26532)
    end
  end

  context "5XX Server Error (Internal Service Error)" do
    it "raises a RuntimeError" do
      RSpec::Mocks.with_temporary_scope do
        html = "<html><body><h3>Internal Service Error</h3><br />The website is currently down. Please try again later.</body></html>"
        uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")
        allow(HttpRequest).to receive(:get_request).with(uri) { { code: 500, response: html } }
        expect { @library = CustomerProfile.new(age: 35, income: 50_000, zipcode: 6201) }.to  raise_error(RuntimeError, /The API server is currently down. HTTP Response Code: 500./)
      end
    end
  end

  context "4XX Client Error" do
    it "raises a RuntimeError" do
      RSpec::Mocks.with_temporary_scope do
        @original_json = %{{"message": "We do not have any information on this type of person."}}
        mock_http_request = instance_double(Net::HTTPClientError, :body => @original_json, code: 400)
        uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")
        allow(HttpRequest).to receive(:send_http_request).with(uri).and_return(mock_http_request)
        expect { @library = CustomerProfile.new(age: 35, income: 50_000, zipcode: 6201) }.to  raise_error(RuntimeError, /Message: We do not have any information on this type of person./)
      end
    end
  end

end