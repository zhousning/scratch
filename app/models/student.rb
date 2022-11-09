class Student < ActiveRecord::Base

  mount_uploader :photo, EnclosureUploader






  belongs_to :factory



  belongs_to :user

end
