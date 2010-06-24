class AddKarmaToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :karma, :integer, :default => 0
  end

  def self.down
    remove_column :snippets, :karma, :default => 0
  end
end
