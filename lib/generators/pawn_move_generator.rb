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

  def moves
    jump_directions.map do |direction|
      hypothetical_jump = next_jump(piece.position, direction)
      hypothetical_jump if valid_position?(hypothetical_jump)
    end
  end

  def captures
    capture_directions.map do |direction|
      hypothetical_capture = next_jump(piece.position, direction)
      hypothetical_capture if valid_capture?(hypothetical_capture)
    end
  end

  def valid_position?(position)
    inbound?(position) && no_piece_at?(position)
  end

  def valid_capture?(position)
    inbound?(position) && piece_at(position) && other_player_is_at?(position)
  end

  attr_reader :capture_directions
end
