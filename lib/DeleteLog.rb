class DeleteLog
   def initialize(filepath)
      @filepath = filepath
      check_file_exists
      open_fd
   end

   def messages_available?
      return false unless @fd
      return !@fd.eof?
   end

   def next_line
      return false unless @fd
      return @fd.gets.chomp
   end

   def close_fd
      @fd.close if @fd
      @fd = nil if @fd.closed?
   end

   private

   def check_file_exists
      return if File.exist? @filepath
      raise 'DeleteLog file does not exist'
   end

   def open_fd
      # STUB
      @fd = open(@filepath, 'r')
   end
end
