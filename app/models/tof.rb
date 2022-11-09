class Tof < ActiveRecord::Base
  belongs_to :qes_bank
  belongs_to :paper

  has_many :paper_tofs, :dependent => :destroy
  has_many :papers, :through => :paper_tofs








end
