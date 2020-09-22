# frozen_string_literal: true

require_relative '../../lib/chess_pieces/rook'

# rubocop: disable all

RSpec.describe Rook do
  let(:pieces) do
    [
      double('White Left Rook', player: :white, position: [0, 0]),
      double('White Left Knight', player: :white, position: [0, 1]),
      double('White Left Bishop', player: :white, position: [0, 2]),
      double('White Queen', player: :white, position: [0, 3]),
      double('White King', player: :white, position: [0, 4]),
      double('White Right Bishop', player: :white, position: [0, 5]),
      double('White Right Knight', player: :white, position: [0, 6]),
      double('White Right Rook', player: :white, position: [0, 7]),
      double('White Pawn', player: :white, position:[1, 0]),
      double('White Pawn', player: :white, position:[1, 1]),
      double('White Pawn', player: :white, position:[1, 2]),
      double('White Pawn', player: :white, position:[1, 3]),
      double('White Pawn', player: :white, position:[1, 4]),
      double('White Pawn', player: :white, position:[1, 5]),
      double('White Pawn', player: :white, position:[1, 6]),
      double('White Pawn', player: :white, position:[1, 7]),

      double('Black Pawn', player: :black, position:[6, 0]),
      double('Black Pawn', player: :black, position:[6, 1]),
      double('Black Pawn', player: :black, position:[6, 2]),
      double('Black Pawn', player: :black, position:[6, 3]),
      double('Black Pawn', player: :black, position:[6, 4]),
      double('Black Pawn', player: :black, position:[6, 5]),
      double('Black Pawn', player: :black, position:[6, 6]),
      double('Black Pawn', player: :black, position:[6, 7]),

      double('Black Left Rook', player: :black, position: [7, 0]),
      double('Black Left Knight', player: :black, position: [7, 1]),
      double('Black Left Bishop', player: :black, position: [7, 2]),
      double('Black Queen', player: :black, position: [7, 3]),
      double('Black King', player: :black, position: [7, 4]),
      double('Black Right Bishop', player: :black, position: [7, 5]),
      double('Black Right Knight', player: :black, position: [7, 6]),
      double('Black Right Rook', player: :black, position: [7, 7])
    ]
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

    context 'when in a position to in 2 directions' do
      subject(:rook) { described_class.new(:white, [2, 0]) }

      it 'returns an array with all valid moves/captures' do
        # Ignore rook from piece list
        other_pieces = pieces.reject.with_index { |_piece, index| index.zero? }

        list_of_moves = rook.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [3, 0], [4, 0], [5, 0], [6, 0])
      end 
    end

    context 'when in a position to move in all directions' do
      subject(:rook) { described_class.new(:black, [4, 1]) }

      it 'returns an array with all valid moves/captures' do
        allow(pieces[14]).to receive(:position).and_return([4, 5])

        # Ignore rook from piece list
        other_pieces = pieces.reject.with_index { |_piece, index| index == 25 }

        list_of_moves = rook.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([3, 1], [2, 1], [1, 1], [4, 2], [4, 3], [4, 4], [4, 5], [5, 1], [4, 0])
      end
    end
  end
end
# rubocop: enable all