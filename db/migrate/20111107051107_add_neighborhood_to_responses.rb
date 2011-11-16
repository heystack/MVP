class AddNeighborhoodToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :neighborhood, :string
  end

  def self.down
    remove_column :responses, :neighborhood
  end
end
