# Here Trainers have access to actions related to Workouts
class Api::V1::Trainers::WorkoutsController < ApplicationController
  def show
    @workout = Workout.find_by(id: params[:id])

    if @workout
      render json: @workout, status: 200
    else
      render json: { errors: "Workout with id #{params[:id]} was not found"}, status: 404
    end
  end

  def create
    if create_params[:exercises] && create_params[:exercises].size > 0
      @workout = Workout.new(
        name: create_params[:name],
        exercises_attributes: create_params[:exercises],
        trainer_id: params[:trainer_id]
      )
      if @workout.save
        render json: @workout, status: 201
      else
        render json: { errors: @workout.errors }, status: 422
      end
    else
      render json: { errors: "Workout with name #{create_params[:name]} could not be created without exercises"}, status: 422
    end
  end

  def update
    @workout = Workout.find_by(id: params[:id])
    if @workout
      @workout.update_with_exercises(update_params)
      if @workout.save
        render json: @workout, status: 200
      else
        render json: { errors: @workout.errors }, status: 422
      end
    else
      render json: { errors: "Workout with id #{params[:id]} was not found"}, status: 404
    end
  end

  def destroy
    @workout = Workout.find_by(id: params[:id])
    if @workout
      if @workout.trainer_id == params[:trainer_id].to_i
        @workout.destroy
        render json: {}, status: :no_content
      else
        render json: { errors: "Workout with id #{params[:id]} is not owned by current trainer"}, status: 422
      end
    else
      render json: { errors: "Workout with id #{params[:id]} was not found"}, status: 404
    end
  end

  def create_params
    params.require(:workout).permit(:name, exercises: [:name, :duration]).to_h
  end

  def update_params
    workout_params = params.require(:workout).permit(:name, :state, exercises: [:name, :duration])
    workout_params[:state] = workout_params[:state].to_i
    workout_params
  end
end

