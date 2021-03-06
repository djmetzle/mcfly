require 'DeleteDirectory'

class DeleteStream
   def initialize(delete_stream_directory)
      @delete_stream_directory = delete_stream_directory
      @subdirectories = {}
      check_directory_exists
   end

   def messages_available?
      update_subdirectories
      return @subdirectories.any? do |_, subdir|
         subdir.messages_available?
      end
   end

   def next_line
      unread_dirs = @subdirectories.select do |_, subdir|
         subdir.messages_available?
      end.values
      return nil if unread_dirs.empty?
      return unread_dirs.first.next_line
   end

   private

   def update_subdirectories
      current_directories = collect_fs_subdirectories.sort.map do |subdir|
         subdir.split(File::SEPARATOR).last
      end
      new_directories = current_directories - @subdirectories.keys
      new_directories.each do |subdir|
         @subdirectories[subdir] =
            DeleteDirectory.new @delete_stream_directory, subdir
      end
   end

   def collect_fs_subdirectories
      return Dir.glob(File.join(@delete_stream_directory, '*/'))
   end

   def check_directory_exists
      return if Dir.exist? @delete_stream_directory
      raise 'Delete Stream directory does not exist'
   end
end
