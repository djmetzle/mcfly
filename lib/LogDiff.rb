require 'SuccessLog'
require 'DeleteLog'

class LogDiff
   def initialize delete_log, success_log
      @delete_log = delete_log
      @success_log = success_log
   end

   def next_entry
      current_delete = @delete_log.next_line
      unless current_delete
         return nil
      end
      while current_delete
         unless @success_log.entry_marked? current_delete.chomp
            return current_delete
         end
         current_delete = @delete_log.next_line
      end
      return nil
   end
end
