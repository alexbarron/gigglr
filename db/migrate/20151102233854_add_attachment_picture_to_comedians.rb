class AddAttachmentPictureToComedians < ActiveRecord::Migration
  def self.up
    change_table :comedians do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :comedians, :picture
  end
end
