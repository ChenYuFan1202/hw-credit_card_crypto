# frozen_string_literal: true

# Create a module using the Luhn Algorithm to validate credit card numbers
module LuhnValidator
  # Validates credit card number using Luhn Algorithm
  # arguments: none
  # assumes: a local String called 'number' exists
  # returns: true/false whether last digit is correct
  def validate_checksum
    nums_a = number.to_s.chars.map(&:to_i)

    # TODO: use the integers in nums_a to validate its last check digit
    nums_length = nums_a.length
    nums_a.map!.with_index do |num, index|
      (nums_length + index).even? ? num * 2 : num
    end

    # nums_a
    nums_a.map! { |num| num > 9 ? num - 9 : num }
    (nums_a.sum % 10).zero?
  end
end
