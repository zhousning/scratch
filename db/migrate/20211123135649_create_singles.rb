class CreateSingles < ActiveRecord::Migration
  def change
    create_table :singles do |t|
    
      t.text :title
    

      t.references :qes_bank
    

    

    

    
      t.timestamps null: false
    end
  end
end
