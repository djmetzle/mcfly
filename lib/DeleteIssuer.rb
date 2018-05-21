require 'DeleteQueue'
require 'EntryParser'

class DeleteIssuer
   def initialize delete_queue, connector_class
      @delete_queue = delete_queue
      @connector_class = connector_class

      require @connector_class
   end

   def flush_queue

   end
end
