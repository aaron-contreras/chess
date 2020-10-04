# frozen_string_literal: true

require_relative '../lib/translator'
require_relative 'shared/among_chess_pieces'

# rubocop: disable all

RSpec.describe Translator do
  include_context 'list_of_pieces'

  subject(:translator) { described_class.new }
  context 'when given a standard move' do
    let(:move) { { type: :standard, piece: pieces[0], ending_position: [3, 0] } }
    it 'returns a nicely formatted move' do
      translated_move = translator.translate(move)

      expect(translated_move).to eq("MOVE a1 #{pieces[0]} -> a4")
    end
  end

  context 'when given a capture move' do
    let(:move) { { type: :capture, piece: pieces[1], captured_piece: pieces[18], ending_position: [7, 4] } }

    it 'returns a nicely formatted move' do
      translated_move = translator.translate(move)
      
      expect(translated_move).to eq("CAPTURE b1 #{pieces[1]} -> c7 #{pieces[18]}")
    end
  end

  context 'when given a castling move' do
    let(:king) { pieces[0] }
    let(:rook) { pieces[1] }
    let(:move) { { type: :castling, style: :long_side, king: king, rook: rook, king_ending_position: [0, 2], rook_ending_position: [0, 3] } }

    it 'returns a nicely formatted move' do
      translated_move = translator.translate(move)
      
      expect(translated_move).to eq("CASTLING #{rook} <<->> #{king}")
    end
  end

  context 'when given an en passant move' do
    let(:pawn) { pieces[0] }
    let(:captured_pawn) { pieces[17] }
    let(:move) { { type: :en_passant, piece: pawn, captured_piece: captured_pawn, ending_position: [5, 2] } }

    it 'returns a nicely formatted move' do
      translated_move = translator.translate(move)

      expect(translated_move).to eq("EN-PASSANT a1 #{pawn} -> b7 #{captured_pawn}")
    end
  end
end
