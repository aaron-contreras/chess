# frozen_string_literal: true

require_relative '../game_constants'

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

  def en_passant_capturable?
    false
  end

  def to_s
    piece_type = self.class.to_s.to_sym 
    GConst::UNICODE_PIECES.dig(player, piece_type)
    # raise NotImplementedError, 'Give your piece a way to display itself on the board'
  end
end
