class AddProjectIdToSprints < ActiveRecord::Migration
  def self.up
    add_column :sprints, :project_id, :integer
    add_index :sprints, :project_id
  end

  def self.down
    remove_column :sprints, :project_id
  end
end
