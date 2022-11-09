class LearnCtgsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @learn_ctg = LearnCtg.new
   
    @learn_ctgs = LearnCtg.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

  def query_all 
    items = LearnCtg.all
   
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



   
  def show
   
    @learn_ctg = LearnCtg.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @learn_ctg = LearnCtg.new
    
  end
   

   
  def create
    @learn_ctg = LearnCtg.new(learn_ctg_params)
     
    if @learn_ctg.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @learn_ctg = LearnCtg.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @learn_ctg = LearnCtg.find(iddecode(params[:id]))
   
    if @learn_ctg.update(learn_ctg_params)
      redirect_to learn_ctg_path(idencode(@learn_ctg.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @learn_ctg = LearnCtg.find(iddecode(params[:id]))
   
    @learn_ctg.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def learn_ctg_params
      params.require(:learn_ctg).permit( :name)
    end
  
  
  
end

