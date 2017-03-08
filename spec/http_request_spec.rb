require_relative '../http_request'

RSpec.describe HttpRequest do

  context "Successful GET Request" do

    it "correctly receives a JSON object if endpoint is working" do
      json_object = %{{"propensity": 0.26532, "ranking": "C"}}
      mock_http_request = double(:body => json_object, code: 200)
      allow(Net::HTTP).to receive(:start).and_return(mock_http_request)
      uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")
      expect(HttpRequest.get_request(uri)).to eq(json_object)
    end
  end


end
