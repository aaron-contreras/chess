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
      update_double_jump_counter(move)
    elsif move[:type] == :castling
      castle(move)
    elsif %i[capture en_passant].include?(move[:type])
      move_piece(move)
      capture(move[:captured_piece])
    end

    all_pieces
  end

  private

  def update_double_jump_counter(move)
    if move[:double_jump]
      moved_piece = all_pieces.find { |piece| piece.position == move[:ending_position] }

      moved_piece.double_jumped = true
    end
  end

  def move_piece(move)
    all_pieces.find { |piece| piece.position == move[:piece].position }.position = move[:ending_position]
    # move[:piece].position = move[:ending_position]
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
    captured_piece = all_pieces.find { |a_piece| a_piece.position == piece.position }
    all_pieces.delete(captured_piece)
  end
end
