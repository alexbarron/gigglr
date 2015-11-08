class AddAddressAttributessToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :street_address, :string
    add_column :venues, :city, :string
    add_column :venues, :state, :string
    add_column :venues, :zip, :string
  end
end
