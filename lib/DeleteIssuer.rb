require 'DeleteQueue'

class DeleteIssuer
   def initialize delete_queue, log_engine
      @delete_queue = delete_queue
      @log_engine = log_engine
   end
end
