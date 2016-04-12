# == Schema Information
#
# Table name: news
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


ActiveAdmin.register News do

  permit_params :title, :content

  index do
    selectable_column
    id_column
    column :title
    column :content
    column :created_at
    actions
  end

  filter :title
  filter :content
  filter :created_at

  form do |f|
    f.inputs "News Details" do
      f.input :title
      f.input :content
    end
    f.actions
  end

  show do |n|
    attributes_table do
      row :id
      row :title
      row :content
      row :created_at
    end
  end

end
