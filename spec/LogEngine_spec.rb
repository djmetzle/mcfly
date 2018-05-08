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

      @config = McFlyConfig.new :stream_path, @log_directory
      @delete_queue = DeleteQueue.new
      @log_engine = LogEngine.new @config, @delete_queue

      @v2_test_entry_1 = '["AS2.0",1410611229.747,"C",{"k":"key","p":"A","h":"[127.0.0.1]:5001","f":"5000"}]'
      @v2_test_entry_2 = '["AS2.0",1234567890.123,"C",{"k":"key","p":"A","h":"[1.2.3.4]:11211","f":"5000"}]'
   end

   describe "#new" do
      it "initializes queue" do
         expect(@delete_queue).to be
      end
   end

   describe "#queue_delete_stream" do
      context "processes new deletes" do
         it "returns false if there are no new deletes" do
            expect(@log_engine.queue_delete_stream).to be_falsey
         end
         it "returns true if new deletes" do
            log_file = File.open(@delete_log_path, "w+")
            log_file.puts @v2_test_entry_1
            log_file.puts @v2_test_entry_2
            log_file.close

            expect(@log_engine.queue_delete_stream).to be_truthy
         end
      end
   end

   describe "#mark_success" do
      it "adds entry to successlog" do
         log_file = File.open(@delete_log_path, "w+")
         log_file.puts @v2_test_entry_1
         log_file.puts @v2_test_entry_2
         log_file.close

         expect{@log_engine.queue_delete_stream}.not_to raise_error

         entry_1 = @delete_queue.peek "[127.0.0.1]:5001"
         entry_2 = @delete_queue.peek "[1.2.3.4]:11211"

         expect{@log_engine.mark_success entry_1}.not_to raise_error
         expect{@log_engine.mark_success entry_2}.not_to raise_error

         success_log = SuccessLog.new @config
         expect(success_log.next_line).to eql @v2_test_entry_1
         expect(success_log.next_line).to eql @v2_test_entry_2
      end
   end

   describe "correctly queues deletes" do
      it "returns true if new deletes" do
         log_file = File.open(@delete_log_path, "w+")
         log_file.puts @v2_test_entry_1
         log_file.puts @v2_test_entry_2
         log_file.close

         expect{@log_engine.queue_delete_stream}.not_to raise_error

         entry_1 = @delete_queue.peek "[127.0.0.1]:5001"
         entry_2 = @delete_queue.peek "[1.2.3.4]:11211"

         expect(entry_1.entry_str).to eql @v2_test_entry_1
         expect(entry_2.entry_str).to eql @v2_test_entry_2
      end
   end
end
