class PaperSingles < ActiveRecord::Migration
  def change
    create_table :paper_singles do |t|
      t.integer :paper_id
      t.integer :single_id

      t.timestamps null: false
    end
  end
end
