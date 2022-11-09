class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
    
      t.string :title,  null: false, default: Setting.systems.default_str
    
      t.date :notice_date
    
      t.text :content
    

    
      t.string :avatar,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.timestamps null: false
    end
  end
end
