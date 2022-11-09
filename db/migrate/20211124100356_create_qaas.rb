class CreateQaas < ActiveRecord::Migration
  def change
    create_table :qaas do |t|
    
      t.text :title
    
      t.text :answer
    

      t.references :qes_bank
    
      t.timestamps null: false
    end
  end
end
