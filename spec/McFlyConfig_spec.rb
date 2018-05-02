require_relative "../lib/McFlyConfig.rb"

describe McFlyConfig do
   describe "#new" do
      before(:each) do
         @config = McFlyConfig.new :stream_path, :log_directory
      end

      it "exposes accessors" do
         expect(@config.stream_path).to eql :stream_path
         expect(@config.log_directory).to eql :log_directory
         expect(@config.use_v2_log_format).to be true
      end

      context 'delete_log_name settings' do
         it "exposes the default log_name" do
            expect(@config.delete_log_name).to be McFlyConfig::DELETE_LOG_DEFAULT_NAME
         end

         it "allows setting the delete_log_name" do
            @config.set_delete_log_name :new_delete_log_name
            expect(@config.delete_log_name).to be :new_delete_log_name
         end
      end

      context "allow toggling the log format" do
         it "toggles the exposed format property" do
            @config.set_v1_log_format
            expect(@config.use_v2_log_format).to be false
         end
      end
   end
end

