require 'test_helper'

class Api::V1::Trainees::TrainersControllerTest < ActionDispatch::IntegrationTest
  describe 'Api::V1::Trainees::TrainersController' do
    let (:url) { "/api/v1/trainees" }
    let (:trainee) { create(:trainee) }
    let (:trainee_url) { "#{url}/#{trainee.id}/trainers" }

    describe 'index' do
      let (:trainer1) { create(:trainer, expertise: chosen_expertise) }
      let (:trainer2) { create(:trainer, expertise: 'yoga') }
      let (:trainer3) { create(:trainer, expertise: chosen_expertise) }
      let (:chosen_expertise) { 'fitness' }

      it 'should return all the trainers with given expertise for the trainee to choose from' do
        trainer1; trainer2; trainer3
        get "/#{trainee_url}", params: { expertise: chosen_expertise }

        json = JSON.parse(@response.body)
        assert_response :success
        assert_equal [trainer1.id, trainer3.id].sort, [json.first['id'], json.last['id']].sort
      end
    end

  end
end