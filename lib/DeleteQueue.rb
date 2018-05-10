class DeleteQueue
   def initialize
      @last_ip = nil
      @hashmap = {}
   end

   def destinations
      return @hashmap.reject { |ip, queue| queue.empty? }.keys
   end

   def push ip, delete
      if @hashmap.key?(ip)
         @hashmap[ip].push delete
         return
      end
      @hashmap[ip] = [ delete ]
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
