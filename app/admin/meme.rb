ActiveAdmin.register Meme do

  # Filters
  filter :meme_type
  filter :meme_caption
  filter :link_title
  filter :created_utc
  filter :link_created_utc

  # Custom Actions
  batch_action :change_meme_type, form: { 
      meme_type: MemeType.established.order(:slug).collect { |mt| [mt.name, mt.id] }, 
      new_meme_name: :text 
    },
    method: :patch do |ids, inputs|
    Rails.logger.info("#{ids.inspect} #{inputs.inspect}")
      # Initialize the meme_type that we'll be assigning
      meme_type = MemeType.find(inputs["meme_type"])

      # buuuutt let's check and see if we're creating a new one instead.
      if (inputs["new_meme_name"] != "")
        # Does it already exist by slug?
        slug = MemeType.slug_from_name(inputs["new_meme_name"])
        unless (meme_type = MemeType.where(slug: slug).first)
          # Nope! Ok let's create it fresh then
          meme_type = MemeType.create(name: inputs["new_meme_name"])
          unless meme_type.valid?
            flash[:error] = "There were errors creating type #{inputs["new_meme_name"]}"
            redirect_to :back
          end
        end
      end
      # We've got the meme_type stored now, assign away
      ids.each do |m| 
        meme = Meme.find(m)
        meme.update_attributes({ meme_type_id: meme_type.id })
      end
      redirect_to :back
  end

  index do
    selectable_column
    id_column
    column :template do |m|
      image_tag(m.meme_type.template(:tiny))
    end
    column :link_title do |m|
      link_to m.link_title, m.to_url
    end
    column :meme_caption
    column :created_utc do |m|
      Time.at(m.created_utc)
    end
    column :meme_type do |m|
      link_to m.meme_type.name, admin_meme_type_path(m.meme_type)
    end
    actions
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
