# frozen_string_literal: true

require_relative 'generator'

# Generates all moves for standard moving pieces (Rooks and Bishops) based on
# the directions in which they move.
# They are stopped from further jumping by friendly pieces and a first capture
# encounter.
class StandardMoveGenerator < Generator
  def initialize(piece, other_pieces, jump_directions)
    @piece = piece
    @other_pieces = other_pieces
    @jump_directions = jump_directions
  end

  def generate_moves
    jump_directions.map do |direction|
      movable_locations(direction)
    end.reject(&:empty?).flatten(1)
  end

  private

  def movable_locations(direction, has_not_captured = true)
    locations_in_direction = []
    hypothetical_position = next_jump(piece.position, direction)

    while valid_position?(hypothetical_position) && has_not_captured
      locations_in_direction << hypothetical_position

      has_not_captured = false if capture?(hypothetical_position)

      hypothetical_position = next_jump(hypothetical_position, direction)

    end

    locations_in_direction
  end

  def capture?(position)
    inbound?(position) && piece_at(position) && other_player_is_at?(position)
  end
end
