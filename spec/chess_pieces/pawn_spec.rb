# frozen_string_literal: true

require_relative '../../lib/chess_pieces/pawn'
require_relative '../shared/among_chess_pieces.rb'

# rubocop: disable all

RSpec.describe Pawn do
  include_context 'list_of_pieces'

  describe '#to_s' do
    include_examples 'piece_display', described_class.new(:white, [1, 0])
    include_examples 'piece_display', described_class.new(:black, [6, 0])
  end

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

    context 'when able to capture "En Passant"' do
      subject(:pawn) { described_class.new(:black, [3, 3]) }
      context 'to its left' do
        it 'returns all valid moves/captures/en passants' do
          # Set up enemy pawn to be capturable by en passant

          enemy_pawn = pieces[10]
          allow(enemy_pawn).to receive(:position).and_return([3, 2])
          allow(enemy_pawn).to receive(:en_passant_capturable?).and_return(true)

          other_pieces = pieces.reject.with_index { |_piece, index| index == 26 }

          list_of_moves = pawn.moves(other_pieces)

          en_passant_move = list_of_moves.find { |move| move[:type] == :en_passant }

          # Correct list of moves
          expect(list_of_moves).to contain_exactly([2, 3], a_kind_of(Moves::EnPassant))

          # Correct En Passant contents
          expect(en_passant_move).to include(
            pawn: pawn,
            enemy_pawn: enemy_pawn,
            ending_position: [2, 2]
          )
        end
      end

      context 'to its right' do
        it 'returns all valid moves/captures/en passants' do
          # Set up enemy pawn to be capturable by en passant

          enemy_pawn = pieces[12]
          allow(enemy_pawn).to receive(:position).and_return([3, 4])
          allow(enemy_pawn).to receive(:en_passant_capturable?).and_return(true)

          other_pieces = pieces.reject.with_index { |_piece, index| index == 26 }

          list_of_moves = pawn.moves(other_pieces)

          en_passant_move = list_of_moves.find { |move| move.is_a?(Moves::EnPassant) }

          # Correct list of moves
          expect(list_of_moves).to contain_exactly([2, 3], a_kind_of(Moves::EnPassant))

          # Correct En Passant contents
          expect(en_passant_move).to have_attributes(pawn: pawn, enemy_pawn: enemy_pawn, ending_position: [2, 4])
        end
      end
    end
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
# rubocop: enable all
