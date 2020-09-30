# frozen_string_literal: true

require_relative '../../lib/chess_pieces/rook'
require_relative '../shared/among_chess_pieces.rb'

# rubocop: disable all


RSpec.describe Rook do
  include_context 'list_of_pieces'

  describe '#to_s' do
    include_examples 'piece_display', described_class.new(:white, [0, 0])
    include_examples 'piece_display', described_class.new(:black, [7, 0])
  end

  describe '#moves' do
    context 'when not in a position to move' do
      subject(:rook) { described_class.new(:white, [0, 0]) }

      it 'returns an empty array' do
        other_pieces = pieces.reject.with_index { |_piece, index| index.zero? }

        list_of_moves = rook.moves(other_pieces)

        expect(list_of_moves).to be_empty
      end
    end

    context 'when in a position to move in 2 directions' do
      subject(:rook) { described_class.new(:white, [2, 0]) }

      it 'returns an array with all valid moves/captures' do
        captured_enemy = pieces[16]

        # Ignore rook from piece list
        other_pieces = pieces.reject.with_index { |_piece, index| index.zero? }

        list_of_moves = rook.moves(other_pieces)

        expected_moves = [
          { type: :capture, piece: rook, captured_piece: captured_enemy, ending_position: [6, 0] }, 

          { type: :standard, piece: rook, ending_position: [5, 0] },
          { type: :standard, piece: rook, ending_position: [4, 0] },
          { type: :standard, piece: rook, ending_position: [3, 0] },
          { type: :standard, piece: rook, ending_position: [2, 1] },
          { type: :standard, piece: rook, ending_position: [2, 2] },
          { type: :standard, piece: rook, ending_position: [2, 3] },
          { type: :standard, piece: rook, ending_position: [2, 4] },
          { type: :standard, piece: rook, ending_position: [2, 5] },
          { type: :standard, piece: rook, ending_position: [2, 6] },
          { type: :standard, piece: rook, ending_position: [2, 7] }
        ]
        expect(list_of_moves).to contain_exactly(*expected_moves)
      end 
    end

    context 'when in a position to move in all directions' do
      subject(:rook) { described_class.new(:black, [4, 1]) }

      it 'returns an array with all valid moves/captures' do
        captured_enemy_top = pieces[9]
        captured_enemy_right = pieces[14]
        allow(captured_enemy_right).to receive(:position).and_return([4, 5])

        # Ignore rook from piece list
        other_pieces = pieces.reject.with_index { |_piece, index| index == 25 }

        list_of_moves = rook.moves(other_pieces)


        expected_moves = [
          { type: :capture, piece: rook, captured_piece: captured_enemy_right, ending_position: [4, 5] }, 
          { type: :standard, piece: rook, ending_position: [3, 1] },
          { type: :standard, piece: rook, ending_position: [2, 1] },
          { type: :capture, piece: rook, captured_piece: captured_enemy_top, ending_position: [1, 1] },
          { type: :standard, piece: rook, ending_position: [4, 2] },
          { type: :standard, piece: rook, ending_position: [4, 3] },
          { type: :standard, piece: rook, ending_position: [4, 4] },
          { type: :standard, piece: rook, ending_position: [5, 1] },
          { type: :standard, piece: rook, ending_position: [4, 0] }
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end

    context 'when in a position to capture directly next to it' do
      subject(:rook) { described_class.new(:black, [2, 0]) }

      it 'returns a capture with the piece next to it' do
        other_pieces = pieces.reject { |piece| piece == rook }

        piece_next_to_rook = pieces[8]


        expected_capture = {
          type: :capture, piece: rook, captured_piece: piece_next_to_rook, ending_position: [1, 0]
        }

        list_of_moves = rook.moves(other_pieces)

        expect(list_of_moves).to include(expected_capture)
      end
    end
  end
end
# rubocop: enable all
