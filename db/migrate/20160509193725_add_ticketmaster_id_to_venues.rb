class AddTicketmasterIdToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :ticketmaster_id, :string
  end
end
