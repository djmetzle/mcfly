$:.unshift File.dirname(__FILE__)
require('McFlyConfig')
require('DeleteQueue')
require('LogEngine')

class McFly
   def initialize(mcfly_config)
      @config = mcfly_config
      @queue = DeleteQueue.new
   end

   def run
      startup
      p "Do The Thing"
   end

   private
   def startup
      p "Run startup"
      @log_engine = LogEngine.new @config, @queue
   end
end
