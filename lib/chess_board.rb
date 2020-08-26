# frozen_string_literal: true

require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'
require_relative './pawn'

# Represents a chess board
class ChessBoard
  def initialize
    @board = initial_board_configuration
  end

  def move_piece(piece_square, target_square)
    piece_to_move = @board[piece_square[0]][piece_square[1]]

    @board[piece_square[0]][piece_square[1]] = ' '

    @board[target_square[0]][target_square[1]] = piece_to_move
  end

  private

  def initial_board_configuration
    [
      [Rook.new(:white), Knight.new(:white), Bishop.new(:white),
       Queen.new(:white), King.new(:white),
       Bishop.new(:white), Knight.new(:white), Rook.new(:white)],

      8.times.map { Pawn.new(:white) },

      [' '] * 8,
      [' '] * 8,
      [' '] * 8,
      [' '] * 8,

      8.times.map { Pawn.new(:black) },

      [Rook.new(:black), Knight.new(:black), Bishop.new(:black),
       Queen.new(:black), King.new(:black),
       Bishop.new(:black), Knight.new(:black), Rook.new(:black)]
    ]
  end
end
