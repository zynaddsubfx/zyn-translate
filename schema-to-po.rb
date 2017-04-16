require 'json'

#src_file = ARGV[1]
#dst_file = ARGV[2]

class PoEntry
    def initialize
        @meta = ""
        @text = ""
    end
    attr_accessor :meta
    attr_accessor :text
end

src_file = "osc-schema.json"
dst_file = "zyn_translation-en.po"

output  = File.open(dst_file, "w+")
json    = File.read(src_file)
obj     = JSON.parse(json)
strings = Hash.new
obj["parameter"].each do |x|
    path      = x["path"]
    shortname = x["shortname"]
    tooltip   = x["tooltip"]
    options   = x["options"]

    if(shortname)
        tmp   = strings[shortname]
        tmp ||= PoEntry.new
        tmp.text = shortname
        tmp.meta << "#{path} shortname\n"
        strings[shortname] = tmp
    end

    if(tooltip)
        tmp   = strings[tooltip]
        tmp ||= PoEntry.new
        tmp.text = tooltip
        tmp.meta << "#{path} tooltip\n"
        strings[tooltip] = tmp
    end
    if(options)
        options.each do |o|
            oo = o["value"]
            tmp   = strings[oo]
            tmp ||= PoEntry.new
            tmp.text = oo
            tmp.meta << "#{path} option\n"
            strings[oo] = tmp
        end
    end
    #"shortname"
    #"tooltip"
    #"options" "value"
end

strings.keys.to_a.sort.each do |k|
    po = strings[k]
    po.meta.each_line do |l|
        output.puts "#. #{l}"
    end
    output.puts "msgid #{po.text.inspect}"
    output.puts 'msgstr ""'
    output.puts ""
end
puts "[INFO] total translatable strings: #{strings.length}"

puts "Done..."
