# frozen_string_literal: true

require_relative '../lib/chess_pieces/rook'
require_relative '../lib/board'
require_relative './shared/among_chess_pieces'
RSpec.describe Board do
  subject(:board) { described_class.new(:white) }
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

  describe '#to_s' do
    it 'prints a nicely formatted board' do
      piece1 = Rook.new(:black, [0, 0])
      piece2 = Rook.new(:white, [1, 0])

      squares = [
        8.times.map { piece1 },
        8.times.map { piece1 },
        [piece1, piece2] + 6.times.map { '' },
        8.times.map { '' },
        8.times.map { '' },
        8.times.map { '' },
        8.times.map { piece2 },
        8.times.map { piece2 }
      ]

      board.instance_variable_set(:@grid, squares)

      puts board
      require 'pry'
      binding.pry
    end
  end
end
