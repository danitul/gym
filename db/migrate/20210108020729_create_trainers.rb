class CreateTrainers < ActiveRecord::Migration[6.0]
  def change
    create_table :trainers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :expertise, null: false

      t.timestamps
    end
  end
end
