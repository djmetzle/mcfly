class DeleteStreamDirectory
   def initialize delete_directory
      @delete_directory = delete_directory
   end

   def get_latest_directory
      sub_dirs = get_sub_directories_list
      return sub_dirs.sort.last
   end

   def get_sub_directories_list
      return Dir.glob("#{@delete_directory}/*/") 
   end

   private
   def check_delete_directory
      unless Dir.exist? @delete_directory
         abort "Delete Stream directory doesn't exist"
      end
   end
end
