# frozen_string_literal: true

require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:chess_board) { described_class.new }

  it 'has a board with 8 ranks' do
    ranks = chess_board.instance_variable_get(:@board)

    expect(ranks.size).to eq 8
  end

  it 'has a board with 8 files' do
    files = chess_board.instance_variable_get(:@board).transpose

    expect(files.size).to eq 8
  end

  it 'has a board with 64 total squares' do
    board = chess_board.instance_variable_get(:@board).flatten

    expect(board.size).to eq 64
  end

  context 'when a game starts' do
    it "top two ranks are white player's pieces" do
      white_mixed_pieces = chess_board.instance_variable_get(:@board)[0]

      white_pawn_pieces = chess_board.instance_variable_get(:@board)[1]

      expect(white_mixed_pieces).to all(have_attributes(color: :white))

      expect(white_pawn_pieces).to all(have_attributes(color: :white))
    end

    it "bottom two ranks are black player's piece" do
      black_mixed_pieces = chess_board.instance_variable_get(:@board)[7]

      black_pawn_pieces = chess_board.instance_variable_get(:@board)[6]

      expect(black_mixed_pieces).to all(have_attributes(color: :black))

      expect(black_pawn_pieces).to all(have_attributes(color: :black)) end end
 
  describe '#move_piece' do
    context 'when no opponent piece is on target' do
      it 'moves the piece to target square' do
        piece_square = [1, 0] 
        target_square = [2, 0]

        moved_piece = chess_board.instance_variable_get(:@board)[piece_square[0]][piece_square[1]]

        chess_board.move_piece(piece_square, target_square)

        expect(chess_board[piece_square[0]][piece_square[1]]).to eq ' '
        expect(chess_board[target_square[0]][target_square[1]]).to eq moved_piece
      end
    end
  end
end
