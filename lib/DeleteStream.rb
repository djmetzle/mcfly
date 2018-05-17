class DeleteStream
   def initialize delete_stream_directory 
      @delete_stream_directory = delete_stream_directory
   end

   def messages_available?
      # STUB
      return false
   end

   def next_line
      # STUB
      return nil
   end
end
