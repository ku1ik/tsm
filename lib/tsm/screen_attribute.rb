module TSM

  class ScreenAttribute < FFI::Struct
    FLAG_BOLD      = 1
    FLAG_UNDERLINE = 2
    FLAG_INVERSE   = 4
    FLAG_PROTECT   = 8

    layout :fccode, :int8,
           :bccode, :int8,
           :fr,     :uint8,
           :fg,     :uint8,
           :fb,     :uint8,
           :br,     :uint8,
           :bg,     :uint8,
           :bb,     :uint8,
           :flags,  :uint # bold, underline, inverse, protect (1 bit each)

    def fg
      self[:fccode]
    end

    def bg
      self[:bccode]
    end

    def bold?
      self[:flags] & FLAG_BOLD == FLAG_BOLD
    end

    def underline?
      self[:flags] & FLAG_UNDERLINE == FLAG_UNDERLINE
    end

    def inverse?
      self[:flags] & FLAG_INVERSE == FLAG_INVERSE
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
        :fg        => self[:fccode],
        :bg        => self[:bccode],
        :bold      => bold?,
        :underline => underline?,
        :inverse   => inverse?
      }
    end
  end

end
