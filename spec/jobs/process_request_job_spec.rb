require 'rails_helper'

RSpec.describe ProcessRequestJob, type: :job do
  it "processes request successfully" do
    request = Request.create!(idempotency_key: "key1", payload: { name: "test" })

    allow_any_instance_of(ProcessRequestJob)
      .to receive(:process_payload)
      .and_return({ success: true })

    described_class.perform_now(request.id)

    request.reload
    expect(request.status).to eq("completed")
  end

  it "does not reprocess completed request" do
    request = Request.create!(
      idempotency_key: "key2",
      payload: { name: "test" },
      status: "completed"
    )

    described_class.perform_now(request.id)

    expect(request.reload.status).to eq("completed")
  end

  it "increments retry count on failure" do
    request = Request.create!(idempotency_key: "key3", payload: { name: "test" })

    allow_any_instance_of(ProcessRequestJob)
      .to receive(:process_payload)
      .and_raise(StandardError)

    expect {
      described_class.perform_now(request.id)
    }.not_to raise_error

    expect(request.reload.status).to eq("failed")
  end
end