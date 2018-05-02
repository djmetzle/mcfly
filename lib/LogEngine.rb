class LogEngine
   def initialize config
      @config = config
      @log_directory = config.log_directory
      @delete_log_name = config.delete_log_name
      @use_v2_log_format = config.use_v2_log_format
   end



end
