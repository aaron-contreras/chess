# frozen_string_literal: true

require_relative '../../lib/chess_pieces/pawn'
require_relative '../shared/among_chess_pieces.rb'

RSpec.describe Pawn do
  include_context 'list_of_pieces'
  
  describe '#moves' do
    context "when it hasn't yet moved" do
      subject(:pawn) { described_class.new(:white, [1, 1]) }

      it 'returns a single and double jump move' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 9 }

        list_of_moves = pawn.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([2, 1], [3, 1])
      end
    end

    context 'when it has already made a single jump' do
      subject(:pawn) { described_class.new(:black, [5, 3]) }

      it 'returns only a single jump move' do
        # Mark as already moved
        pawn.instance_variable_set(:@moved, true)

        other_pieces = pieces.reject.with_index { |_piece, index| index == 19 }

        list_of_moves = pawn.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([4, 3])
      end
    end

    context 'when it already made a double jump' do
      subject(:pawn) { described_class.new(:black, [4, 3]) }

      it 'returns only a single jump move' do
        # Mark as already moved
        pawn.instance_variable_set(:@moved, true)

        other_pieces = pieces.reject.with_index { |_piece, index| index == 19 }

        list_of_moves = pawn.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([3, 3])
      end
    end

    context 'when able to capture' do
      subject(:pawn) { described_class.new(:white, [1, 2]) }

      it 'returns all valid moves/captures' do
        # Set up a bishop to be capturable by the pawn
        allow(pieces[26]).to receive(:position).and_return([2, 1])

        other_pieces = pieces.reject.with_index { |_piece, index| index == 10 }

        list_of_moves = pawn.moves(other_pieces)

        expect(list_of_moves).to contain_exactly([2, 2], [3, 2], [2, 1])
      end
    end

    # TODO second
    # ADD TEST FOR EN PASSANT MOVES
  end

  describe '#en_passant_capturable?' do
    subject(:pawn) { described_class.new(:white, [3, 2]) }

    context 'when there have been moves since a double jump' do
      it 'returns false' do
        # Set up conditions
        pawn.double_jumped = true
        pawn.instance_variable_set(:@moves_since_double_jump, 1)

        expect(pawn).not_to be_en_passant_capturable
      end
    end

    context 'when pawn just double jumped' do
      it 'returns true' do
        # Set up conditions
        pawn.double_jumped = true
        # Pawn has not gotten another turn yet

        expect(pawn).to be_en_passant_capturable
      end
    end

    context "when pawn didn't double jump as first move" do
      subject(:pawn) { described_class.new(:black, [5, 2]) }

      it 'returns false' do
        # Pawn hasn't double jumped

        expect(pawn).not_to be_en_passant_capturable
      end
    end
  end
end
