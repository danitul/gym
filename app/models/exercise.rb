class Exercise < ApplicationRecord
  has_and_belongs_to_many :workouts

  validates :name, :duration, presence: true
  validates :name, uniqueness: true
end
