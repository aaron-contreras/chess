# frozen_string_literal: true

require 'tty-prompt'
require 'tty-box'
require 'tty-screen'
require 'figlet'
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

# Terminal client to play the game
class ChessGameClient
  include Serializable

  attr_accessor :human_player, :game_mode, :all_pieces, :board, :active_player, :non_active_player,
                :end_game_state, :finder, :translator, :verifier

  WHITE_PIECE_LAYOUT = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook] + 8.times.map { Pawn }
  BLACK_PIECE_LAYOUT = WHITE_PIECE_LAYOUT.rotate(8)

  def run
    main_menu_prompt
  end

  def toggle_load_option
    option = { name: 'Load game', value: proc { load_game_prompt } }

    if game_list.empty?
      option[:disabled] = '(No saved games)'
    end

    option
  end

  # rubocop: disable Metrics/MethodLength
  def menu_choices
    {
      main_menu: [
        {name: 'New game', value: proc { create_new_game } },
        {name: 'Quit', value: proc { exit } }
      ].insert(1, toggle_load_option),

      board_theme_colors: {
        'Classic' => :classic,
        'Aged' => :aged,
        'Marble' => :marble,
      },
      terminal_color_modes: {
        'True color' => 0xFFFFFF,
        '256-colors' => 256,
        '16-colors' => 16,
        '8-colors' => 8
      },
      options_menu: {
        'Save progress' => proc { save_prompt },
        'Change board theme' => proc { board_theme_prompt },
        'Switch terminal color mode' => proc { terminal_colors_prompt },
        'Back to game' => proc { start_game },
        'Back to Main menu' => proc { main_menu_prompt },
        'Quit': proc { close_client }
      },
      game_mode_selection: {
        'Single player' => :single_player,
        'Multiplayer' => :multiplayer
      },
      piece_color_selection: {
        'Black' => :black,
        'White' => :white
      },
      promotion_piece_list: {
        'Queen' => Queen,
        'Rook' => Rook,
        'Bishop' => Bishop,
        'Knight' => Knight
      }
    }
  end
  # rubocop: enable Metrics/MethodLength

  # PROMPTS
  ######################
  def main_menu_prompt
    system 'clear'

    prompt = TTY::Prompt.new

    font = Figlet::Font.new('./fonts/isometric3.flf')

    figlet = Figlet::Typesetter.new(font)

    puts figlet['Chess!']
    puts

    prompt.select('Main menu', menu_choices[:main_menu], cycle: true, filter: true)
  end

  def save_prompt
    system 'clear'
    puts board

    prompt = TTY::Prompt.new

    game_name = prompt.ask('Name your game to easily find it later (at least one character)') do |properties|
      properties.required(true)
      properties.validate(/\w+/)
    end

    save_to_file(game_name)

    puts "#{game_name} saved successfully"

    options_menu_prompt
  end

  def load_game_prompt
    system 'clear'

    prompt = TTY::Prompt.new

    choices = { 'Back to main menu' => proc { main_menu_prompt } }.merge(game_list)

    filename = prompt.select('Select a game to load', choices, cycle: true, filter: true)

    serialized_string = File.read(filename)

    deserialize(serialized_string)

    start_game
  end

  def board_theme_prompt
    system 'clear'
    puts board

    prompt = TTY::Prompt.new
    selected_theme = prompt.select('Select a theme', menu_choices[:board_theme_colors], cycle: true, filter: true)

    board.change_theme(selected_theme)

    options_menu_prompt
  end

  def terminal_colors_prompt
    system 'clear'
    puts board

    prompt = TTY::Prompt.new
    puts "If the board is color-less or doesn't look quite right"
    selected_color_mode = prompt.select('Switch to a compatible color mode', menu_choices[:terminal_color_modes], cycle: true, filter: true)

    Paint.mode = selected_color_mode

    options_menu_prompt
  end

  def options_menu_prompt
    system 'clear'
    puts board

    prompt = TTY::Prompt.new

    prompt.select('Options menu', menu_choices[:options_menu], cycle: true, filter: true)
  end

  def in_game_prompt(moves)
    move_list = prepare_moves_for_prompt(moves)

    prompt = TTY::Prompt.new

    choices = { 'Options menu' => proc { options_menu_prompt } }.merge(move_list)

    if game_mode == :multiplayer || active_player == human_player
      prompt.select("#{active_player.to_s.capitalize}'s turn", choices, cycle: true, filter: true)
    else
      # Computer chooses a random move in the best move category by precedence
      # The first move always is the most precedent type of move
      move_list = move_list.values
      best_move_type = move_list.first[:type]
      move_list.select { |move| move[:type] == best_move_type }.sample
    end
  end

  def select_replacement_piece_prompt(pawn)
    if active_player == human_player
      prompt = TTY::Prompt.new
      piece_type = prompt.select('What would you like to promote your pawn to?',
                                 menu_choices[:promotion_piece_list], cycle: true, filter: true)
    else
      piece_type = promotion_piece_list.values.sample
    end

    piece_type.new(pawn.player, pawn.position)
  end

  def end_of_game_prompt
    prompt = TTY::Prompt.new

    choices = {
      'Main menu' => proc { main_menu_prompt },
      'Quit' => proc { close_client }
    }

    prompt.select('Game over', choices, cycle: true, filter: true)
  end

  def piece_color_selection
    prompt = TTY::Prompt.new
    self.human_player = prompt.select('Select your pieces', menu_choices[:piece_color_selection])
  end

  def game_mode_selection
    prompt = TTY::Prompt.new
    self.game_mode = prompt.select('Game mode selection', menu_choices[:game_mode_selection], filter: true) 
  end

  ######################

  def create_new_game
    game_mode_selection
    piece_color_selection

    self.board = Board.new(human_player)
    create_pieces
    board.update(all_pieces)

    self.active_player = :white
    self.non_active_player = :black

    start_game
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

      self.finder = PieceFinder.new(all_pieces)
      manager = PieceManager.new(all_pieces)
      filter = MoveFilter.new(active_player, all_pieces, verifier)

      friendly_pieces = finder.friendly_pieces(active_player)
      enemy_pieces = finder.enemy_pieces(active_player)

      friendly_moves = moves_for(friendly_pieces)
      enemy_moves = moves_for(enemy_pieces)

      friendly_filtered_moves = filter.filter_out(friendly_moves, enemy_moves)

      if game_over?(friendly_filtered_moves, enemy_moves)
        set_end_game_state(friendly_filtered_moves, enemy_moves)
        break
      end

      if verifier.check?(enemy_moves)
        system 'clear'
        puts board
        puts Paint['Check!', :bright]
      end

      selected_move = in_game_prompt(friendly_filtered_moves)

      self.all_pieces = manager.update_piece_set(selected_move)

      if promotable_piece_after?(selected_move)
        pawn = selected_move[:piece]
        replacement_piece = select_replacement_piece_prompt(pawn)
        promotion = { type: :promotion, pawn: pawn, replacement: replacement_piece }

        self.all_pieces = manager.update_piece_set(promotion)
      end

      update_game_state
    end

    system 'clear'
    puts board

    show_end_of_game_status
    end_of_game_prompt
  end

  def set_end_game_state(friendly_filtered_moves, enemy_moves)
    self.end_game_state = if verifier.checkmate?(friendly_filtered_moves, enemy_moves)
                            'Checkmate!'
                          else
                            'Stalemate!'
                          end
  end

  def show_end_of_game_status
    puts Paint[end_game_state, :bright]

    puts Paint["#{non_active_player.to_s.capitalize} wins!", :bright]
  end

  def promotable_piece_after?(move)
    %i[capture standard].include?(move[:type]) && move[:piece].promotable?
  end

  def prepare_moves_for_prompt(move_set)
    # Sort
    sorted_by_precedence = GameConstants::MOVE_PRECEDENCE.each_with_object([]) do |selector, sorted_moves|
      sorted_moves << move_set.select(&selector)
    end.reject(&:empty?).flatten

    # Translate coordinates
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

  def close_client
    system 'clear'

    box_width = TTY::Screen.width / 2
    box_height = TTY::Screen.height / 2
    top_offset = box_height / 2
    left_offset = box_width / 2

    settings = { width: box_width, height: box_height, top: top_offset, left: left_offset, padding: 3, border: :thick, align: :center }

    box = TTY::Box.frame('Great game!', '', 'Come back and play some more ;)', **settings)

    puts box

    sleep(2)

    system 'clear'

    exit
  end
end

ChessGameClient.new.run

