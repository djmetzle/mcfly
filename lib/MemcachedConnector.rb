require 'McFlyConfig'
require 'memcached'

class MemcachedConnector
   CONNECTION_OPTIONS = {
      show_backtraces: false,
      no_block: false,
      buffer_requests: false,
      noreply: false,
      binary_protocol: false,
   }.freeze

   def self.connect(destination)
      connection = get_connection destination
      return connection ? new(connection, destination) : nil
   end

   def delete_key(key)
      @connection.delete key
      DebugLog.log_delete key, @destination, :NotFound
      return true
   rescue Memcached::NotFound
      DebugLog.log_delete key, @destination, :Deleted
      return true
   # The only untested line in the program! Something awful happened!
   rescue # # rubocop:disable Style/RescueStandardError
      return false
   end

   def self.get_connection(destination)
      connection = Memcached.new destination, CONNECTION_OPTIONS
      # force the lazy connect
      return nil unless connection.stats
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
