class Qaa < ActiveRecord::Base
  belongs_to :qes_bank
  belongs_to :paper

  has_many :paper_qaas, :dependent => :destroy
  has_many :papers, :through => :paper_qaas








end
