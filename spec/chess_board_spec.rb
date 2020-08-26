# frozen_string_literal: true

require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:chess_board) { described_class.new } 

  describe '#move_piece' do
    let(:start_coordinates) { [1, 0] }
    let(:end_coordinates) { [2, 0] }
    let(:board) { chess_board.instance_variable_get(:@board) }

    context 'when the target square is empty' do
      it 'moves the piece to the target square' do
        moved_piece = board.dig(*start_coordinates)

        chess_board.move_piece(start_coordinates, end_coordinates)

        expect(board.dig(*end_coordinates)).to eq moved_piece
      end
    end

    context 'when the target square is not empty' do
      it 'captures the piece at the target square' do
        moved_piece = board.dig(*start_coordinates)

        board[end_coordinates[0]][end_coordinates[1]] = double('Dummy pawn')

        chess_board.move_piece(start_coordinates, end_coordinates)

        expect(board.dig(*end_coordinates)).to eq moved_piece
      end
    end
  end
end
