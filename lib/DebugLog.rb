class DebugLog
   LOG_LEVELS = [:silent, :notice, :debug].freeze

   # default
   @@log_level = :notice

   class << self
      def set_log_level(log_level)
         raise ArgumentError unless LOG_LEVELS.include?(log_level)
         @@log_level = log_level
      end

      def log_start
         return unless should_log? :notice
         puts 'Start McFly'
      end

      def log_new_deletes
         return unless should_log? :notice
         puts 'Found new delete log entries!'
      end

      def log_delete(key, destination, found)
         return unless should_log? :notice
         puts "Key '#{key}' #{found} from '#{destination}'"
      end

      private

      def should_log?(min_level)
         current_level_index = LOG_LEVELS.find_index(@@log_level)
         min_level_index = LOG_LEVELS.find_index(min_level)
         return min_level_index <= current_level_index
      end
   end
end
