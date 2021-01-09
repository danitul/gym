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

    describe 'assign workout to trainee' do
      let (:trainee) { create(:trainee) }
      let (:workout) { create(:workout, trainer: trainer, exercises: [exercise1, exercise2]) }

      it 'should update an existing workout successfully' do
        put "#{trainer_url}/#{trainee.id}/assign/#{workout.id}", params: {}

        assert_response 200
        json = JSON.parse(@response.body)
        trainee.reload

        assert_equal json['id'], trainee.id
        assert_equal 1, trainee.workouts.count
        assert_equal workout.id, trainee.workouts.first.id
        assert_equal trainer.id, trainee.trainers.first.id
      end

      it 'should return errors if trainee does not exist' do
        put "#{trainer_url}/-1/assign/#{workout.id}", params: {}

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Trainee with id -1 was not found"
        assert_equal expected_response, json['errors'].first
      end

      it 'should return errors if workout does not exist' do
        put "#{trainer_url}/#{trainee.id}/assign/-1", params: {}

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Workout with id -1 was not found"
        assert_equal expected_response, json['errors'].first
      end

      it 'should return errors if workout is not published' do
        workout.draft!
        put "#{trainer_url}/#{trainee.id}/assign/#{workout.id}", params: {}

        json = JSON.parse(@response.body)
        assert_response 422

        expected_response = "Workout with id #{workout.id} is not yet published"
        assert_equal expected_response, json['errors'].first
      end

      it 'should return errors if workout is from a different trainer' do
        another_trainer = create(:trainer)
        another_workout = create(:workout, trainer: another_trainer, exercises: [exercise1, exercise2])
        put "#{trainer_url}/#{trainee.id}/assign/#{another_workout.id}", params: {}

        json = JSON.parse(@response.body)
        assert_response 422

        expected_response = "Workout with id #{another_workout.id} is not from the current trainer"
        assert_equal expected_response, json['errors'].first
      end
    end

  end
end
