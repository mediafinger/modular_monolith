RSpec.describe StatusController, type: :request do
  let(:request_id) { "request_id-12345" }
  let(:headers) do
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "HTTP_X_REQUEST_ID" => request_id,
    }
  end

  describe "GET /alive" do
    subject(:get_alive) { get "/alive", params: {}, headers: headers }

    it "returns 200" do
      get_alive
      expect(response.status).to eq 200
    end

    it "sets the Content-Type" do
      get_alive

      expect(response.headers["Content-Type"]).to eq("application/json")
    end

    it "sets a new request_id" do
      get "/alive"

      expect(response.headers["X-Request-Id"]).not_to be_nil
    end

    it "keeps the given request_id" do
      get_alive

      expect(response.headers["X-Request-Id"]).to eq(request_id)
    end

    it "stores the path" do
      expect(Current).to receive(:path=).with("/alive")

      get_alive
    end

    it "stores the module_name" do
      expect(Current).to receive(:module_name=).with("App")

      get_alive
    end
  end

  describe "GET /ready" do
    subject(:get_ready) { get "/ready", params: {}, headers: headers }

    it "returns 200" do
      get_ready
      expect(response.status).to eq 200
    end

    context "when DB not available" do
      pending "responds 503 without body" do
        get_ready

        expect(response.status).to eq 503
      end
    end
  end

  describe "GET /version" do
    subject(:get_version) { get "/", params: {}, headers: headers } # currently set to root /

    it "returns 200" do
      get_version

      expect(response.status).to eq 200
    end

    it "reponds with the version a json" do
      get_version

      expect(response.body).to match(/test-/)
    end
  end
end
