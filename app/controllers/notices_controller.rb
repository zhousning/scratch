class NoticesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
   
    @notices = Notice.order('notice_date DESC').all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

  def query_all 
    items = Notice.all
   
    obj = []
    items.each do |item|
      obj << {
        :id => item.id,
       
        :title => item.title,
       
        :notice_date => item.notice_date,
       
        :content => item.content
      
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end



   
  def show
   
    @notice = Notice.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @notice = Notice.new
    
  end
   

   
  def create
    @notice = Notice.new(notice_params)
     
    if @notice.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @notice = Notice.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @notice = Notice.find(iddecode(params[:id]))
   
    if @notice.update(notice_params)
      redirect_to notice_path(idencode(@notice.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @notice = Notice.find(iddecode(params[:id]))
   
    @notice.destroy
    redirect_to :action => :index
  end
   

  
    def download_attachment 
     
      @notice = Notice.find(iddecode(params[:id]))
     
      @attachment_id = params[:number].to_i
      @attachment = @notice.attachments[@attachment_id]

      if @attachment
        send_file File.join(Rails.root, "public", URI.decode(@attachment.file_url)), :type => "application/force-download", :x_sendfile=>true
      end
    end
  

  

  
  
  

  private
    def notice_params
      params.require(:notice).permit( :title, :notice_date, :content , :avatar , attachments_attributes: attachment_params , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
    def attachment_params
      [:id, :file, :_destroy]
    end
  
  
end

