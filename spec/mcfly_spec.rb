require './lib/mcfly'

require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe "McFly" do
   def add_entries_to_logs
      populate_log_directory @log_directory
      add_to_log_directory @log_directory, "20180102T04-1234567890"
      add_log_entry @log_directory, "20180102T01-1234567890", "123456789", get_entry(0)
      add_log_entry @log_directory, "20180102T02-1234567890", "123456789", get_entry(1)
      add_log_entry @log_directory, "20180102T03-1234567890", "123456789", get_entry(2)
      add_log_entry @log_directory, "20180102T04-1234567890", "123456789", get_entry(2)
   end

   before(:each) do
      @log_directory = Dir.mktmpdir

      config = McFlyConfig.new @log_directory
      @mcfly = McFly.new config, 'TestMemcachedConnector'
   end

	describe "#new" do
      describe "accepts config"
      config = McFlyConfig.new @log_directory
      @mcfly = McFly.new config, 'TestMemcachedConnector'
	end

	describe "#run" do
      it do
         add_entries_to_logs
         expect{ @mcfly.run true }.not_to raise_error
      end
	end
end
