# == Schema Information
#
# Table name: memetype_associations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  meme_type_id    :integer
#  meme_id         :integer
#  correct_meme_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Games::MemetypeAssociation < ActiveRecord::Base
  # The user
  belongs_to :user

  # Memetype
  belongs_to :meme_type

  # Their answer
  belongs_to :meme

  # The actual meme
  belongs_to :correct_meme, class_name: "Meme", foreign_key: "correct_meme_id"

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :correct, -> { where('meme_id = correct_meme_id') }
  scope :incorrect, -> { where('meme_id <> correct_meme_id') }
  scope :by_meme_type, ->(meme_type_id) { where(meme_type_id: meme_type_id) }

  def self.meme_types 
  	self.where()
  end

  def self.success_by_type
    successes = Games::MemetypeAssociation.joins(:meme_type).correct.group(:meme_type_id).count
    totals = Games::MemetypeAssociation.joins(:meme_type).group(:meme_type_id).count
    MemeType.select(:id,:name).where(id: successes.keys).collect { |r| [r.id, r.name, successes[r.id], totals[r.id], (successes[r.id].to_f/totals[r.id])] }.sort { |a,b| a[4] <=> b[4] }.reverse
  end

  def self.failure_by_type
    failures = Games::MemetypeAssociation.joins(:meme_type).incorrect.group(:meme_type_id).count
    totals = Games::MemetypeAssociation.joins(:meme_type).group(:meme_type_id).count
    MemeType.select(:id,:name).where(id: failures.keys).collect { |r| [r.id, r.name, failures[r.id], totals[r.id], (failures[r.id].to_f/totals[r.id])] }.sort { |a,b| a[4] <=> b[4] }.reverse
  end

  def self.user_success_by_type(user_id)
    successes = Games::MemetypeAssociation.joins(:user).joins(:meme_type).by_user(user_id).correct.group(:meme_type_id).count
    totals = Games::MemetypeAssociation.joins(:meme_type).group(:meme_type_id).count
    MemeType.select(:id,:name).where(id: successes.keys).collect { |r| [r.id, r.name, successes[r.id], totals[r.id], (successes[r.id].to_f/totals[r.id])] }.sort { |a,b| a[4] <=> b[4] }.reverse
  end

  def self.user_failure_by_type(user_id)
    failures = Games::MemetypeAssociation.joins(:user).joins(:meme_type).by_user(1).incorrect.group(:meme_type_id).count
    totals = Games::MemetypeAssociation.joins(:meme_type).group(:meme_type_id).count
    MemeType.select(:id,:name).where(id: failures.keys).collect { |r| [r.id, r.name, failures[r.id], totals[r.id], (failures[r.id].to_f/totals[r.id])] }.sort { |a,b| a[4] <=> b[4] }.reverse
  end
end
