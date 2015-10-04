class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.text :description
      t.datetime :showtime
      t.integer :venue_id
      t.timestamps null: false
    end
  end
end
