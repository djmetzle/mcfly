class Entry
   attr_accessor :entry_str
   attr_accessor :entry_key
   attr_accessor :entry_pool
   attr_accessor :destination
   attr_accessor :mcrouter_port

   def initialize(entry_str:,
                  entry_key:,
                  entry_pool:,
                  destination:,
                  mcrouter_port:
                 )
      @entry_str = entry_str
      @entry_key = entry_key
      @entry_pool = entry_pool
      @destination = destination
      @mcrouter_port = mcrouter_port
   end
end
