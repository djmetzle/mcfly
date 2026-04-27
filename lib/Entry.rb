# frozen_string_literal: true

class Entry
   attr_accessor :entry_str, :entry_key, :entry_pool, :destination, :mcrouter_port

   def initialize(entry_str:,
                  entry_key:,
                  entry_pool:,
                  destination:,
                  mcrouter_port:)
      @entry_str = entry_str
      @entry_key = entry_key
      @entry_pool = entry_pool
      @destination = destination
      @mcrouter_port = mcrouter_port
   end
end
