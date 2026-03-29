require 'rails_helper'

RSpec.describe "Requests API", type: :request do
  let(:headers) { { "Idempotency-Key" => "abc123" } }

  it "creates a new request" do
    post "/api/v1/requests", params: { data: { name: "test" } }, headers: headers

    expect(response).to have_http_status(:accepted)
    expect(Request.count).to eq(1)
  end

  it "returns existing request for duplicate idempotency key" do
    Request.create!(idempotency_key: "abc123", payload: { name: "test" })

    post "/api/v1/requests", params: { data: { name: "test" } }, headers: headers

    expect(response).to have_http_status(:ok)
    expect(Request.count).to eq(1)
  end

  it "returns bad request if idempotency key missing" do
    post "/api/v1/requests", params: { data: { name: "test" } }

    expect(response).to have_http_status(:bad_request)
  end
end