class LawCtg < ActiveRecord::Base

  mount_uploader :avatar, EnclosureUploader






  has_many :laws, :dependent => :destroy
  accepts_nested_attributes_for :laws, reject_if: :all_blank, allow_destroy: true



end
