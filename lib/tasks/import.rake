namespace :import do

  desc "Import MemeTypes from a JSON file: usage: import:meme_types[filename.json]"
  task :memes, [:filename] => :environment do |t, args|
    new_memes = {}
    require 'json'
    filename = args[:filename]
    raise Exception unless File.exists?(filename)
    puts "Reading from #{filename}..."
    start_memetype_count = MemeType.count
    start_meme_count = Meme.count
    File.foreach(filename).with_index do |line,line_num|
      meme_hash = JSON.parse(line)
      meme_hash.delete("meme_type_id")
      meme_hash.delete("id")
      memetype_hash = meme_hash.delete("meme_type")
      unless (memetype = MemeType.find_by(slug: memetype_hash["slug"]))
        memetype = MemeType.create(memetype_hash)
        new_memes[memetype.name] = 0
      end
      meme_hash["meme_type_id"] = memetype.id
      meme = Meme.find_by(reddit_id: meme_hash["reddit_id"]) || Meme.create(meme_hash)
      
      print "."
    end
    new_meme_type_count = MemeType.count - start_memetype_count
    if (new_memes.keys.count > 0)
      News.create(title: "#{new_meme_type_count} new meme types found!",
                content: new_memes.collect { |type,count| "#{count} #{type} instances\n" })
    end

    puts "\nCreated #{new_meme_type_count} new MemeTypes"
    puts "\nCreated #{Meme.count - start_meme_count} new Memes"

  end

end
