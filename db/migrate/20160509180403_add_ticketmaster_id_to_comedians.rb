class AddTicketmasterIdToComedians < ActiveRecord::Migration
  def change
    add_column :comedians, :ticketmaster_id, :string
  end
end
