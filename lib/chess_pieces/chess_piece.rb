# frozen_string_literal: true

class ChessPiece
  attr_reader :player, :position

  def initialize(player, position)
    @player = player
    @position = position
  end
end
