# frozen_string_literal: true

require_relative 'chess_piece'
require_relative '../generators/standard_move_generator'

# A regular-moving piece.
# Jumps repeatedly accross the board, combining the jump directions from a
# Rook and Bishop.
class Queen < ChessPiece
  def initialize(player, position)
    super(player, position)
  end

  def moves(other_pieces)
    jump_directions = [[-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1]]

    generator = StandardMoveGenerator.new(self, other_pieces, jump_directions)

    generator.generate_moves
  end
end
