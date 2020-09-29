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

  # Dark brown/khaki
  SQUARE_COLOR = {
    dark: '#AC7C5B',
    light: '#EED3AE'
  }.freeze

  RANKS = 8
  FILES = 8

  EVEN_RANK = %i[light dark light dark light dark light dark].freeze

  ODD_RANK = EVEN_RANK.rotate

  EMPTY_SQUARE = ''

  # CASTLING
  LONG_SIDE_FILE = 0
  SHORT_SIDE_FILE = 7

  BLOCKER_FILES = {
    long_side: [1, 2, 3],
    short_side: [5, 6]
  }.freeze

  RANK_TO_LETTER = ('a'..'h').to_a
end

# Alias for module
GConst = GameConstants
