class LawCtgsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @law_ctg = LawCtg.new
   
    @law_ctgs = LawCtg.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

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



   
  def show
   
    @law_ctg = LawCtg.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @law_ctg = LawCtg.new
    
  end
   

   
  def create
    @law_ctg = LawCtg.new(law_ctg_params)
     
    if @law_ctg.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @law_ctg = LawCtg.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @law_ctg = LawCtg.find(iddecode(params[:id]))
   
    if @law_ctg.update(law_ctg_params)
      redirect_to law_ctg_path(idencode(@law_ctg.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @law_ctg = LawCtg.find(iddecode(params[:id]))
   
    @law_ctg.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def law_ctg_params
      params.require(:law_ctg).permit( :name , :avatar)
    end
  
  
  
end

