class CreateCarousels < ActiveRecord::Migration
  def change
    create_table :carousels do |t|
    
      t.string :title,  null: false, default: Setting.systems.default_str
    

    
      t.string :avatar,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.timestamps null: false
    end
  end
end
