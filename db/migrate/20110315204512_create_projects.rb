class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :slug
      t.string :logo
      t.text :description
      t.integer :user_id

      t.timestamps
    end
    add_index :projects, :slug, :unique => true
  end

  def self.down
    drop_table :projects
  end
end
