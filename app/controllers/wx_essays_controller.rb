class WxEssaysController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :wxuser_exist?, :except => [:query_show]


  def query_all 
    items = Essay.all.order('article_date DESC')
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :title => item.title,
       
        :dept => item.dept,

        :image => item.photo_url,
       
        :article_date => item.article_date,
       
        :content => item.content
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



  def query_show
    @essay = Essay.find(iddecode(params[:id]))
    content = @essay.content.gsub("/uploads/image/", Setting.systems.host + ":3000/uploads/image/").gsub("alt=", "width='100%' alt=").gsub(/<(?!br|img)[^>]*>/, '')

    obj = {
      :title => @essay.title,
      :dept => @essay.dept,
      :image => @essay.photo_url,
      :article_date => @essay.article_date,
      :content => content 
    }

    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end
end
