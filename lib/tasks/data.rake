namespace :data do

  def process_file filename, seen_ids = []
    data, ids = MemeScrapr.load_file_for_collation(filename, seen_ids, false)
    skipped_records = []
    failed_inserts = []

    failure_log = "./failed/#{Time.now.to_i}_failures.txt"
    skipped_log = "./failed/#{Time.now.to_i}_skipped.txt"

    Meme.connection
    data.each { |meme| 
      begin
        meme_type = meme.delete(:meme_type)
        type = MemeType.find_by(slug: MemeType.slug_from_name(meme_type))
        if type.nil?
          type = MemeType.create(name: meme_type)
          puts "\nCreate type: #{type.name} [#{type.slug}]"
        end

        meme[:meme_type_id] = type.id
        meme[:reddit_id] = meme.delete(:id)
        record = Meme.create(meme)

        # Did it work?
        if record.errors.empty?
          # Record has been uploaded!
          print "^"
        else
          # OK, did it fail because the ID already exists? We don't need to track those.
          error_messages = ""
          record.errors.messages.each { |c,m|
            if ((/has already been taken/ =~ m.join(",")).nil?)
              error_messages += "#{c}: #{m.join(',')}; "
            end  
          }
          unless error_messages.empty?
            skipped_records << record.reddit_id + " => " + error_messages
            File.open(skipped_log, 'a') { |f|
              f.puts meme
            }
          end
          print "."
        end
      rescue Exception => e
        failed_inserts << e
        print "x"
        File.open(failure_log, 'a') { |f|
          f.puts meme
        }
      end
    }
    puts ''
    return [skipped_records, failed_inserts]
  end

  desc "Process a single file" 
  task :process_single, :filename do |t, args|
    raise Exception.new("No parameter 'file' provided") unless !args[:filename].nil?

    seen_ids = JSON.parse(File.read('seen_ids.txt')) rescue []
    puts "Skipping #{seen_ids.count} records"

    skipped_records, failed_inserts = process_file(args[:filename], seen_ids)

    unless skipped_records.empty?
      puts "These records were skipped:"
      puts skipped_records.collect { |r| "\t#{r}\r\n"}
    end
    unless failed_inserts.empty?
      puts "These records failed to insert:"
      puts failed_inserts.collect { |r| "\t#{r}\r\n"}
    end
    puts 'Done!'
  end

  desc "Process all in queue"
  task :process_queue do
    queue = Dir.glob('./queue/*.txt')
    queue.each do |file|
      puts "Processing #{file}"
      Rake::Task['data:process_single'].invoke(file)
      Rake::Task['data:process_single'].reenable
      Rake::Task['data:update_seen_cache'].invoke
      Rake::Task['data:update_seen_cache'].reenable
      File.rename(file, "#{file}.archived")
    end
    FileUtils.mv Dir.glob("./queue/*.archived"), './archive/'
  end

  desc "Update ID cache"
  task :update_seen_cache do
    seen_ids = Meme.all.select(:reddit_id).collect { |m| m.reddit_id }
    filename = "seen_ids.txt"
    File.open(filename, 'w') { |file| file.write(seen_ids) }
    puts "Cached IDs for #{seen_ids.count} records.\nSaved to: #{filename}"
  end

  desc "Get stats" 
  task :stats do
    MemeType.order(:name).each { |t|
      puts "#{t.memes.count}\t#{t.name}"
    }
    puts "Total Count: #{Meme.count}"
  end

  desc "Update slugs"
  task :update_slugs do
    MemeType.all.each { |m| 
      puts "#{m.slug} => #{MemeType.slug_from_name(m.name)}"
      m.slugify
    }
  end

end
