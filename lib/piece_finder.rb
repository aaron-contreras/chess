# frozen_string_literal: true

class PieceFinder
  def initialize(all_pieces)
    @all_pieces = all_pieces
  end

  def enemy_pieces(player)
    all_pieces.reject { |piece_from_set| piece_from_set.player == player }
  end

  def friendly_pieces(player)
    all_pieces.select { |piece_from_set| piece_from_set.player == player }
  end

  def other_pieces(piece)
    all_pieces.reject { |piece_from_set| piece_from_set == piece }
  end

  def white_pieces
    all_pieces.select { |piece_from_set| piece_from_set }
  end

  private

  attr_reader :all_pieces
end
