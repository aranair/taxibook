require 'rails_helper'

RSpec.describe Grid, type: :model do
  let(:cars) { Grid.cars }
  let(:origin) { Node.new(0, 0) }
  let(:customer_location) { Node.new(-1, -1) }
  let(:destination) { Node.new(1, 1) }

  before(:each) do
    Grid.reset
  end

  describe '@@cars' do
    it 'automatically assigns 3 cars with id 1, 2 and 3 at (0, 0)' do
      expect(cars.map(&:id)).to eq [1, 2, 3]
      cars.each { |car| expect(car.current_location).to eq origin }
    end
  end

  describe '#assign_booking' do
    context 'given that there are more than 1 car near to customer' do
      it 'only assigns the car with smallest id and returns time needed to get to destination' do
        car_id, distance = Grid.assign_booking(origin, destination)
        expect(car_id).to eq 1
        expect(distance).to eq origin.manhattan_distance_to(destination)
      end
    end
    
    it 'returns nil if there are no available cars' do
      3.times { Grid.assign_booking(origin, destination) }
      car_id, distance = Grid.assign_booking(origin, destination)
      expect(car_id).to be nil
      expect(distance).to be nil
    end

    it 'returns car_id and distance when there is 1 car nearest to customer' do
      car = cars.last
      car.current_location = Node.new(-1, 0)
      car_id, distance = Grid.assign_booking(customer_location, destination)

      expect(car_id).to eq 3
      expect(distance).to eq(
        Node.new(-1, 0).manhattan_distance_to(customer_location) +
        customer_location.manhattan_distance_to(destination)
      )
    end
  end

  describe '#reset' do
    it 'sends a reset command to every car' do
      cars.each { |car| expect(car).to receive(:reset) }
      Grid.reset
    end
  end

  describe '#tick' do
    it 'sends a move to every car' do
      cars.each { |car| expect(car).to receive(:move) }
      Grid.tick
    end
  end
end
