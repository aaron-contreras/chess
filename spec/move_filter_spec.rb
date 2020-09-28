# frozen_string_literal: true

require_relative '../lib/move_filter'
require_relative './shared/among_chess_pieces'

RSpec.describe MoveFilter do
  include_context 'list_of_pieces'

  subject(:filter) { described_class.new(king, all_pieces) }

    let(:king) { white_pieces[4] }
    let(:friendly_pieces) { white_pieces.first(3) + [king] }
    let(:enemy_pieces) { black_pieces.first(3) }
    let(:all_pieces) { friendly_pieces + enemy_pieces }

    before do
      # Stub move behavior for enemy_pieces
      allow(enemy_pieces[0]).to receive(:moves).and_return(
        [{ type: :capture, piece: enemy_pieces[0], captured_piece: king, ending_position: [4, 5]}]
      )

      allow(enemy_pieces[1]).to receive(:moves).and_return(
        [{ type: :standard, piece: enemy_pieces[1], ending_position: [4, 5] }]
      )
      allow(enemy_pieces[2]).to receive(:moves).and_return([
        { type: :standard, piece: enemy_pieces[2], ending_position: [5, 4] }]
      )

      # Stub move behavior for friendly_pieces


      allow(friendly_pieces[0]).to receive(:moves).and_return([
        { type: :standard, piece: friendly_pieces[0], ending_position: [3, 1] }
      ])

      allow(friendly_pieces[1]).to receive(:moves).and_return([
        { type: :capture, piece: friendly_pieces[1],captured_piece: enemy_pieces[0], ending_position: [6, 0] }
      ])

      allow(friendly_pieces[2]).to receive(:moves).and_return([])

      allow(king).to receive(:moves).and_return([
        { type: :standard, piece: king, ending_position: [4, 6] }
      ])
    end

  describe '#filter_out' do
    context 'when the king is in check' do
      it "keeps only moves that save the king from check state" do
        friendly_moves = friendly_pieces.map(&:moves).reduce(&:+)
        valid_moves = [
            { type: :standard, piece: king, ending_position: [4, 6] },
            { type: :capture, piece: friendly_pieces[1],captured_piece: enemy_pieces[0], ending_position: [6, 0] }
        ]

        expect(filter.filter_out).to contain_exactly(*valid_moves)
      end 

      it "doesn't keep castling moves" do
        # Add a castling move to the king
        allow(king).to receive(:moves).and_return([
          { type: :standard, piece: king, ending_position: [4, 6] },
          { type: :castling, king: king, rook: friendly_pieces[0], king_ending_position: [0, 2], rook_ending_position: [0, 3] }
        ])
        valid_moves = [
          { type: :standard, piece: king, ending_position: [4, 6] },
          { type: :capture, piece: friendly_pieces[1],captured_piece: enemy_pieces[0], ending_position: [6, 0] }
        ]

        expect(filter.filter_out).to contain_exactly(*valid_moves)
      end
    end

    context 'when the king is in checkmate' do
      it 'returns an empty move set' do
        # Simulate check mate
        friendly_pieces.each do |piece|
          allow(friendly_pieces[1]).to receive(:moves).and_return(
            [ { type: :standard, piece: friendly_pieces[1], ending_position: [5, 0] }]
          )

          expect(filter.filter_out).to be_empty
        end
      end
    end
  end
end
