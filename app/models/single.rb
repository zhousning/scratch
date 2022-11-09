class Single < ActiveRecord::Base
  belongs_to :qes_bank

  has_many :paper_singles, :dependent => :destroy
  has_many :papers, :through => :paper_singles



  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true




  has_many :single_options, :dependent => :destroy
  accepts_nested_attributes_for :single_options, reject_if: :all_blank, allow_destroy: true



end
