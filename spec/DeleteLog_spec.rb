require './lib/DeleteLog'

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

      @filename = "123456789"
      @full_path = File.join(@delete_stream_directory, @subdirectory, @filename) 
      add_log_entry @delete_stream_directory, @subdirectory, @filename, get_entry(1)

      @delete_dir = DeleteLog.new @full_path
   end

   after(:each) do
      FileUtils.remove_entry_secure @delete_stream_directory
   end

   describe "#new" do
      it "checks filepath existance" do
         filename = "111111111"
         full_path = File.join(@delete_stream_directory, @subdirectory, filename) 

         expect {
            DeleteLog.new full_path
         }.to raise_error(RuntimeError, "DeleteLog file does not exist")

         # create the file
         add_log_entry @delete_stream_directory, @subdirectory, filename, get_entry(1)

         expect( DeleteLog.new full_path ).to be_an_instance_of(DeleteLog)
      end
   end

   describe ".messages_available?" do
      it "returns true if data left to read" do
         expect(@delete_dir.messages_available?).to be_truthy
      end
      it "returns false at eof" do
         expect(@delete_dir.messages_available?).to be_truthy
         _ = @delete_dir.next_line
         expect(@delete_dir.messages_available?).to be_falsey
      end
   end

   describe ".next_line" do
      it "gets the next line" do
         expect(@delete_dir.next_line).to eql get_entry(1)
         expect(@delete_dir.messages_available?).to be_falsey
         add_log_entry @delete_stream_directory, @subdirectory, @filename, get_entry(0)
         add_log_entry @delete_stream_directory, @subdirectory, @filename, get_entry(0)
         add_log_entry @delete_stream_directory, @subdirectory, @filename, get_entry(1)
         add_log_entry @delete_stream_directory, @subdirectory, @filename, get_entry(2)
         expect(@delete_dir.messages_available?).to be_truthy
         expect(@delete_dir.next_line).to eql get_entry(0)
         expect(@delete_dir.next_line).to eql get_entry(0)
         expect(@delete_dir.next_line).to eql get_entry(1)
         expect(@delete_dir.messages_available?).to be_truthy
         expect(@delete_dir.next_line).to eql get_entry(2)
         expect(@delete_dir.messages_available?).to be_falsey
      end
   end

   describe ".close_fd" do
      it "closes the file descriptor" do
         expect(@delete_dir.messages_available?).to be_truthy
         expect {
            @delete_dir.close_fd
         }.not_to raise_error
         expect(@delete_dir.messages_available?).to be_falsey
      end

   end
end
