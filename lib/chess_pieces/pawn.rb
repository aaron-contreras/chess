# frozen_string_literal: true

require_relative 'chess_piece'

class Pawn < ChessPiece
  def initialize(player, position)
    super(player, position)
  end

  def moves(other_pieces)
    []
  end
end
