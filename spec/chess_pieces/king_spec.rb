# frozen_string_literal: true

require_relative '../../lib/chess_pieces/king'
require_relative '../shared/among_chess_pieces'

RSpec.describe King do
  include_context 'list_of_pieces'

  describe '#moves' do
    context 'when not in a position to move' do
      subject(:king) { described_class.new(:white, [0, 4])}

      it 'returns an empty array' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 4 }
        
        list_of_moves = king.moves(other_pieces)

        expect(list_of_moves).to be_empty
      end
    end
  end
end
