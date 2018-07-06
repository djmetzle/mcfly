require 'DeleteLog'

class DeleteDirectory
   def initialize(delete_stream_directory, subdirectory)
      @delete_stream_directory = delete_stream_directory
      @subdirectory = subdirectory
      @log_files = {}
      check_directory_exists
   end

   def messages_available?
      scan_files
      return @log_files.any? do |_, delete_log|
         delete_log.messages_available?
      end
   end

   def next_line
      unread_files = @log_files.select do |_, delete_log|
         delete_log.messages_available?
      end.values
      return nil if unread_files.empty?
      return unread_files.first.next_line
   end

   private

   def scan_files
      current_files = get_fs_files.sort.map do |file|
         file.split(File::SEPARATOR).last
      end
      new_files = current_files - @log_files.keys
      new_files.each do |filename|
         @log_files[filename] = DeleteLog.new File.join(full_path(), filename)
      end
   end

   def check_directory_exists
      return if Dir.exist? full_path
      raise 'Delete Stream subdirectory does not exist'
   end

   def full_path
      return File.join(@delete_stream_directory, @subdirectory)
   end

   def get_fs_files
      return Dir.glob(File.join(@delete_stream_directory, @subdirectory, '*'))
   end
end
