# frozen_string_literal: true

require_relative '../../lib/chess_pieces/queen'
require_relative '../shared/among_chess_pieces'
# rubocop: disable all

RSpec.describe Queen do
  include_context 'list_of_pieces'

  describe '#moves' do
    context 'when not in a position to move' do
      subject(:queen) { described_class.new(:white, [0, 3]) }

      it 'returns an empty array' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 3 }

        list_of_moves = queen.moves(other_pieces)

        expect(list_of_moves).to be_empty
      end
    end

    context 'when in a position to move in some directions' do
      subject(:queen) { described_class.new(:black, [7, 3]) }

      it 'returns all valid moves/captures' do
        # Exclude queen and the two pawns blocking its path
        other_pieces = pieces.reject.with_index { |_piece, index| [18, 20, 27].include?(index) }

        list_of_moves = queen.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([6, 2], [5, 1], [4, 0], [6, 4], [5, 5], [4, 6], [3, 7])
      end
    end

    context 'when in a position to move in all directions' do
      subject(:queen) { described_class.new(:white, [3, 3])}

      it 'returns all valid moves/captures' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 3}

        list_of_moves = queen.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([2, 3], [2, 4], [3, 4], [3, 5], [3, 6], [3, 7], [4, 4], [5, 5], [6, 6], [4, 3], [5, 3], [6, 3], [4, 2], [5, 1], [6, 0], [3, 2], [3, 1], [3, 0], [2, 2])
      end
    end
  end

  describe '#to_s' do
    context 'when it belongs to white player' do
      subject(:queen) { described_class.new(:white, [0, 3]) }

      it 'returns a white unicode queen' do
        white_unicode_queen = "\u2655"

        stringified_queen = queen.to_s

        expect(stringified_queen).to eq white_unicode_queen
      end
    end

    context 'when it belongs to black player' do
      subject(:queen) { described_class.new(:black, [7, 3]) }

      it 'returns a black unicode queen' do
        black_unicode_queen = "\u265b"

        stringified_queen = queen.to_s

        expect(stringified_queen).to eq black_unicode_queen
      end
    end
  end
end
# rubocop: disable all
