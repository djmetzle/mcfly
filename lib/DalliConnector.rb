require 'McFlyConfig'
require 'dalli'

class DalliConnector
   def self.connect(destination)
      connection = get_connection destination
      return connection ? new(connection, destination) : nil
   end

   def delete_key(key)
      if @connection.delete key
         DebugLog.log_delete key, @destination, :Deleted
      else
         DebugLog.log_delete key, @destination, :NotFound
      end
      return true
   # The only untested line in the program! Something awful happened!
   rescue # # rubocop:disable Style/RescueStandardError
      return false
   end

   def self.get_connection(destination)
      connection = Dalli::Client.new destination
      # force the lazy connect
      connection.alive!
      return connection
   # We expect the connection to Memcached to fail most of the time.
   rescue # # rubocop:disable Style/RescueStandardError
      return nil
   end

   private

   def initialize(connection, destination)
      @connection = connection
      @destination = destination
   end
end
