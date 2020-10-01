# frozen_string_literal: true

require 'tty-prompt'
require_relative 'lib/game_constants'
require_relative 'lib/board'
require_relative 'lib/chess_pieces/rook'
require_relative 'lib/chess_pieces/knight'
require_relative 'lib/chess_pieces/bishop'
require_relative 'lib/chess_pieces/queen'
require_relative 'lib/chess_pieces/king'
require_relative 'lib/chess_pieces/pawn'
require_relative 'lib/piece_manager'
require_relative 'lib/move_filter'
prompt = TTY::Prompt.new

player_piece_color = prompt.select('Select your pieces', GConst::PIECE_COLORS, cycle: true, show_help: :always)

p GConst::START_POSITIONS
white_piece_positions = GConst::START_POSITIONS.first(16)
black_piece_positions = GConst::START_POSITIONS - white_piece_positions

p white_piece_positions
puts
p black_piece_positions

# Sets pieces in right position

white_piece_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook] + [Pawn] * 8
black_piece_order = white_piece_order.rotate(8)

white_pieces = white_piece_positions.map.with_index do |position, piece_number|
  white_piece_order[piece_number].new(:white, position)
end

black_pieces = black_piece_positions.map.with_index do |position, piece_number|
  black_piece_order[piece_number].new(:black, position)
end

white_king = white_pieces[4]
black_king = black_pieces[11]

all_pieces = white_pieces + black_pieces
# require 'pry'
# binding.pry

p white_pieces
p black_pieces

board = Board.new(player_piece_color)
board.update(all_pieces)

# require 'pry'
# binding.pry

puts board

kings = {
  white: white_king,
  black: black_king
}

players = {
  white: white_pieces,
  black: black_pieces
}

active_player = :white
other_player = :black

choices = { a1: all_pieces[0], a2: all_pieces[1] }
answer = prompt.select("Select a piece to move", choices)
p answer
# loop do
#   manager = PieceManager.new(all_pieces)
#   filter = MoveFilter.new(kings[active_player], all_pieces)
#   verifier = GameRuleVerifier.new(kings[active_player], all_pieces)

#   moves = filter.filter_out

#   if verifier.checkmate?(moves) || verifier.stalemate?(moves)
#     puts 'GAME OVER'
#     break
#   end

#   all_pieces = manager.update_piece_set(moves.sample)

#   board.update(all_pieces)

#   puts board

#   # Update moves since a pawn double jumped
#   # Could be refactored into the pawn class
#   all_pieces.select(&:double_jumped).each do |pawn|
#     pawn.moves_since_double_jump += 1
#   end

#   # Switch turns
#   if active_player == :white
#     active_player = :black
#     other_player = :white
#   else
#     active_player = :white
#     other_player = :black
#   end
# end
