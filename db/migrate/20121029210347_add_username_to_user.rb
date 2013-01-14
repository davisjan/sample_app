class AddUsernameToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def self.up
    add_column :users, :username, :string
    User.reset_column_information
    User.all.each do |user|
      user.username = "user#{user.id}"
    end
    execute <<-SQL
      CREATE UNIQUE INDEX username_index ON users (username)
    SQL
  end

  def self.down
    execute <<-SQL
      DROP INDEX users.username_index
    SQL
    remove_column :users, :username
  end

end
