class CreateQesBanks < ActiveRecord::Migration
  def change
    create_table :qes_banks do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :editor,  null: false, default: Setting.systems.default_str
    
      t.integer :single_count,  null: false, default: Setting.systems.default_num 
    
      t.integer :mcq_count,  null: false, default: Setting.systems.default_num 
    
      t.integer :tof_count,  null: false, default: Setting.systems.default_num 
    
      t.integer :qaa_count,  null: false, default: Setting.systems.default_num 
    

    
      t.string :photo,  null: false, default: Setting.systems.default_str
    

      t.references :learn_ctg

      t.references :user
    

    
      t.timestamps null: false
    end
  end
end
