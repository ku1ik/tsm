module TSM
  class ScreenLine

    attr_reader :cells

    def initialize
      @cells = []
    end

    def <<(cell)
      cells << cell
    end

    def [](idx)
      cells[idx]
    end

    def size
      cells.size
    end

    def to_s
      cells.map { |cell| prepare_character(cell.last) }.join('')
    end

    private

    def prepare_character(ch)
      ch == '' ? ' ' : ch
    end
  end
end
