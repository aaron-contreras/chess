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

prompt = TTY::Prompt.new

player_piece_color = prompt.select('Select your pieces', GConst::PIECE_COLORS, cycle: true, show_help: :always)

p GConst::PIECE_POSITIONS
# white_pieces = [Rook.new(:white, )]
# board = Board.new(player_piece_color)
# puts board
