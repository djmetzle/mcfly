$:.unshift File.dirname(__FILE__)
require('McFlyConfig')
require('DeleteQueue')
require('LogEngine')
require('DeleteIssuer')

class McFly
   attr_reader :config, :log_engine, :queue, :issuer

   def initialize mcfly_config, connector_class="MemcachedConnector"
      @config = mcfly_config
      @queue = DeleteQueue.new
      @connector_class = connector_class
   end

   def run one_time=false
      startup
      loop do
         did_work = false
         did_work ||= @log_engine.queue_delete_stream
         did_work ||= @issuer.flush_queues
         sleep 0.1 unless did_work
         break if one_time
      end
   end

   private
   def startup
      @log_engine = LogEngine.new @config, @queue
      @issuer = DeleteIssuer.new @queue, @connector_class
   end
end
