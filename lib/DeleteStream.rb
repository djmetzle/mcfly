require 'DeleteDirectory'

class DeleteStream
   def initialize delete_stream_directory
      @delete_stream_directory = delete_stream_directory
      @subdirectories = {}
      check_directory_exists
   end

   def messages_available?
      update_subdirectories
      return @subdirectories.any? { |_, subdir|
         subdir.messages_available?
      }
   end

   def next_line
      unread_dirs = @subdirectories.select { |_, subdir|
         subdir.messages_available?
      }.values
      return nil if unread_dirs.empty?
      return unread_dirs.first.next_line
   end

   private
   def update_subdirectories
      current_directories = get_fs_subdirectories.sort.map { |subdir|
         subdir.split(File::SEPARATOR).last
      }
      new_directories = current_directories - @subdirectories.keys
      new_directories.each { |subdir|
         @subdirectories[subdir] =
               DeleteDirectory.new @delete_stream_directory, subdir
      }
   end

   def get_fs_subdirectories
      return Dir.glob(File.join(@delete_stream_directory, '*/'))
   end

   def check_directory_exists
      unless Dir.exist? @delete_stream_directory
         raise 'Delete Stream directory does not exist'
      end
   end
end
