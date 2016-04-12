class MemesController < ApplicationController

  def index
    @memes = Meme.all.limit(50).order('created_utc desc')
  end

  def show
    @meme = Meme.find(params[:id])
  end

  def flag
  	@meme = Meme.find(params[:id])
  	@meme.update_attributes(flag: true, flagged_by: current_user) unless @meme.flag?
  	respond_to do |m|
  		m.js { flash[:notice] = "Flagged, thanks!"}
  	end
  end
end
