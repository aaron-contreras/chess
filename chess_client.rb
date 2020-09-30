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
black_king = black_pieces[4]

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

players = {
  white: white_pieces,
  black: black_pieces
}

active_player = players[:white]
finder = PieceFinder.new(all_pieces)
manager = PieceManager.new(all_pieces)
filter = MoveFilter.new(white_king, all_pieces)

moves = filter.filter_out

updated_piece_set = manager.update_piece_set(moves.last)

board.update(updated_piece_set)

puts board

filter = MoveFilter.new(black_king, updated_piece_set)

moves = filter.filter_out

updated_piece_set = manager.update_piece_set(moves.last)

board.update(updated_piece_set)

puts board

pp updated_piece_set.select(&:moved?)
