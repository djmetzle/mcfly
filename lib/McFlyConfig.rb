require 'DebugLog'

class McFlyConfig
   attr_reader :delete_stream_directory
   attr_reader :use_v2_log_format

   def initialize(delete_stream_directory)
      @delete_stream_directory = delete_stream_directory
      @use_v2_log_format = true
   end

   def set_v1_log_format
      @use_v2_log_format = false
   end
end
