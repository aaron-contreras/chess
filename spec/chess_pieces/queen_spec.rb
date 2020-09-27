# frozen_string_literal: true

require_relative '../../lib/chess_pieces/queen'
require_relative '../shared/among_chess_pieces'
# rubocop: disable all

RSpec.describe Queen do
  include_context 'list_of_pieces'

  describe '#to_s' do
    include_examples 'piece_display', described_class.new(:white, [0, 3])
    include_examples 'piece_display', described_class.new(:black, [7, 3])
  end

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

        expected_moves = [
          { type: :standard, piece: queen, ending_position: [6, 2] },
          { type: :standard, piece: queen, ending_position: [5, 1] },
          { type: :standard, piece: queen, ending_position: [4, 0] },
          { type: :standard, piece: queen, ending_position: [6, 4] },
          { type: :standard, piece: queen, ending_position: [5, 5] },
          { type: :standard, piece: queen, ending_position: [4, 6] },
          { type: :standard, piece: queen, ending_position: [3, 7] }
        ]
        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end

    context 'when in a position to move in all directions' do
      subject(:queen) { described_class.new(:white, [3, 3])}

      it 'returns all valid moves/captures' do
        captured_pawn_left = pieces[16]
        captured_pawn_middle = pieces[19]
        captured_pawn_right = pieces[22]

        other_pieces = pieces.reject.with_index { |_piece, index| index == 3}

        list_of_moves = queen.moves(other_pieces)

        expected_moves = [
          { type: :capture, piece: queen, captured_piece: captured_pawn_left, ending_position: [6, 0] },
          { type: :capture, piece: queen, captured_piece: captured_pawn_middle, ending_position: [6, 3] },
          { type: :capture, piece: queen, captured_piece: captured_pawn_right, ending_position: [6, 6] },
          { type: :standard, piece: queen, ending_position: [2, 3] },
          { type: :standard, piece: queen, ending_position: [2, 4] },
          { type: :standard, piece: queen, ending_position: [3, 4] },
          { type: :standard, piece: queen, ending_position: [3, 5] },
          { type: :standard, piece: queen, ending_position: [3, 6] },
          { type: :standard, piece: queen, ending_position: [3, 7] },
          { type: :standard, piece: queen, ending_position: [4, 4] },
          { type: :standard, piece: queen, ending_position: [5, 5] },
          { type: :standard, piece: queen, ending_position: [4, 3] },
          { type: :standard, piece: queen, ending_position: [5, 3] },
          { type: :standard, piece: queen, ending_position: [4, 2] },
          { type: :standard, piece: queen, ending_position: [5, 1] },
          { type: :standard, piece: queen, ending_position: [3, 2] },
          { type: :standard, piece: queen, ending_position: [3, 1] },
          { type: :standard, piece: queen, ending_position: [3, 0] },
          { type: :standard, piece: queen, ending_position: [2, 2] }
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end
  end
end
# rubocop: disable all
