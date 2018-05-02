require "./lib/DeleteQueue"

describe "the delete queue" do
   before(:each) do
      @queue = DeleteQueue.new
   end

   context "correct Defaults" do
      it "has nil next_ip on init" do
         expect(@queue.next_ip).to be nil
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

   context "cycles next_ip" do
      it "queues and cycles ips" do
         @queue.push :an_ip, :delete_str
         @queue.push :another_ip, :delete_str
         expect(@queue.next_ip).to eql :an_ip
         expect(@queue.next_ip).to eql :another_ip
         expect(@queue.next_ip).to eql :an_ip
      end
   end
end
