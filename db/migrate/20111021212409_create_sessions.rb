class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.text :session_id, :limit => 1000
      t.text :data, :limit => 1000

      t.timestamps
    end
  end

  def self.down
    drop_table :sessions
  end
end
