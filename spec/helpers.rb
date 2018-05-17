module Helpers
   def populate_log_directory dir
      # make some test data for the DeleteStream
      subdirs = [
         "20180102T01-1234567890",
         "20180102T02-1234567890",
         "20180102T03-1234567890",
      ]

      subdirs.each do |subdir|
         mksubdir dir, subdir
      end
   end

   def add_to_log_directory dir, subdir
      mksubdir dir, subdir
   end

   def add_log_entry dir, subdir, filename, entry
      open(File.join(dir, subdir, filename), 'a') { |f|
        f.puts entry
      }
   end

   def get_entry n
      entries = [
         '["AS2.0",1410611229.747,"C",{"k":"A","p":"A","h":"[127.0.0.1]:5001","f":"5000"}]',
         '["AS2.0",1234567890.123,"C",{"k":"B","p":"A","h":"[1.2.3.4]:11211","f":"5000"}]',
         '["AS2.0",1248163264.123,"C",{"k":"C","p":"A","h":"[127.0.0.1]:5001","f":"5000"}]',
      ]
      return entries[n]
   end

   private
   def mksubdir dir, subdir
      Dir.mkdir(File.join(dir, subdir))
   end
end
