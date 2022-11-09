class Essay < ActiveRecord::Base

  mount_uploader :photo, EnclosureUploader

  belongs_to :user






end
