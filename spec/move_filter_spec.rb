# frozen_string_literal: true

require_relative '../lib/move_filter'
require_relative './shared/among_chess_pieces'

# rubocop: disable all
RSpec.describe MoveFilter do
  include_context 'list_of_pieces'

  subject(:filter) { described_class.new(:white, all_pieces, verifier) }

  let(:king) { white_pieces[4] }
  let(:friendly_pieces) { white_pieces.first(3) + [king] }
  let(:enemy_pieces) { black_pieces.first(3) }
  let(:all_pieces) { friendly_pieces + enemy_pieces }
  let(:verifier) { double('Verifier') }
  let(:friendly_moves) { friendly_pieces.map(&:moves).flatten }
  let(:enemy_moves) { enemy_pieces.map(&:moves).flatten }

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

    allow(filter).to receive(:will_be_check?).with(friendly_pieces[0].moves[0]).and_return(true)
    allow(filter).to receive(:will_be_check?).with(friendly_pieces[1].moves[0]).and_return(false)
    allow(filter).to receive(:will_be_check?).with(friendly_pieces[2].moves[0]).and_return(true)
    allow(filter).to receive(:will_be_check?).with(king.moves[0]).and_return(false)
  end

  describe '#filter_out' do
    context 'when the king is in check' do
      before { allow(verifier).to receive(:checkv2?).and_return(true) }

      it "keeps only moves that save the king from check state" do
        valid_moves = [
            { type: :standard, piece: king, ending_position: [4, 6] },
            { type: :capture, piece: friendly_pieces[1],captured_piece: enemy_pieces[0], ending_position: [6, 0] }
        ]

        filtered_moves = filter.filter_out(friendly_moves, enemy_moves)

        expect(filtered_moves).to contain_exactly(*valid_moves)
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

        filtered_moves = filter.filter_out(friendly_moves, enemy_moves)

        expect(filtered_moves).to contain_exactly(*valid_moves)
      end
    end

    context 'when the king is in checkmate' do
      before { allow(verifier).to receive(:checkv2?).and_return(true) }
      it 'returns an empty move set' do
        # Simulate check mate
        allow(friendly_pieces[1]).to receive(:moves).and_return(
          [ { type: :standard, piece: friendly_pieces[1], ending_position: [5, 0] }]
        )

        allow(king).to receive(:moves).and_return([])

        allow(filter).to receive(:will_be_check?).with(friendly_pieces[1].moves[0]).and_return(true)
        allow(filter).to receive(:will_be_check?).with(king.moves[0]).and_return(true)

        filtered_moves = filter.filter_out(friendly_moves, enemy_moves)

        expect(filtered_moves).to be_empty
      end
    end
  end
end
