# frozen_string_literal: true

require_relative '../../lib/pieces/knight'
require_relative '../../lib/pieces/piece'

RSpec.describe Knight do
  describe '#current_moves' do
    let(:piece) { instance_double(Piece) }

    context 'during initial board setup' do
      subject(:black_knight) { described_class.new({ color: :black, location: [0, 1] }) }
      let(:board) do
        [
          [piece, black_knight, piece, piece, piece, piece, piece, piece],
          [piece, piece, piece, piece, piece, piece, piece, piece],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        results = black_knight.current_moves(board)
        expect(results).to contain_exactly([2, 0], [2, 2])
      end
    end

    context 'when board is empty' do
      subject(:black_knight) { described_class.new({ color: :black, location: [3, 3] }) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_knight, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has eight moves' do
        results = black_knight.current_moves(board)
        expect(results).to contain_exactly([1, 2], [1, 4], [2, 1], [2, 5], [4, 1], [4, 5], [5, 2], [5, 4])
      end
    end

    context 'during initial board setup' do
      subject(:white_knight) { described_class.new({ color: :whilte, location: [7, 6] }) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [piece, piece, piece, piece, piece, piece, piece, piece],
          [piece, piece, piece, piece, piece, piece, white_knight, piece]
        ]
      end

      it 'has two moves' do
        results = white_knight.current_moves(board)
        expect(results).to contain_exactly([5, 5], [5, 7])
      end
    end

    context 'when all moves are blocked' do
      subject(:black_knight) { described_class.new({ color: :black, location: [3, 3] }) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, piece, nil, nil, nil],
          [nil, piece, nil, nil, nil, piece, nil, nil],
          [nil, nil, nil, black_knight, nil, nil, nil, nil],
          [nil, piece, nil, nil, nil, piece, nil, nil],
          [nil, nil, piece, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        results = black_knight.current_moves(board)
        expect(results).to be_empty
      end
    end
  end

  describe '#current_captures' do
    let(:white_piece) { instance_double(Piece, color: :white) }
    let(:black_piece) { instance_double(Piece, color: :black) }

    context 'when there is one opposing piece to capture' do
      subject(:black_knight) { described_class.new({ color: :black, location: [4, 7] }) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, black_piece, nil],
          [nil, nil, nil, nil, nil, white_piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, black_knight],
          [nil, nil, nil, nil, nil, black_piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, black_piece, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has one capture' do
        results = black_knight.current_captures(board)
        expect(results).to contain_exactly([3, 5])
      end
    end

    context 'when there is four opposing pieces and four pieces to ignore' do
      subject(:black_knight) { described_class.new({ color: :black, location: [3, 3] }) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, white_piece, nil, white_piece, nil, nil, nil],
          [nil, black_piece, nil, nil, nil, black_piece, nil, nil],
          [nil, nil, nil, black_knight, nil, nil, nil, nil],
          [nil, black_piece, nil, nil, nil, black_piece, nil, nil],
          [nil, nil, white_piece, nil, white_piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four captures' do
        results = black_knight.current_captures(board)
        expect(results).to contain_exactly([1, 2], [1, 4], [5, 2], [5, 4])
      end
    end

    context 'when there is four opposing pieces and four empty places to ignore' do
      subject(:black_knight) { described_class.new({ color: :black, location: [3, 3] }) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, white_piece, nil, nil, nil, white_piece, nil, nil],
          [nil, nil, nil, black_knight, nil, nil, nil, nil],
          [nil, white_piece, nil, nil, nil, white_piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four captures' do
        results = black_knight.current_captures(board)
        expect(results).to contain_exactly([2, 1], [2, 5], [4, 1], [4, 5])
      end
    end
  end
end
