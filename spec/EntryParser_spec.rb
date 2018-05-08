require './lib/EntryParser'

describe "EntryParser" do
   before(:each) do
      @parser = EntryParser.new

      @v1_test_entry_1 = '["AS1.0",1410611165.754,"C",["127.0.0.1",5001,"delete key\r\n"]]'
      @v1_test_entry_2 = '["AS1.0",1410611165.754,"C",["127.0.0.1",5001,"delete key\r\n"]]'

      @v2_test_entry_1 = '["AS2.0",1410611229.747,"C",{"k":"key","p":"A","h":"[127.0.0.1]:5001","f":"5000"}]'
      @v2_test_entry_2 = '["AS2.0",1234567890.123,"C",{"k":"key","p":"A","h":"[1.2.3.4]:11211","f":"5000"}]'
   end

   describe "#parse" do
      context "accepts a string entry" do
         it "raises on bad arguments" do
            expect{ @parser.parse :a_Symbol }.to raise_error ArgumentError
         end
      end

      context "JSON decodes that string" do
         it "json parses v1 log format" do
            expect{ @parser.parse @v1_test_entry_1 }.not_to raise_error
            expect{ @parser.parse @v1_test_entry_2 }.not_to raise_error
         end
         it "json parses v2 log format" do
            expect{ @parser.parse @v2_test_entry_1 }.not_to raise_error
            expect{ @parser.parse @v2_test_entry_2 }.not_to raise_error
         end
         it "throws on bad entries" do
            expect{ @parser.parse "{[invalid json," }.to raise_error RuntimeError
            expect{ @parser.parse '{}' }.to raise_error RuntimeError
            expect{ @parser.parse '[]' }.to raise_error RuntimeError
         end
         it "throws on bad version" do
            expect{ @parser.parse '["invalid version"]' }.to raise_error RuntimeError
         end
      end

      context "understands v2 log format" do
         it "has correct destination" do
            entry = @parser.parse @v2_test_entry_1
            expect(entry.destination).to eql "[127.0.0.1]:5001"
            entry = @parser.parse @v2_test_entry_2
            expect(entry.destination).to eql "[1.2.3.4]:11211"
         end
      end

      context "understands v1 log format" do
         # maybe this stays stubbed?
      end

      context "emits an Entry" do
         it "turns v2 logs into Entrys" do
            expect(@parser.parse @v2_test_entry_1).to be_instance_of(Entry)
            expect(@parser.parse @v2_test_entry_2).to be_instance_of(Entry)
         end
         it "turns v1 logs into Entrys" do
            # STUBBY Goodness
            #expect(@parser.parse @v1_test_entry_1).to be_instance_of(Entry)
            #expect(@parser.parse @v1_test_entry_2).to be_instance_of(Entry)
         end

      end
   end

end
