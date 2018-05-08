require 'McFlyConfig'
require 'DeleteQueue'
require 'SuccessLog'
require 'DeleteLog'
require 'EntryParser'

class LogEngine
   def initialize config, delete_queue
      @config = config
      @delete_queue = delete_queue

      @success_log = SuccessLog.new config
      @delete_log = DeleteLog.new config

      @parser = EntryParser.new
   end

   def queue_delete_stream
      if @delete_log.at_end_of_delete_log?
         return false
      end

      while next_line = @delete_log.next_line
         next_entry = @parser.parse next_line
         break if next_entry.nil?
         @delete_queue.push next_entry.destination, next_entry
      end

      return true
   end

   def mark_success entry
      @success_log.append entry
   end
end
