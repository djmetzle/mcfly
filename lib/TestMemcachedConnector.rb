class TestMemcachedConnector
   @@will_connect_setting = true
   @@will_delete_setting = true

   def self.connect(destination)
      @destination = destination
      return @@will_connect_setting ? new : nil
   end

   def delete_key(_)
      return @will_delete
   end

   # Behavior toggles for testing
   def self.set_will_connect(will_connect)
      @@will_connect_setting = will_connect
   end

   def self.set_will_delete(will_delete)
      @@will_delete_setting = will_delete
   end

   private

   # use the factory method please
   def initialize
      set_defaults
   end

   def set_defaults
      @will_connect = @@will_connect_setting
      @will_delete = @@will_delete_setting
   end
end
