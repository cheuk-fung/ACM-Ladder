class ChangeDataTypeForSubmissionLanguage < ActiveRecord::Migration
  def up
    change_table :submissions do |t|
      t.change :language, :integer
    end
  end

  def down
    change_table :submissions do |t|
      t.change :language, :string
    end
  end
end
