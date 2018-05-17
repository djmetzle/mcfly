require './lib/McFlyConfig'
require './lib/DeleteDirectory'

require 'tmpdir'

describe "DeleteDirectory" do
   before(:each) do
      @deletes_directory = Dir.tmpdir
   end

   describe "#new" do
      it "takes the delete directory" do
         expect { DeleteDirectory.new @deletes_directory }.not_to raise_error
      end
      it "fail if the delete directory does not exist" do
         expect { DeleteDirectory.new "/whargarl" }.to raise_error
      end
   end

   

end
