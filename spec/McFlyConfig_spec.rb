require "./lib/McFlyConfig"

describe McFlyConfig do
   describe "#new" do
      before(:each) do
         @config = McFlyConfig.new :delete_stream_directory
      end

      it "exposes accessors" do
         expect(@config.delete_stream_directory).to eql :delete_stream_directory
         expect(@config.use_v2_log_format).to be true
      end

      context "allow toggling the log format" do
         it "toggles the exposed format property" do
            @config.set_v1_log_format
            expect(@config.use_v2_log_format).to be false
         end
      end
   end
end

