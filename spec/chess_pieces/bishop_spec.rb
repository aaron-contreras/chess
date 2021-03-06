# frozen_string_literal: true

require_relative '../../lib/chess_pieces/bishop'
require_relative '../shared/among_chess_pieces'

# rubocop: disable all

RSpec.describe Bishop do
  include_context 'list_of_pieces'

  describe '#to_s' do
    include_examples 'piece_display', described_class.new(:white, [0, 2])
    include_examples 'piece_display', described_class.new(:black, [7, 2])
  end

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
        captured_enemy_pawn = pieces[15]

        other_pieces = pieces.reject.with_index { |_piece, index| index == 27 }        

        list_of_moves = bishop.moves(other_pieces)

        expected_moves = [
          { type: :capture, piece: bishop, captured_piece: captured_enemy_pawn, ending_position: [1, 7] }, 
          { type: :standard, piece: bishop, ending_position: [4, 2] },
          { type: :standard, piece: bishop, ending_position: [3, 1] },
          { type: :standard, piece: bishop, ending_position: [2, 0] },
          { type: :standard, piece: bishop, ending_position: [4, 4] },
          { type: :standard, piece: bishop, ending_position: [3, 5] },
          { type: :standard, piece: bishop, ending_position: [2, 6] },
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end

    context 'when in a position to move in all directions' do
      subject(:bishop) { described_class.new(:white, [3, 5]) }

      it 'returns an array with all valid moves/captures' do
        captured_enemy_pawn = pieces[18]

        other_pieces = pieces.reject.with_index { |_piece, index| index == 5 }

        list_of_moves = bishop.moves(other_pieces)

        expected_moves = [
          { type: :capture, piece: bishop, captured_piece: captured_enemy_pawn, ending_position: [6, 2] },
          { type: :standard, piece: bishop, ending_position: [2, 4] },
          { type: :standard, piece: bishop, ending_position: [2, 6] },
          { type: :standard, piece: bishop, ending_position: [4, 6] },
          { type: :standard, piece: bishop, ending_position: [5, 7] },
          { type: :standard, piece: bishop, ending_position: [4, 4] },
          { type: :standard, piece: bishop, ending_position: [5, 3] },
        ]


        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end
  end
end
# rubocop: enable all
