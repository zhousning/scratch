class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.datetime :start_time
    
      t.datetime :end_time
    
      t.integer :single,  null: false, default: Setting.systems.default_num 
    
      t.float :single_score,  null: false, default: Setting.systems.default_num 
    
      t.integer :mcq,  null: false, default: Setting.systems.default_num 
    
      t.float :mcq_score,  null: false, default: Setting.systems.default_num 
    
      t.integer :tof,  null: false, default: Setting.systems.default_num 
    
      t.float :tof_score,  null: false, default: Setting.systems.default_num 
    
      t.integer :qaa,  null: false, default: Setting.systems.default_num 
    
      t.float :qaa_score,  null: false, default: Setting.systems.default_num 
    
      t.text :desc
    

    

    

    

    
      t.timestamps null: false
    end
  end
end
