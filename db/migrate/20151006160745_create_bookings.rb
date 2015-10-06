class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :comedian_id
      t.integer :show_id

      t.timestamps null: false
    end
    add_index :bookings, :comedian_id
    add_index :bookings, :show_id
    add_index :bookings, [:comedian_id, :show_id], unique: true
  end
end
