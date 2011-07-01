class CreateDelayedJobs < ActiveRecord::Migration
  def change
    create_table :delayed_jobs, :force => true do |t|
      t.integer  :priority, :default => 0      # Allows some jobs to jump to the front of the queue
      t.integer  :attempts, :default => 0      # Provides for retries, but still fail eventually.
      t.text     :handler                      # YAML-encoded string of the object that will do work
      t.text     :last_error                   # reason for last failure (See Note below)
      t.datetime :run_at                       # When to run. Could be Time.zone.now for immediately, or sometime in the future.
      t.datetime :locked_at                    # Set when a client is working on this object
      t.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
      t.string   :locked_by                    # Who is working on this object (if locked)
      t.timestamps
    end
	
    add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'
  end
end