class DeleteQueue
   def initialize
      @hashmap = {}
   end

   def destinations
      return @hashmap.reject { |_, queue| queue.empty? }.keys
   end

   def push(host_address, delete)
      @hashmap[host_address] ||= []
      @hashmap[host_address].push delete
      return
   end

   def peek(host_address)
      return @hashmap[host_address].first
   end

   def shift(host_address)
      @hashmap[host_address].shift
      return
   end
end
