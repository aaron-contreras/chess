# frozen_string_literal: true
class EnPassant
  def initialize(enemy_piece, ending_location); end
end
class EnPassantGenerator
  def initialize(pawn, other_pieces, capture_directions)
    @pawn = pawn
    @other_pieces = other_pieces
    @capture_directions
  end

  def en_passant_moves
    en_passant_moves = []

    enemy_piece = capturable_enemy_pawn

    # require 'pry-byebug'
    # binding.pry

    en_passant_moves << [EnPassant.new(enemy_piece, target_position(enemy_piece))] if enemy_piece
    
    en_passant_moves
  end

  private
  
  attr_reader :pawn, :other_pieces, :capture_directions

  def next_to_pawn?(piece)
    pawn.location[0] == piece.location[0] && (pawn.location[1] - piece.location[1]) == 1
  end

  def capturable_enemy_pawn
    other_pieces.find { |piece| piece.en_passant_capturable? && next_to_pawn?(piece) }
  end

  def target_position(enemy_piece)
    enemy_piece_file = enemy_piece.position[1]

    possible_targets = capture_directions.map do |direction|
      [pawn.location[0] + direction[0], pawn.location[1] + direction[1]]
    end

    possible_targets.find { |target| enemy_piece_file == target[1] }
  end
end

