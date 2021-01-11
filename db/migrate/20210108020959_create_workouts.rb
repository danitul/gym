class CreateWorkouts < ActiveRecord::Migration[6.0]
  def change
    create_table :workouts do |t|
      t.string :name, null: false
      t.string :creator, null: false
      t.integer :duration, null: false
      t.integer :state, null: false, default: 0
      t.references :trainer, null: false, foreign_key: true
      t.references :trainee, null: true, foreign_key: true

      t.timestamps
    end
  end
end
