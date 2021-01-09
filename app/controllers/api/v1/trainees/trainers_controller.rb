class Api::V1::Trainees::TrainersController < ApplicationController
  def index
    @trainers = Trainer.with_expertise(params[:expertise]).all

    render json: @trainers.to_json, status: 200
  end
end
