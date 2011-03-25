class CreateTaskPriorities < ActiveRecord::Migration
  def self.up
    create_table :task_priorities do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
    add_index :task_priorities, :position, :unique => true
  end

  def self.down
    drop_table :task_priorities
  end
end
