require 'restclient'
require 'json'

class WxUsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :wxuser_exist?, :except => [:update, :get_userid]

  def update 
    wxuser = WxUser.find_by(:openid => params[:id])
    respond_to do |f|
      if wxuser.update(wx_user_params)
        f.json { render :json => {:status => "wxuser update success" }.to_json}
      else
        f.json { render :json => {:status => "wxuser update error"}.to_json}
      end
    end
  end

  def get_userid
    encryptedData = params[:encryptedData]
    iv = params[:iv]
    url = "https://api.weixin.qq.com/sns/jscode2session"
    data = {
      appid: "wxfa7abc0845745fb8", 
      secret: "4c93bcb1a27aab64bd1c1e9ddfb2b660",
      js_code: params[:code].to_s,
      grant_type: 'authorization_code'
    }
    response = RestClient.get url, params: data, :accept => :json
    body = JSON.parse(response.body)
    unless body["errcode"]
      openid = body["openid"]
      session_key = body["session_key"]

      @wxuser = WxUser.find_by(:openid => openid)
      unless @wxuser
        @wxuser = WxUser.new(:openid => openid)
        @wxuser.save
      end

      respond_to do |f|
        f.json { render :json => {:state => 'success', :openId => openid }.to_json }
      end
    else
      respond_to do |f|
        f.json { render :json => {:state => 'error' }.to_json }
      end
    end
  end

  def fcts
    objs = []
    fcts = Factory.all
    fcts.each do |fct|
      objs << fct.name
    end
    respond_to do |f|
      f.json { render :json => objs.to_json }
    end
  end

  def set_fct
    fct = Factory.find_by(:name => params[:fct])
    wxuser = WxUser.find_by(:openid => params[:openid])
    respond_to do |f|
      if wxuser.update_attributes(:state => Setting.states.ongoing, :factory => fct, :name => params[:name], :phone => params[:phone] )
        f.json { render :json => {:status => "success" }.to_json}
      else
        f.json { render :json => {:status => "error"}.to_json}
      end
    end
  end

  def status
    objs = []
    fcts = Factory.all
    fcts.each do |fct|
      objs << fct.name
    end
    wxuser = WxUser.find_by(:openid => params[:openid])
    respond_to do |f|
      name = wxuser.name || ''
      phone = wxuser.phone || ''
      fct = wxuser.factory.nil? ? '' : wxuser.factory.name
      f.json { render :json => {:name => name, :phone => phone, :fct => fct, :fcts => objs}.to_json}
    end
  end

  private
    def wx_user_params
      params.require(:wx_user).permit(:nickname, :avatarurl, :gender, :city, :province, :country, :language, :name, :phone)
    end                                  

end
