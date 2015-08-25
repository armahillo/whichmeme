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

  has_attached_file :template, 
                     styles: { medium: "300x300>", thumb: "100x100>", tiny: "30x30#" }, 
                     default_style: :medium

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_attachment_content_type :template, content_type: /\aimage\/.*\z/

  

  after_create :slugify

  def slugify
    self.update_attributes(slug: MemeType.slug_from_name(name))
  end

  def self.slug_from_name name
    name.downcase.gsub(/[\'\"]/,'').gsub(/[^\w]/,'_').gsub(/_+/,'_').chomp('_')
  end

end
