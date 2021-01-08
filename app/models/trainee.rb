class Trainee < ApplicationRecord
  has_many :workouts
  has_many :trainers, through: :workouts

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
