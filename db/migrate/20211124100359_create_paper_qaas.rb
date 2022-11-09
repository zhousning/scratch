class CreatePaperQaas < ActiveRecord::Migration
  def change
    create_table :paper_qaas do |t|
      t.integer :paper_id
      t.integer :qaa_id

      t.timestamps null: false
    end
  end
end
