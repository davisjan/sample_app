class AddLocationToMicroposts < ActiveRecord::Migration
  def self.up
    add_column :microposts, :location, :string
  end

  def self.down
    remove_column :microposts, :location
  end
end
