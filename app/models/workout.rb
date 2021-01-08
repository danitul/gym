class Workout < ApplicationRecord
  STATES = { draft: 0, published: 1 }
  enum state: STATES

  belongs_to :trainer
  belongs_to :trainee, optional: true

  has_and_belongs_to_many :exercises
  accepts_nested_attributes_for :exercises

  validates :name, :creator, :duration, :state, :exercises, presence: true

  before_create :add_creator
  before_save :add_duration

  def add_creator
    self.creator = self.trainer.full_name
  end

  def add_duration
    self.duration = self.exercises.map(&:duration).sum
  end

  def self.create_with_exercises(params, trainer_id)
    trainer = Trainer.find_by(id: trainer_id)
    workout = Workout.new(name: params[:name], exercises_attributes: params[:exercises], trainer: trainer)
    workout.add_creator
    workout.add_duration
    workout
  end

  def update_with_exercises(params)
    self.exercises = []
    self.update(name: params[:name], state: params[:state], exercises_attributes: params[:exercises])
    #self.add_creator
    #self.add_duration
    self.save
  end
end
