class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :source
      t.integer :original_id
      t.integer :level
      t.string :title
      t.integer :time_limit
      t.integer :memory_limit
      t.text :description
      t.text :input
      t.text :output
      t.text :sample_input
      t.text :sample_output
      t.text :hint

      t.timestamps
    end
  end
end
