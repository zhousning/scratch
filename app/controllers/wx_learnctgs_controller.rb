class WxLearnctgsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :wxuser_exist?

  def query_all 
    items = LearnCtg.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :name => item.name,

        :logo => item.logo
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def qes_bank
    learn_ctg = LearnCtg.find(iddecode(params[:learn_ctg_id]))
    items = learn_ctg.qes_banks.select('editor').uniq
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :name => item.editor
      
      }
    end
    respond_to do |f|
      f.json{ render :json => {:title => learn_ctg.logo, :res => obj}.to_json}
    end
  end

end
