require 'snooby'

namespace :scrapr do
  desc "Determines the last time we refreshed, then pulls down latest content since then"
  task :scan => :environment do
    # First, we'll determine when we last scanned. 
    # This should be based on the collation time
    # not perfect, but works for now.
    since = STATUS.data['last_seen'] || 0
    #Dir.glob("./data/*.txt").each do |filename|
    #  timestamp = File.basename(filename, ".txt").split("-").last.to_i || 0
    #  if (timestamp > since) 
    #    since = timestamp
    #  end
    #end

    # 1000 is the max comments reddit API allows
    comments_to_pull = STATUS.data['comments_to_pull'] || 1000 
    # Scan these usernames, or default to captionbot
    username_to_scan = STATUS.data['usernames'].first || "captionbot"

    # Named floyd because of reasons.
    floyd = MemeScrapr.new(username_to_scan, comments_to_pull, since)
    new_last_seen = floyd.scrape(true)
    STATUS.data['last_seen'] = new_last_seen if !new_last_seen.nil?
    STATUS.save
  end

  desc "Combines all individuals pulls, omitting duplicates"
  task :collate => :environment do
    MemeScrapr.collate_files
    collated_file = Dir.glob("./data/*.txt").first
    MemeScrapr.generate_ranked_summary(collated_file) unless !File.exist?(collated_file)
  end
end
