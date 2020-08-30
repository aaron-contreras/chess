# frozen_string_literal: true

require_relative '../lib/move_generator'

# rubocop: disable Metrics/BlockLength

describe MoveGenerator do
  # Has a ChessBoard object as a dependency

  let(:board_layout) do
    [
      8.times.map { double('White Pawn') },
      [
        double('White Rook Left'), double('White Knight Left'), double('White Bishop Left'),
        double('White Queen'), double('White King'),
        double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
      ],

      8.times.map { ' ' },
      8.times.map { ' ' },
      8.times.map { ' ' },
      8.times.map { ' ' },

      8.times.map { double('Black Pawn') },
      [
        double('Black Rook Left'), double('Black Knight Left'), double('Black Bishop Left'),
        double('Black Queen'), double('Black King'),
        double('Black Bishop Right'), double('Black Knight Right'), double('Black Rook Right')
      ]
    ]
  end

  let(:chess_board) { double('ChessBoard', board: board_layout) }

  subject(:generator) { described_class.new(chess_board) }

  # Test pieces without special cases for capturing first
  describe 'generate_move' do
    context 'on initial board configuration' do
      context 'when given a rook' do
        # TO-DO: fails
        it 'generates its valid moves' do
          pawn_coordinates = [1, 3]
          valid_moves = [[2, 3], [3, 3]]

          generated_moves = generator.generate_move(pawn_coordinates)

          expect(generated_moves).to eq valid_moves
        end
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
