class CreateComedians < ActiveRecord::Migration
  def change
    create_table :comedians do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
