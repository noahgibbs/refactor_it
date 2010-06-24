class AddKarmaToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :karma, :integer
  end

  def self.down
    remove_column :snippets, :karma
  end
end
