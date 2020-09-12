# frozen_string_literal: true

# Generates the valid set of moves available in a ChessBoard
class MoveGenerator
  def initialize(chess_board)
    @chess_board = chess_board
  end

  def generate_moves(piece_coordinates)
    piece = chess_board.board.dig(*piece_coordinates)

    if piece.repeatedly_jumps?
      moves_by_direction = piece.movement_directions.map do |y_travel, x_travel|
        1.upto(8).map do |jump|
          [piece_coordinates[0] + jump * y_travel, piece_coordinates[1] + jump * x_travel]
        end
      end
    else
      moves_by_direction = piece.movement_directions.map do |y_travel, x_travel|
        [[piece_coordinates[0] + y_travel, piece_coordinates[1] + x_travel]]
      end
    end

    valid_moves_by_direction = moves_by_direction.map do |movements|
      movements.select do |move|
        valid_square?(move)
      end
    end.reject(&:empty?)

    final_moves = valid_moves_by_direction.map do |movements_by_direction|
      first_invalid = movements_by_direction.find_index do |move|
        square_contents = chess_board.board.dig(*move)

        square_contents != ' '
      end

      # Here

      movements_by_direction[0...first_invalid]
    end.reject(&:empty?)

    if piece.repeatedly_jumps?
      final_moves.flatten(1)
    else
      final_moves.map do |direction|
        direction[0]
      end
    end
  end

  def generate_captures(piece_coordinates)
    piece = chess_board.board.dig(*piece_coordinates)

    capture_squares = piece.capture_directions.map do |y_travel, x_travel|
      [piece_coordinates[0] + y_travel, piece_coordinates[1] + x_travel]
    end.select { |square| square[0].between?(0, 8) && square[1].between?(0, 8) }

    if piece.repeatedly_jumps?
      capture_squares = []
      piece.capture_directions.each do |y_travel, x_travel|
        jumps = 1
        loop do
          square_coords = [piece_coordinates[0] + jumps * y_travel, piece_coordinates[1] + jumps * x_travel]

          square_contents = chess_board.board.dig(*square_coords)

          break unless valid_square?(square_coords)

          if square_contents != ' '
            capture_squares << square_coords
            break
          end

          jumps += 1
        end
      end
    end

    capture_squares.select do |coords|
      square = chess_board.board.dig(*coords)

      square != ' ' && square.color != piece.color
    end
  end

  private

  attr_reader :chess_board

  def valid_square?(move)
    move.all? { |coord| coord.between?(0, 8) }
  end

  def valid_move?(move)
  end

end
