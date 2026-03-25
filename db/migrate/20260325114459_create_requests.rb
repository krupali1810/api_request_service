class CreateRequests < ActiveRecord::Migration[7.1]
 	def change
    create_table :requests do |t|
      t.string  :idempotency_key, null: false
      t.string  :status, null: false, default: "pending"
      t.jsonb   :payload, null: false, default: {}
      t.jsonb   :result
      t.string  :error_message
      t.integer :retry_count, null: false, default: 0
      t.datetime :processed_at
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :requests, :idempotency_key, unique: true
    add_index :requests, :status
  end
end
