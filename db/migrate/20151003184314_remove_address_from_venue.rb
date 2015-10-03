class RemoveAddressFromVenue < ActiveRecord::Migration
  def change
  	remove_column :venues, :address
  end
end
