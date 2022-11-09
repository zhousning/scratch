require 'nokogiri'         

class EssaysController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
   
    if current_user.has_role?(Setting.roles.role_grp)
      @essays = Essay.order('article_date DESC').all.page( params[:page]).per( Setting.systems.per_page )
    else
      @essays = current_user.essays.order('article_date DESC').all.page( params[:page]).per( Setting.systems.per_page )
    end
   
  end
   

   
  def show
   
    @essay = Essay.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @essay = Essay.new
    
  end
   

   
  def create
    @essay = Essay.new(essay_params)
     
    if @essay.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @essay = Essay.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @essay = Essay.find(iddecode(params[:id]))
   
    if @essay.update(essay_params)
      redirect_to essay_path(idencode(@essay.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @essay = Essay.find(iddecode(params[:id]))
   
    @essay.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def essay_params
      params.require(:essay).permit( :title, :dept, :article_date, :content , :photo)
    end
  
  
  
end

