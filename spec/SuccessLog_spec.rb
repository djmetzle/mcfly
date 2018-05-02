require './lib/McFlyConfig'
require './lib/SuccessLog'

require 'tmpdir'

describe "SucessLog" do
   before(:each) do
      @log_directory = Dir.tmpdir 
      
      # clean up an existing delete log
      @success_log_path = "#{@log_directory}/#{SuccessLog::SUCCESS_LOG_NAME}"
      if File.exist? @success_log_path
         File.delete @success_log_path
      end

      config = McFlyConfig.new :stream_path, @log_directory
      @success_log = SuccessLog.new config
   end

   describe "#new" do
      context "on initialize" do
         context "unpacks config" do
            it "exposes the success log filename" do 
               expect(@success_log.get_success_log_filename).to eql @success_log_path
            end
         end
      end
   end


   describe "#next_line" do
      it "reads entries linearly" do
         @success_log.append("an entry")
         @success_log.append("another entry")
      end
   end
   describe "#append" do
      it "does not raise error" do
         expect { @success_log.append("an entry") }.not_to raise_error
      end
      it "returns to read position after append" do
         @success_log.append("an entry")
         expect(@success_log.next_line).to eql "an entry"
      end
   end

   describe "#at_end_of_success_log?" do
      context "exposes success log eof" do
         it "returns true if at eof" do
            expect(@success_log.at_end_of_success_log?).to be_truthy
         end
         it "returns false if not at eof" do
            @success_log.append("an entry")
            expect(@success_log.at_end_of_success_log?).to be_falsey
         end
      end
   end

end
