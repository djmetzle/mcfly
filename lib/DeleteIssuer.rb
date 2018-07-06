require 'DeleteQueue'
require 'EntryParser'

class DeleteIssuer
   def initialize(delete_queue, connector_class)
      @delete_queue = delete_queue

      require connector_class
      @connector_class = eval(connector_class)
   end

   def flush_queues
      did_work = false
      @delete_queue.destinations.each do |destination|
         did_work ||= flush_destination destination
      end
      return did_work
   end

   private

   def flush_destination(destination)
      connect_str = EntryParser.deserialize_destination destination
      connection = @connector_class.connect connect_str
      return false if connection.nil?
      return drain_queue destination, connection
   end

   def drain_queue(destination, connection)
      did_work = false
      loop do
         next_entry = @delete_queue.peek destination
         break unless next_entry

         success = connection.delete_key next_entry.entry_key
         @delete_queue.shift destination if success

         break unless success
         did_work = true
      end
      return did_work
   end
end
