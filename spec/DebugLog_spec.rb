require './lib/DebugLog'

describe "DebugLog" do
   describe "#set_log_level" do
      it "accepts log levels" do
         expect{ DebugLog.set_log_level :debug }.not_to raise_error ArgumentError
         expect{ DebugLog.set_log_level :notice }.not_to raise_error ArgumentError
         expect{ DebugLog.set_log_level :silent }.not_to raise_error ArgumentError
      end
      it "throws on bad log level" do
         expect{ DebugLog.set_log_level :asdlfk }.to raise_error ArgumentError
         expect{ DebugLog.set_log_level :whargarl }.to raise_error ArgumentError
         expect{ DebugLog.set_log_level "debug" }.to raise_error ArgumentError
      end
   end

   describe "#log_start" do
      it "logs at notice" do
         DebugLog.set_log_level :debug
         expect{ DebugLog.log_start }.to output(/Start/).to_stdout
         DebugLog.set_log_level :notice
         expect{ DebugLog.log_start }.to output(/Start/).to_stdout
         DebugLog.set_log_level :silent
         expect{ DebugLog.log_start }.not_to output(/Start/).to_stdout
      end
   end

   describe "#log_new_deletes" do
      it "logs at notice" do
         DebugLog.set_log_level :debug
         expect{ DebugLog.log_new_deletes }.to output(/Found/).to_stdout
         DebugLog.set_log_level :notice
         expect{ DebugLog.log_new_deletes }.to output(/Found/).to_stdout
         DebugLog.set_log_level :silent
         expect{ DebugLog.log_new_deletes }.not_to output(/Found/).to_stdout
      end
   end

   describe "#log_delete" do
      it "logs at notice" do
         DebugLog.set_log_level :debug
         expect{ DebugLog.log_delete "KEY", "DEST", :Deleted }.to output(/Key/).to_stdout
         DebugLog.set_log_level :notice
         expect{ DebugLog.log_delete "KEY", "DEST", :Deleted }.to output(/Key/).to_stdout
         DebugLog.set_log_level :silent
         expect{ DebugLog.log_delete "KEY", "DEST", :Deleted }.not_to output(/Key/).to_stdout
      end
   end
end
