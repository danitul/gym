class Trainer < ApplicationRecord
  # if this list is supposed to get long then load them from an expertise table
  EXPERTISE = %w(yoga fitness strength)

  has_many :workouts
  has_many :trainees, through: :workouts

  validates :first_name, :last_name, :expertise, presence: true
  validates :expertise, inclusion: { in: EXPERTISE, message: "%{value} is not a valid expertise" }

  scope :with_expertise, -> (expertise) { where('expertise = ?', expertise) }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
