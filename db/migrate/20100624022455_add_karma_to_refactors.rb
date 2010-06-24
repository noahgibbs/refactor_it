class AddKarmaToRefactors < ActiveRecord::Migration
  def self.up
    add_column :refactors, :karma, :integer
  end

  def self.down
    remove_column :refactors, :karma
  end
end
