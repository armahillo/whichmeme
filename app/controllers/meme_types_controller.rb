class MemeTypesController < ApplicationController
  authorize_resource
  
  def index
    @established = MemeType.established.order('instance_count desc')
    @long_tail = MemeType.long_tail.order('instance_count desc')
  end

  def show
    @meme_type = MemeType.includes(:memes).find(params[:id])
    @memes = @meme_type.memes
  end
end
