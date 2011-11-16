class AddTopicIdToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :topic_id, :integer
  end

  def self.down
    remove_column :responses, :topic_id
  end
end
