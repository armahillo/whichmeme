ActiveAdmin.register MemeType do
  
  # Config
  permit_params :name, :slug, :created_at, :updated_at, :template
  config.sort_order = 'instance_count_desc'

  # Filters
  filter :name, as: :string
  filter :slug, as: :string
  filter :instance_count, as: :numeric
  filter :created_at

  # Scopes
  scope :all, default: true
  scope :established
  scope("Long Tail") { |scope| scope.where('instance_count <= 5') }

  # Custom Actions
  batch_action :combine, form: { destination_id: :text }  do |ids, inputs|
    absorbing_type = MemeType.find(inputs['destination_id']) 
    ids.each do |id|
      absorbing_type.absorb!(id)
    end
    MemeType.reset_counters(absorbing_type.id, :memes)
    redirect_to :back
  end

  index do
    selectable_column
    id_column
    column :name do |mt|
      link_to mt.name, admin_meme_type_path(mt)
    end
    column :slug
    column :template do |mt|
      image_tag(mt.template(:tiny))
    end
    column :instances, sortable: :instance_count do |mt|
      mt.memes.count
    end
    column :example do |mt|
      link = mt.memes.first.to_url
      link_to_if link.present?, "Sample", link
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

  show title: :name do |mt|
    attributes_table do
      row :name
      row :slug
      row :template do
        image_tag(mt.template.url(:thumb))
      end
    end
  
    table_for mt.memes do
      column(:link_title) { |m| link_to m.link_title, edit_admin_meme_path(m) }
      column :meme_caption
      column("Link") { |m| link_to m.to_url, m.to_url }
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
