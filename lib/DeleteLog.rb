require 'McFlyConfig'

class DeleteLog
   def initialize config
      @config = config
   end

   def next_line
      @delete_log_file = get_delete_log_file
      unless @delete_log_file
         return nil
      end
      line = @delete_log_file.gets
      return line ? line.chomp : nil
   end

   def at_end_of_delete_log?
      @delete_log_file = get_delete_log_file
      unless @delete_log_file
         return true
      end
      return @delete_log_file.eof?
   end

   private
   def get_delete_log_file
      if @delete_log_file
         return @delete_log_file
      end

      begin
         return File.open(get_delete_log_path, "r+")
      rescue
         return nil
      end
   end

   def get_delete_log_path
      return "#{@config.log_directory}/#{@config.delete_log_name}"
   end


end

