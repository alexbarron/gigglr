class AddTicketmasterIdToShows < ActiveRecord::Migration
  def change
    add_column :shows, :ticketmaster_id, :string
  end
end
