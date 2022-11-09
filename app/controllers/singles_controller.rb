class SinglesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @singles = @qes_bank.singles
    @tags = ['A', 'B', 'C', 'D', 'E', 'F', 'G']
  end
   
   
  def show
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @single = @qes_bank.singles.find(iddecode(params[:id]))
  end
   

   
  def new
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @single = Single.new
  end
   

   
  def create
    @single = Single.new(single_params)
     
    if @single.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   
  def edit
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @single = @qes_bank.singles.find(iddecode(params[:id]))
  end
   
  def update
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @single = @qes_bank.singles.find(iddecode(params[:id]))
   
    if @single.update(single_params)
      redirect_to edit_qes_bank_single_path(idencode(@qes_bank.id), idencode(@single.id)) 
    else
      render :edit
    end
  end
   
  def destroy
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @single = @qes_bank.singles.find(iddecode(params[:id]))
   
    @single.destroy
    redirect_to :action => :index
  end
   
  def xls_download
    send_file File.join(Rails.root, "templates", "单选题模板.xlsx"), :filename => "单选题模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    parse = ParseSingle.new(current_user)
    excel = params["excel_file"]
    parse.process(qes_bank, excel)

    redirect_to :action => :index
  end 
  

  private
    def single_params
      params.require(:single).permit( :title , enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
  
end

