class Paper < ActiveRecord::Base
  has_many :paper_singles, :dependent => :destroy
  has_many :singles, :through => :paper_singles

  has_many :paper_mcqs, :dependent => :destroy
  has_many :mcqs, :through => :paper_mcqs

  has_many :paper_tofs, :dependent => :destroy
  has_many :tofs, :through => :paper_tofs

  has_many :paper_qaas, :dependent => :destroy
  has_many :qaas, :through => :paper_qaas


  belongs_to :user

end
