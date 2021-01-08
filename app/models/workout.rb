class Workout < ApplicationRecord
  STATES = { draft: 0, published: 1 }
  enum state: STATES

  belongs_to :trainer
  belongs_to :trainee, optional: true

  has_and_belongs_to_many :exercises

  validates :name, :creator, :duration, :state, :exercises, presence: true

  before_create :add_creator
  before_save :add_duration

  def add_creator
    self.creator = "#{self.trainer.first_name} #{self.trainer.last_name}"
  end

  def add_duration
    self.duration = self.exercises.map(&:duration).sum
  end
end
