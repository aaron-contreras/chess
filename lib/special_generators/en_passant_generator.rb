# frozen_string_literal: true
class EnPassant
  attr_reader :pawn, :enemy_pawn, :ending_position

  def initialize(pawn, enemy_pawn, ending_position)
    @pawn = pawn
    @enemy_pawn = enemy_pawn
    @ending_position = ending_position
  end
end

class EnPassantGenerator
  def initialize(pawn, other_pieces, capture_directions)
    @pawn = pawn
    @other_pieces = other_pieces
    @capture_directions = capture_directions
  end

  def en_passant_moves
    en_passant_moves = []
    enemy_pawn = capturable_enemy_pawn

    if enemy_pawn
      ending_position = target_position(enemy_pawn)

      en_passant_moves << EnPassant.new(pawn, enemy_pawn, ending_position)
    end

    en_passant_moves
  end

  private

  attr_reader :pawn, :other_pieces, :capture_directions

  def next_to_pawn?(piece)
    pawn.position[0] == piece.position[0] && (pawn.position[1] - piece.position[1]) == 1
  end

  def capturable_enemy_pawn
    other_pieces.find { |piece| piece.en_passant_capturable? && next_to_pawn?(piece) }
  end

  def target_position(enemy_piece)
    enemy_piece_file = enemy_piece.position[1]

    possible_targets = capture_directions.map do |direction|
      [pawn.position[0] + direction[0], pawn.position[1] + direction[1]]
    end

    possible_targets.find { |target| enemy_piece_file == target[1] }
  end
end
