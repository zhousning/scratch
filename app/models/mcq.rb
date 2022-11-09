class Mcq < ActiveRecord::Base
  belongs_to :qes_bank
  belongs_to :paper


  has_many :paper_mcqs, :dependent => :destroy
  has_many :papers, :through => :paper_mcqs



  has_many :mcq_options, :dependent => :destroy
  accepts_nested_attributes_for :mcq_options, reject_if: :all_blank, allow_destroy: true





end
