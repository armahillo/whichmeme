=begin
  This research game presents the user with a single meme template with
  three captions. One of them is the actual caption and the other two are
  captions from NOT this template.

  The user selects the one they think is the best match and it records both
  their selection and which was the correct one.

  Sign-In is required.
=end

class Games::MemetypeAssociationsController < ApplicationController
  load_and_authorize_resource

  def new
    # This is the "correct" meme for this iteration
    # Choose one that the user has not already done
    @target_meme = Meme.includes(:meme_type).established.with_image.where("memes.id not in (SELECT meme_id FROM #{Games::MemetypeAssociation.table_name} WHERE user_id = ?)", current_user).order("RANDOM()").first
    begin
      raise Exception.new("No unseen meme types remaining!") if @target_meme.nil?
      # The meme_type associated with it, for convenience
      @meme_type = @target_meme.meme_type
      # Build out the array of displayed items
      @memes = [@target_meme]
      # The AREL query here ensures that the memes chosen are NOT going to
      # generate false positive
      @memes << Meme.includes(:meme_type).established.where('memes.id not in (?)', @target_meme.id).where('meme_type_id NOT IN (?)', @meme_type.id).order("RANDOM()").first
      @memes << Meme.includes(:meme_type).established.where('memes.id not in (?,?)', @target_meme.id, @memes.first.id).where('meme_type_id NOT IN (?)', @meme_type.id).order("RANDOM()").first
      
      # Just to ensure that it's not always the left-hand side one
      @memes.shuffle!
  
      # Some of this data is stored in the form as hidden fields
      @memetype_association = Games::MemetypeAssociation.new(user_id: current_user, correct_meme_id: @target_meme.id)
    rescue Exception => e
      flash[:error] = e.message
      redirect_to root_path
    end
  end

  def create
    # which is the correct meme type?
    meme_type_id = params[:meme_type_id]
    # which were available?
    meme1, meme2, meme3 = params[:meme_ids].split(",")
    # which did they select?
    meme_id = params[:memetype_association][:meme_id].to_i

    # We pull this dynamically so that the user can't "cheat" when filling
    # out items.
    correct_meme_id = Meme.where('meme_type_id = ? AND id IN (?,?,?)', meme_type_id, meme1, meme2, meme3).first.id
    
    # Store the data and allow the user to continue
    memetype_association = Games::MemetypeAssociation.create!(meme_id: meme_id, meme_type_id: meme_type_id, correct_meme_id: correct_meme_id, user: current_user)

    correct = correct_meme_id == meme_id
    current_user.increment!(:memetype_associations_correct) if correct

    session[:user_metadata][:games][:memetype_association] = current_user.memetype_associations_count
    session[:user_metadata][:games][:memetype_accuracy] = current_user.memetype_accuracy

    flash[:correct] = (correct ? 1 : 0)
    if (correct) 
      session[:user_metadata][:games][:best_type] = current_user.best_type
      flash[:agree] = "They agree!"
    else
      flash[:disagree] = "They disagree :("
    end
    flash[:track] = "memetype"
    redirect_to :back, status: 303
  end
end
