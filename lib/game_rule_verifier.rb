# frozen_string_literal: true

require_relative './piece_finder'
require_relative './piece_manager'

# Detects whether game rules such as "check", "checkmate", or "stalemate" are in place.
class GameRuleVerifier
  def initialize(king, all_pieces)
    @king = king
    @player = king.player
    @all_pieces = all_pieces
    @finder = PieceFinder.new(all_pieces)
  end

  def check?(all_pieces)
    enemy_moves = enemy_moves(all_pieces)

    enemy_moves.any? do |piece_moves|
      result = piece_moves.map do |move|
        move[:captured_piece]
      end.include?(king)
    end
  end

  def checkv2?(enemy_moves)
    enemy_moves.any? { |move| move[:captured_piece] == king }
  end

  def checkmate?(player_moves)
    player_moves.empty? && check?(all_pieces)
  end

  def stalemate?(player_moves)
    require 'pry'
    binding.pry
    player_moves.empty? && check?(all_pieces) == false
  end

  private

  attr_reader :king, :player, :all_pieces, :finder

  # def moves(pieces)
  #   finder = PieceFinder.new(all_pieces)

  #   pieces.map do |piece|
  #     other_pieces = finder.other_pieces(piece)
  #     piece.moves(other_pieces)
  #   end.flatten
  # end

  # def end_up_in_check?(move)
  #   manager = PieceManager.new(all_pieces)

  #   future_pieces = manager.update_piece_set(move)

  #   check?(future_pieces)
  # end

  def enemy_moves(all_pieces)
    finder = PieceFinder.new(all_pieces)

    enemy_pieces = finder.enemy_pieces(player)

    enemy_pieces.map do |piece|
      other_pieces = finder.other_pieces(piece)
      piece.moves(other_pieces)
    end
  end
end
