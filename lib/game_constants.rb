# frozen_string_literal: true

# Game info and settings used all throughout
module GameConstants
  # DISPLAY
  UNICODE_PIECES = {
    black: {
      Rook: "\u265c", Knight: "\u265e", Bishop: "\u265d", Queen: "\u265b",
      King: "\u265a", Pawn: "\u265f"
    },
    white: {
      Rook: "\u2656", Knight: "\u2658", Bishop: "\u2657", Queen: "\u2655",
      King: "\u2654", Pawn: "\u2659"
    }
  }.freeze

  # CASTLING
  LONG_SIDE_FILE = 0
  SHORT_SIDE_FILE = 7

  BLOCKER_FILES = {
    long_side: [1, 2, 3],
    short_side: [5, 6]
  }.freeze
end

# Alias for module
GConst = GameConstants
