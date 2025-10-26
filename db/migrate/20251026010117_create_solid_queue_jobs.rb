class CreateSolidQueueJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :solid_queue_jobs do |t|
      t.string :queue_name, null: false
      t.text :payload, null: false
      t.integer :priority, default: 0, null: false
      t.integer :attempts, default: 0, null: false
      t.datetime :run_at
      t.datetime :failed_at
      t.datetime :locked_at
      t.string :locked_by
      t.timestamps
    end

    add_index :solid_queue_jobs, :queue_name
    add_index :solid_queue_jobs, :run_at
    add_index :solid_queue_jobs, :locked_at
  end
end
