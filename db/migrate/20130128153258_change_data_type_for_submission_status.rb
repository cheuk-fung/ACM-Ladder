class ChangeDataTypeForSubmissionStatus < ActiveRecord::Migration
  def up
    change_table :submissions do |t|
      t.change :status, :integer
    end
  end

  def down
    change_table :submissions do |t|
      t.change :status, :string
    end
  end
end
