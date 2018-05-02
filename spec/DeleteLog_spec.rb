require './lib/McFlyConfig'
require './lib/DeleteLog'

require 'tmpdir'

describe "DeleteLog" do
   before(:each) do
      @log_directory = Dir.tmpdir

      # clean up an existing delete log
      @delete_log_path = "#{@log_directory}/#{McFlyConfig::DELETE_LOG_DEFAULT_NAME}"
      if File.exist? @delete_log_path
         File.delete @delete_log_path
      end

      log_file = File.open(@delete_log_path, "w+")
      log_file.puts "a test string"
      log_file.puts "another test string"
      log_file.close

      config = McFlyConfig.new :stream_path, @log_directory
      @delete_log = DeleteLog.new config
   end

   describe "#new" do
      context "opens existing log file" do
         it "opens existing log" do
            expect(@delete_log.next_line).to eql "a test string"
         end
      end
   end

   describe "#next_line" do
      it "reads entries linearly" do
            expect(@delete_log.next_line).to eql "a test string"
            expect(@delete_log.next_line).to eql "another test string"
      end
      it "returns nil if file doesn't exist" do
         if File.exist? @delete_log_path
            File.delete @delete_log_path
         end
         config = McFlyConfig.new :stream_path, @log_directory
         @delete_log = DeleteLog.new config
         expect(@delete_log.next_line).to be_nil
      end
   end

   describe "#at_end_of_delete_log?" do
      context "exposes delete log eof" do
         it "returns false if not at eof" do
            expect(@delete_log.at_end_of_delete_log?).to be_falsey
         end
         it "returns true if at eof" do
            # empty the delete file
            log_file = File.open(@delete_log_path, "w+")
            log_file.truncate(0)
            log_file.close

            config = McFlyConfig.new :stream_path, @log_directory
            @delete_log = DeleteLog.new config
            expect(@delete_log.at_end_of_delete_log?).to be_truthy
         end
      it "returns true even if file doesn't exist" do
         if File.exist? @delete_log_path
            File.delete @delete_log_path
         end
         config = McFlyConfig.new :stream_path, @log_directory
         @delete_log = DeleteLog.new config
         expect(@delete_log.at_end_of_delete_log?).to be_truthy
      end
      end
   end

end
