require './lib/LogEngine'

require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe "LogEngine" do
   before(:each) do
      @log_directory = Dir.mktmpdir

      @delete_queue = DeleteQueue.new

      @config = McFlyConfig.new @log_directory
      @log_engine = LogEngine.new @config, @delete_queue

   end

   after(:each) do
      FileUtils.remove_entry_secure @log_directory
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
