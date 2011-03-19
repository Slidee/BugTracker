class CreateSprints < ActiveRecord::Migration
  def self.up
    create_table :sprints do |t|
      t.string :name
      t.string :slug
      t.text :goals
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :sprints, :slug, :unique => true
  end

  def self.down
    drop_table :sprints
  end
end
