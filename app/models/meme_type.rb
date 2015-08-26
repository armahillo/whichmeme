# == Schema Information
#
# Table name: meme_types
#
#  id                    :integer          not null, primary key
#  name                  :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  template_file_name    :string
#  template_content_type :string
#  template_file_size    :integer
#  template_updated_at   :datetime
#  instance_count        :integer
#

class MemeType < ActiveRecord::Base
  has_many :memes

  has_attached_file :template, 
                     styles: { medium: "300x300>", thumb: "100x100>", tiny: "30x30#" }, 
                     default_style: :medium

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_attachment_content_type :template, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

  after_create :slugify

  scope :established, -> { where('instance_count > 5') }

  def absorb!(id)
    return if id == self.id
    mt = MemeType.includes(:memes).find(id)
    mt.memes.each do |m|
      m.update_attributes({ meme_type_id: self.id })
    end
    mt.reload
    mt.destroy if mt.memes.count == 0
    MemeType.reset_counters(self.id, :memes)
  end

  def slugify
    self.update_attributes(slug: MemeType.slug_from_name(name))
  end

  def self.slug_from_name name
    name.downcase.gsub(/[\'\"]/,'').gsub(/[^\w]/,'_').gsub(/_+/,'_').chomp('_')
  end

end
