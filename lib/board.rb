# frozen_string_literal: true

require 'paint'

# Displayable Chess Board
class Board
  attr_reader :grid, :bottom_side_player

  def initialize(bottom_side_player)
    @grid = Array.new(8) { Array.new(8) { GameConstants::EMPTY_SQUARE } }
    @bottom_side_player = bottom_side_player
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

  def rotate
    
  end

  def hold?(piece)
    grid.dig(*piece.position).empty? == false
  end

  def to_s
    <<~BOARD
          #{(1..8).map(&:itself).join('    ')}  
      #{color_squares.join}
    BOARD
  end

  private

  def build_grid
    Array.new(8) { Array.new(8) { GameConstants::EMPTY_SQUARE } }
  end

  def clear
    @grid = Array.new(8) { Array.new(8) { GameConstants::EMPTY_SQUARE } }
  end

  def padded_squares
    grid.map do |rank|
      rank.map do |square|
        if square == GameConstants::EMPTY_SQUARE
          ' '
        else
          square
        end
      end
    end
  end

  def color_squares
    padded_squares.map.with_index do |row, rank|
      if rank.even?
        row_coloring = GameConstants::EVEN_RANK
      else
        row_coloring = GameConstants::ODD_RANK
      end

      padding = padding_row.map.with_index do |square, file|
        square_color = GameConstants::SQUARE_COLOR[row_coloring[file]]

        Paint[square, nil, square_color]
      end.join

      main_row = row.map.with_index do |square, file|
        square_color = GameConstants::SQUARE_COLOR[row_coloring[file]]

        if square == ' '
          piece_color = nil
        else
          piece_color = square.player.to_s
        end

        colored_square = Paint["  #{square}  ", piece_color, square_color]
      end.join

      <<~RANK
          #{padding}
        #{alphabetical_ranks[rank]} #{main_row}
          #{padding}
      RANK
    end
  end

  def padding_row
    Array.new(8) { '     ' }
  end

  def alphabetical_ranks
    if bottom_side_player == :white
      GameConstants::RANK_TO_LETTER.reverse
    else
      GameConstants::RANK_TO_LETTER
    end
  end
end
