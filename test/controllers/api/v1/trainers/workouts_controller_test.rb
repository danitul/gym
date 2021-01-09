require 'test_helper'

class Api::V1::Trainers::WorkoutsControllerTest < ActionDispatch::IntegrationTest
  describe 'Api::V1::Trainers::WorkoutsController' do
    let (:url) { "/api/v1/trainers" }

    let (:trainer) { create(:trainer) }
    let (:exercise1) { create(:exercise) }
    let (:exercise2) { create(:exercise) }

    let (:trainer_url) { "#{url}/#{trainer.id}/workouts" }

    describe 'show' do
      let (:workout) { create(:workout, trainer: trainer, exercises: [exercise1, exercise2]) }

      it 'should return the specific workout' do
        get "/#{trainer_url}/#{workout.id}"

        json = JSON.parse(@response.body)

        assert_response :success
        assert_equal workout.id, json['id']
        assert_equal workout.name, json['name']
        assert_equal workout.creator, json['creator']
        assert_equal workout.duration, json['duration']
        assert_equal workout.state, json['state']
        assert_equal workout.trainer.id, json['trainer_id']
        assert_nil json['trainee_id']
      end

      it 'should return not found error if workout not found' do
        get "/#{trainer_url}/-1"

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Workout with id -1 was not found"
        assert_equal expected_response, json['errors']
      end
    end

    describe 'destroy' do
      let (:workout) { create(:workout, trainer: trainer, exercises: [exercise1, exercise2]) }
      let (:another_trainer) { create(:trainer) }
      let (:another_workout) { create(:workout, trainer: another_trainer, exercises: [exercise1]) }

      it 'should successfully destroy the specific workout' do
        delete "/#{trainer_url}/#{workout.id}"

        assert_response :no_content
        assert_equal "", @response.body
      end

      it 'should return error if workout is not owned by current trainer' do
        delete "/#{trainer_url}/-1"

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Workout with id -1 was not found"
        assert_equal expected_response, json['errors']
      end

      it 'should return not found error if workout not found' do
        delete "/#{trainer_url}/#{another_workout.id}"

        json = JSON.parse(@response.body)
        assert_response 422

        expected_response = "Workout with id #{another_workout.id} is not owned by current trainer"
        assert_equal expected_response, json['errors']
      end
    end

    describe 'create new workout' do
      before do
        @params = {
          name: "My workout",
          exercises: [
            { name: "Ex 1", duration: 3 },
            { name: "Ex 2", duration: 4 }
          ]
        }
      end

      it 'should create a new workout successfully' do
        initial_workout_count = Workout.count

        post trainer_url, params: { workout: @params }

        assert_response 201
        assert_equal initial_workout_count + 1, Workout.count

        json = JSON.parse(@response.body)

        workout = Workout.last
        assert_equal json['id'], workout.id
        assert_equal @params[:name], workout.name
        assert_equal trainer.full_name, workout.creator
        assert_equal workout.duration, json['duration']
        assert_equal workout.state, json['state']
        assert_equal trainer.id, json['trainer_id']
        assert_nil json['trainee_id']
        assert_equal 2, workout.exercises.count
        assert_equal @params[:exercises].first[:name], workout.exercises.first[:name]
        assert_equal @params[:exercises].first[:duration], workout.exercises.first[:duration]
        assert_equal @params[:exercises].last[:name], workout.exercises.last[:name]
        assert_equal @params[:exercises].last[:duration], workout.exercises.last[:duration]
      end

      it 'should return errors if workout params were not correct' do
        post trainer_url, params: { workout: { exercises: @params[:exercises] } }

        json = JSON.parse(@response.body)
        assert_response 422

        expected_response = {"name" => ["can't be blank"]}
        assert_equal expected_response, json['errors']
      end

      it 'should return errors if workout exercises are not given' do
        post trainer_url, params: { workout: { name: @params[:name] } }

        json = JSON.parse(@response.body)
        assert_response 422

        expected_response = "Workout with name #{@params[:name]} could not be created without exercises"
        assert_equal expected_response, json['errors']
      end
    end

    describe 'update existing workout' do
      before do
        @params = {
          name: "Updated workout",
          state: 1,
          exercises: [
            { name: "Ex 1", duration: 3 }
          ]
        }
        @workout = create(:workout, trainer: trainer, exercises: [exercise1, exercise2])
      end

      it 'should update an existing workout successfully' do
        put "#{trainer_url}/#{@workout.id}", params: { workout: @params }

        assert_response 200
        json = JSON.parse(@response.body)

        workout = Workout.find(@workout.id)
        assert_equal json['id'], workout.id
        assert_equal @params[:name], workout.name
        assert_equal trainer.full_name, workout.creator
        assert_equal workout.duration, json['duration']
        assert_equal workout.state, json['state']
        assert_equal trainer.id, json['trainer_id']
        assert_nil json['trainee_id']
        assert_equal 1, workout.exercises.count
        assert_equal @params[:exercises].first[:name], workout.exercises.first[:name]
        assert_equal @params[:exercises].first[:duration], workout.exercises.first[:duration]
      end

      it 'should return errors if workout params were not correct' do
        @params[:name] = ""
        put "#{trainer_url}/#{@workout.id}", params: { workout: @params }

        json = JSON.parse(@response.body)
        assert_response 422

        expected_response = {"name" => ["can't be blank"]}
        assert_equal expected_response, json['errors']
      end

      it 'should return errors if workout does not exist' do
        put "#{trainer_url}/-1", params: { workout: @params }

        json = JSON.parse(@response.body)
        assert_response 404

        expected_response = "Workout with id -1 was not found"
        assert_equal expected_response, json['errors']
      end
    end
  end
end
