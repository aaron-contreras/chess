# frozen_string_literal: true

require_relative 'chess_piece'
require_relative '../generators/pawn_move_generator'
class Pawn < ChessPiece
  def initialize(player, position)
    super(player, position)
  end

  def moves(other_pieces)
    generator = PawnMoveGenerator.new(self, other_pieces, jump_directions, capture_directions)

    generator.generate_moves
  end

  private

  def color_direction
    if player == :white
      1
    else
      -1
    end
  end

  def jump_directions
    if moved
      [[1 * color_direction, 0]]
    else
      [[1 * color_direction, 0], [2 * color_direction, 0]]
    end
  end

  def capture_directions
    [[1 * color_direction, -1], [1 * color_direction, 1]]
  end
end
