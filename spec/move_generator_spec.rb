# frozen_string_literal: true

require_relative '../lib/move_generator'

# rubocop: disable Metrics/BlockLength
# rubocop: disable Metrics/LineLength
describe MoveGenerator do
  # Has a ChessBoard object as a dependency

  let(:chess_board) { double('ChessBoard', board: board_layout) }

  subject(:generator) { described_class.new(chess_board) }

  # Test pieces without special cases for capturing first
  describe 'generate_move' do
    let(:rook_movement_directions) { [[-1, 0], [0, 1], [1, 0], [0, -1]] }
    let(:knight_movement_directions) { [[-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [1, -2], [2, -1]] }
    let(:bishop_movement_directions) { [[-1, -1], [-1, 1], [1, 1], [1, -1]] }
    let(:queen_movement_directions) { [[-1, 0], [0, 1], [1, 0], [0, -1], [-1, -1], [-1, 1], [1, 1], [1, -1]] }
    let(:king_movement_directions) { [[-1, -1], [-1, 0], [-1, -1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]] }

    context 'on initial board configuration' do
      let(:board_layout) do
        [
          [
            double('White Rook Left'), double('White Knight Left'), double('White Bishop Left'),
            double('White Queen'), double('White King'),
            double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
          ],
          8.times.map { double('White Pawn') },

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

      before do
        board_layout[0].each do |white_piece|
          allow(white_piece).to receive(:color).and_return(:white)
        end

        board_layout[1].each do |white_piece|
          allow(white_piece).to receive(:color).and_return(:white)
        end
      end

      context 'when given a rook' do
        it 'returns no valid moves' do
          allow(board_layout[0][0]).to receive(:movement_directions).and_return(rook_movement_directions)
          allow(board_layout[0][0]).to receive(:repeatedly_jumps?).and_return(true)
          valid_moves = generator.generate_moves([0, 0])
          expect(valid_moves).to eq([])
        end
      end

      context 'when given a bishop' do
        it 'returns no valid moves' do
          allow(board_layout[0][2]).to receive(:movement_directions).and_return(bishop_movement_directions)
          allow(board_layout[0][2]).to receive(:repeatedly_jumps?).and_return(true)

          valid_moves = generator.generate_moves([0, 2])

          expect(valid_moves).to eq([])
        end
      end

      context 'when given a knight' do
        it 'returns two valid moves' do
          allow(board_layout[0][1]).to receive(:movement_directions).and_return(knight_movement_directions)
          allow(board_layout[0][1]).to receive(:repeatedly_jumps?).and_return(false)

          valid_moves = generator.generate_moves([0, 1])

          expect(valid_moves).to contain_exactly([2, 0], [2, 2])
        end
      end

      context 'when given a king' do

        it 'returns no valid moves' do
          allow(board_layout[0][4]).to receive(:movement_directions).and_return(king_movement_directions)
          allow(board_layout[0][4]).to receive(:repeatedly_jumps?).and_return(false)

          valid_moves = generator.generate_moves([0, 4])

          expect(valid_moves).to eq([])
        end
      end

      # SPECIAL CASES FOR CAPTURES

      # PAWN

      context 'when given a' do
        context 'white pawn' do
          let(:pawn_movement_directions) { [[1, 0], [2, 0]] }

          it 'returns two valid moves' do
            allow(board_layout[1][0]).to receive(:movement_directions).and_return(pawn_movement_directions)

            allow(board_layout[1][0]).to receive(:repeatedly_jumps?).and_return(false)

            valid_moves = generator.generate_moves([1, 0])

            expect(valid_moves).to contain_exactly([2, 0], [3, 0])
          end
        end

        context 'black pawn' do
          let(:pawn_movement_directions) { [[-1, 0], [-2, 0]] }

          it 'returns two valid moves' do
            allow(board_layout[6][3]).to receive(:movement_directions).and_return(pawn_movement_directions)

            allow(board_layout[6][3]).to receive(:repeatedly_jumps?).and_return(false)

            valid_moves = generator.generate_moves([6, 3])

            expect(valid_moves).to contain_exactly([5, 3], [4, 3])
          end
        end
      end

      context 'when given a queen' do
        it 'returns no valid moves' do
          allow(board_layout[0][3]).to receive(:movement_directions).and_return(queen_movement_directions)
          allow(board_layout[0][3]).to receive(:repeatedly_jumps?).and_return(true)

          valid_moves = generator.generate_moves([0, 3])

          expect(valid_moves).to eq([])
        end
      end
    end

    context 'on a developing game' do
      context 'when given a movable rook' do
        let(:board_layout) do
          [
            [
              double('White Rook Left'), ' ', double('White Bishop Left'),
              double('White Queen'), double('White King'),
              double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
            ],
            [' ', double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn')],

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

        it 'returns all valid moves' do
          allow(board_layout[0][0]).to receive(:movement_directions).and_return(rook_movement_directions)
          allow(board_layout[0][0]).to receive(:repeatedly_jumps?).and_return(true)

          valid_moves = generator.generate_moves([0, 0])

          expect(valid_moves).to contain_exactly([0, 1], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0])
        end
      end

      context 'when given a movable knight' do
        let(:board_layout) do
          [
            [
              double('White Rook Left'), ' ', double('White Bishop Left'),
              double('White Queen'), double('White King'),
              double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
            ],
            [double('White Pawn'), ' ', ' ', double('White Pawn'), ' ', ' ', ' ', ' '],

            8.times.map { ' ' },
            [' ', ' ', double('White Knight Left'), ' ', ' ', ' ', ' ', ' '],
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

        it 'returns all valid moves' do
          allow(board_layout[3][2]).to receive(:movement_directions).and_return(knight_movement_directions)
          allow(board_layout[3][2]).to receive(:repeatedly_jumps?).and_return(false)

          valid_moves = generator.generate_moves([3, 2])

          expect(valid_moves).to contain_exactly([2, 0], [1, 1], [2, 4], [4, 4], [5, 3], [5, 1], [4, 0])
        end
      end

      context 'when given a movable bishop' do
        let(:board_layout) do
          [
            [
              double('White Rook Left'), ' ', ' ',
              double('White Queen'), double('White King'),
              double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
            ],
            [' ', double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn')],

            8.times.map { ' ' },
            [' ', double('White bishop left'), ' ', ' ', ' ', ' ', ' ', ' '],
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

        it 'returns all valid moves' do
          allow(board_layout[3][1]).to receive(:movement_directions).and_return(bishop_movement_directions)
          allow(board_layout[3][1]).to receive(:repeatedly_jumps?).and_return(true)

          valid_moves = generator.generate_moves([3, 1])

          expect(valid_moves).to contain_exactly([2, 0], [2, 2], [4, 0], [4, 2], [5, 3])
        end
      end

      context 'when given a movable queen' do
        let(:board_layout) do
          [
            [
              double('White Rook Left'), ' ', ' ',
              ' ', double('White King'),
              double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
            ],
            [' ', double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn'), double('White Pawn')],

            8.times.map { ' ' },
            [' ', double('White Queen'), ' ', ' ', ' ', ' ', ' ', ' '],
            8.times.map { ' ' },
            8.times.map { ' ' },

            [double('Black Pawn'), ' ', double('Black Pawn'), double('Black Pawn'), double('Black Pawn'), double('Black Pawn'), double('Black Pawn')],
            [
              double('Black Rook Left'), double('Black Knight Left'), double('Black Bishop Left'),
              double('Black Queen'), double('Black King'),
              double('Black Bishop Right'), double('Black Knight Right'), double('Black Rook Right')
            ]
          ]
        end

        it 'returns all valid moves' do
          allow(board_layout[3][1]).to receive(:movement_directions).and_return(queen_movement_directions)
          allow(board_layout[3][1]).to receive(:repeatedly_jumps?).and_return(true)

          valid_moves = generator.generate_moves([3, 1])

          expect(valid_moves).to contain_exactly([2, 1], [2, 2], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], [4, 2], [5, 3], [4, 1], [5, 1], [6, 1], [4, 0], [3, 0], [2, 0])
        end
      end

      context 'when given a movable king' do
        let(:board_layout) do
          [
            [
              double('White Rook Left'), ' ', ' ',
              ' ', double('White King'),
              double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
            ],
            [' ', double('White Pawn'), double('White Pawn'), double('White Pawn'), ' ', ' ', double('White Pawn')],

            8.times.map { ' ' },
            [' ', double('White Queen'), ' ', ' ', ' ', ' ', ' ', ' '],
            8.times.map { ' ' },
            8.times.map { ' ' },

            [double('Black Pawn'), ' ', double('Black Pawn'), double('Black Pawn'), double('Black Pawn'), double('Black Pawn'), double('Black Pawn')],
            [
              double('Black Rook Left'), double('Black Knight Left'), double('Black Bishop Left'),
              double('Black Queen'), double('Black King'),
              double('Black Bishop Right'), double('Black Knight Right'), double('Black Rook Right')
            ]
          ]
        end

        it 'generates all valid moves' do
          allow(board_layout[0][4]).to receive(:movement_directions).and_return(king_movement_directions)
          allow(board_layout[0][4]).to receive(:repeatedly_jumps?).and_return(false)

          valid_moves = generator.generate_moves([0, 4])

          expect(valid_moves).to contain_exactly([0, 3], [1, 4], [1, 5])
        end
      end
      
      context 'when given a movable white pawn' do
        let(:board_layout) do
          [
            [
              double('White Rook Left'), ' ', ' ',
              ' ', double('White King'),
              double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
            ],
            [' ', double('White Pawn'), double('White Pawn'), double('White Pawn'), ' ', ' ', double('White Pawn')],

            8.times.map { ' ' },
            [double('White Pawn'), double('White Queen'), ' ', ' ', ' ', ' ', ' ', ' '],
            8.times.map { ' ' },
            8.times.map { ' ' },

            [double('Black Pawn'), ' ', double('Black Pawn'), double('Black Pawn'), double('Black Pawn'), double('Black Pawn'), double('Black Pawn')],
            [
              double('Black Rook Left'), double('Black Knight Left'), double('Black Bishop Left'),
              double('Black Queen'), double('Black King'),
              double('Black Bishop Right'), double('Black Knight Right'), double('Black Rook Right')
            ]
          ]
        end

        let(:pawn_movement_directions) { [[1, 0]] }

        it 'returns all valid moves' do
          allow(board_layout[3][0]).to receive(:movement_directions).and_return(pawn_movement_directions)
          allow(board_layout[3][0]).to receive(:repeatedly_jumps?).and_return(false)

          valid_moves = generator.generate_moves([3, 0])

          expect(valid_moves).to contain_exactly([4, 0])
        end
      end

      context 'when given a movable black pawn' do
        let(:board_layout) do
          [
            [
              double('White Rook Left'), ' ', ' ',
              ' ', double('White King'),
              double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
            ],
            [' ', double('White Pawn'), double('White Pawn'), double('White Pawn'), ' ', ' ', double('White Pawn')],

            8.times.map { ' ' },
            [double('White Pawn'), double('White Queen'), ' ', ' ', ' ', ' ', ' ', ' '],
            8.times.map { ' ' },
            [double('Black Pawn'), ' ', ' ', ' ', ' ', ' ', ' ', ' '],

            [' ', ' ', double('Black Pawn'), double('Black Pawn'), double('Black Pawn'), double('Black Pawn'), double('Black Pawn')],
            [
              double('Black Rook Left'), double('Black Knight Left'), double('Black Bishop Left'),
              double('Black Queen'), double('Black King'),
              double('Black Bishop Right'), double('Black Knight Right'), double('Black Rook Right')
            ]
          ]
        end

        let(:pawn_movement_directions) { [[-1, 0]] }

        it 'returns all valid moves' do
          allow(board_layout[5][0]).to receive(:movement_directions).and_return(pawn_movement_directions)
          allow(board_layout[5][0]).to receive(:repeatedly_jumps?).and_return(false)

          valid_moves = generator.generate_moves([5, 0])

          expect(valid_moves).to contain_exactly([4, 0])
        end
      end
    end
  end

  context '#generate_captures' do
    context "when given a white pawn that can't capture" do
      let(:board_layout) do
        [
          [
            double('White Rook Left'), double('White Knight Left'), double('White Bishop Left'),
            double('White Queen'), double('White King'),
            double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
          ],
          8.times.map { double('White Pawn') },

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

      let(:pawn_capture_directions) { [[1, -1], [1, 1]] }

      # CREATE A CLASS FOR EVERY PIECE CAPTURE STYLE
      # PAWN NEEDS EN_PASSANT
      # ETC

      it 'returns an empty array' do
        allow(board_layout[1][3]).to receive(:capture_directions).and_return(pawn_capture_directions)
        allow(board_layout[1][3]).to receive(:repeatedly_jumps?).and_return(false)

        captures = generator.generate_captures([1, 3])

        expect(captures).to be_empty
      end
    end

    context 'when given a pawn that can capture' do
      let(:board_layout) do
        [
          [
            double('White Rook Left'), double('White Knight Left'), double('White Bishop Left'),
            double('White Queen'), double('White King'),
            double('White Bishop Right'), double('White Knight Right'), double('White Rook Right')
          ],
          8.times.map { double('White Pawn') },

          [double('Black Pawn'), ' ', ' ', ' ', ' ', ' ', ' ', ' '],
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

      let(:pawn_capture_directions) { [[1, -1], [1, 1]] }
      it 'returns the capture coordinates' do
        allow(board_layout[1][1]).to receive(:capture_directions).and_return(pawn_capture_directions)
        allow(board_layout[1][1]).to receive(:color).and_return(:white)
        allow(board_layout[2][0]).to receive(:color).and_return(:black)

        captures = generator.generate_captures([1, 1])

        expect(captures).to contain_exactly([2, 0])
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
# rubocop: enable Metrics/LineLength
