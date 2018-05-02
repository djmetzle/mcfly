class SuccessLog
   SUCCESS_LOG_NAME = "success.log"

   def initialize config
      @config = config
      @log_directory = config.log_directory
      @success_log_file = get_success_log_file
   end

   def next_line
      return @success_log_file.gets.chomp
   end

   def at_end_of_success_log?
      return @success_log_file.eof?
   end

   def append entry
      current_read_pos = @success_log_file.pos
      @success_log_file.puts entry.chomp
      @success_log_file.pos = current_read_pos
   end

   def get_success_log_filename
      return "#{@log_directory}/#{SUCCESS_LOG_NAME}"
   end

   private
   def get_success_log_file
      unless File.exist? get_success_log_filename
         return File.new(get_success_log_filename, "w+")
      end
      return File.open(get_success_log_filename, "r+")
   end
end
