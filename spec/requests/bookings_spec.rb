require 'rails_helper'

RSpec.describe "Bookings", type: :request do
  before(:each) do
    Grid.reset
  end

  let(:booking_params) do
    { source: { x: -1, y: -1 }, destination: { x: 2, y: 2 } }
  end

  describe 'POST api/book' do
    it 'finds and assigns the nearest car and returns the id and total time' do
      post api_book_path, booking: booking_params
      expect(response).to be_success
      body = JSON.parse(response.body)

      expect(body['car_id']).to eq 1
      expect(body['total_time']).to eq 8
    end

    context 'given that there is no car available' do
      it 'returns empty response' do
        4.times do 
          post api_book_path, booking: booking_params
        end

        expect(response).to be_success
        expect(response.body).to eq ''
      end
    end
  end

  describe 'GET api/tick' do
    it 'calls Grid tick' do
      expect(Grid).to receive(:tick)
      get api_tick_path
    end
  end

  describe 'GET api/reset' do
    it 'calls Grid reset' do
      expect(Grid).to receive(:reset)
      get api_reset_path
    end
  end
end
