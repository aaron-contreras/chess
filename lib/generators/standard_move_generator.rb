# frozen_string_literal: true

# Generates moves for standard moving pieces (Rooks and Bishops)
class StandardMoveGenerator
  def initialize(piece, other_pieces, jump_directions)
    @piece = piece
    @other_pieces = other_pieces
    @jump_directions = jump_directions
  end

  def generate_moves
    jump_directions.map do |direction|
      movable_locations(direction)
    end.reject(&:empty?).flatten(1)
  end

  private

  attr_reader :piece, :other_pieces, :jump_directions

  def movable_locations(direction, has_not_captured = true)
    locations_in_direction = []
    hypothetical_position = next_jump(piece.position, direction)

    while valid_position?(hypothetical_position) && has_not_captured
      locations_in_direction << hypothetical_position

      has_not_captured = false if capture?(hypothetical_position)

      hypothetical_position = next_jump(hypothetical_position, direction)

    end

    locations_in_direction
  end

  def next_jump(position, direction)
    [position[0] + direction[0], position[1] + direction[1]]
  end

  def valid_position?(position)
    inbound?(position) && (no_piece_at?(position) || other_player_is_at?(position))
  end

  def inbound?(position)
    position[0].between?(0, 7) && position[1].between?(0, 7)
  end

  def no_piece_at?(position)
    other_pieces.none? { |other_piece| other_piece.position == position }
  end

  def piece_at(position)
    other_pieces.select { |other_piece| other_piece.position == position }[0]
  end

  def other_player_is_at?(position)
    other_piece = piece_at(position)

    other_piece.player != piece.player
  end

  def capture?(position)
    inbound?(position) && piece_at(position) && other_player_is_at?(position)
  end
end
