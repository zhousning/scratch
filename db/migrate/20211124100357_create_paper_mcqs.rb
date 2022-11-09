class CreatePaperMcqs < ActiveRecord::Migration
  def change
    create_table :paper_mcqs do |t|
      t.integer :paper_id
      t.integer :mcq_id

      t.timestamps null: false
    end
  end
end
