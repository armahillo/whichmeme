ActiveAdmin.register Games::MemetypeAssociation do

  permit_params :user_id, :meme_id, :correct_meme_id, :meme_type_id

  filter :meme_type, label: "Displayed Meme Type", collection: proc { MemeType.select(:id,:name).joins(:memetype_associations).uniq
 }
  filter :user, label: "Participant", collection: proc { User.select(:id, :name).joins(:memetype_associations).uniq }
  filter :correct_meme_id, as: :numeric
  filter :meme_id, as: :numeric
  filter :created_at

  scope :correct
  scope :incorrect

  sidebar :statistics do
    ul do
      li link_to("Success by type", success_by_type_admin_games_memetype_associations_path)
      li link_to("Failure by type", failure_by_type_admin_games_memetype_associations_path)
    end
  end


  index title: "Memetype Association Game" do
    selectable_column
    id_column
    column :meme_type do |m|
      link_to image_tag(m.meme_type.template(:tiny)), admin_meme_type_path(m.meme_type)
    end
    column :user do |m|
      if m.user.present?
        link_to m.user.name, admin_user_path(m.user)
      else
        "Unknown"
      end
    end
    column :selected_meme do |m|
      link_to m.meme.meme_type.name, admin_meme_path(m.meme_id)
    end
    column :correct_meme do |m|
      link_to m.correct_meme.meme_type.name, admin_meme_path(m.correct_meme_id)
    end
    column :chose_correctly do |m|
      m.correct_meme_id == m.meme_id ? status_tag("Yes", :ok) : status_tag("No")
    end
    column :created_at do |m|
      Time.at(m.created_at)
    end
    actions
  end

  collection_action :success_by_type do
    @successes = Games::MemetypeAssociation.success_by_type
  end

  collection_action :failure_by_type do
    @failures = Games::MemetypeAssociation.failure_by_type
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
