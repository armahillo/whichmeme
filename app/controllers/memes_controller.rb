class MemesController < ApplicationController

  def index
    @memes = Meme.all.limit(50).order(:link_created_utc)
  end
end
