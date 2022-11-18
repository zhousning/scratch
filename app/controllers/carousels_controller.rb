class CarouselsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
   
    @carousels = Carousel.all
   
  end
   

  def query_all 
    items = Carousel.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :title => item.title
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @carousel = Carousel.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @carousel = Carousel.new
    
  end
   

   
  def create
    @carousel = Carousel.new(carousel_params)
     
    if @carousel.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @carousel = Carousel.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @carousel = Carousel.find(iddecode(params[:id]))
   
    if @carousel.update(carousel_params)
      redirect_to carousel_path(idencode(@carousel.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @carousel = Carousel.find(iddecode(params[:id]))
   
    @carousel.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def carousel_params
      params.require(:carousel).permit( :title , :avatar)
    end
  
  
  
end

