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
    it 'has the proper piece configuration' do
      board = chess_board.instance_variable_get(:@board)

      initial_board_configuration = [
        [Rook.new(:white), Knight.new(:white), Bishop.new(:white), Queen.new(:white), King.new(:white), Bishop.new(:white), Knight.new(:white), Rook.new(:white)],
        [Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white)],
        [' '] * 8,
        [' '] * 8,
        [' '] * 8,
        [' '] * 8,
        [Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black)],
        [Rook.new(:black), Knight.new(:black), Bishop.new(:black), Queen.new(:black), King.new(:black), Bishop.new(:black), Knight.new(:black), Rook.new(:black)]
      ]

      expect(board).to eq initial_board_configuration
    end
  end
end
