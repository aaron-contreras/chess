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

  private

  attr_reader :chess_board

  def valid_square?(move)
    move.all? { |coord| coord.between?(0, 8) }
  end

  def valid_move?(move)
  end

end
