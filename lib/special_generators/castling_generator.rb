# frozen_string_literal: true

require_relative '../moves'
# class Castling
#   def initialize(style, king, rook)
#     @style = style
#     @king = king
#     @rook = rook
#   end
# end

class CastlingGenerator
  def initialize(king, other_pieces)
    @king = king
    @other_pieces = other_pieces
  end

  def generate_castling
    castling_moves = []

    unless king.moved
      if long_side_rook && path_is_cleared?(long_side_rook)
        castling_moves << Moves::Castling.new(:long_side, king, long_side_rook)
      end

      if short_side_rook && path_is_cleared?(short_side_rook)
        castling_moves << Moves::Castling.new(:short_side, king, short_side_rook)
      end
    end

    castling_moves
  end

  private

  attr_reader :king, :other_pieces

  def short_side_rook
    other_pieces.find { |piece| piece.player == king.player && piece.moved == false && piece.position[0] == king.position[0] && piece.position[1] == 7 }
  end

  def long_side_rook
    other_pieces.find { |piece| piece.player == king.player && piece.moved == false && piece.position[0] == king.position[0] && piece.position[1] == 0 }
  end

  def path_is_cleared?(rook)
    row = rook.position[0]

    if long_side?(rook)
      other_pieces.none? { |piece| [[row, 1], [row, 2], [row, 3]].include?(piece.position) }
    else
      other_pieces.none? { |piece| [[row, 5], [row, 6]].include?(piece.position) }
    end
  end

  def long_side?(rook)
    rook.position[1] == 0
  end

  def short_side?(rook)
    rook.position[1] == 7
  end
end
