class McFlyConfig
   attr_reader :stream_path
   attr_reader :log_directory
   attr_reader :delete_log_name
   attr_reader :use_v2_log_format

   DELETE_LOG_DEFAULT_NAME = "failed-deletes.log"

   def initialize stream_path, log_directory
      @stream_path = stream_path
      @log_directory = log_directory
      @delete_log_name = DELETE_LOG_DEFAULT_NAME
      @use_v2_log_format = true
   end

   def set_delete_log_name delete_log_name
      @delete_log_name = delete_log_name
   end

   def set_v1_log_format
      @use_v2_log_format = false
   end
end
