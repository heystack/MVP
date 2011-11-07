class AddQualifier1ToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :qualifier1, :string
  end

  def self.down
    remove_column :responses, :qualifier1
  end
end
