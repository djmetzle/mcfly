class DeleteQueue
   def initialize
      @last_ip = nil
      @hashmap = {}
   end

   def next_ip
      if @last_ip.nil?
         return @last_ip = @hashmap.keys.first
      end
      keys = @hashmap.keys
      cur_index = keys.index(@last_ip)
      next_index = (cur_index + 1) % keys.length
      return @last_ip = keys[next_index]
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

   def pop ip
      @hashmap[ip].shift
      return
   end
end
