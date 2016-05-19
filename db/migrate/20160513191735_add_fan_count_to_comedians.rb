class AddFanCountToComedians < ActiveRecord::Migration
  def change
    add_column :comedians, :fan_count, :integer, default: 0
    update "UPDATE comedians SET fan_count = (SELECT COUNT(*) FROM relationships WHERE relationships.comedian_id = comedians.id)"
  end
end
