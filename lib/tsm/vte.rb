module TSM
  module Bindings
    callback :vte_write_callback, [:pointer, :pointer, :size_t, :pointer], :void

    # int tsm_vte_new(struct tsm_vte **out, struct tsm_screen *con,
    #     tsm_vte_write_cb write_cb, void *data,
    #     tsm_log_t log, void *log_data);
    attach_function :tsm_vte_new, [:pointer, :pointer, :vte_write_callback,
                                   :pointer, :pointer, :pointer], :int

    # void tsm_vte_input(struct tsm_vte *vte, const char *u8, size_t len);
    attach_function :tsm_vte_input, [:pointer, :pointer, :size_t], :void

    # void tsm_vte_unref(struct tsm_vte *vte);
    attach_function :tsm_vte_unref, [:pointer], :void
  end

  class Vte
    attr_reader :screen

    def initialize(screen)
      @screen = screen
      create_vte
    end

    def input(data)
      if data.is_a?(Array)
        size = data.size
        data = data.pack('C*').force_encoding('utf-8')
      else
        size = data.bytesize
      end

      mem_buf = FFI::MemoryPointer.new(:char, size)
      mem_buf.put_bytes(0, data)
      call(:input, mem_buf, size)
    end

    def release
      TSM::Bindings.tsm_vte_unref(@pointer)
    end

    private

    def create_vte
      vte_ptr = FFI::MemoryPointer.new(:pointer)
      @write_callback = proc { } # make it ivar so it doesn't get gc'ed
      ret = TSM::Bindings.tsm_vte_new(vte_ptr, screen.pointer, @write_callback,
                                      nil, nil, nil)
      raise "Couldn't create screen" unless ret.zero?
      @pointer = vte_ptr.get_pointer(0)
    end

    def call(function, *args)
      TSM::Bindings.public_send(:"tsm_vte_#{function}", @pointer, *args)
    end
  end
end
