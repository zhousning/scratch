class WxSystemsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :wxuser_exist?

  def dog 
    carousels = Carousel.all 
    carousel_arr = []
    carousels.each_with_index do |carousel, index|
      carousel_arr << carousel.avatar_url
    end
    respond_to do |f|
      f.json { render :json => {:dogs => carousel_arr}.to_json}
    end
  end

end
