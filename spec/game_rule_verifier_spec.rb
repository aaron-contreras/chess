# frozen_string_literal: true

require_relative '../lib/game_rule_verifier'
require_relative './shared/among_chess_pieces.rb'

# rubocop: disable all
RSpec.describe GameRuleVerifier do
  subject(:verifier) { described_class.new(king, all_pieces) }

  include_context 'list_of_pieces'

  describe '#check?' do
    let(:king) { pieces[4] }
    let(:friendly_pieces) { white_pieces.first(3) + [king] }
    let(:enemy_pieces) { black_pieces.first(3) }
    let(:all_pieces) { friendly_pieces + enemy_pieces }


    # Stub move behavior for enemy_pieces
    before do
      allow(enemy_pieces[0]).to receive(:moves).and_return(
        [{ type: :standard, piece: enemy_pieces[0], ending_position: [1, 2] }]
      )
      allow(enemy_pieces[1]).to receive(:moves).and_return(
        [{ type: :standard, piece: enemy_pieces[1], ending_position: [4, 5] }]
      )
      allow(enemy_pieces[2]).to receive(:moves).and_return([{ type: :standard, piece: enemy_pieces[2], ending_position: [5, 4] }]
      )
    end

    context 'when the king is not in check' do
      it 'returns false' do
        allow(king).to receive(:position).and_return([4, 4])

        check_state = verifier.check?(all_pieces)

        expect(check_state).to eq(false)
      end
    end

    context 'when the king is in check' do
      it 'returns true' do
        allow(king).to receive(:position).and_return([4, 5])
        allow(king).to receive(:is_a?).with(King).and_return(true)

        # Simulate ability to put in check
        allow(enemy_pieces[0]).to receive(:moves).and_return(
          [{ type: :capture, piece: enemy_pieces[0], captured_piece: king, ending_position: [4, 5]}]
        )

        check_state = verifier.check?(all_pieces)

        expect(check_state).to eq(true)
      end
    end
  end

  describe '#checkmate?' do
    let(:king) { pieces[4] }
    let(:friendly_pieces) { white_pieces.first(3) }
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
      allow(enemy_pieces[2]).to receive(:moves).and_return([{ type: :standard, piece: enemy_pieces[2], ending_position: [5, 4] }]
      )

      # Stub move behavior for friendly_pieces


      allow(friendly_pieces[1]).to receive(:moves).and_return([])

      allow(friendly_pieces[2]).to receive(:moves).and_return([])
    end

    context 'when king can get out of check' do
      it 'returns false' do
        allow(friendly_pieces[0]).to receive(:moves).and_return([
          { type: :capture,
          piece: friendly_pieces[0],
          captured_piece: enemy_pieces[0],
          ending_position: enemy_pieces[0].position
          }
        ])

        player_moves = friendly_pieces.map(&:moves)
        checkmate_state = verifier.checkmate?(all_pieces)

        expect(checkmate_state).to eq(false)
      end
    end

    context "when king can't get out of check" do
      it 'returns true' do
        allow(king).to receive(:is_a?).with(King).and_return(true)
        allow(friendly_pieces[0]).to receive(:moves).and_return([])

        player_moves = friendly_pieces.map(&:moves).reject(&:empty?)

        checkmate_state = verifier.checkmate?(player_moves)

        expect(checkmate_state).to eq(true)
      end
    end
  end

  describe '#stalemate?' do
    let(:king) { white_pieces[4] }
    let(:enemy_pieces) { black_pieces.first(2) }
    let(:all_pieces) { enemy_pieces + [king] }

    context 'when in stalemate' do
      before do
        allow(enemy_pieces[0]).to receive(:moves).and_return(
          [],
          [ { type: :capture, piece: enemy_pieces[0], captured_piece: king, ending_position: king.position }]
        )
        allow(enemy_pieces[1]).to receive(:moves).and_return(
          [],
          [ { type: :capture, piece: enemy_pieces[1], captured_piece: king, ending_position: king.position}]
        )

        allow(king).to receive(:moves).and_return([])
      end

      it 'returns true' do
        expect(verifier.stalemate?(king.moves)).to eq(true)
      end

      context 'when not in stalemate' do
        before do
          allow(king).to receive(:moves).and_return([
            { type: :standard, piece: king, ending_position: [7, 5] }
          ])
        end

        it 'returns false' do
          expect(verifier.stalemate?(king.moves)).to eq(false)
        end
      end
    end
  end
end
# rubocop: enable all
