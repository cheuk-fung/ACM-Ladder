class AddExpToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :exp, :integer
  end
end
