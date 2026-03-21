# frozen_string_literal: true

require_relative '../credit_card'
require_relative '../substitution_cipher'
require_relative '../double_trans_cipher'
require_relative '../sk_cipher'
require 'minitest/autorun'
require 'minitest/rg'

describe 'Test card info encryption' do
  before do
    @cc = CreditCard.new('4916603231464963', 'Mar-30-2020',
                         'Soumya Ray', 'Visa')
    @key = 3
  end

  describe 'Using Caesar cipher' do
    it 'should encrypt card information' do
      enc = SubstitutionCipher::Caesar.encrypt(@cc, @key)
      _(enc).wont_equal @cc.to_s
      _(enc).wont_be_nil
    end

    it 'should decrypt text' do
      enc = SubstitutionCipher::Caesar.encrypt(@cc, @key)
      dec = SubstitutionCipher::Caesar.decrypt(enc, @key)
      _(dec).must_equal @cc.to_s
    end
  end

  describe 'Using Permutation cipher' do
    it 'should encrypt card information' do
      enc = SubstitutionCipher::Permutation.encrypt(@cc, @key)
      _(enc).wont_equal @cc.to_s
      _(enc).wont_be_nil
    end

    it 'should decrypt text' do
      enc = SubstitutionCipher::Permutation.encrypt(@cc, @key)
      dec = SubstitutionCipher::Permutation.decrypt(enc, @key)
      _(dec).must_equal @cc.to_s
    end
  end

  # TODO: Add tests for double transposition and modern symmetric key ciphers
  #       Can you DRY out the tests using metaprogramming? (see lecture slide)
  describe 'Using Double Transposition cipher' do
    it 'should encrypt card information' do
      enc = DoubleTranspositionCipher.encrypt(@cc, @key)
      _(enc).wont_equal @cc.to_s
      _(enc).wont_be_nil
      _(enc).must_be_instance_of String
    end

    it 'should decrypt text' do
      enc = DoubleTranspositionCipher.encrypt(@cc, @key)
      dec = DoubleTranspositionCipher.decrypt(enc, @key)
      _(dec).must_equal @cc.to_s
    end
  end

  describe 'Using Modern Symmetric Cipher' do
    it 'should generate a Base64 key' do
      key = ModernSymmetricCipher.generate_new_key

      _(key).wont_be_nil
      _(key).must_be_instance_of String
      _(Base64.strict_decode64(key).bytesize).must_equal 32
    end

    {
      'card information' => -> { @cc.to_s },
      'plain text' => -> { 'encryption demo' }
    }.each do |label, text_builder|
      it "should encrypt and decrypt #{label}" do
        key = ModernSymmetricCipher.generate_new_key
        text = instance_exec(&text_builder)
        enc = ModernSymmetricCipher.encrypt(text, key)
        dec = ModernSymmetricCipher.decrypt(enc, key)

        _(enc).wont_be_nil
        _(enc).wont_equal text
        _(dec).must_equal text
      end
    end

    it 'should produce different ciphertext for repeated encryption' do
      key = ModernSymmetricCipher.generate_new_key
      text = @cc.to_s

      enc_one = ModernSymmetricCipher.encrypt(text, key)
      enc_two = ModernSymmetricCipher.encrypt(text, key)

      _(enc_one).wont_equal enc_two
    end
  end
end
