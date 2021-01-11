require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  describe Workout do
    let (:trainer) { create(:trainer) }
    let (:exercise1) { create(:exercise) }
    let (:exercise2) { create(:exercise) }
    
    describe 'complete workout' do
      it 'should create a workout correctly' do
        assert_equal 0, Workout.count
        create(:workout, trainer: trainer, exercises: [exercise1, exercise2])
        assert_equal 1, Workout.count
      end

      it 'should add the correct duration' do
        workout = create(:workout, trainer: trainer, exercises: [exercise1, exercise2])
        expected_duration = exercise1.duration + exercise2.duration
        assert_equal expected_duration, workout.duration
      end

      it 'should add the correct creator' do
        workout = create(:workout, trainer: trainer, exercises: [exercise1, exercise2])
        expected_creator = "#{trainer.first_name} #{trainer.last_name}"
        assert_equal expected_creator, workout.creator
      end
    end

    describe 'validations' do
      it "does not create a workout with no name given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:workout, trainer: trainer, exercises: [exercise1, exercise2], name: nil)
        end
      end

      it "does not create a workout with no trainer given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:workout, trainer: nil, exercises: [exercise1, exercise2])
        end
      end

      it "does not create a workout with no exercises given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:workout, trainer: trainer)
        end
      end

      it "does not create a workout with no state" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:workout, trainer: trainer, exercises: [exercise1, exercise2], state: nil)
        end
      end

      it "does not create a workout with invalid state" do
        assert_raises ArgumentError do
          create(:workout, trainer: trainer, exercises: [exercise1, exercise2], state: -1)
        end
      end
    end
  end
end
