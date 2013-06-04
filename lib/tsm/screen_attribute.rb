module TSM

  class ScreenAttribute < ::FFI::Struct
    layout :fccode, :int8,
            :bccode, :int8,
            :fr,     :uint8,
            :fg,     :uint8,
            :fb,     :uint8,
            :br,     :uint8,
            :bg,     :uint8,
            :bb,     :uint8,
            :flags,  :uint # bold, underline, inverse, protect (1 bit each)

    def bold?
      # TODO
    end

    def underline?
      # TODO
    end

    def inverse?
      # TODO
    end
  end

end
