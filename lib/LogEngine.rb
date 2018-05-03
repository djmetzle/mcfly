require 'McFlyConfig'
require 'DeleteQueue'
require 'SuccessLog'
require 'DeleteLog'

class LogEngine
   def initialize config, delete_queue
      @config = config
      @delete_queue = delete_queue

      @success_log = SuccessLog.new config
      @delete_log = DeleteLog.new config
   end

   def queue_delete_stream

   end

   def mark_success entry


   end
end
