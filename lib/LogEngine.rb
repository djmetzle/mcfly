require 'McFlyConfig'
require 'DeleteQueue'
require 'DeleteStream'
require 'EntryParser'

class LogEngine
   def initialize config, delete_queue
      @config = config
      @delete_queue = delete_queue

      @delete_stream = DeleteStream.new config.delete_stream_directory

      @parser = EntryParser.new
   end

   def queue_delete_stream
      unless @delete_stream.messages_available?
         return false
      end

      while next_line = @delete_stream.next_line
         next_entry = @parser.parse next_line
         break if next_entry.nil? # needed?
         @delete_queue.push next_entry.destination, next_entry
      end
      puts "#{Time.now.to_f}: Found new delete log entries!"
      return true
   end
end
