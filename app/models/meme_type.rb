# == Schema Information
#
# Table name: meme_types
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MemeType < ActiveRecord::Base
  has_many :memes

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create :slugify

  def slugify
    self.update_attributes(slug: MemeType.slug_from_name(name))
  end

  def self.slug_from_name name
    name.downcase.gsub(/[\'\"]/,'').gsub(/[^\w]/,'_').gsub(/_+/,'_').chomp('_')
  end

end
