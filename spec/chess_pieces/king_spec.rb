# frozen_string_literal: true

require_relative '../../lib/chess_pieces/king'
require_relative '../shared/among_chess_pieces'

# rubocop: disable all
RSpec.describe King do
  include_context 'list_of_pieces'

  describe '#to_s' do
    include_examples 'piece_display', described_class.new(:white, [0, 4])
    include_examples 'piece_display', described_class.new(:black, [7, 4])
  end

  describe '#moves' do
    context 'when not in a position to move' do
      subject(:king) { described_class.new(:white, [0, 4])}

      it 'returns an empty array' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 4 }

        list_of_moves = king.moves(other_pieces)

        expect(list_of_moves).to be_empty
      end
    end

    context 'when in a position able to move but not capture' do
      subject(:king) { described_class.new(:black, [4, 4])}

      it 'returns an array with all valid moves' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 28 }

        list_of_moves = king.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([3, 4], [3, 5], [4, 5], [5, 5], [5, 4], [5, 3], [4, 3], [3, 3])
      end
    end

    context 'when in a position able to move and capture' do
      subject(:king) { described_class.new(:white, [2, 4]) }

      it 'returns an array with all valid moves/caputres' do
        # Place a black pawn in a capturable position
        allow(pieces[16]).to receive(:position).and_return([3, 4])

        other_pieces = pieces.reject.with_index { |_piece, index| index == 4 }

        list_of_moves = king.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([2, 5], [3, 5], [3, 4], [3, 3], [2, 3])
      end
    end

    context 'when able to perform long side castling' do
      subject(:king) { described_class.new(:white, [0, 4]) }
      it 'returns an array with valid moves/captures/castling' do
        # Make the castle move available
        other_pieces = pieces.reject.with_index { |_piece, index| [1, 2, 3].include?(index) }

        long_side_rook = pieces[0]

        list_of_moves = king.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([0, 3], a_kind_of(Castling))
      end
    end

    context 'when able to perform short side castling' do
      subject(:king) { described_class.new(:black, [7, 4]) }

      it 'returns an array with valid moves/captures/castling' do
        # Make the castle move available
        other_pieces = pieces.reject.with_index { |_piece, index| [29, 30].include?(index) }

        short_side_rook = pieces[31]

        list_of_moves = king.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([7, 5], a_kind_of(Castling))
      end
    end
  end
end
