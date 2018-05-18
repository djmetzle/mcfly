require './lib/LogEngine'

require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe "LogEngine" do
   def add_entries_to_logs
      populate_log_directory @log_directory
      add_to_log_directory @log_directory, "20180102T04-1234567890"
      add_log_entry @log_directory, "20180102T01-1234567890", "123456789", get_entry(0)
      add_log_entry @log_directory, "20180102T02-1234567890", "123456789", get_entry(1)
      add_log_entry @log_directory, "20180102T03-1234567890", "123456789", get_entry(2)
      add_log_entry @log_directory, "20180102T04-1234567890", "123456789", get_entry(2)
   end

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
            expect(@log_engine.queue_delete_stream).to be_falsey
            add_entries_to_logs
            expect(@log_engine.queue_delete_stream).to be_truthy
         end
      end
   end
end
