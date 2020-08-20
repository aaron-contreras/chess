# frozen_string_literal: true
class ChessBoard

  def initialize
    @board = initial_board_configuration
  end

  def initial_board_configuration
    [
        [Rook.new(:white), Knight.new(:white), Bishop.new(:white), Queen.new(:white), King.new(:white), Bishop.new(:white), Knight.new(:white), Rook.new(:white)],
        [Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white), Pawn.new(:white)],
        [' '] * 8,
        [' '] * 8,
        [' '] * 8,
        [' '] * 8,
        [Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black), Pawn.new(:black)],
        [Rook.new(:black), Knight.new(:black), Bishop.new(:black), Queen.new(:black), King.new(:black), Bishop.new(:black), Knight.new(:black), Rook.new(:black)]
    ]
  end
end

class Pieces
  def initialize(color)
    @color = color
  end

  def ==(other_piece)
    self.class == other_piece.class
  end
end

class Rook < Pieces

end

class Knight < Pieces

end

class Bishop < Pieces

end

class Queen < Pieces

end

class King < Pieces

end

class Pawn < Pieces

end
