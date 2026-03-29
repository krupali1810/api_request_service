require 'rails_helper'

RSpec.describe Request, type: :model do
  it "is valid with valid attributes" do
    request = Request.new(
      idempotency_key: "abc123",
      payload: { name: "test" }
    )
    expect(request).to be_valid
  end

  it "is invalid without idempotency_key" do
    request = Request.new(payload: { name: "test" })
    expect(request).not_to be_valid
  end

  it "prevents duplicate idempotency_key" do
    Request.create!(idempotency_key: "abc", payload: { name: "test" })
    duplicate = Request.new(idempotency_key: "abc", payload: { name: "test" })

    expect(duplicate).not_to be_valid
  end

  it "transitions to processing safely" do
    request = Request.create!(idempotency_key: "key1", payload: { name: "test" })

    request.start_processing!
    expect(request.status).to eq("processing")
  end
end