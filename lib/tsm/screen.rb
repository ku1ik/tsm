require 'tsm/screen_attribute'

module TSM
  module Bindings

    # class Screen < ::FFI::Struct
    #   layout :ref,       :size_t,
    #          :llog,      :log_submit_callback,
    #          :llog_data, :pointer,
    #          :opts,      :uint,
    #          :flags,     :uint,
    #          :timer,     :pointer, # shl_timer

    #          # default attributes few new cells
    #          :def_attr, FFI::ScreenAttribute,

    #          # current buffer
    #          :size_x,        :uint,
    #          :size_y,        :uint,
    #          :margin_top,    :uint,
    #          :margin_bottom, :uint,
    #          :line_num,      :uint,
    #          :lines,         :pointer, # array of lines
    #          :main_lines,    :pointer, # array of lines
    #          :alt_lines,     :pointer, # array of lines

    #          # scroll-back buffer
    #          :sb_count,   :uint,
    #          :sb_first,   FFI::Line.by_ref,
    #          :sb_last,    FFI::Line.by_ref,
    #          :sb_max,     :uint,
    #          :sb_pos,     FFI::Line.by_ref,
    #          :sb_last_id, :uint64,

    #          # cursor
    #          :cursor_x, :uint,
    #          :cursor_y, :uint,

    #          # tab ruler
    #          :tab_ruler, :pointer, # bool

    #          # selection
    #          :sel_active, :bool,
    #          :sel_start,  FFI::SelectionPos,
    #          :sel_end,    FFI::SelectionPos
    # end

    callback :screen_prepare_callback, [:pointer, :pointer], :int
    callback :screen_draw_callback, [:pointer, :uint32, :pointer, :size_t,
                                     :uint, :uint, :uint,
                                     ScreenAttribute.by_ref, :pointer],
                                     :int
    callback :screen_render_callback, [:pointer, :pointer], :int

    # int tsm_screen_new(struct tsm_screen **out, tsm_log_t log, void *log_data);
    attach_function :tsm_screen_new, [:pointer, :pointer, :pointer], :int

    # unsigned int tsm_screen_get_width(struct tsm_screen *con);
    attach_function :tsm_screen_get_width, [:pointer], :uint

    # unsigned int tsm_screen_get_height(struct tsm_screen *con);
    attach_function :tsm_screen_get_height, [:pointer], :uint

    # int tsm_screen_resize(struct tsm_screen *con, unsigned int x, unsigned int y);
    attach_function :tsm_screen_resize, [:pointer, :uint, :uint], :int

    # void tsm_screen_set_flags(struct tsm_screen *con, unsigned int flags);
    attach_function :tsm_screen_set_flags, [:pointer, :uint], :void

    # unsigned int tsm_screen_get_flags(struct tsm_screen *con);
    attach_function :tsm_screen_get_flags, [:pointer], :uint

    # unsigned int tsm_screen_get_cursor_x(struct tsm_screen *con);
    attach_function :tsm_screen_get_cursor_x, [:pointer], :uint

    # unsigned int tsm_screen_get_cursor_y(struct tsm_screen *con);
    attach_function :tsm_screen_get_cursor_y, [:pointer], :uint

    # void tsm_screen_move_left(struct tsm_screen *con, unsigned int num);
    attach_function :tsm_screen_move_left, [:pointer, :uint], :void

    # void tsm_screen_move_right(struct tsm_screen *con, unsigned int num);
    attach_function :tsm_screen_move_right, [:pointer, :uint], :void

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
    FLAG_INSERT_MODE = 0x01
    FLAG_AUTO_WRAP   = 0x02
    FLAG_REL_ORIGIN  = 0x04
    FLAG_INVERSE     = 0x08
    FLAG_HIDE_CURSOR = 0x10
    FLAG_FIXED_POS   = 0x20
    FLAG_ALTERNATE   = 0x40

    def initialize(width, height)
      create_screen
      resize(width, height)
    end

    def width
      call(:get_width)
    end

    def height
      call(:get_height)
    end

    def resize(width, height)
      call(:resize, width, height)
    end

    def cursor_x
      call(:get_cursor_x)
    end

    def cursor_y
      call(:get_cursor_y)
    end

    def move_cursor_left(n = 1)
      call(:move_left, n)
    end

    def move_cursor_right(n = 1)
      call(:move_right, n)
    end

    def flags
      call(:get_flags)
    end

    def flags=(flags)
      call(:set_flags, flags)
    end

    def cursor_visible?
      flags & FLAG_HIDE_CURSOR == 0
    end

    def draw(&block)
      callback = proc do |screen, id, ch_ptr, len, width, posx, posy, screen_attr, data|
        char = ch_ptr.read_string
        yield(posx, posy, char, screen_attr)
        0
      end

      call(:draw, nil, callback, nil, nil)
    end

    private

    def create_screen
      screen_ptr = ::FFI::MemoryPointer.new(:pointer)
      ret = TSM::Bindings.tsm_screen_new(screen_ptr, nil, nil)
      raise "Couldn't create screen" unless ret.zero?
      @pointer = screen_ptr.get_pointer(0)
    end

    def call(function, *args)
      TSM::Bindings.public_send(:"tsm_screen_#{function}", @pointer, *args)
    end
  end

end
