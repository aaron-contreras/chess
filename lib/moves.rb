# frozen_string_literal: true

# Types of moves one can perform in the game.
module Moves
  Castling = Struct.new(:style, :king, :rook)
  EnPassant = Struct.new(:pawn, :enemy_pawn, :ending_position)
end
