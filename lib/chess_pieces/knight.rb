# frozen_string_literal: true

require_relative 'chess_piece'
require_relative '../generators/single_jump_move_generator'

# A single-jumping piece which can 'gallop' over pieces blocking it.
# Moves in an L-shaped path
class Knight < ChessPiece
  def initialize(player, position)
    super(player, position)
  end

  def moves(other_pieces)
    jump_directions = [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]

    generator = SingleJumpMoveGenerator.new(self, other_pieces, jump_directions)

    generator.generate_moves
  end

  def to_s
    if player == :white
      "\u2658"
    else
      "\u265e"
    end
  end
end
