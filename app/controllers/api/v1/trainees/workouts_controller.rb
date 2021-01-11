# Here Trainees have access to actions related to Workouts
class Api::V1::Trainees::WorkoutsController < ApplicationController
  # returns all the Trainee's workouts based on a filter
  # We only have one now, but this would need some refactoring
  # once we have a need for more such filters.
  def index
    @trainee = Trainee.find_by(id: params[:trainee_id])
    if !@trainee.nil?
      @workouts = @trainee.workouts.within_timeframe(params[:start_date], params[:end_date])
      render json: @workouts.to_json, status: 200
    else
      render json: { errors: "Trainee with id #{params[:trainee_id]} was not found"}, status: 404
    end
  end
end