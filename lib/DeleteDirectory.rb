require 'DeleteLog'

class DeleteDirectory
   def initialize delete_stream_directory, subdirectory
      @delete_stream_directory = delete_stream_directory
      @subdirectory = subdirectory
      @log_files = {}
      check_directory_exists
   end

   def messages_available?
      scan_files
      return @log_files.any? { |_, delete_log|
         delete_log.messages_available?
      }
   end

   def next_line
      unread_files = @log_files.select { |_, delete_log|
         delete_log.messages_available?
      }.values
      return nil if unread_files.empty?
      return unread_files.first.next_line
   end

   private
   def scan_files
      current_files = get_fs_files.sort.map { |file|
         file.split(File::SEPARATOR).last
      }
      new_files = current_files - @log_files.keys
      new_files.each { |filename|
         @log_files[filename] = DeleteLog.new File.join(full_path(), filename)
      }
   end

   def check_directory_exists
      unless Dir.exist? full_path
         raise "Delete Stream subdirectory doesn't exist"
      end
   end

   def full_path
      return File.join(@delete_stream_directory, @subdirectory)
   end

   def get_fs_files
      return Dir.glob(File.join(@delete_stream_directory, @subdirectory, "*"))
   end
end
