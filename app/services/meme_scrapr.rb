require 'snooby'

LOG_PREFIX = '[[MEMESCRAPR]]'
VERSION = '1.0'

class MemeScrapr

  attr_reader :count, :username, :quantity, :since, :most_recent_timestamp, :memes

  def initialize username = "CaptionBot", quantity = 500, since = 0
  	@username = username
  	@quantity = quantity
  	@since = since
  	@most_recent_timestamp = nil
  	@count = 0
  	@memes = {}
  	@filename = ""
  end

  def scrape verbose = false
  	time_of_run = Time.now.to_i.to_s
    @filename = "reddit-#{@username}-#{time_of_run}"
    @unparseable_file = "unparseable-#{@username}-#{time_of_run}"
    @unparsed_records = []

    # Reset these in case the same object is run more than once.
    @count = 0
    @most_recent_timestamp = nil

    File.open("#{QUEUED_DIR}/#{@filename}.txt", 'w') { |file|
      file.puts("#{LOG_PREFIX} REDDIT DUMP FROM #{@username.upcase}: #{time_of_run}")
      file.puts("#{LOG_PREFIX} SINCE UTC: #{@since}") unless @since == 0
      puts "Scraping Memes from #{@username} since #{@since}" if verbose

      begin
        Snooby::Client.new("MemeScraprBot, v#{VERSION}").u(@username).comments(@quantity.to_i).each { |c|
          if (@most_recent_timestamp.nil?)
            @most_recent_timestamp = c.created_utc
            file.puts("#{LOG_PREFIX} LAST UTC: #{Time.at(c.created_utc)} (#{c.created_utc})")
          end
          begin
            scrapings = parse_body(c) || next
            file.puts scrapings
            print "." if verbose
            @count += 1
          rescue 
            print "E" if verbose
            @unparsed_records << c
          end
        }
      rescue Exception => e
      	#puts "\nERROR: #{e}"
      end
    }
    if @unparsed_records.count > 0 
      File.open("#{FAILED_DIR}/#{@unparseable_file}.txt", 'w') { |file|
        file.puts("#{LOG_PREFIX} UNPARSED RECORDS FROM #{@username.upcase}: #{time_of_run}")
        file.puts("#{LOG_PREFIX} #{@unparsed_records.count} RECORDS TOTAL")
        @unparsed_records.each do |c|
          file.puts c
        end
      }
      puts "\n!!! Saved #{@unparsed_records.count} unparsed records to #{FAILED_DIR}/#{@unparseable_file}.txt" if verbose
    end
    puts "\nDone!\n#{count} memes scraped. Saved to: #{QUEUED_DIR}/#{@filename}.txt" if verbose
    return @most_recent_timestamp.to_i
  end

  def self.collate_files
    filelist = []
    dataset = []
    # Each comment has a unique ID. We'll use that to ensure there are no dupes.
    ids_seen = []
    oldest_utc = nil
    newest_utc = nil
    # Iterate through the files and assemble them into a mega array
    Dir.glob("#{QUEUED_DIR}/*.txt").each do |file|
      print "#{file}: "
      begin
        new_data, new_ids = MemeScrapr.load_file_for_collation(file, ids_seen)
        filelist << file
      rescue Exception => e
        p e
        next
      end
      ids_seen += new_ids
      dataset += new_data
      File.rename(file, "#{file}.archived")
    end

    if dataset.empty? then puts "Nothing to do!"; return; end
  	# Sort the mega-hash by created_at_utc
    sorted_data = dataset.sort_by { |m| m[:created_utc] }
    oldest_utc = sorted_data.first[:created_utc]
    newest_utc = sorted_data.last[:created_utc]
  	# dump to file with special filename.
    filename = "collated-#{Time.now.to_i.to_s}.txt"
    File.open(filename, 'wb') { |file|
      file.puts "#{LOG_PREFIX} Collation of: #{filelist.join(',')}"
      file.puts "#{LOG_PREFIX} Start UTC: #{Time.at(oldest_utc)} (#{oldest_utc})"
      file.puts "#{LOG_PREFIX} End UTC: #{Time.at(oldest_utc)} (#{newest_utc})"
      sorted_data.each { |datum|
        file.puts datum
      }
    }
    FileUtils.mv Dir.glob("#{QUEUED_DIR}/*.archived"), ARCHIVED_DIR
    FileUtils.cp(filename, QUEUED_DIR)
  end

private
  # Need to refactor this so that there's a single method
  # that loads and iterates the file, and accepts a block parameter.

  def self.load_file_for_collation filename, ids, verbose = true
  	raise "#{filename} not found!" unless File.exist?("#{filename}")
    new_ids = []
    temporary_collection = []
  	File.open("#{filename}", 'r') { |file|
      file.each_line do |line|
      	next if line[0..(LOG_PREFIX.length-1)] == LOG_PREFIX
        meme = eval(line.chomp)
        next if (ids.include?(meme[:id]) || new_ids.include?(meme[:id]))
        if !meme.has_key?(:created_utc)
          meme[:created_utc] = 0.0
        end
        temporary_collection << meme
        new_ids << meme[:id]
        print "." if verbose
      end
    }
    puts "Processed #{filename}, added #{new_ids.count} (#{new_ids.count + ids.count} total)" if verbose
    return [temporary_collection, new_ids]
  end

  def parse_body(c)
    return nil if (c.created_utc.to_i <= @since.to_i)
    caption_tokens_re = Regexp.new(/([^*]+).*?([^*]+)/)
    transcript = c.body.match(caption_tokens_re) || ["","",""]
    meme_caption_cleaned = transcript[2].gsub(/&gt;/,'').split("\r\n\r\n").reject! { |c| c.empty? }.each { |c| c.gsub!(/^\s\-\s/,"").capitalize! }
    Hash[:body => c.body,
         :meme_type => transcript[1],
         :meme_caption => meme_caption_cleaned,
         :id => c.id,
         :link_id => c.link_id,
         :link_title => c.link_title,
         :subreddit => c.subreddit,
         :subreddit_id => c.subreddit_id,
         :created_utc => c.created_utc]
  end


end

