class AdvisesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @advises = Advise.order('created_at DESC').all.page( params[:page]).per( Setting.systems.per_page )
  end
   

  def query_all 
    items = Advise.all
   
    obj = []
    items.each do |item|
      obj << {
        #:factory => idencode(factory.id),
        :id => idencode(item.id),
       
        :title =>  item.user.factories.first.name + '-' + item.user.name,
       
        :content => item.content[0,20] + '...'
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @advise = Advise.where(:id => iddecode(params[:id])).first
   
  end
   

   
  def new
    @advise = Advise.new
    
  end
   

  def create
    @advise = Advise.new(advise_params)
     
    @advise.user = current_user
     
    if @advise.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @advise = Advise.where(:user => current_user, :id => iddecode(params[:id])).first
   
  end
   

   
  def update
   
    @advise = Advise.where(:user => current_user, :id => iddecode(params[:id])).first
   
    if @advise.update(advise_params)
      redirect_to advise_path(idencode(@advise.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @advise = Advise.where(:id => iddecode(params[:id])).first
   
    @advise.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def advise_params
      params.require(:advise).permit( :title, :content)
    end
  
  
  
end

