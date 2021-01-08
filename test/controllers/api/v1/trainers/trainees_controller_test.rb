require 'test_helper'

class Api::V1::Trainers::TraineesControllerTest < ActionDispatch::IntegrationTest
  describe 'Api::V1::Trainers::TraineesController' do
    let (:url) { "/api/v1/trainers" }

    let (:trainer) { create(:trainer) }
    let (:exercise1) { create(:exercise) }
    let (:exercise2) { create(:exercise) }

    let (:trainer_url) { "#{url}/#{trainer.id}/trainees" }

    describe 'index' do
      let (:trainee1) { create(:trainee) }
      let (:trainee2) { create(:trainee) }
      let (:trainee3) { create(:trainee) }
      let (:another_trainee) { create(:trainee) }
      let (:another_trainer) { create(:trainer) }

      let (:workout1) { create(:workout, trainer: trainer, trainee: trainee1, exercises: [exercise1, exercise2]) }
      let (:workout2) { create(:workout, trainer: trainer, trainee: trainee2, exercises: [exercise1]) }
      let (:workout3) { create(:workout, trainer: trainer, trainee: trainee3, exercises: [exercise2]) }
      let (:workout4) { create(:workout, trainer: another_trainer, trainee: another_trainee, exercises: [exercise1, exercise2]) }

      it 'should return all the trainer trainees' do
        workout1; workout2; workout3; workout4
        get "/#{trainer_url}"

        json = JSON.parse(@response.body)
        assert_response :success
        assert_equal [trainee1.id, trainee2.id, trainee3.id].sort, [json.first['id'], json.second['id'], json.last['id']].sort
      end

      it 'should return not found error if trainer not found' do
        get "/#{url}/-1/trainees"

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Trainer with id -1 was not found"
        assert_equal expected_response, json['errors']
      end
    end

  end
end
