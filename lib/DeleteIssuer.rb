require 'LogEngine'
require 'DeleteQueue'

class DeleteIssuer
   def initialize delete_queue, log_engine, connection_class
      @delete_queue = delete_queue
      @log_engine = log_engine
      @connection_class = connection_class
   end

   def flush_delete_queue
      did_work = false

      destinations = @delete_queue.destinations
      return did_work if destinations.empty? # false

      destinations.each do |destination|
         connection = get_connection destination
         next unless connection

         did_work = true

         flush_queue connection, destination
      end

      return did_work
   end

   private
   def get_connection destination
      # Try connecting to Memcached server `destination`.

      return nil
   end

   def flush_queue connection, destination
      while not @delete_queue.empty? destination
         # don't get stuck in while loop
         return
      end
   end
end
