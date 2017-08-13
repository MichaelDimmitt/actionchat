class AddPrivateAndUseridsToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :is_private, :boolean, default: false
    add_column :rooms, :user1, :integer, default: nil
    add_column :rooms, :user2, :integer, default: nil
  end
end
