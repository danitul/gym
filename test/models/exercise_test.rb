require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  describe Exercise do
    it 'should create an exercise correctly' do
      assert_equal 0, Exercise.count
      create(:exercise)
      assert_equal 1, Exercise.count
    end

    describe 'validations' do
      it "does not create an exercise with no name given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:exercise, name: nil)
        end
      end

      it "does not create an exercise with no duration given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:exercise, duration: nil)
        end
      end
    end
  end
end
