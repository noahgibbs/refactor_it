class CreateRefactors < ActiveRecord::Migration
  def self.up
    create_table :refactors do |t|
      t.text :body
      t.text :comment
      t.integer :snippet_id, :null => false
      t.string :language
      t.integer :user_id
      t.string :user_note

      t.timestamps
    end

    add_index :refactors, :snippet_id
    add_index :refactors, :user_id
    add_index :refactors, :created_at
    add_index :refactors, :updated_at
  end

  def self.down
    drop_table :refactors
  end
end
