class PaperMcq < ActiveRecord::Base
  belongs_to :paper
  belongs_to :mcq
end
