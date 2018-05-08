require './lib/Entry'

describe "Entry" do
   describe "#new" do
      it "accepts named arguments" do
         expect { Entry.new(
                              entry_str: "string",
                              entry_key: "key",
                              entry_pool: "pool",
                              destination: "dest",
                              mcrouter_port: "11211"
                           ) }.not_to raise_error
      end

      it "exposes properties" do
         @entry = Entry.new(
                              entry_str: "string",
                              entry_key: "key",
                              entry_pool: "pool",
                              destination: "dest",
                              mcrouter_port: 11211
                           )
         expect(@entry.entry_str).to eql "string"
         expect(@entry.entry_key).to eql "key"
         expect(@entry.entry_pool).to eql "pool"
         expect(@entry.destination).to eql "dest"
         expect(@entry.mcrouter_port).to eql 11211
      end
   end
end
