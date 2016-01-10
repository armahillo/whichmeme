ActiveAdmin.register Meme do

  # Config
  permit_params :meme_type_id, :body, :meme_caption, :link_title, :subreddit, :created_utc, :source, :thumbnail, :score, :ups, :link_created_utc, :title

  # Filters
  filter :meme_type
  filter :meme_caption
  filter :link_title
  filter :created_utc
  filter :link_created_utc

  # Custom Actions
  batch_action :change_meme_type, form: { 
      meme_type: proc { MemeType.established.order(:slug).collect { |mt| [mt.name, mt.id] } }, 
      new_meme_name: :text 
    },
    method: :patch do |ids, inputs|
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

  show title: :id do |m|
    attributes_table do
      row :link_title
      row :meme_caption
      row :template do
        image_tag(m.meme_type.template.url(:thumb))
      end
      row :MTA_Occurrences do
        m.memetype_associations.count
      end
    end
  
    table_for m.memetype_associations do |mta|
      column(:user) { |mta| link_to mta.user.name, admin_user_path(mta.user) }
      column(:meme_type) { |mta| link_to mta.meme_type.name, admin_meme_type_path(mta.meme_type) }
      column(:correct) { |mta| mta.correct_meme_id == mta.meme_id ? "Yes"  : "No" }
    end
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
    column :live_link do |m|
      link_to m.to_url, m.to_url
    end
    actions
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
