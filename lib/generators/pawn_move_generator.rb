# frozen_string_literal: true

require_relative 'generator'

class PawnMoveGenerator < Generator
  def initialize(piece, other_pieces, jump_directions, capture_directions)
    super(piece, other_pieces, jump_directions)

    @capture_directions = capture_directions
  end

  def generate_moves
    (moves + captures).compact
  end

  private

  attr_reader :capture_directions

  def moves
    jump_directions.map do |direction|
      jump = next_jump(piece.position, direction)

      { type: :standard, piece: piece, ending_position: jump } if valid_move?(jump)
    end
  end

  def captures
    capture_directions.map do |direction|
      jump = next_jump(piece.position, direction)

      { type: :capture, piece: piece, captured_piece: piece_at(jump), ending_position: jump } if valid_capture?(jump)
    end
  end

  def valid_move?(position)
    inbound?(position) && no_piece_at?(position)
  end

  def valid_capture?(position)
    inbound?(position) && piece_at(position) && other_player_is_at?(position)
  end
end
