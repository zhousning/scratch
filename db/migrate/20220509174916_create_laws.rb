class CreateLaws < ActiveRecord::Migration
  def change
    create_table :laws do |t|
    
      t.string :title,  null: false, default: Setting.systems.default_str
    
      t.date :pdt_date
    
      t.text :content
    
      t.string :dept,  null: false, default: Setting.systems.default_str
    
      t.string :ctg,  null: false, default: Setting.systems.default_str
    

      t.references :user
    

    
      t.string :attch,  null: false, default: Setting.systems.default_str
    

    
      t.references :law_ctg
    

    
      t.timestamps null: false
    end
  end
end
