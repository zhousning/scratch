class WxAdvisesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :wxuser_exist?


  def create_advise
    openid = params[:openid] 
    content = params[:text] 
    user = WxUser.find_by_openid(openid)

    @advise = Advise.new(:content => content, :wx_user => user)
     
    if @advise.save
      respond_to do |f|
        f.json{ render :json => {:status => 'success'}.to_json}
      end
    else
      respond_to do |f|
        f.json{ render :json => {:status => 'error'}.to_json}
      end
    end
  end
   
end
