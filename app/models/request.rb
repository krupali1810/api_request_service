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

  private

  def set_default_status
    self.status ||= "pending"
  end
end