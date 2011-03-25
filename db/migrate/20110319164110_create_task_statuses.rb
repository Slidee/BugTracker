class CreateTaskStatuses < ActiveRecord::Migration
  def self.up
    create_table :task_statuses do |t|
      t.string :name
      t.string :type_enum

      t.timestamps
    end

    add_index :task_statuses, :type_enum
  end

  def self.down
    drop_table :task_statuses
  end
end
