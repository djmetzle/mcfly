class SuccessLog
   SUCCESS_LOG_NAME = "success.log"

   def initialize config
      @config = config
      @log_directory = config.log_directory
      @success_log_file = get_success_log_file
   end

   def next_line
      line = @success_log_file.gets
      return line ? line.chomp : nil
   end

   def at_end_of_success_log?
      return @success_log_file.eof?
   end

   def entry_marked? entry
      current_read_pos = @success_log_file.pos
      found = false

      @success_log_file.rewind
      match = @success_log_file.each_line.lazy.find { |line|
         line.chomp.eql? entry
      }
      if match
         found = true
      end

      @success_log_file.pos = current_read_pos
      return found
   end

   def append entry
      current_read_pos = @success_log_file.pos
      @success_log_file.seek(0, IO::SEEK_END)
      @success_log_file.puts "#{entry.chomp}\n"
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
