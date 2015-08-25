class AddAttachmentTemplateToMemeTypes < ActiveRecord::Migration
  def self.up
    change_table :meme_types do |t|
      t.attachment :template
    end
  end

  def self.down
    remove_attachment :meme_types, :template
  end
end
