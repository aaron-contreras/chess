# frozen_string_literal: true

require_relative '../generators/standard_move_generator'

# A regular moving piece.
# Jumps repeatedly across the board in a diagonal direction.
class Bishop
  attr_reader :player, :position
  def initialize(player, position)
    @player = player
    @position = position
  end

  def moves(other_pieces)
    jump_directions = [[-1, -1], [-1, 1], [1, 1], [1, -1]]

    generator = StandardMoveGenerator.new(self, other_pieces, jump_directions)

    generator.generate_moves
  end

  def to_s
    if player == :white
      "\u2657"
    else
      "\u265d"
    end
  end
end