require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:car) { Car.new(1) }
  let(:origin) { Node.new(0, 0) }
  let(:customer_location) { Node.new(-1, -1) }
  let(:destination) { Node.new(1, 1) }

  describe '#book' do
    context 'given that the car is already booked' do
      it 'does not take customer' do
        car.book(customer_location, destination)

        expect(car.book(customer_location, Node.new(5, 5))).to eq nil
        expect(car.destination).to eq destination
      end
    end

    it 'updates car status, set customer location/destination and returns trip time' do
      trip_time = car.book(customer_location, destination)

      expect(trip_time).to eq(
        origin.manhattan_distance_to(customer_location) + 
        customer_location.manhattan_distance_to(destination)
      )
      expect(car.available?).to eq false
      expect(car.customer_location).to eq customer_location
    end

    context 'given that the car is already at customer location' do
      it 'immediately sets customer_location to nil (to move towards destination)' do
        trip_time = car.book(origin, destination)
        expect(trip_time).to eq origin.manhattan_distance_to(destination)
        expect(car.customer_location).to be nil
      end
    end
  end

  describe '#reset' do
    before { car.book(customer_location, destination) }
    context 'given that the car is booked' do
      it 'resets car back to original status' do
        car.reset
        expect(car.current_location).to eq origin
        expect(car.available?).to eq true
      end
    end

    it 'resets car back to original location and status' do
      car.reset
      expect(car.current_location).to eq origin
      expect(car.available?).to eq true
    end
  end

  describe '#move' do
    context 'given that the car is available' do
      it 'does nothing' do
        expect(car.move).to be nil
      end
    end

    context 'given that the car is booked at current location' do
      before { car.book(origin, destination) }
      it 'immediately moves towards destination (x-axis then y)' do
        car.move
        expect(car.current_location).to eq Node.new(1, 0)
        car.move
        expect(car.current_location).to eq Node.new(1, 1)
      end
    end

    context 'given that the car is booked but customer has not been picked up' do
      before { car.book(customer_location, destination) }
      it 'moves towards customer pickup (x-axis then y)' do
        car.move
        expect(car.current_location).to eq Node.new(-1, 0)
        car.move
        expect(car.current_location).to eq Node.new(-1, -1)
      end

      it 'updates customer_location when car reaches customer pickup point' do
        2.times { car.move }
        expect(car.customer_location).to be nil
      end
    end

    context 'given that the car has picked up customer' do
      before do 
        car.book(customer_location, destination)
        2.times { car.move }
      end

      it 'moves towards destination, (x-axis then y)' do
        car.move
        expect(car.current_location).to eq Node.new(0, -1)
        car.move
        expect(car.current_location).to eq Node.new(1, -1)
        car.move
        expect(car.current_location).to eq Node.new(1, 0)
      end

      it 'updates status to available when it reaches destination' do
        5.times { car.move }
        expect(car.destination).to be nil
        expect(car.current_location).to eq destination
        expect(car.available?).to eq true
      end
    end
  end
end
