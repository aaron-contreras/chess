# frozen_string_literal: true

require_relative './piece_finder'
require_relative './piece_manager'
require_relative './game_rule_verifier'

class MoveFilter
  def initialize(king, all_pieces)
    @king = king
    @player = king.player
    @all_pieces = all_pieces
    @finder = PieceFinder.new(all_pieces)
    @manager = PieceManager.new(all_pieces)
    @verifier = GameRuleVerifier.new(king, all_pieces)
  end

  def filter_out
    # reject all moves that will put the king in check after the move is made
    friendly_pieces = finder.friendly_pieces(player)
    enemy_pieces = finder.enemy_pieces(player)
    
    friendly_moves = moves(friendly_pieces)

    enemy_moves = moves(enemy_pieces)

    if verifier.check?(all_pieces)
      friendly_moves = friendly_moves.reject { |move| move[:type] == :castling }
    end

    friendly_moves.reject do |move|
      future_pieces = manager.update_piece_set(move)
      verifier.check?(future_pieces)
    end
    # reject all castles when the king is already in check

  end

  private

  attr_reader :king, :player, :all_pieces, :finder, :manager, :verifier

  def moves(piece_set)
    piece_set.map do |piece|
      other_pieces = finder.other_pieces(piece)
      piece.moves(other_pieces)
    end.flatten
  end
end