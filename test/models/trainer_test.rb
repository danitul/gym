require "test_helper"

class TrainerTest < ActiveSupport::TestCase
  describe Trainer do
    it 'should create a trainer correctly' do
      assert_equal 0, Trainer.count
      create(:trainer)
      assert_equal 1, Trainer.count
    end

    describe 'validations' do
      it "does not create a trainer with no first name given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:trainer, first_name: nil)
        end
      end

      it "does not create a trainer with no last name given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:trainer, last_name: nil)
        end
      end

      it "does not create a trainer with no expertise given" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:trainer, expertise: nil)
        end
      end

      it "does not create a trainer with an invalid expertise" do
        assert_raises ActiveRecord::RecordInvalid do
          create(:trainer, expertise: ['invalid expertise'])
        end
      end
    end
  end
end
