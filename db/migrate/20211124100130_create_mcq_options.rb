class CreateMcqOptions < ActiveRecord::Migration
  def change
    create_table :mcq_options do |t|
    
      t.text :title

      t.integer :sequence,  null: false, default: Setting.systems.default_num
    
      t.boolean :answer,  null: false, default: false 
    

    

    

    
      t.references :mcq
    

    
      t.timestamps null: false
    end
  end
end
