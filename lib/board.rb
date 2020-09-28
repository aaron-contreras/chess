# frozen_string_literal: true

require 'paint'

# Displayable Chess Board
class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { GameConstants::EMPTY_SQUARE } }
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
      #{color_squares.each { |rank| puts rank }}
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
          '       '
        else
          "   #{square}   "
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

        Paint[square, nil, square_color]
      end.join

      [padding, main_row, padding]
    end
  end

  def padding_row
    Array.new(8) { '       ' }
  end
end
