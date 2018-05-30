class DeleteQueue
   def initialize
      @hashmap = {}
   end

   def destinations
      return @hashmap.reject { |_, queue| queue.empty? }.keys
   end

   def push ip, delete
      @hashmap[ip] ||= []
      @hashmap[ip].push delete
      return
   end

   def peek ip
      return @hashmap[ip].first
   end

   def shift ip
      @hashmap[ip].shift
      return
   end
end
