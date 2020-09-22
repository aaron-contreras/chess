# frozen_string_literal: true

require_relative '../../lib/chess_pieces/bishop'
require_relative '../shared/among_chess_pieces'

# rubocop: disable all
RSpec.describe Bishop do
  include_context 'list_of_pieces'

  describe '#moves' do
    context 'when not in a position to move' do
      subject(:bishop) { described_class.new(:white, [0, 5]) }

      it 'returns an empty array' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 2 }

        list_of_moves = bishop.moves(other_pieces)

        expect(list_of_moves).to be_empty
      end
    end

    context 'when in a position to move in two directions' do
      subject(:bishop) { described_class.new(:black, [5, 3]) }

      it 'returns an array with all valid moves/captures' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 27 }        

        list_of_moves = bishop.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([4, 2], [3, 1], [2, 0], [4, 4], [3, 5], [2, 6], [1, 7])
      end
    end

    context 'when in a position to move in all directions' do
      subject(:bishop) { described_class.new(:white, [3, 5]) }

      it 'returns an array with all valid moves/captures' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 5 }

        list_of_moves = bishop.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([2, 4], [2, 6], [4, 6], [5, 7], [4, 4], [5, 3], [6, 2])
      end
    end
  end

  describe '#to_s' do
    context 'when it belongs to white player' do
      subject(:bishop) { described_class.new(:white, [0, 2]) }

      it 'returns a white unicode bishop' do
        white_unicode_bishop = "\u2657"

        stringified_bishop = bishop.to_s

        expect(stringified_bishop).to eq white_unicode_bishop
      end
    end
    
    context 'when it belongs to black player' do
      subject(:bishop) { described_class.new(:black, [7, 2]) }

      it 'returns a black unicode bishop' do
        black_unicode_bishop = "\u265d"

        stringified_bishop = bishop.to_s

        expect(stringified_bishop).to eq black_unicode_bishop
      end
    end
  end
end
# rubocop: enable all
