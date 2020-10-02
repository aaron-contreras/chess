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
require_relative 'lib/translator'
require_relative 'lib/rule_verifier'
prompt = TTY::Prompt.new

# Executable
class ChessClient
  attr_accessor :player_piece_color, :all_pieces, :board, :active_player, :non_active_player,
                :time_started, :moves_performed, :capture_list, :finder, :translator, :verifier

  def run
    prompt = TTY::Prompt.new
    choices = {
      'New game': proc { create_new_game }
    }
    answer = prompt.select('Main menu', choices)
    puts answer
  end

  def create_new_game
    piece_color_selection

    self.time_started = Time.new

    self.board = Board.new(player_piece_color)
    create_pieces
    board.update(all_pieces)

    self.active_player = :white
    self.non_active_player = :black

    start_game
  end

  def piece_color_selection
    prompt = TTY::Prompt.new
    piece_colors = { 'Black': :black, 'White': :white }
    self.player_piece_color = prompt.select('Select your pieces', piece_colors)
  end

  def create_pieces
    white_pieces = GameConstants::STARTING_POSITIONS[:white].map.with_index do |position, piece_number|
      GameConstants::WHITE_PIECE_LAYOUT[piece_number].new(:white, position)
    end

    black_pieces = GameConstants::STARTING_POSITIONS[:black].map.with_index do |position, piece_number|
      GameConstants::BLACK_PIECE_LAYOUT[piece_number].new(:black, position)
    end

    self.all_pieces = white_pieces + black_pieces
  end

  def moves_for(piece_set)
    piece_set.map do |piece|
      other_pieces = finder.other_pieces(piece)
      piece.moves(other_pieces)
    end.flatten
  end

  def start_game
    self.translator = Translator.new
    self.verifier = RuleVerifier.new
    puts board

    loop do
      manager = PieceManager.new(all_pieces)
      self.finder = PieceFinder.new(all_pieces)
      filter = MoveFilter.new(active_player, all_pieces, verifier)

      friendly_pieces = finder.friendly_pieces(active_player)
      enemy_pieces = finder.enemy_pieces(active_player)

      friendly_moves = moves_for(friendly_pieces)
      enemy_moves = moves_for(enemy_pieces)

      friendly_moves = filter.filter_out(friendly_moves, enemy_moves)

      break if game_over?(friendly_moves, enemy_moves)

      # Sort moves by priority
      move_list = prepare_moves_for_prompt(friendly_moves)

      prompt = TTY::Prompt.new

      selected_move = prompt.select('Select your move', move_list, filter: true)

      self.all_pieces = manager.update_piece_set(selected_move)

      update_game_state

      puts board
    end
  end

  def prepare_moves_for_prompt(move_set)
    sorted_by_precedence = GameConstants::MOVE_PRECEDENCE.reduce([]) do |sorted_moves, selector|
      sorted_moves << move_set.select(&selector)
      sorted_moves
    end.reject(&:empty?).flatten

    sorted_by_precedence.map { |move| [translator.translate(move), move] }.to_h
  end

  def game_over?(friendly_moves, enemy_moves)
    verifier.checkmate?(friendly_moves, enemy_moves) || verifier.stalemate?(friendly_moves, enemy_moves)
  end

  def update_game_state
    board.update(all_pieces)
    system 'clear'
    puts board

    all_pieces.select(&:double_jumped).each do |pawn|
      pawn.moves_since_double_jump += 1
    end

    switch_turns
  end

  def switch_turns
    if active_player == :white
      self.active_player = :black
      self.non_active_player = :white
    else
      self.active_player = :white
      self.non_active_player = :black
    end
  end
end

ChessClient.new.run

# EXAMPLE ON HOW TO SET A PROC AS A RETURN VALUE FROM MENU

# prompt.select('up or downcase?') do |menu|
#   menu.choice 'Up', proc { puts 'hey'.upcase }
#   menu.choice 'Down', proc { puts 'hey'.downcase }
# end
#############################

