# frozen_string_literal: true

class StandardMoveGenerator
  def initialize(piece, jump_directions)
    @piece = piece
    @jump_directions = jump_directions
  end

  def generate_moves; end
end