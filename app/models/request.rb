class Request < ApplicationRecord
  # ENUM
  enum status: {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed",
    cancelled: "cancelled"
  }

  # VALIDATIONS
  validates :idempotency_key, presence: true, uniqueness: true
  validates :status, presence: true
  validates :payload, presence: true

  # CALLBACKS
  before_validation :set_default_status, on: :create

  # IDEMPOTENCY
  def already_processed?
    completed?
  end

  # CONCURRENCY SAFE PROCESSING
  def start_processing!
    with_lock do
      return if processing? || completed? || cancelled?

      update!(status: :processing)
    end
  end

  def mark_completed!(result_data)
    update!(
      status: :completed,
      result: result_data,
      processed_at: Time.current
    )
  end

  def mark_failed!(error)
    update!(
      status: :failed,
      error_message: error.message
    )
  end

  def cancel!
    update!(
      status: :cancelled,
      cancelled_at: Time.current
    )
  end

  # RETRY TRACKING
  def increment_retry!
    increment!(:retry_count)
  end

  private

  def set_default_status
    self.status ||= "pending"
  end
end