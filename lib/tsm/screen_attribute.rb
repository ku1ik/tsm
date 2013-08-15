module TSM

  class ScreenAttribute < FFI::Struct
    FLAG_BOLD      = 1
    FLAG_UNDERLINE = 2
    FLAG_INVERSE   = 4
    FLAG_PROTECT   = 8
    FLAG_BLINK     = 16
    RGB_LEVELS = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]

    layout :fccode, :int8,
           :bccode, :int8,
           :fr,     :uint8,
           :fg,     :uint8,
           :fb,     :uint8,
           :br,     :uint8,
           :bg,     :uint8,
           :bb,     :uint8,
           :flags,  :uint # bold, underline, inverse, protect, blink (1 bit each)

    def to_h
      {
        :fg        => fg,
        :bg        => bg,
        :bold      => bold?,
        :underline => underline?,
        :inverse   => inverse?,
        :blink     => blink?
      }
    end

    private

    def flags
      self[:flags]
    end

    def fg
      code = self[:fccode]

      case code
      when -1
        color_from_rgb(self[:fr], self[:fg], self[:fb])
      when 0..15
        code
      else
        nil
      end
    end

    def bg
      code = self[:bccode]

      case code
      when -1
        color_from_rgb(self[:br], self[:bg], self[:bb])
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

    def blink?
      flags & FLAG_BLINK == FLAG_BLINK
    end

    def color_from_rgb(r, g, b)
      if r == g && g == b && (r - 8) % 10 == 0
        232 + (r - 8) / 10
      else
        16 + RGB_LEVELS.index(r) * 36 + RGB_LEVELS.index(g) * 6 + RGB_LEVELS.index(b)
      end
    end
  end

end
