require 'memcached'

class MemcachedConnector
   def self.connect destination
      connection = self.get_connection destination  
      return connection ? self.new(connection) : nil
   end

   def delete_key key
      begin
         @connection.delete key
         return true
      rescue Memcached::NotFound
         return true
      rescue
         return false
      end
   end

   private
   def initialize connection 
      @connection = connection
   end

   def self.get_connection destination
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
end
