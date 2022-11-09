class Enclosure < ActiveRecord::Base
  mount_uploader :file, EnclosureUploader

  belongs_to :notice
  belongs_to :article
  belongs_to :ocr
  belongs_to :single
  belongs_to :notice
end




# == Schema Information
#
# Table name: enclosures
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  file       :string          default(""), not null
#  notice_id  :integer
#  article_id :integer
#  ocr_id     :integer
#

