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
      capture(move)
      move_piece(move)
    else
      promote(move)
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
    piece_to_move = all_pieces.find { |piece| piece.position == move[:piece].position }

    piece_to_move.position = move[:ending_position]
  end

  def castle(move)
    move[:king].position = move[:king_ending_position]
    move[:rook].position = move[:rook_ending_position]
  end

  def capture(move)
    captured_piece = all_pieces.find { |a_piece| a_piece.position == move[:captured_piece].position }

    if captured_piece.player == :white
      white_captures << captured_piece
    else
      black_captures << captured_piece
    end

    all_pieces.delete(captured_piece)
  end

  def promote(move)
    pawn = move[:pawn]
    replacement = move[:replacement]

    all_pieces << replacement
    all_pieces.delete(pawn)
  end
end
