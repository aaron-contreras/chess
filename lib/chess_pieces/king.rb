# frozen_string_literal: true

require_relative 'chess_piece'
require_relative '../generators/single_jump_move_generator'
require_relative '../special_generators/castling_generator'

class King < ChessPiece
  attr_reader :moved

  def initialize(player, position)
    super(player, position)
    @moved = false
  end

  def moves(other_pieces)
    jump_directions = [[-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1]]

    generator = SingleJumpMoveGenerator.new(self, other_pieces, jump_directions)

    standard_moves = generator.generate_moves
    special_moves = castling(other_pieces)

    (standard_moves + special_moves).compact
  end

  def to_s
    if player == :white
      "\u2654"
    else
      "\u265a"
    end
  end

  private

  def castling(other_pieces)
    generator = CastlingGenerator.new(self, other_pieces)
    
    generator.generate_castling
  end
end
