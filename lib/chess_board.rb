# frozen_string_literal: true

require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'
require_relative './pawn'

# Represents a chess board
class ChessBoard
  # rubocop: disable Metrics/LineLength
  INITIAL_BOARD_CONFIGURATION = [
    [Rook.new(:white), Knight.new(:white), Bishop.new(:white), Queen.new(:white), King.new(:white), Bishop.new(:white), Knight.new(:white), Rook.new(:white)],

    8.times.map { Pawn.new(:white) },

    [' '] * 8,
    [' '] * 8,
    [' '] * 8,
    [' '] * 8,

    8.times.map { Pawn.new(:black) },

    [Rook.new(:black), Knight.new(:black), Bishop.new(:black), Queen.new(:black), King.new(:black), Bishop.new(:black), Knight.new(:black), Rook.new(:black)]
  ].freeze
  # rubocop: enable Metrics/LineLength

  def initialize
    @board = INITIAL_BOARD_CONFIGURATION
  end
end
