class TweakSubmissions < ActiveRecord::Migration
  def self.up
    change_table :submissions do |t|
      t.change :language, :integer, :limit => 1
      t.change :status, :integer, :limit => 1, :default => 0
      t.text :error
    end
  end

  def self.down
    change_table :submissions do |t|
      t.change :language, :string
      t.change :status, :string
      t.remove :error
    end
  end
end
