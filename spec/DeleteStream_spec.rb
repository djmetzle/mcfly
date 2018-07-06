require './lib/DeleteStream'

require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe "DeleteStream" do
   before(:each) do
      @log_directory = Dir.mktmpdir
      @delete_stream = DeleteStream.new @log_directory
   end

   after(:each) do
      FileUtils.remove_entry_secure @log_directory
   end

   describe "#new" do
      it "fails if directory does not exist" do
         expect {
            DeleteStream.new "/WHARGARL"
         }.to raise_error(RuntimeError, "Delete Stream directory does not exist")
         expect(
            DeleteStream.new @log_directory
         ).to be_an_instance_of(DeleteStream)
      end
   end

   describe ".messages_available?" do
      it "returns false with empty directory" do
         expect(@delete_stream.messages_available?).to be_falsey
      end

      it "returns false with empty subdirectories" do
         populate_log_directory @log_directory
         expect(@delete_stream.messages_available?).to be_falsey
         add_to_log_directory @log_directory, "20180102T04-1234567890"
         expect(@delete_stream.messages_available?).to be_falsey
      end
   end

   describe ".next_line" do
      it "returns nil if there is no next_line" do
         expect(@delete_stream.next_line).to be_nil
      end
      it "returns nil if there is no next_line" do
         populate_log_directory @log_directory
         expect(@delete_stream.messages_available?).to be_falsey
         add_to_log_directory @log_directory, "20180102T04-1234567890"
         expect(@delete_stream.messages_available?).to be_falsey
         subdirectory = "20180102T04-1234567890"
         add_log_entry @log_directory, "20180102T01-1234567890", "123456789", get_entry(0)
         add_log_entry @log_directory, "20180102T02-1234567890", "123456789", get_entry(1)
         add_log_entry @log_directory, "20180102T03-1234567890", "123456789", get_entry(2)
         add_log_entry @log_directory, "20180102T04-1234567890", "123456789", get_entry(2)
         expect(@delete_stream.next_line).to eql get_entry(0)
         expect(@delete_stream.next_line).to eql get_entry(1)
         expect(@delete_stream.next_line).to eql get_entry(2)
         expect(@delete_stream.next_line).to eql get_entry(2)
         expect(@delete_stream.next_line).to be_nil
      end
   end
end
