# frozen_string_literal: true

require_relative 'chess_piece'
require_relative '../generators/single_jump_move_generator'

class King < ChessPiece
  def initialize(player, position)
    super(player, position)
  end

  def moves(other_pieces)
    jump_directions = [[-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1]]

    generator = SingleJumpMoveGenerator.new(self, other_pieces, jump_directions)

    generator.generate_moves
  end

  def to_s
    if player == :white
      "\u2654"
    else
      "\u265a"
    end
  end
end
