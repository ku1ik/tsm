module TSM

  class ScreenAttributeStruct < FFI::Struct
    layout :fccode, :int8,
           :bccode, :int8,
           :fr,     :uint8,
           :fg,     :uint8,
           :fb,     :uint8,
           :br,     :uint8,
           :bg,     :uint8,
           :bb,     :uint8,
           :flags,  :uint # bold, underline, inverse, protect (1 bit each)
  end

  class ScreenAttribute
    FLAG_BOLD      = 1
    FLAG_UNDERLINE = 2
    FLAG_INVERSE   = 4

    attr_reader :fg, :bg, :flags

    def initialize(struct)
      @fg = struct[:fccode]
      @bg = struct[:bccode]
      @flags = struct[:flags]
    end

    def bold?
      flags & FLAG_BOLD == FLAG_BOLD
    end

    def underline?
      flags & FLAG_UNDERLINE == FLAG_UNDERLINE
    end

    def inverse?
      flags & FLAG_INVERSE == FLAG_INVERSE
    end

    def ==(other)
      fg == other.fg &&
        bg == other.bg &&
        bold? == other.bold? &&
        underline? == other.underline? &&
        inverse? == other.inverse?
    end

    def as_json(*)
      {
        :fg        => fg,
        :bg        => bg,
        :bold      => bold?,
        :underline => underline?,
        :inverse   => inverse?
      }
    end
  end
end
