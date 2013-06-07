require 'ffi'
require "tsm/version"

module TSM
  module Bindings
    extend FFI::Library
    ffi_lib '/home/kill/.local/lib/libtsm.so'
  end
end

require 'tsm/screen'
require 'tsm/vte'
