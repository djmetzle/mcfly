require './lib/LogDiff.rb'

describe "#LogDiff" do
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

      @delete_log = DeleteLog.new config
      @success_log = SuccessLog.new config

      @loggdiff = LogDiff.new @delete_log, @success_log
   end

   describe "#next_entry" do
      context "Emits delete log entries" do
         it "reads from the delete log" do
            log_file = File.open(@delete_log_path, "w+")
            log_file.puts "a test string"
            log_file.puts "another test string"
            log_file.puts "yet another test string"
            log_file.close

            expect(@loggdiff.next_entry).to eql "a test string"
            expect(@loggdiff.next_entry).to eql "another test string"
            expect(@loggdiff.next_entry).to eql "yet another test string"

         end
      end
      context "discards deletes marked" do
         it "reads from the delete log" do
            log_file = File.open(@delete_log_path, "w+")
            log_file.puts "test string 1"
            log_file.puts "test string 2"
            log_file.puts "test string 3"
            log_file.puts "test string 4"
            log_file.puts "test string 5"
            log_file.close

            #@success_log.append "test string 1"
            @success_log.append "test string 2"
            @success_log.append "test string 4"

            expect(@loggdiff.next_entry).to eql "test string 1"
            expect(@loggdiff.next_entry).to eql "test string 3"
            expect(@loggdiff.next_entry).to eql "test string 5"
         end
      end
      context "return nil when stream is done" do
         it "returns nil when empty" do
            log_file = File.open(@delete_log_path, "w+")
            log_file.puts "test string 1"
            log_file.puts "test string 2"
            log_file.puts "test string 3"
            log_file.close

            #@success_log.append "test string 1"
            @success_log.append "test string 2"

            expect(@loggdiff.next_entry).to eql "test string 1"
            expect(@loggdiff.next_entry).to eql "test string 3"
            expect(@loggdiff.next_entry).to be_nil
         end
      end
   end
end