# IN GAME MENU
# prompt.select('In-game options') do |menu|
#   menu.choice 'Save progress', (proc { save_progress_menu })
#   menu.choice 'Make a move', (proc { move_menu })
#   menu.choice 'Declare draw', (proc { declare_draw_menu })
#   menu.choice 'Give up', (proc { give_up_menu })
#   menu.choice 'Back to main menu (Progress will be lost)', (proc { main_menu })
#   menu.choice 'Quit (Progress will be lost)', (proc { system 'exit' })
# end
#############

# MOVE CHOOSING
# choices = { 'In-game options': (proc { 'hello' }) }
# selection = prompt.select('Select your move', choices)
# require 'pry'
# binding.pry
# ############

# player_piece_color = prompt.select('Select your pieces', GConst::PIECE_COLORS, cycle: true, show_help: :always)

# p GConst::START_POSITIONS
# white_piece_positions = GConst::START_POSITIONS.first(16)
# black_piece_positions = GConst::START_POSITIONS - white_piece_positions

# p white_piece_positions
# puts
# p black_piece_positions

# # Sets pieces in right position

# white_piece_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook] + [Pawn] * 8
# black_piece_order = white_piece_order.rotate(8)

# white_pieces = white_piece_positions.map.with_index do |position, piece_number|
#   white_piece_order[piece_number].new(:white, position)
# end

# black_pieces = black_piece_positions.map.with_index do |position, piece_number|
#   black_piece_order[piece_number].new(:black, position)
# end

# white_king = white_pieces[4]
# white_king.position = [5, 3]
# black_king = black_pieces[12]
# black_king.position = [7, 1]

# all_pieces = white_pieces + black_pieces
# all_pieces = [white_king, Queen.new(:white, [6, 1]), black_king]
# # require 'pry'
# # binding.pry

# p white_pieces
# p black_pieces

# board = Board.new(player_piece_color)
# board.update(all_pieces)

# # require 'pry'
# # binding.pry

# puts board

# kings = {
#   white: white_king,
#   black: black_king
# }

# players = {
#   white: white_pieces,
#   black: black_pieces
# }

# active_player = :white
# other_player = :black

# loop do
#   manager = PieceManager.new(all_pieces)
#   finder = PieceFinder.new(all_pieces)
#   translator = Translator.new
#   verifier = RuleVerifier.new
#   filter = MoveFilter.new(active_player, all_pieces, verifier)

#   friendly_pieces = finder.friendly_pieces(active_player)
#   enemy_pieces = finder.enemy_pieces(active_player)

#   friendly_moves = friendly_pieces.map do |piece|
#     other_pieces = finder.other_pieces(piece)
#     piece.moves(other_pieces)
#   end.flatten

#   enemy_moves = enemy_pieces.map do |piece|
#     other_pieces = finder.other_pieces(piece)
#     piece.moves(other_pieces)
#   end.flatten

#   friendly_moves = filter.filter_out(friendly_moves, enemy_moves)

#   # Sort moves by priority
#   en_passant = proc { |move| move[:type] == :en_passant }
#   castling = proc { |move| move[:type] == :castling }
#   captures = proc { |move| move[:type] == :capture }
#   standard = proc { |move| move[:type] == :standard }

#   sorted_moves = friendly_moves.select(&en_passant) + friendly_moves.select(&castling) + friendly_moves.select(&captures) + friendly_moves.select(&standard)

#   translated_moves = sorted_moves.map { |move| [translator.translate(move), move] }.to_h

#   if verifier.checkmate?(friendly_moves, enemy_moves) || verifier.stalemate?(friendly_moves, enemy_moves)
#     puts 'GAME OVER'
#     break
#   end

#   selected_move = prompt.select('Select your move', translated_moves, filter: true)

#   all_pieces = manager.update_piece_set(selected_move)

#   board.update(all_pieces)

#   system 'clear'
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


# MENUs

# MAKE A MOVE MENU

