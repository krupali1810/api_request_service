class ProcessRequestJob < ApplicationJob
  queue_as :default

  # Retry only for temporary failures
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform(request_id)
    request = Request.find_by(id: request_id)
    return unless request

    return if request.completed? || request.cancelled?

    request.start_processing!

    result = process_payload(request.payload)

    request.mark_completed!(result)

  rescue TemporaryError => e
    request.increment_retry!
    raise e

  rescue => e
    request.mark_failed!(e)
  end

  private

  # Simulated external processing
  def process_payload(payload)
    # Simulate delay
    sleep(2)

    # Simulate random failure
    if rand < 0.2
      raise TemporaryError, "Temporary failure, retrying..."
    end
    {
      message: "Processed successfully",
      input: payload
    }
  end

  # Custom error for retryable failures
  class TemporaryError < StandardError; end
end