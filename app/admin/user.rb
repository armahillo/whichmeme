# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#

ActiveAdmin.register User do

  permit_params :name, :email

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :sign_in_count
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :sign_in_count
  filter :last_sign_in_ip
  filter :last_sign_in_at
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
    end
    f.actions
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
