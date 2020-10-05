# frozen_string_literal: true

require 'paint'

# Displayable Chess Board
class Board
  attr_reader :human_player, :theme, :grid

  def initialize(human_player, theme = :classic)
    @human_player = human_player
    @theme = theme
    @grid = build_grid
  end

  def place(piece)
    rank = piece.position[0]
    file = piece.position[1]

    @grid[rank][file] = piece
  end

  def update(pieces)
    clear
    pieces.each { |piece| place(piece) }
  end

  def change_theme(theme)
    @theme = theme
  end

  def to_s
    <<~BOARD

      #{color_squares.join}
          #{GameConstants::INDEX_TO_FILE.join('    ')}  
    BOARD
  end

  private

  # To simulate a more realistic gameplay, you always play on the side closest
  # to the bottom of the screen.
  def rotated_board
    if human_player == :white
      grid.reverse
    else
      grid
    end
  end

  def build_grid
    Array.new(8) { Array.new(8) { GameConstants::EMPTY_SQUARE } }
  end

  def clear
    @grid = build_grid
  end

  def equalized_width_squares
    rotated_board.map do |rank|
      rank.map do |square|
        if square == GameConstants::EMPTY_SQUARE
          ' '
        else
          square
        end
      end
    end
  end

  def row_colors(rank)
    if rank.even?
      GameConstants::EVEN_RANK
    else
      GameConstants::ODD_RANK
    end
  end

  def color_squares
    equalized_width_squares.map.with_index do |row, rank|
      row_colors = row_colors(rank)
      # Optional padding to make board taller
      # padding = format_row(GameConstants::PADDING_ROW, row_colors)
      main_row = format_row(row, row_colors)

      <<~RANK
        #{oriented_ranks[rank]} #{main_row}
      RANK
    end
  end

  def format_row(row, row_colors)
    row.map.with_index do |square, file|
      square_color = GameConstants::BOARD_THEME.dig(theme, row_colors[file])

      foreground_color = foreground_color(square)

      Paint["  #{square}  ", :bold, foreground_color, square_color]
    end.join
  end

  def foreground_color(square)
    square.player.to_s unless square == ' '
  end

  def oriented_ranks
    if human_player == :white
      GameConstants::INDEX_TO_RANK.reverse
    else
      GameConstants::INDEX_TO_RANK
    end
  end
end
