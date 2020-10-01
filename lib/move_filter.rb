# frozen_string_literal: true

require_relative './piece_finder'
require_relative './piece_manager'
require_relative './game_rule_verifier'

class MoveFilter2

  attr_reader :active_player, :all_pieces, :verifier

  def initialize(active_player, all_pieces, verifier)
    @active_player = active_player
    @all_pieces = all_pieces
    @verifier = verifier
  end

  def filter_out(friendly_moves, enemy_moves, all_pieces)
    if verifier.checkv2?(enemy_moves)
      friendly_moves = friendly_moves.reject { |move| move[:type] == :castling }
    end

    friendly_moves = friendly_moves.reject { |move| will_be_check?(move) }
  end

  def will_be_check?(move)
    fake_pieces = all_pieces.map(&:dup)
    manager = PieceManager.new(fake_pieces)
    future_fake_pieces = manager.update_piece_set(move)

    finder = PieceFinder.new(future_fake_pieces)
    fake_enemy_pieces = finder.enemy_pieces(active_player)

    will_be_check = verifier.check?(enemy_pieces)
  end
end

class MoveFilter
  attr_reader :active_player, :all_pieces, :verifier

  def initialize(active_player, all_pieces, verifier)
    @active_player = active_player
    @all_pieces = all_pieces
    @verifier = verifier
  end

  def filter_out(friendly_moves, enemy_moves)
    friendly_moves = friendly_moves.reject { |move| move[:type] == :castling } if verifier.checkv2?(enemy_moves)

    friendly_moves.reject { |move| will_be_check?(move) }
  end

  # If a move is performed, will the king be in check?
  def will_be_check?(move)
    fake_pieces = all_pieces.map(&:dup)
    manager = PieceManager.new(fake_pieces)
    future_fake_pieces = manager.update_piece_set(move)

    finder = PieceFinder.new(future_fake_pieces)
    fake_enemy_pieces = finder.enemy_pieces(active_player)
    fake_enemy_moves = moves_for(fake_enemy_pieces, future_fake_pieces)

    verifier.checkv2?(fake_enemy_moves)
  end

  def moves_for(enemy_pieces, all_pieces)
    enemy_pieces.map do |piece|
      finder = PieceFinder.new(all_pieces)
      other_pieces = finder.other_pieces(piece)
      piece.moves(other_pieces)
    end
  end
end
# def initialize(king = nil, all_pieces = nil)
#     @king = king
#     @player = king.player
#     @all_pieces = all_pieces
#     @finder = PieceFinder.new(all_pieces)
#     @verifier = GameRuleVerifier.new(king, all_pieces)
#   end

#   def filter_out
#     friendly_pieces = finder.friendly_pieces(player)
#     enemy_pieces = finder.enemy_pieces(player)

#     friendly_moves = moves(friendly_pieces)

#     enemy_moves = moves(enemy_pieces)
#     # reject all castles when the king is already in check
#     if verifier.checkv2?(enemy_moves)
#       friendly_moves = friendly_moves.reject { |move| move[:type] == :castling }
#     end

#     # reject all moves that will put the king in check after the move is made
#     valid_moves = friendly_moves.reject { |move| will_be_check?(move) }

#     valid_moves
#   end

#   def filter_out_v2(friendly_moves)

#   private

#   attr_reader :king, :player, :all_pieces, :finder, :verifier

#   def will_be_check?(move)
#     fake_pieces = all_pieces.map(&:dup)
#     manager = PieceManager.new(fake_pieces)
#     new_verifier = GameRuleVerifier.new(king.dup, fake_pieces)
#     future_fake_pieces = manager.update_piece_set(move)

#     will_be_check = new_verifier.check?(future_fake_pieces)

#     if will_be_check
#     end

#     will_be_check
#   end

#   def moves(piece_set)
#     piece_set.map do |piece|
#       other_pieces = finder.other_pieces(piece)
#       piece.moves(other_pieces)
#     end.flatten
#   end
# end
