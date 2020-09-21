# frozen_string_literal: true

require_relative '../lib/chess_board'

# rubocop: disable Metrics/BlockLength
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

  describe '#en_passant' do
    let(:board) { chess_board.instance_variable_get(:@board) }
    let(:capturing_pawn) { double('Capturing Pawn') }
    let(:captured_pawn) { double('Captured Pawn') }

    before do
      board[capturing_pawn_coordinates[0]][capturing_pawn_coordinates[1]] = capturing_pawn

      board[captured_pawn_coordinates[0]][captured_pawn_coordinates[1]] = captured_pawn
    end

    context 'when black is capturing' do
      before { allow(capturing_pawn).to receive(:color).and_return(:black) }

      context 'towards the right' do
        let(:capturing_pawn_coordinates) { [4, 2] }
        let(:captured_pawn_coordinates) { [4, 3] }
        let(:end_move_coordinates) { [5, 3] }

        it 'takes en passant' do
          chess_board.en_passant(capturing_pawn_coordinates, end_move_coordinates)

          expect(board.dig(*end_move_coordinates)).to eq capturing_pawn

          expect(board.dig(*capturing_pawn_coordinates)).to eq ' '

          expect(board.dig(*captured_pawn_coordinates)).to eq ' '
        end
      end

      context 'towards the left' do
        let(:capturing_pawn_coordinates) { [4, 3] }
        let(:captured_pawn_coordinates) { [4, 2] }
        let(:end_move_coordinates) { [5, 2] }

        it 'takes en passant' do
          allow(capturing_pawn).to receive(:color).and_return(:black)

          chess_board.en_passant(capturing_pawn_coordinates, end_move_coordinates)

          expect(board.dig(*capturing_pawn_coordinates)).to eq(' ')

          expect(board.dig(*end_move_coordinates)).to eq(capturing_pawn)

          expect(board.dig(*captured_pawn_coordinates)).to eq ' '
        end
      end
    end

    context 'when white is capturing' do
      before { allow(capturing_pawn).to receive(:color).and_return(:white) }

      context 'towards the right' do
        let(:capturing_pawn_coordinates) { [4, 2] }
        let(:captured_pawn_coordinates) { [4, 3] }
        let(:end_move_coordinates) { [3, 3] }

        it 'takes en passant' do
          chess_board.en_passant(capturing_pawn_coordinates, end_move_coordinates)

          expect(board.dig(*capturing_pawn_coordinates)).to eq(' ')

          expect(board.dig(*end_move_coordinates)).to eq(capturing_pawn)

          expect(board.dig(*captured_pawn_coordinates)).to eq ' '
        end
      end

      context 'towards the left' do
        let(:capturing_pawn_coordinates) { [4, 3] }
        let(:captured_pawn_coordinates) { [4, 2] }
        let(:end_move_coordinates) { [3, 2] }

        it 'takes en passant' do
          chess_board.en_passant(capturing_pawn_coordinates, end_move_coordinates)

          expect(board.dig(*capturing_pawn_coordinates)).to eq(' ')

          expect(board.dig(*end_move_coordinates)).to eq(capturing_pawn)

          expect(board.dig(*captured_pawn_coordinates)).to eq ' '
        end
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
