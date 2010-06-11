class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.string :title
      t.text :body
      t.text :notes
      t.string :language
      t.integer :user_id, :null => false

      t.timestamps
    end

    add_index :snippets, :language
    add_index :snippets, :user_id
    add_index :snippets, :created_at
    add_index :snippets, :updated_at
  end

  def self.down
    drop_table :snippets
  end
end
