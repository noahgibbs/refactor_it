class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.string :title
      t.text :body
      t.boolean :published
      t.string :language

      t.timestamps
    end
  end

  def self.down
    drop_table :snippets
  end
end
