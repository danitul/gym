require "test_helper"

class TraineeTest < ActiveSupport::TestCase
  describe Trainee do
    it 'should create a trainee correctly' do
      assert_equal 0, Trainee.count
      create(:trainee)
      assert_equal 1, Trainee.count
    end

    describe 'validations' do
      it "does not create a trainee with no first name given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:trainee, first_name: nil)
        end
      end

      it "does not create a trainee with no last name given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:trainee, last_name: nil)
        end
      end

      it "does not create a trainee with no email given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:trainee, email: nil)
        end
      end

      it "does not create a trainee with the same email twice" do
        trainee = create(:trainee)
        assert_raises ActiveRecord::RecordInvalid do
          create(:trainee, email: trainee.email)
        end
      end
    end
  end
end
