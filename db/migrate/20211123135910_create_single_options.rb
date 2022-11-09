class CreateSingleOptions < ActiveRecord::Migration
  def change
    create_table :single_options do |t|
    
      t.text :title
    
      t.boolean :answer,  null: false, default: false 
    

    

    

    
      t.references :single
    

    
      t.timestamps null: false
    end
  end
end
