class Games::MemetypeAssociationsController < ApplicationController
  load_and_authorize_resource

  def new
    @target_meme = Meme.includes(:meme_type).established.where('memes.id not in (SELECT id FROM memetype_associations WHERE user_id = ?)', current_user).order("RANDOM()").first
    @meme_type = @target_meme.meme_type
    @memes = [@target_meme]
    @memes << Meme.includes(:meme_type).established.where('memes.id not in (?)', @target_meme.id).where('meme_type_id NOT IN (?)', @meme_type.id).order("RANDOM()").first
    @memes << Meme.includes(:meme_type).established.where('memes.id not in (?,?)', @target_meme.id, @memes.first.id).where('meme_type_id NOT IN (?)', @meme_type.id).order("RANDOM()").first
    
    @memes.shuffle!

    @memetype_association = Games::MemetypeAssociation.new(user_id: current_user, correct_meme_id: @target_meme.id)
  end

  def create
    meme_type_id = params[:meme_type_id]
    meme1, meme2, meme3 = params[:meme_ids].split(",")
    meme_id = params[:memetype_association][:meme_id]

    correct_meme_id = Meme.where('meme_type_id = ? AND id IN (?,?,?)', meme_type_id, meme1, meme2, meme3).first.id
    
    memetype_association = Games::MemetypeAssociation.create!(meme_id: meme_id, meme_type_id: meme_type_id, correct_meme_id: correct_meme_id, user: current_user)

    redirect_to :back
  end
end
