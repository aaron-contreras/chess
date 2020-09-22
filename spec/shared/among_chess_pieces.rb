# frozen_string_literal: true

RSpec.shared_context 'list_of_pieces' do
  let(:pieces) do
    [
      double('White Left Rook', player: :white, position: [0, 0]),
      double('White Left Knight', player: :white, position: [0, 1]),
      double('White Left Bishop', player: :white, position: [0, 2]),
      double('White Queen', player: :white, position: [0, 3]),
      double('White King', player: :white, position: [0, 4]),
      double('White Right Bishop', player: :white, position: [0, 5]),
      double('White Right Knight', player: :white, position: [0, 6]),
      double('White Right Rook', player: :white, position: [0, 7]),
      double('White Pawn', player: :white, position:[1, 0]),
      double('White Pawn', player: :white, position:[1, 1]),
      double('White Pawn', player: :white, position:[1, 2]),
      double('White Pawn', player: :white, position:[1, 3]),
      double('White Pawn', player: :white, position:[1, 4]),
      double('White Pawn', player: :white, position:[1, 5]),
      double('White Pawn', player: :white, position:[1, 6]),
      double('White Pawn', player: :white, position:[1, 7]),

      double('Black Pawn', player: :black, position:[6, 0]),
      double('Black Pawn', player: :black, position:[6, 1]),
      double('Black Pawn', player: :black, position:[6, 2]),
      double('Black Pawn', player: :black, position:[6, 3]),
      double('Black Pawn', player: :black, position:[6, 4]),
      double('Black Pawn', player: :black, position:[6, 5]),
      double('Black Pawn', player: :black, position:[6, 6]),
      double('Black Pawn', player: :black, position:[6, 7]),

      double('Black Left Rook', player: :black, position: [7, 0]),
      double('Black Left Knight', player: :black, position: [7, 1]),
      double('Black Left Bishop', player: :black, position: [7, 2]),
      double('Black Queen', player: :black, position: [7, 3]),
      double('Black King', player: :black, position: [7, 4]),
      double('Black Right Bishop', player: :black, position: [7, 5]),
      double('Black Right Knight', player: :black, position: [7, 6]),
      double('Black Right Rook', player: :black, position: [7, 7])
    ]
  end
end