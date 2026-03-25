class AddStatusCheckConstraint < ActiveRecord::Migration[7.1]
  def change
  	execute <<-SQL
      ALTER TABLE requests
      ADD CONSTRAINT status_check
      CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled'));
    SQL
  end
end
