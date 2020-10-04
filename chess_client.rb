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
require_relative 'lib/serializable'
# Executable
class ChessClient
  include Serializable

  attr_accessor :player_piece_color, :all_pieces, :board, :active_player, :non_active_player,
                :time_started, :moves_performed, :capture_list, :finder, :translator, :verifier

  WHITE_PIECE_LAYOUT = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook] + 8.times.map { Pawn }
  BLACK_PIECE_LAYOUT = WHITE_PIECE_LAYOUT.rotate(8)

  def run
    prompt = TTY::Prompt.new
    choices = {
      'New game': proc { create_new_game },
      'Load game': proc { load_game_prompt }
    }

    prompt.select('Main menu', choices)
  end

  def save_prompt
    system 'clear'
    puts board

    prompt = TTY::Prompt.new

    game_name = prompt.ask('Name your game to easily find it later (at least one character)') do |properties|
      properties.required(true)
      properties.validate(/\w+/)
    end

    puts "#{game_name} saved successfully"

    save_to_file(game_name)

    options_menu
  end

  def load_game_prompt
    system 'clear'
    puts 'hello'

    prompt = TTY::Prompt.new

    filename = prompt.select('Select a game to load', game_list)

    serialized_string = File.read(filename)

    deserialize(serialized_string)

    start_game
  end

  def options_menu
    system 'clear'
    puts board

    prompt = TTY::Prompt.new
    choices = {
      'Save progress' => (proc { save_prompt }),
      'Back to game' => proc { start_game },
      'Declare draw' => 1,
      'Give up' => 2,
      'Back to Main menu' => proc { run },
      'Quit' => proc { exit(true) }
    }

    prompt.select('Options menu', choices)
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
      WHITE_PIECE_LAYOUT[piece_number].new(:white, position)
    end

    black_pieces = GameConstants::STARTING_POSITIONS[:black].map.with_index do |position, piece_number|
      BLACK_PIECE_LAYOUT[piece_number].new(:black, position)
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

    loop do
      system 'clear'
      puts board

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

      choices = { 'Options menu' => proc { options_menu } }.merge(move_list)

      selected_move = prompt.select('Select your move', choices, filter: true)

      self.all_pieces = manager.update_piece_set(selected_move)

      if promotable_piece_after?(selected_move)
        pawn = selected_move[:piece]
        replacement_piece = select_replacement_piece(pawn)
        promotion = { type: :promotion, pawn: pawn, replacement: replacement_piece }

        self.all_pieces = manager.update_piece_set(promotion)
      end

      update_game_state
    end

    system 'clear'
    puts board
  end

  def promotable_piece_after?(move)
    %i[capture standard].include?(move[:type]) && move[:piece].promotable?
  end

  def select_replacement_piece(pawn)
    if active_player == player_piece_color
      prompt = TTY::Prompt.new
      piece_type = prompt.select('What would you like to promote your pawn to?', promotion_piece_list)
    else
      piece_type = promotion_piece_list.values.sample
    end

    piece_type.new(pawn.player, pawn.position)
  end

  def promotion_piece_list
    {
      'Queen' => Queen,
      'Rook' => Rook,
      'Bishop' => Bishop,
      'Knight' => Knight
    }
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
