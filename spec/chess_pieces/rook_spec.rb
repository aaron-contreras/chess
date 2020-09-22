# frozen_string_literal: true

require_relative '../../lib/chess_pieces/rook'
require_relative '../shared/among_chess_pieces.rb'
# rubocop: disable all

RSpec.describe Rook do
  include_context 'list_of_pieces'

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

  describe '#to_s' do
    context 'when it belongs to white player' do
      subject(:rook) { described_class.new(:white, [0, 0]) }

      it 'returns a white unicode rook' do
        white_unicode_rook = "\u2656"

        stringified_rook = rook.to_s

        expect(stringified_rook).to eq white_unicode_rook
      end
    end
    
    context 'when it belongs to black player' do
      subject(:rook) { described_class.new(:black, [7, 7]) }

      it 'returns a black unicode rook' do
        black_unicode_rook = "\u265c"

        stringified_rook = rook.to_s

        expect(stringified_rook).to eq black_unicode_rook
      end
    end
  end
end
# rubocop: enable all
