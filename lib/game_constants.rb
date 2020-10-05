# frozen_string_literal: true

# Game info and settings used all throughout
module GameConstants
  # DISPLAY
  PIECE_COLORS = { 'Black': :black, 'White': :white }.freeze

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

  BOARD_THEME = {
    classic: {
      dark: '#AC7C5B',
      light: '#EED3AE'
    },
    aged: {
      dark: '#724211',
      light: '#E5A853'
    },
    marble: {
      dark: '#5D565A',
      light: '#BFBBBE'
    }
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

  # Index to file conversion
  INDEX_TO_FILE = ('a'..'h').to_a

  # Index to rank conversion
  INDEX_TO_RANK = ('1'..'8').to_a

  PADDING_ROW = Array.new(8) { ' ' }

  # Positions where pieces will be placed on the board at the start of a game
  PIECE_SQUARES = (0..7).to_a.repeated_permutation(2).to_a.select { |rank, _file| [0, 1, 6, 7].include?(rank) }

  STARTING_POSITIONS = {
    white: PIECE_SQUARES.first(16),
    black: PIECE_SQUARES[16..-1]
  }.freeze

  MOVE_PRECEDENCE = [
    proc { |move| move[:type] == :en_passant },
    proc { |move| move[:type] == :castling },
    proc { |move| move[:type] == :capture },
    proc { |move| move[:type] == :standard }
  ].freeze
end

