class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :user
      t.references :problem
      t.integer :original_id
      t.text :code
      t.string :language
      t.integer :time
      t.integer :memory
      t.string :status

      t.timestamps
    end
    add_index :submissions, :user_id
    add_index :submissions, :problem_id
  end
end
