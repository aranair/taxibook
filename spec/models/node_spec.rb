require 'rails_helper'

RSpec.describe Node, type: :model do
  describe '#initialize' do
    it 'raises an error if coordinates are outside boundary' do
      expect{ Node.new(2**31, 0) }.to raise_error
      expect{ Node.new(-2**31-1, 0) }.to raise_error
      expect{ Node.new(0, 2**31) }.to raise_error
      expect{ Node.new(0, -2**31-1) }.to raise_error

      expect{ Node.new(0, -2**31) }.to_not raise_error
      expect{ Node.new(0, 2**31-1) }.to_not raise_error
      expect{ Node.new(-2**31, 0) }.to_not raise_error
      expect{ Node.new(2**31-1, 0) }.to_not raise_error
    end
  end

  describe '#manhanttan_distance_to' do
    let(:node_1) { Node.new(0, 0) }
    let(:node_2) { Node.new(2, 5) }

    it 'returns a positive manhanttan_distance to another node' do
      expect(node_1.manhattan_distance_to(node_2)).to eq 7
    end
  end

  describe '==' do
    it 'checks equivalence via x and y coordinates' do
      expect(Node.new(0, 0) == Node.new(0, 0)).to eq true
      expect(Node.new(0, 0) == Node.new(0, 1)).to eq false
    end
  end
end
