# frozen_string_literal: true

require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:chess_board) { described_class.new } 

  describe '#move_piece' do
    let(:start_coordinates) { [1, 0] }
    let(:end_coordinates) { [2, 0] }
    let(:board) { chess_board.instance_variable_get(:@board) }

    context 'when the target square is empty' do
      it 'moves the piece to the target square' do
        moved_piece = board.dig(*start_coordinates)

        chess_board.move_piece(start_coordinates, end_coordinates)

        expect(board.dig(*end_coordinates)).to eq moved_piece
      end
    end

    context 'when the target square is not empty' do
      it 'captures the piece at the target square' do
        moved_piece = board.dig(*start_coordinates)

        board[end_coordinates[0]][end_coordinates[1]] = double('Dummy pawn')

        chess_board.move_piece(start_coordinates, end_coordinates)

        expect(board.dig(*end_coordinates)).to eq moved_piece
      end
    end
  end

  describe '#castle' do
    let(:board) { chess_board.instance_variable_get(:@board) }
    let(:king_start_coordinates) { [0, 4] }

    context 'when move is short castle' do
      let(:king_end_coordinates) { [0, 6] }
      let(:rook_start_coordinates) { [0, 7] }
      let(:rook_end_coordinates) { [0, 5] }

      before do
        board[0][5] = ' '
        board[0][6] = ' '
      end

      it 'moves the king two squares towards the rook' do
        king = board.dig(*king_start_coordinates)

        chess_board.castle(king_start_coordinates, rook_start_coordinates)

        expect(board.dig(*king_end_coordinates)).to eq king
      end

      it 'moves the rook one square over the king' do
        rook = board.dig(*rook_start_coordinates)

        chess_board.castle(king_start_coordinates, rook_start_coordinates)

        expect(board.dig(*rook_end_coordinates)).to eq rook
      end
    end

    context 'when move is long castle' do
      let(:king_end_coordinates) { [0, 2] }
      let(:rook_start_coordinates) { [0, 0] }
      let(:rook_end_coordinates) { [0, 3] }

      before do
        board[0][1] = ' '
        board[0][2] = ' '
        board[0][3] = ' '
      end

      it 'moves the king two squares towards the rook' do
        king = board.dig(*king_start_coordinates)

        chess_board.castle(king_start_coordinates, rook_start_coordinates)

        expect(board.dig(*king_end_coordinates)).to eq king
      end

      it 'moves the rook one square over the king' do
        rook = board.dig(*rook_start_coordinates)

        chess_board.castle(king_start_coordinates, rook_start_coordinates)

        expect(board.dig(*rook_end_coordinates)).to eq rook
      end
    end
  end
end
