require 'json'

class Status
  attr_accessor :data
	
  def initialize(file)
    @filename = file
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

