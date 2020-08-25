# frozen_string_literal: true

require_relative '../lib/chess_board'

# rubocop: disable Metrics/BlockLength
describe ChessBoard do
  describe '#move_piece' do
    let(:piece_square) { [1, 0] }
    let(:target_square) { [2, 0] }

    context 'when a target square is empty' do
      let(:chess_board) { ChessBoard.new }
      let(:board) { chess_board.instance_variable_get(:@board) }


      it 'moves the piece to the target square' do
        moved_piece = board[piece_square[0]][piece_square[1]]

        chess_board.move_piece(piece_square, target_square)

        expect(board[target_square[0]][target_square[1]]).to eq(moved_piece)
      end
    end


    context "when the target square has an opponent's piece" do
      let(:chess_board) { ChessBoard.new }
      let(:board) { chess_board.instance_variable_get(:@board) }

      it "captures the opponent's piece" do
        require 'pry'
        binding.pry
        board[target_square[0]][target_square[1]] = double('Pawn')

        moved_piece = board[piece_square[0]][piece_square[1]]

        chess_board.move_piece(piece_square, target_square)

        expect(board[target_square[0]][target_square[1]]).to eq(moved_piece)
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
