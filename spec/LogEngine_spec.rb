require './lib/LogEngine'

describe "LogEngine" do
   before(:each) do
      @log_directory = Dir.tmpdir

      # clean up an existing success log
      @success_log_path = "#{@log_directory}/#{SuccessLog::SUCCESS_LOG_NAME}"
      if File.exist? @success_log_path
         File.delete @success_log_path
      end

      # clean up an existing delete log
      @delete_log_path = "#{@log_directory}/#{McFlyConfig::DELETE_LOG_DEFAULT_NAME}"
      if File.exist? @delete_log_path
         File.delete @delete_log_path
      end

      config = McFlyConfig.new :stream_path, @log_directory
      @delete_queue = DeleteQueue.new
      @log_engine = LogEngine.new config, @delete_queue
   end

   describe "#new" do
      it "initializes queue" do
         expect(@delete_queue).to be

      end
   end

   describe "#queue_delete_stream" do
      context "processes new deletes" do

      end
   end
end
