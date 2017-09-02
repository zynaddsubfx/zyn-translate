require 'json'

lang_dict = Hash.new

translation = "fr.po"
file = File.new(translation)

pairs = []

begin
    line = file.gets
    eng  = ""
    otr  = ""
    while(line)
        if(/^msgid/.match(line))
            eng = /^msgid "(.*)"/.match(line)[1]
        elsif(/^msgstr/.match(line))
            otr = /^msgstr "(.*)"/.match(line)[1]
            pairs << [eng, otr]

            eng = ""
            otr = ""
        end
        line = file.gets
    end
end


pairs.each do |pr|
    if(!pr[0].empty? && !pr[1].empty?)
        #TODO detect collisions
        lang_dict[pr[0]] = pr[1]
    end
end

puts "Total Translation Pairs: #{pairs.length}"
puts "Total Translated:        #{lang_dict.length}"

src_file = "osc-schema.json"
dst_file = "osc-schema-fr.json"

output  = File.open(dst_file, "w+")
json    = File.read(src_file)
obj     = JSON.parse(json)
obj["parameter"].each do |x|
    path      = x["path"]
    shortname = x["shortname"]
    tooltip   = x["tooltip"]
    options   = x["options"]

    if(shortname && lang_dict.include?(shortname))
        x["shortname"] = lang_dict[shortname]
    end

    if(tooltip && lang_dict.include?(tooltip))
        x["tooltip"] = lang_dict[tooltip]
    end

    if(options)
        (0...options.length).each do |i|
            opt = options[i]["value"]
            if(opt && lang_dict.include?(opt))
                options[i]["value"] = lang_dict[opt]
            end
        end
    end
end

output.puts JSON.pretty_generate(obj)
