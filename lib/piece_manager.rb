# frozen_string_literal: true

class PieceManager
  attr_reader :white_pieces, :black_pieces, :white_captures, :black_captures, :all_pieces

  def initialize(white_pieces, black_pieces)
    @white_pieces = white_pieces
    @black_pieces = black_pieces
    @white_captures = []
    @black_captures = []
    @all_pieces = white_pieces + black_pieces
  end

  def update_piece_set(piece, move)
    if move[:type] == :standard
      piece.position = move[:ending_position]
    elsif move[:type] == :castling
      move[:king].position = move[:king_ending_position]
      move[:rook].position = move[:rook_ending_position]
    elsif move[:type] == :capture
      piece.position = move[:ending_position]
      capture(move[:captured_piece])
    end

    all_pieces
  end

  private

  def capture(piece)
    if piece.player == :white
      white_captures << piece
    else
      black_captures << piece
    end

    all_pieces.delete(piece)
  end
end
