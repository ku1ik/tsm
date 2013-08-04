module TSM

  class ScreenAttribute < FFI::Struct
    FLAG_BOLD      = 1
    FLAG_UNDERLINE = 2
    FLAG_INVERSE   = 4

    layout :fccode, :int8,
           :bccode, :int8,
           :fr,     :uint8,
           :fg,     :uint8,
           :fb,     :uint8,
           :br,     :uint8,
           :bg,     :uint8,
           :bb,     :uint8,
           :flags,  :uint # bold, underline, inverse, protect (1 bit each)

    def to_h
      {
        :fg        => fg,
        :bg        => bg,
        :bold      => bold?,
        :underline => underline?,
        :inverse   => inverse?
      }
    end

    private

    def flags
      self[:flags]
    end

    def fg
      code = self[:fccode]

      case code
      when 0..15
        code
      else
        nil
      end
    end

    def bg
      code = self[:bccode]

      case code
      when 0..15
        code
      else
        nil
      end
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
  end

end
