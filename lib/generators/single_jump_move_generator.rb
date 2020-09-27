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
      valid_moves(direction)
    end.compact
  end

  private

  # These pieces jump and (coincidentally) capture in their single jump per direction
  def valid_moves(direction)
    jump = next_jump(piece.position, direction)

    if valid_move?(jump)
      { type: :standard, piece: piece, ending_position: jump }
    elsif capture?(jump)
      enemy_piece = piece_at(jump)

      { type: :capture, piece: piece, captured_piece: enemy_piece, ending_position: jump }
    end
  end
end
