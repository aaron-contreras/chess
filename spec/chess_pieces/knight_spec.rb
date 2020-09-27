# frozen_string_literal: true

require_relative '../../lib/chess_pieces/knight'
require_relative '../shared/among_chess_pieces'

# rubocop: disable all

RSpec.describe Knight do
  include_context 'list_of_pieces'

  describe '#to_s' do
    include_examples 'piece_display', described_class.new(:white, [0, 1])
    include_examples 'piece_display', described_class.new(:black, [7, 1])
  end

  describe '#moves' do

    context 'when not in a position to move' do
      subject(:knight) { described_class.new(:black, [5, 3]) }

      it 'returns an empty array' do
        # Setup black pawns and rooks to block knight movements
        allow(pieces[16]).to receive(:position).and_return([4, 1])
        allow(pieces[23]).to receive(:position).and_return([3, 2])
        allow(pieces[22]).to receive(:position).and_return([4, 5])
        allow(pieces[31]).to receive(:position).and_return([3, 4])


        other_pieces = pieces.reject.with_index { |_piece, index| index == 25 }

        list_of_moves = knight.moves(other_pieces)

        expect(list_of_moves).to be_empty
      end
    end

    context 'when in a position that can move but not capture' do
      subject(:knight) { described_class.new(:white, [0, 1]) }

      it 'returns all valid moves' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 1 }

        list_of_moves = knight.moves(other_pieces)

        expected_moves = [
          { type: :standard, piece: knight, ending_position: [2, 0] },
          { type: :standard, piece: knight, ending_position: [2, 2] }
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end

    context 'when in a position that can move and capture' do
      subject(:knight) { described_class.new(:black, [4, 4]) }

      it 'returns all valid moves/captures' do
        # Setup a pawn to be capturable by the knight
        enemy_piece = pieces[11]
        allow(enemy_piece).to receive(:position).and_return([2, 3])

        other_pieces = pieces.reject.with_index { |_piece, index| index == 30 }

        list_of_moves = knight.moves(other_pieces)

        expected_moves = [
          { type: :capture, piece: knight, captured_piece: enemy_piece, ending_position: [2, 3] },
          { type: :standard, piece: knight, ending_position: [2, 5] },
          { type: :standard, piece: knight, ending_position: [3, 6] },
          { type: :standard, piece: knight, ending_position: [5, 6] },
          { type: :standard, piece: knight, ending_position: [5, 2] },
          { type: :standard, piece: knight, ending_position: [3, 2] },
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end
  end
end
