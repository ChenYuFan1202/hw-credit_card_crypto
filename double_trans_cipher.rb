# frozen_string_literal: true

# Create a module for double transposition cipher
module DoubleTranspositionCipher
  def self.build_blocks(string, block_size)
    string.scan(/.{1,#{block_size}}/).map { |block| block.ljust(block_size, ' ') }
  end

  def self.permute_block(blocks, row_permutation, col_permutation)
    row_permutation.map { |row_index| blocks[row_index] }.map do |block|
      col_permutation.map { |col_index| block[col_index] }.join
    end
  end

  def self.inverse_permute_col(blocks, col_permutation)
    inverse_col = col_permutation.each_with_index.sort.map { |_, new_index| new_index }
    blocks.map do |block|
      inverse_col.map { |col_index| block[col_index] }.join
    end
  end

  def self.inverse_permute_row(blocks, row_permutation)
    inverse_row = row_permutation.each_with_index.sort.map { |_, new_index| new_index }
    inverse_row.map { |row_index| blocks[row_index] }
  end

  def self.encrypt(document, key)
    # TODO: FILL THIS IN!
    ## Suggested steps for double transposition cipher
    # 1. find number of rows/cols such that matrix is almost square
    # 2. break plaintext into evenly sized blocks
    # 3. sort rows in predictibly random way using key as seed
    # 4. sort columns of each row in predictibly random way
    # 5. return joined cyphertext
    json_string = document.to_json
    block_size = Math.sqrt(json_string.length).ceil
    blocks = build_blocks(json_string, block_size)
    rng = Random.new(key)
    col_permutation = (0...block_size).to_a.shuffle(random: rng)
    row_permutation = (0...blocks.length).to_a.shuffle(random: rng)

    encrypted_blocks = permute_block(blocks, row_permutation, col_permutation)
    encrypted_blocks.join
  end

  def self.decrypt(ciphertext, key)
    # TODO: FILL THIS IN!
    block_size = Math.sqrt(ciphertext.length).ceil
    blocks = build_blocks(ciphertext, block_size)
    rng = Random.new(key)
    col_permutation = (0...block_size).to_a.shuffle(random: rng)
    row_permutation = (0...blocks.length).to_a.shuffle(random: rng)
    decrypted_col_blocks = inverse_permute_col(blocks, col_permutation)
    decrypted_blocks = inverse_permute_row(decrypted_col_blocks, row_permutation)
    decrypted_blocks.join.rstrip
  end
end
