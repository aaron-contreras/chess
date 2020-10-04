# frozen_string_literal: true

require_relative '../game_constants'

# Base class with common attributes and behavior for a chess piece
class ChessPiece
  attr_reader :player, :starting_position
  attr_accessor :position, :moved, :double_jumped

  def initialize(player, position)
    @player = player
    @position = position
    @double_jumped = false
    @starting_position = position
  end

  def moves(_other_pieces)
    raise NotImplementedError, 'Implement to allow your chess piece to know how to move'
  end

  def en_passant_capturable?
    false
  end

  def promotable?
    false
  end

  def moved?
    starting_position != position
  end

  def to_s
    piece_type = self.class.to_s.to_sym

    GConst::UNICODE_PIECES.dig(player, piece_type)
  end

  def serialize
    JSON.dump(
      {
        '@player' => player,
        '@position' => position,
        '@double_jumped' => double_jumped,
        '@starting_position' => starting_position
      }
    )
  end
end
