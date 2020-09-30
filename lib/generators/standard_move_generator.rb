# frozen_string_literal: true

require_relative 'generator'

# Generates all moves for standard moving pieces (Rooks and Bishops) based on
# the directions in which they move.
# They are stopped from further jumping by friendly pieces and a first capture
# encounter.
class StandardMoveGenerator < Generator
  def initialize(piece, other_pieces, jump_directions)
    @piece = piece
    @other_pieces = other_pieces
    @jump_directions = jump_directions
  end

  def generate_moves
    moves + captures
  end

  private

  def moves
    jump_directions.map do |direction|
      valid_moves(direction)
    end.reject(&:empty?).flatten(1)
  end

  def valid_moves(direction)
    moves_in_direction = []
    jump = next_jump(piece.position, direction)

    while valid_move?(jump)
      moves_in_direction << { type: :standard, piece: piece, ending_position: jump }

      jump = next_jump(jump, direction)
    end

    moves_in_direction
  end

  def next_jump_captures?(next_jump, direction)
    if moves.empty?
      jump = next_jump(piece.position, direction)
    else

      last_jump = moves.last[:ending_position]

      jump = next_jump(last_jump, direction)
    end
  end

  def captures
    jump_directions.map do |direction|
      moves = valid_moves(direction)

      if moves.empty?
        next_jump = next_jump(piece.position, direction)
      else
        next_jump = next_jump(moves.last[:ending_position], direction)
      end

      next unless capture?(next_jump)

      ending_position = next_jump

      captured_piece = piece_at(ending_position)

      { type: :capture, piece: piece, captured_piece: captured_piece, ending_position: ending_position }
    end.compact
  end
end
