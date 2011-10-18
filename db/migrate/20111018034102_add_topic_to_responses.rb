class AddTopicToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :topic, :string
  end

  def self.down
    remove_column :responses, :topic
  end
end
