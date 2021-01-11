require 'test_helper'

class Api::V1::Trainees::WorkoutsControllerTest < ActionDispatch::IntegrationTest
  describe 'Api::V1::Trainees::WorkoutsController' do
    let (:url) { "/api/v1/trainees" }

    let (:trainee) { create(:trainee) }
    let (:exercise1) { create(:exercise) }
    let (:exercise2) { create(:exercise) }

    let (:trainee_url) { "#{url}/#{trainee.id}/workouts" }

    describe 'index' do
      let (:trainer1) { create(:trainer) }
      let (:trainer2) { create(:trainer) }
      let (:another_trainee) { create(:trainee) }

      let (:workout1) { create(:workout, trainer: trainer1, trainee: trainee, exercises: [exercise1, exercise2]) }
      let (:workout2) { create(:workout, trainer: trainer2, trainee: trainee, exercises: [exercise1]) }
      let (:workout3) { create(:workout, trainer: trainer1, trainee: trainee, exercises: [exercise2]) }
      let (:workout4) { create(:workout, trainer: trainer1, trainee: another_trainee, exercises: [exercise1, exercise2]) }

      it 'should return all the trainees workouts within a time frame' do
        workout1.update(created_at: Time.now - 2.days)
        workout2; workout3; workout4
        get "/#{trainee_url}", params: { start_date: Time.now - 1.day, end_date: Time.now + 1.day }

        json = JSON.parse(@response.body)
        assert_response :success
        assert_equal [workout2.id, workout3.id].sort, [json.first['id'], json.last['id']].sort
      end

      it 'should return not found error if trainee not found' do
        get "/#{url}/-1/workouts"

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Trainee with id -1 was not found"
        assert_equal expected_response, json['errors']
      end
    end

  end
end
