class AddLogoToLearnCtgs < ActiveRecord::Migration
  def change
    add_column :learn_ctgs, :logo, :text
  end
end
