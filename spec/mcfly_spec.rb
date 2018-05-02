require './lib/mcfly'

describe "McFly" do
   before(:each) do
      @log_directory = Dir.tmpdir
      config = McFlyConfig.new :stream_path, @log_directory
      @mcfly = McFly.new config
   end

	describe "#new" do
      describe "accepts config"
      config = McFlyConfig.new :stream_path, @log_directory
      @mcfly = McFly.new config
	end

	describe "#run" do
      it do
         expect{ @mcfly.run }.not_to raise_error
      end
	end
end
