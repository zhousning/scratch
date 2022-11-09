class CreatePaperTofs < ActiveRecord::Migration
  def change
    create_table :paper_tofs do |t|
      t.integer :paper_id
      t.integer :tof_id

      t.timestamps null: false
    end
  end
end
