# Here Trainees have access to actions related to Trainers
class Api::V1::Trainees::TrainersController < ApplicationController
  # returns all trainers the trainee would be interested in to choose from
  # for now we only have expertise so we leave it as is
  # but if we add multiple dimensions this should be refactored.
  def index
    @trainers = Trainer.with_expertise(params[:expertise]).all

    render json: @trainers.to_json, status: 200
  end
end
