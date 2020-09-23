# frozen_string_literal: true

# Base class with common attributes and behavior for a chess piece
class ChessPiece
  attr_reader :player, :position, :moved

  def initialize(player, position)
    @player = player
    @position = position
    @moved = false
  end

  def moves(other_pieces)
    raise NotImplementedError, 'Implement to allow your chess piece to know how to move'
  end
end
