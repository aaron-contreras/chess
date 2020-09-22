# frozen_string_literal: true

class Generator

  def initialize(piece, other_pieces, jump_directions)
    @piece = piece
    @other_pieces = other_pieces
    @jump_directions = jump_directions
  end

  private

  attr_reader :piece, :other_pieces, :jump_directions

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
end