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

  def capture?(position)
    position && inbound?(position) && piece_at(position) && other_player_is_at?(position)
  end

  def next_jump_captures?(moves, direction)
    return if moves.empty?

    last_jump = moves.last[:ending_position]

    jump = next_jump(last_jump, direction)

    capture?(jump)
  end

  def captures
    jump_directions.map do |direction|
      moves = valid_moves(direction)

      next unless next_jump_captures?(moves, direction)

      ending_position = next_jump(moves.last[:ending_position], direction)

      captured_piece = piece_at(ending_position)

      { type: :capture, piece: piece, captured_piece: captured_piece, ending_position: ending_position }
    end.compact
  end
end
