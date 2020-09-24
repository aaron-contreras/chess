# frozen_string_literal: true

require_relative 'chess_piece'
require_relative '../generators/pawn_move_generator'
require_relative '../special_generators/en_passant_generator'

# A chess piece with special moving conditions based on its current state in
# the game. Can perform a special type of move called "En Passant"
class Pawn < ChessPiece
  attr_accessor :double_jumped
  attr_reader :moves_since_double_jump

  def initialize(player, position)
    super(player, position)
    @double_jumped = false
    @moves_since_double_jump = 0
  end

  def moves(other_pieces)
    simple_generator = PawnMoveGenerator.new(self, other_pieces, jump_directions, capture_directions)

    special_generator = EnPassantGenerator.new(self, other_pieces, capture_directions)

    simple_generator.generate_moves + special_generator.en_passant_moves
  end

  def en_passant_capturable?
    double_jumped && moves_since_double_jump.zero?
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
