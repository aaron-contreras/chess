# frozen_string_literal: true

require_relative 'chess_piece'
require_relative '../generators/single_jump_move_generator'

class Knight < ChessPiece
  def initialize(player, position)
    super(player, position)
  end

  def moves(other_pieces)
    jump_directions = [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]

    generator = SingleJumpMoveGenerator.new(self, other_pieces, jump_directions)

    generator.generate_moves
  end
end
