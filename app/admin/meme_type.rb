ActiveAdmin.register MemeType do
  
  permit_params :name, :slug, :created_at, :updated_at, :template

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :template do |mt|
      image_tag(mt.template(:tiny))
    end
    column :instances, sortable: :instance_count do |mt|
      mt.memes.count
    end
    actions
  end

  form do |f|
    f.inputs "Meme Type" do
      f.input :name
      f.input :slug
      f.input :template, required: false, as: :file
    end
    f.actions
  end

  show do |mt|
    attributes_table do
      row :name
      row :slug
      row :template do
        image_tag(mt.template.url(:thumb))
      end
    end
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
