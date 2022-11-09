class QesBank < ActiveRecord::Base

  mount_uploader :photo, EnclosureUploader

  has_many :singles, :dependent => :destroy
  accepts_nested_attributes_for :singles, reject_if: :all_blank, allow_destroy: true


  has_many :mcqs, :dependent => :destroy
  accepts_nested_attributes_for :mcqs, reject_if: :all_blank, allow_destroy: true


  has_many :tofs, :dependent => :destroy
  accepts_nested_attributes_for :tofs, reject_if: :all_blank, allow_destroy: true


  has_many :qaas, :dependent => :destroy
  accepts_nested_attributes_for :qaas, reject_if: :all_blank, allow_destroy: true

  belongs_to :learn_ctg

  belongs_to :user


end
