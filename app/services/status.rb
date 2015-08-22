require 'json'

class Status
  attr_accessor :data
	
  def initialize
    raise "No last_seen specified in ENV" unless ENV.has_key?("LAST_SEEN")
    @filename = ENV['LAST_SEEN']
    self.load
  end

  def save
    File.open(@filename, 'w') do |f|
      f.puts @data.to_json
    end
  end

  def load
    @data = JSON.parse(File.read(@filename))
  end
end

