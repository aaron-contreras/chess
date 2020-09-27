# frozen_string_literal: true

require_relative '../moves'
require_relative '../game_constants'

# Generates valid castling moves between a king and its rooks
class CastlingGenerator
  def initialize(king, other_pieces)
    @king = king
    @other_pieces = other_pieces
    @king_rank = king.position[0]
  end

  def generate_castling
    castling_moves = []

    castling_moves << build_castling_move(:short_side) if valid_castle?(:short_side)

    castling_moves << build_castling_move(:long_side) if valid_castle?(:long_side)

    castling_moves
  end

  private

  attr_reader :king, :other_pieces, :king_rank

  def build_castling_move(style)
    rook = rook_getter(style)

    if style == :long_side
      king_ending_position = [king_rank, 2]
      rook_ending_position = [king_rank, 3]
    else
      king_ending_position = [king_rank, 6]
      rook_ending_position = [king_rank, 5]
    end

    { type: :castling, king: king, rook: rook, king_ending_position: king_ending_position, rook_ending_position: rook_ending_position }
  end

  def same_player?(piece)
    king.player == piece.player
  end

  def same_rank?(piece)
    king_rank == piece.position[0]
  end

  def castleable_rook?(piece, side)
    same_player?(piece) && same_rank?(piece) && piece.moved == false && piece.position[1] == side
  end

  def short_side_rook
    other_pieces.find { |piece| castleable_rook?(piece, GConst::SHORT_SIDE_FILE) }
  end

  def long_side_rook
    other_pieces.find { |piece| castleable_rook?(piece, GConst::LONG_SIDE_FILE) }
  end

  # Determine whether a rook is considered to be in the 'long' or 'short' side
  # of the board.

  def rook_side(rook)
    if rook.position[1].zero?
      :long_side
    else
      :short_side
    end
  end

  # Squares that must be empty in order to castle
  def blockers(style)
    ranks = 3.times.map { king_rank }
    ranks.zip(GConst::BLOCKER_FILES[style])
  end

  # No pieces between a king and a given rook
  def path_is_cleared?(rook)
    style = rook_side(rook)
    blocking_positions = blockers(style)

    other_pieces.none? { |piece| blocking_positions.include?(piece.position) }
  end

  # Gets the rook in given file
  def rook_getter(style)
    if style == :short_side
      short_side_rook
    else
      long_side_rook
    end
  end

  def valid_castle?(style)
    rook = rook_getter(style)

    king.moved == false && rook && path_is_cleared?(rook)
  end
end
