# frozen_string_literal: true

class GameRuleVerifier
  def initialize(king, friendly_pieces, enemy_pieces)
    @king = king
    @friendly_pieces = friendly_pieces
    @enemy_pieces = enemy_pieces
    @all_pieces = friendly_pieces + enemy_pieces
  end

  def check?
    enemy_moves.any? do |piece_moves|
      piece_moves.map do |move|
        move[:captured_piece]
      end.include?(king)
    end
  end
  
  private

  attr_reader :king, :friendly_pieces, :enemy_pieces, :all_pieces

  def other_pieces(piece)
    all_pieces.reject { |piece_from_set| piece_from_set == piece }
  end

  def enemy_moves
    enemy_pieces.map do |piece|
      others = other_pieces(piece)
      piece.moves(others)
    end
  end
end