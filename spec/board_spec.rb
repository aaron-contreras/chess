# frozen_string_literal: true

require_relative '../lib/board'
require_relative './shared/among_chess_pieces'
RSpec.describe Board do
  subject(:board) { described_class.new }
  include_context 'list_of_pieces'

  describe '#place' do
    it 'places the piece on its spot in the board' do
      position = [1, 0]

      piece = pieces.find { |piece| piece.position == position }

      board.place(piece)

      expect(board.grid.dig(*position)).to eq(piece)
    end
  end

  describe '#update' do
    context 'when a former piece is not given' do

      before do
        pieces.each do |piece|
          board.place(piece)
        end
      end

      it 'removes the piece from the board' do
        excluded_piece = pieces[0]
        new_piece_set = pieces[1..-1]

        board.update(new_piece_set)

        expect(board.hold?(excluded_piece)).to eq(false)
      end
    end
  end
end