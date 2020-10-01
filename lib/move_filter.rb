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
    @verifier = GameRuleVerifier.new(king, all_pieces)
  end

  def filter_out
    friendly_pieces = finder.friendly_pieces(player)
    enemy_pieces = finder.enemy_pieces(player)

    friendly_moves = moves(friendly_pieces)

    enemy_moves = moves(enemy_pieces)
    # reject all castles when the king is already in check
    if verifier.checkv2?(enemy_moves)
      friendly_moves = friendly_moves.reject { |move| move[:type] == :castling }
    end

    # reject all moves that will put the king in check after the move is made
    valid_moves = friendly_moves.reject { |move| will_be_check?(move) }

    valid_moves
  end

  private

  attr_reader :king, :player, :all_pieces, :finder, :verifier

  def will_be_check?(move)
    fake_pieces = all_pieces.map(&:dup)
    manager = PieceManager.new(fake_pieces)
    new_verifier = GameRuleVerifier.new(king.dup, fake_pieces)
    future_fake_pieces = manager.update_piece_set(move)

    will_be_check = new_verifier.check?(future_fake_pieces)

    if will_be_check
    end

    will_be_check
  end

  def moves(piece_set)
    piece_set.map do |piece|
      other_pieces = finder.other_pieces(piece)
      piece.moves(other_pieces)
    end.flatten
  end
end
