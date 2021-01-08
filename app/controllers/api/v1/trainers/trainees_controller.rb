class Api::V1::Trainers::TraineesController < ApplicationController
  def index
    @trainer = Trainer.find_by(id: params[:trainer_id])

    if !@trainer.nil?
      render json: @trainer.trainees, status: 200
    else
      render json: { errors: "Trainer with id #{params[:trainer_id]} was not found"}, status: 404
    end
  end
end
