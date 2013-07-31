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
      cells.map(&:last).join('')
    end

  end
end
