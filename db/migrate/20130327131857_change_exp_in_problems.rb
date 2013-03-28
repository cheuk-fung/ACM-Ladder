class ChangeExpInProblems < ActiveRecord::Migration
  def up
    change_table :problems do |t|
      t.change :exp, :integer, :default => 1
    end
    execute "UPDATE `problems` SET `exp`='1' WHERE `exp` IS NULL"
  end

  def down
    change_table :problems do |t|
      t.change :exp, :integer
    end
  end
end
