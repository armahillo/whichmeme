=begin
  This research game presents the user with a single meme text with
  three templates. One of them is the actual template and the other two are
  templates from NOT for this caption

  The user selects the one they think is the best match and it records both
  their selection and which was the correct one.

  Sign-In is required.
=end


class Games::TypememeAssociationsController < ApplicationController
  load_and_authorize_resource

  def new
    # First, we'll identify a meme that is from an established type that also has an image (the image is a necessary component), and
    # ensure the user has not already seen that meme's text.
    @meme = Meme.includes(:meme_type).established.with_image.where("memes.id not in (SELECT meme_id FROM #{Games::TypememeAssociation.table_name} WHERE user_id = ?)", current_user).order("RANDOM()").first
    # Use that meme type as the basis.
    @target_meme_type = @meme.meme_type
    @meme_types = [@target_meme_type]
    # Identify a different meme type that we've not seen yet
    @meme_types << MemeType.established.with_image.where('id != ?', @target_meme_type.id).order("RANDOM()").first
    # And one more time...
    @meme_types << MemeType.established.with_image.where('id not in (?,?)', *@meme_types.collect { |mt| mt.id } ).order("RANDOM()").first
    # Randomize them
    @meme_types.shuffle!
    # Seed the object -- this information is stored as hidden fields in the form.
    @typememe_association = Games::TypememeAssociation.new(user_id: current_user, correct_meme_type_id: @target_meme_type.id)
  end

  def create
  	# The meme text source
    meme_id = params[:meme_id]
    # All three meme_Type_ids displayed
    meme_type1, meme_type2, meme_type3 = params[:meme_type_ids].split(",")
    # The selected meme type from the user
    meme_type_id = params[:typememe_association][:meme_type_id]
    # Which type is correct?
    correct_meme_type_id = Meme.where('id = ? AND meme_type_id IN (?,?,?)', meme_id, meme_type1, meme_type2, meme_type3).first.id
    
    typememe_association = Games::TypememeAssociation.create!(meme_id: meme_id, meme_type_id: meme_type_id, correct_meme_type_id: correct_meme_type_id, user: current_user)

    redirect_to :back

  end
end