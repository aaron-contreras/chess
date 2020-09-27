# frozen_string_literal: true

# In charge of updating pieces after every move, keeping track of which
# player has which pieces
class PieceManager
  attr_reader :all_pieces, :white_captures, :black_captures

  def initialize(all_pieces)
    @all_pieces = all_pieces
    @white_captures = []
    @black_captures = []
  end

  def update_piece_set(move)
    if move[:type] == :standard
      move_piece(move)
    elsif move[:type] == :castling
      castle(move)
    elsif %i[capture en_passant].include?(move[:type])
      move_piece(move)
      capture(move[:captured_piece])
    end

    all_pieces
  end

  private

  def move_piece(move)
    move[:piece].position = move[:ending_position]
  end

  def castle(move)
    move[:king].position = move[:king_ending_position]
    move[:rook].position = move[:rook_ending_position]
  end

  def capture(piece)
    if piece.player == :white
      white_captures << piece
    else
      black_captures << piece
    end

    all_pieces.delete(piece)
  end
end
