# frozen_string_literal: true

require_relative 'game_constants'

# Translates moves into a human readable format
class Translator
  def translate(move)
    translated_type = translate_type(move[:type])

    if move[:type] == :standard
      "#{translated_type} #{translate_position(move[:piece].position)} #{move[:piece]} -> #{translate_position(move[:ending_position])}"
    elsif move[:type] == :castling
      "#{translated_type} #{translate_castling_style(move)}"
    else
      "#{translated_type} #{translate_position(move[:piece].position)} #{move[:piece]} -> #{translate_position(move[:captured_piece].position)} #{move[:captured_piece]}"
    end
  end

  def translate_position(position)
    rank = position[0]
    file = position[1]
    "#{GameConstants::INDEX_TO_FILE[file]}#{GameConstants::INDEX_TO_RANK[rank]}"
  end

  def translate_type(type)
    if type == :standard
      'MOVE'
    elsif type == :en_passant
      'EN-PASSANT'
    else
      type.to_s.upcase
    end
  end

  def translate_castling_style(move)
    if move[:style] == :long_side
      "#{move[:rook]} <<->> #{move[:king]}"
    else
      "#{move[:king]} <<->> #{move[:rook]}"
    end
  end
end
