class TweakUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :handle, :string, :null => false
      t.change :level, :integer, :limit => 1, :default => 0
    end
    add_index :users, :handle, :unique => true
  end

  def down
    change_table :users do |t|
      t.change :handle, :string, :null => true
      t.change :level, :integer, :default => nil
    end
    remove_index :users, :column => :handle
  end
end
