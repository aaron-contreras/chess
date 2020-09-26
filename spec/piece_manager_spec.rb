# frozen_string_literal: true

require_relative '../lib/piece_manager'
require_relative './shared/among_chess_pieces'

RSpec.describe PieceManager do
  include_context 'list_of_pieces'

  subject(:manager) { described_class.new(white_pieces, black_pieces) }

  describe '#update_piece_set' do
    context 'when given a "standard" non-capturing move' do
      let(:piece) { pieces[9] }
      let(:move) { {type: :standard, ending_position: [3, 1]} }

      it "updates the given piece's position" do
        allow(piece).to receive(:position).and_return(move)

        manager.update_piece_set(piece, move)

        expect(piece.position).to eq(move)
      end
    end

    context 'when a given a "standard" capturing move' do
      let(:piece) { pieces[9] }
      let(:piece_to_capture) { pieces[28] }
      let(:move) { { type: :capture, ending_position: [2, 2], captured_piece: pieces[28] } }

      it 'captures the piece' do
        allow(piece).to receive(:position).and_return(move)

        piece_set = manager.update_piece_set(piece, move)

        expect(piece.position).to eq(move)

        expect(piece_set).not_to include(piece_to_capture)
      end
    end
  end
end
