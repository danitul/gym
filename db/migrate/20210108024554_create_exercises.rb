class CreateExercises < ActiveRecord::Migration[6.0]
  def change
    create_table :exercises do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :duration, null: false

      t.timestamps
    end
  end
end
