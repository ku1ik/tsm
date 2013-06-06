require 'ffi'
require "tsm/version"

module TSM
  module Bindings
    extend FFI::Library
    ffi_lib '/home/kill/.local/lib/libtsm.so'

    typedef :pointer, :ivar

    callback :log_submit_callback, [:pointer, :string, :int, :string, :string, :uint, :string, :ivar], :void
  end
end

require 'tsm/screen'
require 'tsm/vte'
