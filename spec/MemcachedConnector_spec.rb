require './lib/MemcachedConnector'

describe "MemcachedConnector" do
   describe "#connect" do
      it "returns nil on fail" do
         expect(MemcachedConnector.connect "1.1.1.1:9999").to be_nil
      end
      it "return new self" do
         expect(MemcachedConnector.connect "127.0.0.1:11211").to be_an_instance_of(MemcachedConnector)
      end
   end

   describe ".delete_key" do
      let(:connector) { MemcachedConnector.connect "127.0.0.1:11211" }
      let(:connection) { connector.instance_variable_get(:@connection) }

      it "succeeds with key" do
         connection.set "some_key", "some_value"
         expect(connector.delete_key "some_key").to be_truthy
      end

      it "succeeds even without key" do
         connection.flush
         expect(connector.delete_key "some_key").to be_truthy
      end
   end
end
