# frozen_string_literal: true

require_relative './piece_finder'
require_relative './piece_manager'
require_relative './chess_pieces/king'

# Detects whether game rules such as "check", "checkmate", or "stalemate" are in place.
class RuleVerifier
  def check?(enemy_moves)
    enemy_moves.any? { |move| move[:captured_piece].is_a?(King) }
  end

  def checkmate?(friendly_moves, enemy_moves)
    friendly_moves.empty? && check?(enemy_moves)
  end

  def stalemate?(friendly_moves, enemy_moves)
    friendly_moves.empty? && check?(enemy_moves) == false
  end
end
