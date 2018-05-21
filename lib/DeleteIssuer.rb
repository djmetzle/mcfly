require 'DeleteQueue'
require 'EntryParser'

class DeleteIssuer
   def initialize delete_queue, connector_class
      @delete_queue = delete_queue
      @connector_class = connector_class

      require @connector_class
   end

   def flush_queues
      @delete_queue.destinations.each do |destination|
         flush_destination destination
      end
   end

   private
   def flush_destination destination
      connect_str = EntryParser.deserialize_destination destination
      connection = @connector_class.connect connect_str
      return if connector.nil?
      drain_queue destination, connection
   end

   def drain_queue destination, connection
      loop do
         next_entry = @delete_queue.peek destination
         break unless next_entry

         success = connection.delete_key next_entry.key
         @delete_queue.shift destination if success

         break unless success
      end
      return
   end
end
