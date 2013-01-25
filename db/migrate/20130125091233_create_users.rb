class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :handle
      t.integer :level
      t.string :school
      t.integer :student_id
      t.string :college
      t.string :major
      t.string :mobile

      t.timestamps
    end
  end
end
