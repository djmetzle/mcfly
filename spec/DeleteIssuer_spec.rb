require './lib/DeleteIssuer'
require './lib/TestMemcachedConnector'
require './lib/EntryParser'

require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe "DeleteIssuer" do
   before(:each) do
      @queue = DeleteQueue.new
      @issuer = DeleteIssuer.new @queue, TestMemcachedConnector
   end

   describe ".flush_queue" do
      it "succeeds when the queue is empty" do
         expect { @issuer.flush_queues }.not_to raise_error
      end

      it "succeeds when the queue is not empty" do
         # use default test connector settings
         TestMemcachedConnector.set_will_connect true
         TestMemcachedConnector.set_will_delete true

         destination = 'localhost:11211'
         parser = EntryParser.new

         @queue.push destination, parser.parse(get_entry(0))
         @queue.push destination, parser.parse(get_entry(1))
         @queue.push destination, parser.parse(get_entry(2))

         expect { @issuer.flush_queues }.not_to raise_error
      end
   end
end
