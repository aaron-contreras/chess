# frozen_string_literal: true

# Game info and settings used all throughout
module GameConstants
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
end

# Alias for module
GConst = GameConstants
