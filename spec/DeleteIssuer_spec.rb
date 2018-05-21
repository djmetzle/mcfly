require './lib/DeleteIssuer'

TEST_CONNECTOR = "TestMemcachedConnector"

describe "DeleteIssuer" do
   before(:each) do
      @queue = DeleteQueue.new
      @issuer = DeleteIssuer.new @queue, TEST_CONNECTOR
   end

   describe ".flush_queue" do
      it "succeeds when the queue is empty" do
         expect { @issuer.flush_queues }.not_to raise_error
      end
   end
end
