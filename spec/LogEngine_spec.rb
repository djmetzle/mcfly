require './lib/LogEngine'

describe "LogEngine" do
   before(:each) do
      @log_directory = Dir.tmpdir

      @delete_queue = DeleteQueue.new

      @config = McFlyConfig.new @log_directory
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
            # STUB
         end
      end
   end

   describe "correctly queues deletes" do
      it "returns true if new deletes" do
       # stub
      end
   end
end
