# frozen_string_literal: true

require_relative '../lib/game_rule_verifier'
require_relative './shared/among_chess_pieces.rb'

RSpec.describe GameRuleVerifier do
  subject(:verifier) { described_class.new(king, friendly_pieces, enemy_pieces) }

  include_context 'list_of_pieces'

  describe '#check?' do
    let(:king) { pieces[4] }
    let(:friendly_pieces) { white_pieces.first(3) }
    let(:enemy_pieces) { black_pieces.first(3) }
    
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

        check_state = verifier.check?

        expect(check_state).to eq(false)
      end
    end

    context 'when the king is in check' do
      it 'returns true' do
        allow(king).to receive(:position).and_return([4, 5])

        # Simulate ability to put in check
        allow(enemy_pieces[0]).to receive(:moves).and_return(
          [{ type: :capture, piece: enemy_pieces[0], captured_piece: king, ending_position: [4, 5]}]
        )

        check_state = verifier.check?

        expect(check_state).to eq(true)
      end
    end
  end
end
