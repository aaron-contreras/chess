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
end
