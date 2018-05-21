class TestMemcachedConnector
   def initialize

   end

   def connect destination
      set_defaults
      @destination = destination
      return @will_connect
   end

   def delete key
     return @will_delete
   end

   # Behavior toggles for testing
   def set_will_connect will_connect
      @will_connect = will_connect
   end

   def set_will_delete will_delete
      @will_delete = will_delete
   end

   private
   def set_defaults
      @will_connect = true
      @will_delete = true
   end
end
