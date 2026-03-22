# frozen_string_literal: true

require_relative '../credit_card'
require 'minitest/autorun'
require 'minitest/rg'

# Feel free to replace the contents of cards with data from your own yaml file
card_details = [
  { num: '4916603231464963',
    exp: 'Mar-30-2020',
    name: 'Soumya Ray',
    net: 'Visa' },
  { num: '6011580789725897',
    exp: 'Sep-30-2020',
    name: 'Nick Danks',
    net: 'Visa' },
  { num: '5423661657234057',
    exp: 'Feb-30-2020',
    name: 'Lee Chen',
    net: 'Mastercard' }
]

cards = card_details.map do |c|
  CreditCard.new(c[:num], c[:exp], c[:name], c[:net])
end

describe 'Test hashing requirements' do
  describe 'Check hashes are consistently produced' do
    # TODO: Check that each card produces the same hash if hashed repeatedly
    cards.each do |card|
      it "produces the same hash for card #{card.number}" do
        hash_one = card.hash
        hash_two = card.hash

        _(hash_one).must_equal hash_two
      end
    end
  end

  describe 'Check for unique hashes' do
    # TODO: Check that each card produces a different hash than other cards
    it 'produces different hashes for different cards' do
      hashes = cards.map(&:hash)
      unique_hashes = hashes.uniq
      _(hashes.length).must_equal unique_hashes.length
    end
  end

  describe 'Check serialization round-trip' do
    cards.each do |card|
      it "restores the same card data from to_s for card #{card.number}" do
        serialized_card = card.to_s
        restored_card = CreditCard.from_s(serialized_card)

        _(restored_card.to_s).must_equal card.to_s
      end
    end
  end
end
