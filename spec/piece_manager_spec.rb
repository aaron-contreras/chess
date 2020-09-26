# frozen_string_literal: true

require_relative '../lib/piece_manager'
require_relative './shared/among_chess_pieces'

# rubocop: disable all
RSpec.describe PieceManager do
  include_context 'list_of_pieces'

  subject(:manager) { described_class.new(white_pieces, black_pieces) }

  describe '#update_piece_set' do
    context 'when given a "standard" non-capturing move' do
      let(:piece) { pieces[9] }
      let(:move) { { type: :standard, piece: piece, ending_position: [3, 1] } }

      it "updates the given piece's position" do
        allow(piece).to receive(:position).and_return(move)

        piece_set = manager.update_piece_set(move)

        expect(piece.position).to eq(move)
        expect(piece_set).to contain_exactly(*pieces)
      end
    end

    context 'when given a "standard" capturing move' do
      let(:piece) { pieces[9] }
      let(:piece_to_capture) { pieces[28] }
      let(:move) { { type: :capture, piece: piece, captured_piece: piece_to_capture, ending_position: [2, 2] } }

      it 'captures the piece' do
        allow(piece).to receive(:position).and_return(move)

        piece_set = manager.update_piece_set(move)

        expect(piece.position).to eq(move)

        expect(piece_set).not_to include(piece_to_capture)
      end
    end

    context 'when given a castling move' do
      let(:king) { pieces[26] }
      let(:rook) { pieces[23]}
      let(:move) { { type: :castling, king: king, rook: rook, king_ending_position: [7, 1], rook_ending_position: [7, 2] } }

      it 'castles the king and rook' do
        piece_set = manager.update_piece_set(move)

        allow(king).to receive(:position).and_return(move[:king_ending_position])
        allow(rook).to receive(:position).and_return(move[:rook_ending_position])

        expect(king.position).to eq(move[:king_ending_position])
        expect(rook.position).to eq(move[:rook_ending_position])

        expect(piece_set).to contain_exactly(*pieces)
      end
    end

    context 'when given an "en passant" move' do
      let(:pawn) { pieces[26] }
      let(:piece_to_capture) { pieces[9] }
      let(:move) { { type: :en_passant, piece: pawn, captured_piece: piece_to_capture, piece_ending_position: [2, 1] } }

      it 'performs the en passant move' do
        piece_set = manager.update_piece_set(move)

        allow(pawn).to receive(:position).and_return(move[:piece_ending_position])

        expect(pawn.position).to eq(move[:piece_ending_position])
        expect(piece_set).not_to include(piece_to_capture)
      end
    end
  end
end
