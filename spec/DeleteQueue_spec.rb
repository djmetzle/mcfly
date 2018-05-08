require "./lib/DeleteQueue"

describe "the delete queue" do
   before(:each) do
      @queue = DeleteQueue.new
   end


   context "correct Defaults" do
      it "has empty destinations on init" do
         expect(@queue.destinations.empty?).to be_truthy
      end
   end

   context "queue keys" do
      it "returns queued keys" do
         @queue.push :an_ip, :delete_str
         @queue.push :another_ip, :delete_str
         expect(@queue.destinations).to match_array [:an_ip, :another_ip]
      end
      it "does not return empty keys" do
         @queue.push :an_ip, :delete_str
         @queue.push :another_ip, :delete_str
         @queue.push :yet_another_ip, :delete_str
         @queue.pop :yet_another_ip
         expect(@queue.destinations).to match_array [:an_ip, :another_ip]
      end
   end

   context "allows queueing deletes for ips" do
      it "allows pushing ips" do
         @queue.push :an_ip, :delete_str
      end
      it "allows peeking ips" do
         @queue.push :an_ip, :delete_str
         expect(@queue.peek :an_ip).to eql :delete_str
      end
      it "allows popping ips" do
         @queue.push :an_ip, :delete_str_1
         @queue.push :an_ip, :delete_str_2
         expect(@queue.peek :an_ip).to eql :delete_str_1
         @queue.pop :an_ip
         expect(@queue.peek :an_ip).to eql :delete_str_2
      end
   end

end
