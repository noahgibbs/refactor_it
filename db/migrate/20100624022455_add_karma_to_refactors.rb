class AddKarmaToRefactors < ActiveRecord::Migration
  def self.up
    add_column :refactors, :karma, :integer, :default => 0
  end

  def self.down
    remove_column :refactors, :karma, :default => 0
  end
end
