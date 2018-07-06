require 'McFlyConfig'
require 'memcached'

class MemcachedConnector
   def self.connect(destination)
      connection = get_connection destination
      return connection ? new(connection, destination) : nil
   end

   def delete_key(key)
      begin
         @connection.delete key
         DebugLog.log_delete key, @destination, :NotFound
         return true
      rescue Memcached::NotFound
         DebugLog.log_delete key, @destination, :Deleted
         return true
      rescue
         return false
      end
   end

   def self.get_connection(destination)
      options = {
         :show_backtraces => false,
         :no_block => false,
         :buffer_requests => false,
         :noreply => false,
         :binary_protocol => false
      }
      begin
         connection = Memcached.new destination, options
         # force the lazy connect
         return nil unless connection.stats
         return connection
      rescue
         return nil
      end
   end

   private

   def initialize(connection, destination)
      @connection = connection
      @destination = destination
   end
end
