class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :snippet_id, :null => false
      t.integer :refactor_id
      t.integer :user_id, :null => false
      t.integer :vote_type, :null => false
      t.integer :vote_approved, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
