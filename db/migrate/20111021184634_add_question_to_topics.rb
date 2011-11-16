class AddQuestionToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :question, :string
  end

  def self.down
    remove_column :topics, :question
  end
end
