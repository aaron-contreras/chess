# frozen_string_literal: true

require_relative '../../lib/chess_pieces/king'
require_relative '../shared/among_chess_pieces'

# rubocop: disable all
RSpec.describe King do
  include_context 'list_of_pieces'

  describe '#to_s' do
    include_examples 'piece_display', described_class.new(:white, [0, 4])
    include_examples 'piece_display', described_class.new(:black, [7, 4])

  end
  

  describe '#moves' do
    before do
      other_pieces = pieces.reject { |piece| piece == king }
      other_pieces.each do |piece|
        allow(piece).to receive(:moves).and_return([])
      end
    end

    context 'when not in a position to move' do
      subject(:king) { described_class.new(:white, [0, 4])}

      it 'returns an empty array' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 4 }

        list_of_moves = king.moves(other_pieces)

        expect(list_of_moves).to be_empty
      end
    end


    context 'when in a position able to move but not capture' do
      subject(:king) { described_class.new(:black, [4, 4])}

      it 'returns an array with all valid moves' do
        other_pieces = pieces.reject.with_index { |_piece, index| index == 28 }

        list_of_moves = king.moves(other_pieces)

        expected_moves = [
          { type: :standard, piece: king, ending_position: [3, 4] },
          { type: :standard, piece: king, ending_position: [3, 5] },
          { type: :standard, piece: king, ending_position: [4, 5] },
          { type: :standard, piece: king, ending_position: [5, 5] },
          { type: :standard, piece: king, ending_position: [5, 4] },
          { type: :standard, piece: king, ending_position: [5, 3] },
          { type: :standard, piece: king, ending_position: [4, 3] },
          { type: :standard, piece: king, ending_position: [3, 3] }
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end

    context 'when in a position able to move and capture' do
      subject(:king) { described_class.new(:white, [2, 4]) }

      it 'returns an array with all valid moves/caputres' do
        # Place a black pawn in a capturable position
        enemy_piece = pieces[16]
        allow(pieces[16]).to receive(:position).and_return([3, 4])

        other_pieces = pieces.reject.with_index { |_piece, index| index == 4 }

        list_of_moves = king.moves(other_pieces)

        expected_moves = [
          { type: :capture, piece: king, captured_piece: enemy_piece, ending_position: [3, 4] },
          { type: :standard, piece: king, ending_position: [2, 5] },
          { type: :standard, piece: king, ending_position: [3, 5] },
          { type: :standard, piece: king, ending_position: [3, 3] },
          { type: :standard, piece: king, ending_position: [2, 3] },
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end

    context 'when an enemy piece can move to the path between king and rook' do
      subject(:king) { described_class.new(:white, [0, 4]) }
      
      it "can't castle" do
        allow(black_pieces[0]).to receive(:moves).and_return(
          [ { type: :standard, piece: black_pieces[0], ending_position: [0, 3]} ]
        )

        other_pieces = pieces.reject.with_index { |piece, index| (1..4).include?(index) || (17..31).include?(index) }

        long_side_rook = white_pieces[0]

        list_of_moves = king.moves(other_pieces)

        expected_moves = [
          { type: :standard, piece: king, ending_position: [0, 3] }
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end

    context 'when able to perform long side castling' do
      subject(:king) { described_class.new(:white, [0, 4]) }
      it 'returns an array with valid moves/captures/castling' do
        # Make the castle move available

        allow(black_pieces[0]).to receive(:moves).and_return([])

        other_pieces = pieces.reject.with_index { |_piece, index| [1, 2, 3].include?(index) || (17..31).include?(index) }


        long_side_rook = pieces[0]

        list_of_moves = king.moves(other_pieces)

        expected_moves = [
          { type: :castling, king: king, rook: long_side_rook, king_ending_position: [0, 2], rook_ending_position: [0, 3] },
          { type: :standard, piece: king, ending_position: [0, 3] }
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end

    context 'when able to perform short side castling' do
      subject(:king) { described_class.new(:black, [7, 4]) }

      it 'returns an array with valid moves/captures/castling' do
        allow(white_pieces[0]).to receive(:moves).and_return([])

        # Make the castle move available
        other_pieces = pieces.reject.with_index { |_piece, index| [29, 30].include?(index) || (0..15).include?(index) }

        short_side_rook = pieces[31]

        list_of_moves = king.moves(other_pieces)

        expected_moves = [
          { type: :castling, king: king, rook: short_side_rook, king_ending_position: [7, 6], rook_ending_position: [7, 5] },
          { type: :standard, piece: king, ending_position: [7, 5] }
        ]

        expect(list_of_moves).to contain_exactly(*expected_moves)
      end
    end
  end
end
