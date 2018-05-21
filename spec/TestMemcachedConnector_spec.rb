require './lib/TestMemcachedConnector'

describe "TestMemcachedConnector" do
   describe "#connect" do
      it "connects by default" do
         TestMemcachedConnector.set_will_connect true
         TestMemcachedConnector.set_will_delete  true
         expect(TestMemcachedConnector.connect "localhost:12345").to be_an_instance_of(TestMemcachedConnector)
      end

      it "returns nil on 'failed' connect" do
         TestMemcachedConnector.set_will_connect false
         expect(TestMemcachedConnector.connect "localhost:12345").to be_nil
      end
   end

   describe ".delete_key" do
      it "succeeds by default" do
         TestMemcachedConnector.set_will_connect true
         TestMemcachedConnector.set_will_delete  true
         connector = TestMemcachedConnector.connect "localhost:12345"
         expect(connector.delete_key :key).to be_truthy
      end

      it "returns false if delete fails" do
         TestMemcachedConnector.set_will_connect true
         TestMemcachedConnector.set_will_delete  false
         connector = TestMemcachedConnector.connect "localhost:12345"
         expect(connector.delete_key :key).to be_falsey
      end
   end
end
