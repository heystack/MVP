class AddZipcodeToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :zipcode, :string
  end

  def self.down
    remove_column :responses, :zipcode
  end
end
