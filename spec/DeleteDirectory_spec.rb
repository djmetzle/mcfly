require './lib/DeleteDirectory'

require 'tmpdir'

require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe "DeleteDirectory" do
   before(:each) do
      @delete_stream_directory = Dir.mktmpdir
      @subdirectory = "20180102T04-1234567890"
      add_to_log_directory @delete_stream_directory, @subdirectory
      @delete_dir = DeleteDirectory.new @delete_stream_directory, @subdirectory
   end

   after(:each) do
      FileUtils.remove_entry_secure @delete_stream_directory
   end

   describe "#new" do
      it "takes the delete directory" do
         add_to_log_directory @delete_stream_directory, "WHARGARL"
         expect(
            DeleteDirectory.new @delete_stream_directory, "WHARGARL"
         ).to be_an_instance_of(DeleteDirectory)
      end
      it "fail when delete directory does not exist" do
         expect {
            DeleteDirectory.new "/whargarl", "wat"
         }.to raise_error RuntimeError
         expect {
            DeleteDirectory.new @delete_stream_directory, "wat"
         }.to raise_error RuntimeError
      end
   end

   describe "messages_available?" do
      it "returns false with empty subdir" do
         expect(@delete_dir.messages_available?).to be_falsey
      end
      it "picks up new files" do
         add_log_entry @delete_stream_directory, @subdirectory, "123456789", get_entry(1)
         expect(@delete_dir.messages_available?).to be_truthy
      end
   end

   describe "next_line" do
      it "returns nil if no new messages are available" do
         expect(@delete_dir.next_line).to be_nil
      end
      it "returns nil if no new messages are available" do
         expect(@delete_dir.messages_available?).to be_falsey
         add_log_entry @delete_stream_directory, @subdirectory, "123456789", get_entry(1)
         expect(@delete_dir.messages_available?).to be_truthy
         expect(@delete_dir.next_line).to eql get_entry(1)
      end
   end
end
