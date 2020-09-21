# frozen_string_literal: true

require_relative 'generators/standard_move_generator'

module ChessPieces
  # Standard-moving chess pieces pieces
  # Jump repeatedly in the same direction
  class Rook
    attr_reader :player, :position

    def initialize(player, position)
      @player = player
      @position = position
    end

    def moves(other_pieces)
      jump_directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
      generator = StandardMoveGenerator.new(self, other_pieces, jump_directions)

      generator.generate_moves
    end
  end

  class Bishop; end

  class Knight; end

  class Queen; end

  class King; end

  class Pawn; end
end
