class CreateErrorLogs < ActiveRecord::Migration
  def change
    create_table :error_logs do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :log_url,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.references :user
    

    
      t.timestamps null: false
    end
  end
end
