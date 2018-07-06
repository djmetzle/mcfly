require 'Entry'

require 'json'

class EntryParser
   FORMAT_LOOKUP = {
      'AS1.0' => 1,
      'AS2.0' => 2,
   }.freeze

   def parse(entry)
      raise ArgumentError unless entry.is_a? String

      json_object = json_parse_entry entry

      raise 'Bad JSON Entry provided' unless json_object

      version = get_log_version json_object

      return parse_entry version, json_object, entry
   end

   def self.deserialize_destination(destination_string)
      dest_matches = destination_string.match(/^\[(\S+)\]:(\d+)$/)
      return nil unless dest_matches

      dest_host, dest_port = dest_matches.captures
      return nil unless dest_host && dest_port

      return "#{dest_host}:#{dest_port}"
   end

   private

   def json_parse_entry(entry_str)
      return JSON.parse entry_str
   rescue JSON::ParserError
      return nil
   end

   def get_log_version(json_object)
      raise 'Bad JSON Entry provided' unless json_object.is_a? Array

      version_str = json_object[0]

      raise 'Bad JSON Entry provided' unless version_str
      raise 'Bad JSON Entry provided' unless FORMAT_LOOKUP.key? version_str

      return FORMAT_LOOKUP[version_str]
   end

   def parse_entry(version, json_object, entry_str)
      case version
      when 2
         return parse_v2_entry json_object, entry_str
      when 1
         return parse_v1_entry json_object, entry_str
      end
   end

   def parse_v2_entry(json_object, entry_str)
      entry_obj = json_object[3]

      entry_key = entry_obj['k']
      entry_pool = entry_obj['p']
      destination = entry_obj['h']
      mcrouter_port = entry_obj['f']

      return Entry.new(entry_str: entry_str,
                       entry_key: entry_key,
                       entry_pool: entry_pool,
                       destination: destination,
                       mcrouter_port: mcrouter_port)
   end

   def parse_v1_entry(json_object, entry_str)
      # TODO: STUB
      # We don't actually _need_ to support v1 format
   end
end
