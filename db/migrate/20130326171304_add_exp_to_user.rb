class AddExpToUser < ActiveRecord::Migration
  def change
    add_column :users, :exp, :integer, :default => 0
  end
end
