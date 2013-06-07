module TSM
  class ScreenSnapshot
    attr_reader :lines

    def initialize
      @lines = []
    end

    def <<(line)
      lines << line
    end

    def [](idx)
      lines[idx]
    end

    def size
      lines.size
    end

    def to_s
      lines.map(&:to_s).join("\n")
    end
  end
end
