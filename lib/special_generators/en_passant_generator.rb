# frozen_string_literal: true

# Generates valid 'En Passant' moves for a pawn
class EnPassantGenerator
  def initialize(pawn, other_pieces, capture_directions)
    @pawn = pawn
    @other_pieces = other_pieces
    @capture_directions = capture_directions
  end

  def en_passant_moves
    en_passant_moves = []

    if capturable_enemy_pawn?
      enemy_pawn = find_capturable_enemy_pawn

      move = { type: :en_passant, piece: pawn, captured_piece: enemy_pawn, ending_position: ending_position(enemy_pawn) }

      en_passant_moves << move
    end

    en_passant_moves
  end

  private

  attr_reader :pawn, :other_pieces, :capture_directions

  def adjacent?(piece)
    (pawn.position[1] - piece.position[1]).abs == 1
  end

  def next_to_pawn?(piece)
    pawn.position[0] == piece.position[0] && adjacent?(piece)
  end

  def capturable_enemy_pawn?
    other_pieces.any? { |piece| piece.en_passant_capturable? && next_to_pawn?(piece) }
  end

  def find_capturable_enemy_pawn
    other_pieces.find { |piece| piece.en_passant_capturable? && next_to_pawn?(piece) }
  end

  def file_difference(enemy_piece)
    enemy_piece.position[1] - pawn.position[1]
  end

  # Capture direction based on where the enemy pawn is
  def select_capture_direction(enemy_piece)
    capture_directions.find { |direction| direction[1] == file_difference(enemy_piece) }
  end

  def ending_position(enemy_piece)
    capture_direction = select_capture_direction(enemy_piece)

    [pawn.position[0] + capture_direction[0], pawn.position[1] + capture_direction[1]]
  end
end
