require 'tsm/screen_attribute'

module TSM
  module Bindings
    callback :screen_prepare_callback, [:pointer, :pointer], :int
    callback :screen_draw_callback, [:pointer, :uint32, :pointer, :size_t,
                                     :uint, :uint, :uint,
                                     ScreenAttributeStruct.by_ref, :pointer],
                                     :int
    callback :screen_render_callback, [:pointer, :pointer], :int

    # int tsm_screen_new(struct tsm_screen **out, tsm_log_t log, void *log_data);
    attach_function :tsm_screen_new, [:pointer, :pointer, :pointer], :int

    # int tsm_screen_resize(struct tsm_screen *con, unsigned int x, unsigned int y);
    attach_function :tsm_screen_resize, [:pointer, :uint, :uint], :int

    # unsigned int tsm_screen_get_flags(struct tsm_screen *con);
    attach_function :tsm_screen_get_flags, [:pointer], :uint

    # unsigned int tsm_screen_get_cursor_x(struct tsm_screen *con);
    attach_function :tsm_screen_get_cursor_x, [:pointer], :uint

    # unsigned int tsm_screen_get_cursor_y(struct tsm_screen *con);
    attach_function :tsm_screen_get_cursor_y, [:pointer], :uint

    # void tsm_screen_draw(struct tsm_screen *con,
    #          tsm_screen_prepare_cb prepare_cb,
    #          tsm_screen_draw_cb draw_cb,
    #          tsm_screen_render_cb render_cb,
    #          void *data);
    attach_function :tsm_screen_draw, [:pointer, :screen_prepare_callback,
                                       :screen_draw_callback,
                                       :screen_render_callback, :pointer], :void
  end

  class Screen
    FLAG_HIDE_CURSOR = 0x10

    attr_reader :pointer

    def initialize(width, height)
      create_screen
      resize(width, height)
    end

    def cursor_x
      call(:get_cursor_x)
    end

    def cursor_y
      call(:get_cursor_y)
    end

    def cursor_visible?
      flags & FLAG_HIDE_CURSOR == 0
    end

    def snapshot
      snapshot = []

      line_no = -1
      line = nil

      draw do |x, y, char, attr|
        if y != line_no
          line_no = y
          line = []
          snapshot << line
        end

        line << [attr, char]
      end

      snapshot
    end

    private

    def create_screen
      screen_ptr = FFI::MemoryPointer.new(:pointer)
      ret = TSM::Bindings.tsm_screen_new(screen_ptr, nil, nil)
      raise "Couldn't create screen" unless ret.zero?
      @pointer = screen_ptr.get_pointer(0)
    end

    def call(function, *args)
      TSM::Bindings.public_send(:"tsm_screen_#{function}", pointer, *args)
    end

    def resize(width, height)
      call(:resize, width, height)
    end

    def flags
      call(:get_flags)
    end

    def draw(&block)
      callback = proc do |screen, id, ch_ptr, len, width, posx, posy, attr_struct, data|
        char = ch_ptr.read_string
        attr = ScreenAttribute.new(attr_struct)
        yield(posx, posy, char, attr)
        0
      end

      call(:draw, nil, callback, nil, nil)
    end
  end

end
