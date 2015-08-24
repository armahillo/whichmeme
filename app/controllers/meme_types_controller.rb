class MemeTypesController < ApplicationController
  def index
    @meme_types = MemeType.all
  end

  def show
    @meme_type = MemeType.includes(:memes).find(params[:id])
    @memes = @meme_type.memes
  end
end
