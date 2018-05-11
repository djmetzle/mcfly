require './lib/DeleteIssuer'

describe "DeleteIssuer" do
   before(:each) do

   end
   describe "#new" do
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

      @config = McFlyConfig.new :stream_path, @log_directory
      @delete_queue = DeleteQueue.new
      @log_engine = LogEngine.new @config, @delete_queue

      @issuer = DeleteIssuer.new @delete_queue, @log_engine

      @v2_test_entry_1 = '["AS2.0",1410611229.747,"C",{"k":"key","p":"A","h":"[127.0.0.1]:5001","f":"5000"}]'
      @v2_test_entry_2 = '["AS2.0",1234567890.123,"C",{"k":"key","p":"A","h":"[1.2.3.4]:11211","f":"5000"}]'
   end


   describe ".flush_delete_queue" do
      it "returns false if no destinations" do

      end
      it "returns false if no connections are made" do

      end
   end
end
