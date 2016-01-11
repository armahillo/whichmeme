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

  show title: :name do |u|
    attributes_table do
      row :id
      row :name
      row :created_at
      row :email
      row :sign_in_count
      row :last_sign_in_at
      row :last_sign_in_ip
      row :provider
      row :MTA_Score do
        correct = Games::MemetypeAssociation.by_user(u.id).correct.count
        incorrect = Games::MemetypeAssociation.by_user(u.id).incorrect.count
        total = correct + incorrect
        if (total > 0)
          "#{(correct.to_f / total) * 100}% (#{correct} correct of #{total})"
        else
          "None yet."
        end
      end
    end

    panel "Best at these types" do
      table_for Games::MemetypeAssociation.user_success_by_type(u.id) do |s|
        column(:meme_type) { |data| link_to data[1], admin_meme_type_path(data[0]) }
        column(:successes) { |data| data[2] }
        column(:trials) { |data| data[3] }
        column(:success_rate) { |data| data[4] }
      end
    end

    panel "Worst at these types" do
      table_for Games::MemetypeAssociation.user_failure_by_type(u.id) do |s|
        column(:meme_type) { |data| link_to data[1], admin_meme_type_path(data[0]) }
        column(:failures) { |data| data[2] }
        column(:trials) { |data| data[3] }
        column(:failure_rate) { |data| data[4] }
      end
    end
  
    panel "Correct guesses" do
      table_for Games::MemetypeAssociation.correct.by_user(u.id).order(:meme_type_id) do |mta|
        column(:meme_type) { |mta| link_to mta.meme_type.name, admin_meme_type_path(mta.meme_type) }
        column(:meme_caption) { |mta| mta.correct_meme.meme_caption }
      end
    end

    panel "Incorrect guesses" do
      table_for Games::MemetypeAssociation.incorrect.by_user(u.id).order(:meme_type_id) do |mta|
        column(:meme_type) { |mta| link_to mta.meme_type.name, admin_meme_type_path(mta.meme_type) }
        column(:guess_caption) { |mta| mta.meme.meme_caption }
        column(:correct_caption) { |mta| mta.correct_meme.meme_caption }
      end
    end
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
