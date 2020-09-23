# frozen_string_literal: true

RSpec.shared_context 'list_of_pieces' do
  let(:pieces) do
    [
      double('White Left Rook', player: :white, position: [0, 0], moved: false),
      double('White Left Knight', player: :white, position: [0, 1], moved: false),
      double('White Left Bishop', player: :white, position: [0, 2], moved: false),
      double('White Queen', player: :white, position: [0, 3], moved: false),
      double('White King', player: :white, position: [0, 4], moved: false),
      double('White Right Bishop', player: :white, position: [0, 5], moved: false),
      double('White Right Knight', player: :white, position: [0, 6], moved: false),
      double('White Right Rook', player: :white, position: [0, 7], moved: false),
      double('White Pawn', player: :white, position:[1, 0], moved: false),
      double('White Pawn', player: :white, position:[1, 1], moved: false),
      double('White Pawn', player: :white, position:[1, 2], moved: false),
      double('White Pawn', player: :white, position:[1, 3], moved: false),
      double('White Pawn', player: :white, position:[1, 4], moved: false),
      double('White Pawn', player: :white, position:[1, 5], moved: false),
      double('White Pawn', player: :white, position:[1, 6], moved: false),
      double('White Pawn', player: :white, position:[1, 7], moved: false),

      double('Black Pawn', player: :black, position:[6, 0], moved: false),
      double('Black Pawn', player: :black, position:[6, 1], moved: false),
      double('Black Pawn', player: :black, position:[6, 2], moved: false),
      double('Black Pawn', player: :black, position:[6, 3], moved: false),
      double('Black Pawn', player: :black, position:[6, 4], moved: false),
      double('Black Pawn', player: :black, position:[6, 5], moved: false),
      double('Black Pawn', player: :black, position:[6, 6], moved: false),
      double('Black Pawn', player: :black, position:[6, 7], moved: false),

      double('Black Left Rook', player: :black, position: [7, 0], moved: false),
      double('Black Left Knight', player: :black, position: [7, 1], moved: false),
      double('Black Left Bishop', player: :black, position: [7, 2], moved: false),
      double('Black Queen', player: :black, position: [7, 3], moved: false),
      double('Black King', player: :black, position: [7, 4], moved: false),
      double('Black Right Bishop', player: :black, position: [7, 5], moved: false),
      double('Black Right Knight', player: :black, position: [7, 6], moved: false),
      double('Black Right Rook', player: :black, position: [7, 7], moved: false)
    ]
  end
end
