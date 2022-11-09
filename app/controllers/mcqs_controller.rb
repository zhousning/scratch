class McqsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

  def index
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @mcqs = @qes_bank.mcqs
  end
   

  def show
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @mcq = @qes_bank.mcqs.find(iddecode(params[:id]))
  end
   

   
  def new
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @mcq = Mcq.new
  end
   

   
  def create
    @mcq = Mcq.new(mcq_params)
     
    if @mcq.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   
  def edit
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @mcq = @qes_bank.mcqs.find(iddecode(params[:id]))
  end
   
  def update
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @mcq = @qes_bank.mcqs.find(iddecode(params[:id]))
   
    if @mcq.update(mcq_params)
      redirect_to edit_qes_bank_mcq_path(idencode(@qes_bank.id), idencode(@mcq.id)) 
    else
      render :edit
    end
  end
   
  def destroy
    @qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    @mcq = @qes_bank.mcqs.find(iddecode(params[:id]))
   
    @mcq.destroy
    redirect_to :action => :index
  end
   
  def xls_download
    send_file File.join(Rails.root, "templates", "多选题模板.xlsx"), :filename => "多选题模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    qes_bank = QesBank.find(iddecode(params[:qes_bank_id]))
    parse = ParseMcq.new(current_user)
    excel = params["excel_file"]
    parse.process(qes_bank, excel)

    redirect_to :action => :index
  end 

  private
    def mcq_params
      params.require(:mcq).permit( :title)
    end
  
  
  
end

