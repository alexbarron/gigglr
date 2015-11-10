class AddDistancePreferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :distance_pref, :integer,  null: false, default: 20
  end
end
