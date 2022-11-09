class CreateEssays < ActiveRecord::Migration
  def change
    create_table :essays do |t|
    
      t.string :title,  null: false, default: Setting.systems.default_str
    
      t.string :dept,  null: false, default: Setting.systems.default_str
    
      t.date :article_date
    
      t.text :content
    

    
      t.string :photo,  null: false, default: Setting.systems.default_str
    

      t.references :user
    

    

    
      t.timestamps null: false
    end
  end
end
