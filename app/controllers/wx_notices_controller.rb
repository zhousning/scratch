class WxNoticesController < ApplicationController
  skip_before_action :verify_authenticity_token
  #before_filter :wxuser_exist?
  def query_latest
    @notice = Notice.order("notice_date DESC").first
    if @notice
      respond_to do |f|
        f.json { render :json => { :id => @notice.id, :title => @notice.title }.to_json}
      end
    else
      respond_to do |f|
        f.json { render :json => { :id => '', :title => '' }.to_json}
      end
    end
  end

  def query_show
    @notice = Notice.find(params[:id])
    respond_to do |f|
      f.json { render :json => { :title => @notice.title, :article_date => @notice.notice_date, :content => @notice.content }.to_json}
    end
  end
end
