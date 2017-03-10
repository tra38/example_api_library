require_relative '../http_request'

RSpec.describe HttpRequest do

  context "Successful GET Request" do

    before(:all) do
      RSpec::Mocks.with_temporary_scope do
        @original_json = %{{"propensity": 0.26532, "ranking": "C"}}
        mock_http_request = instance_double(Net::HTTPSuccess, :body => @original_json, code: 200)
        uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")
        allow(HttpRequest).to receive(:send_http_request).with(uri).and_return(mock_http_request)
        uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")

        @http_request = HttpRequest.get_request(uri)
      end
    end

    it "correctly receives and parses a JSON object if endpoint is working" do
      returned_json = @http_request[:response]
      expect(returned_json).to eq(@original_json)
    end

    it "returns correct HTTP code" do
      code = @http_request[:code]
      expect(code).to eq(200)
    end
  end

  context "Internal Service Error" do
    before(:all) do
      RSpec::Mocks.with_temporary_scope do
        @original_html = "<html><body><h3>Internal Service Error</h3><br />The website is currently down. Please try again later.</body></html>"
        mock_http_request = instance_double(Net::HTTPServerError, :body => @original_html, code: 500)
        uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")
        allow(HttpRequest).to receive(:send_http_request).with(uri).and_return(mock_http_request)
        uri = URI("https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35")

        @http_request = HttpRequest.get_request(uri)
      end
    end

    it "returns the HTML of the Internal Service Error" do
      returned_html = @http_request[:response]
      expect(@original_html).to eq(returned_html)
    end

    it "returns correct HTTP Code" do
      code = @http_request[:code]
      expect(code).to eq(500)
    end
  end

  context "API Endpoint Moved To New Location" do

    before(:all) do
      RSpec::Mocks.with_temporary_scope do
        @original_html = %{<html><body>You are being redirected.</body></html>}
        @original_json = %{{"propensity": 0.26532, "ranking": "C"}}

        old_url = "https://not_real.com/customer_scoring?income=50000&zipcode=6201&age=35"
        new_url = "https://not_real.com/v2/customer_scoring?income=50000&zipcode=6201&age=35"
        old_uri = URI(old_url)
        new_uri = URI(new_url)

        first_mock_http_request = instance_double(Net::HTTPRedirection, :body => @original_html, code: 301)
        allow(first_mock_http_request).to receive(:[]).with("location").and_return(new_url)

        second_mock_http_request = instance_double(Net::HTTPSuccess, :body => @original_json, code: 200)

        allow(HttpRequest).to receive(:send_http_request).with(old_uri) { first_mock_http_request }
        allow(HttpRequest).to receive(:send_http_request).with(new_uri) { second_mock_http_request }

        @http_request = HttpRequest.get_request(old_uri)
      end
    end

    it "correctly receives and parses a JSON object if endpoint is working" do
      returned_json = @http_request[:response]
      expect(returned_json).to eq(@original_json)
    end

    it "returns correct HTTP code" do
      code = @http_request[:code]
      expect(code).to eq(200)
    end
  end

  context "API Endpoint Stuck In Redirection Loop" do

    it "escapes from the redirection loop by raising an Error" do
      RSpec::Mocks.with_temporary_scope do

        @original_html = %{<html><body>You are being redirected.</body></html>}
        @original_json = %{{"propensity": 0.26532, "ranking": "C"}}

        old_url = "https://not_real.com/v1_hm_maybe_v2_sounds_pretty_cool/customer_scoring?income=50000&zipcode=6201&age=35"
        new_url = "https://not_real.com/v2_hm_maybe_i_like_v1_better/customer_scoring?income=50000&zipcode=6201&age=35"
        old_uri = URI(old_url)
        new_uri = URI(new_url)

        first_mock_http_request = instance_double(Net::HTTPRedirection, :body => @original_html, code: 301)
        allow(first_mock_http_request).to receive(:[]).with("location").and_return(new_url)

        second_mock_http_request = instance_double(Net::HTTPRedirection, :body => @original_json, code: 301)
        allow(second_mock_http_request).to receive(:[]).with("location").and_return(old_url)

        allow(HttpRequest).to receive(:send_http_request).with(old_uri) { first_mock_http_request }
        allow(HttpRequest).to receive(:send_http_request).with(new_uri) { second_mock_http_request }

        expect { @http_request = HttpRequest.get_request(old_uri) }.to raise_error(RuntimeError)
      end
    end

  end

end
