# frozen_string_literal: true

# A Pawn chess piece
class Pawn
  attr_reader :color
  def initialize(color)
    @color = color
  end
end
