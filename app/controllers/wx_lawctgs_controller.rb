class WxLawctgsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :wxuser_exist?


  def query_all 
    items = LawCtg.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :name => item.name
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def qes_bank
    law_ctg = LawCtg.find(iddecode(params[:law_ctg_id]))
    items = law_ctg.laws
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
        :name => item.title,
        :ctg => item.ctg,
        :attach => item.attch_url.nil? ? '' : URI.decode(item.attch_url)
      }
    end
    respond_to do |f|
      f.json{ render :json => {:title => law_ctg.name, :res => obj}.to_json}
    end
  end

  def query_show
    @law = Law.find(iddecode(params[:id]))
    respond_to do |f|
      f.json { render :json => { :title => @law.title, :article_date => @law.pdt_date, :content => @law.content }.to_json}
    end
  end


end
