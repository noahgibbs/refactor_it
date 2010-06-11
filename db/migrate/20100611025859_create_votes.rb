class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :snippet_id
      t.integer :user_id
      t.integer :vote_type
      t.integer :vote_approved

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
