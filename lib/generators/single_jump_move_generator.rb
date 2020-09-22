# frozen_string_literal: true

require_relative 'generator'

# Generates all moves for single-jumping pieces.
# This includes Knights and Kings
class SingleJumpMoveGenerator < Generator
  def initialize(piece, other_pieces, jump_directions)
    super(piece, other_pieces, jump_directions)
  end

  def generate_moves
    jump_directions.map do |direction|
      movable_locations(direction)
    end.compact
  end

  private

  def movable_locations(direction)
    hypothetical_position = next_jump(piece.position, direction)

    hypothetical_position if valid_position?(hypothetical_position)
  end
end
