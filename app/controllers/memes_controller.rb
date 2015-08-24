class MemesController < ApplicationController

  def index
    @memes = Meme.all.limit(50).order('created_utc desc')
  end
end
