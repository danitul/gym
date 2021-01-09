class Api::V1::Trainers::TraineesController < ApplicationController
  # using this action a trainer can see all trainees that chose to train with that trainer
  def index
    @trainer = Trainer.find_by(id: params[:trainer_id])

    if !@trainer.nil?
      render json: @trainer.trainees, status: 200
    else
      render json: { errors: "Trainer with id #{params[:trainer_id]} was not found"}, status: 404
    end
  end

  # this is the assign a workout to a trainee action performed by a trainer
  def update
    @trainee = Trainee.find_by(id: params[:trainee_id].to_i)
    @workout = Workout.find_by(id: params[:workout_id].to_i)
    if @trainee && @workout
      if @workout.is_assignable?(params[:trainer_id].to_i)
        @trainee.assign(@workout)
        render json: @trainee, status: 200
      else
        errors = []
        unless @workout.published?
          errors << "Workout with id #{params[:workout_id]} is not yet published"
        end
        unless @workout.trainer_id == params[:trainer_id].to_i
          errors << "Workout with id #{params[:workout_id]} is not from the current trainer"
        end
        render json: { errors: errors }, status: 422
      end
    else
      errors = []
      errors << "Workout with id #{params[:workout_id]} was not found" unless @workout
      errors << "Trainee with id #{params[:trainee_id]} was not found" unless @trainee
      render json: { errors: errors }, status: 404
    end
  end
end
