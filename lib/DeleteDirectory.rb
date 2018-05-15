require 'McFlyConfig'

class DeleteLog
   def initialize delete_stream_directory
      @delete_directory = delete_directory
      check_delete_directory 
   end

   def next_line

   end
   
   def at_end_of_log?

   end

   private
   def get_sub_directories_list
      return Dir.glob("#{@delete_directory}/*/") 
   end

   def get_latest_directory
      sub_dirs = get_sub_directories_list
      return sub_dirs.sort.last
   end

   def check_delete_directory
      unless Dir.exist? @delete_directory
         abort "Delete Stream directory doesn't exist"
      end
   end

# OLD
#   def next_line
#      @delete_log_file = get_delete_log_file
#      unless @delete_log_file
#         return nil
#      end
#      line = @delete_log_file.gets
#      return line ? line.chomp : nil
#   end
#
#   def at_end_of_delete_log?
#      @delete_log_file = get_delete_log_file
#      unless @delete_log_file
#         return true
#      end
#      return @delete_log_file.eof?
#   end
#
#   private
#   def get_delete_log_file
#      if @delete_log_file
#         return @delete_log_file
#      end
#
#      begin
#         return File.open(get_delete_log_path, "r+")
#      rescue
#         return nil
#      end
#   end
#
#   def get_delete_log_path
#      return "#{@config.log_directory}/#{@config.delete_log_name}"
#   end


end

